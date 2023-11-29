--[[ ===================================================== ]] --
--[[            MH My Garage Script by MaDHouSe            ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local MenuItemId = nil

local function DoVehicleDamage(vehicle, body, engine)
    local engine = engine + 0.0
    local body = body + 0.0
    if body < 900.0 then
        SmashVehicleWindow(vehicle, 0)
        SmashVehicleWindow(vehicle, 1)
        SmashVehicleWindow(vehicle, 2)
        SmashVehicleWindow(vehicle, 3)
        SmashVehicleWindow(vehicle, 4)
        SmashVehicleWindow(vehicle, 5)
        SmashVehicleWindow(vehicle, 6)
        SmashVehicleWindow(vehicle, 7)
    end
    if body < 800.0 then
        SetVehicleDoorBroken(vehicle, 0, true)
        SetVehicleDoorBroken(vehicle, 1, true)
        SetVehicleDoorBroken(vehicle, 2, true)
        SetVehicleDoorBroken(vehicle, 3, true)
        SetVehicleDoorBroken(vehicle, 4, true)
        SetVehicleDoorBroken(vehicle, 5, true)
        SetVehicleDoorBroken(vehicle, 6, true)
    end
    if engine < 700.0 then
        SetVehicleTyreBurst(vehicle, 1, false, 990.0)
        SetVehicleTyreBurst(vehicle, 2, false, 990.0)
        SetVehicleTyreBurst(vehicle, 3, false, 990.0)
        SetVehicleTyreBurst(vehicle, 4, false, 990.0)
    end
    if engine < 500.0 then
        SetVehicleTyreBurst(vehicle, 0, false, 990.0)
        SetVehicleTyreBurst(vehicle, 5, false, 990.0)
        SetVehicleTyreBurst(vehicle, 6, false, 990.0)
        SetVehicleTyreBurst(vehicle, 7, false, 990.0)
    end
    SetVehicleEngineHealth(vehicle, engine)
    SetVehicleBodyHealth(vehicle, body)
end

local function TakeOutVehicle(data)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local tmpLocation = vector3(coords.x, coords.y, coords.z)
    if tmpLocation then
        if not QBCore.Functions.SpawnClear(tmpLocation, 5.0) then
            QBCore.Functions.Notify(Lang:t('error.area_is_obstructed'), 'error', 5000)
            return
        else
            QBCore.Functions.SpawnVehicle(data.vehicle, function(veh)
                QBCore.Functions.TriggerCallback("mh-mygaragemenu:server:GetVehicleProperties", function(properties)
                    QBCore.Functions.SetVehicleProperties(veh, properties)
                    SetVehicleNumberPlateText(veh, data.plate)
                    SetEntityHeading(veh, heading)
                    SetVehRadioStation(veh, 'OFF')
                    SetVehicleDirtLevel(veh, 0)
                    SetVehicleDoorsLocked(veh, 0)
                    SetEntityAsMissionEntity(veh, true, true)
                    TaskWarpPedIntoVehicle(playerPed, veh, -1)
                    DoVehicleDamage(veh, data.body, data.engine)
                    SetVehicleFuelLevel(veh, data.fuel + 0.0)
                    DecorSetFloat(veh, "_FUEL_LEVEL", GetVehicleFuelLevel(veh))
                    TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", data.plate)
                    TriggerServerEvent('mh-mygaragemenu:server:GetVehicleOutGarage', data.plate)
                    exports['qb-menu']:closeMenu()
                end, data.plate)
            end, tmpLocation, true)
        end
    end
end

local function CheckPlayers(vehicle)
    for i = -1, 7, 1 do
        TaskLeaveVehicle(GetPedInVehicleSeat(vehicle, i), vehicle, 1)
        SetVehicleDoorsLocked(vehicle, 2)
    end
end

local function ParkCar(player, vehicle)
    local plate = QBCore.Functions.GetPlate(vehicle)
    SetVehicleEngineOn(vehicle, false, false, true)
    CheckPlayers(vehicle)
    Wait(1500)
    RequestAnimSet("anim@mp_player_intmenu@key_fob@")
    TaskPlayAnim(player, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false)
    Wait(500)
    ClearPedTasks(player)
    SetVehicleLights(vehicle, 2)
    Wait(150)
    SetVehicleLights(vehicle, 0)
    Wait(150)
    SetVehicleLights(vehicle, 2)
    Wait(150)
    SetVehicleLights(vehicle, 0)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
    Wait(1000)
    TriggerServerEvent('mh-mygaragemenu:server:PutVehicleInGarage', plate)
    QBCore.Functions.DeleteVehicle(vehicle)
    DeleteVehicle(vehicle)
end

local function IsValueExists(index, val)
    if type(val) == "table" then
        for _, value in ipairs(index) do
            if IsValueExists(val, value) then
                return true
            end
        end
        return false
    else
        for _, value in ipairs(index) do
            if value == val then
                return true
            end
        end
    end
    return false
end

RegisterNetEvent('qb-radialmenu:client:onRadialmenuOpen', function()
    QBCore.Functions.TriggerCallback("mh-mygaragemenu:server:isAllowed", function(isAllowed)
        if isAllowed then
            if MenuItemId ~= nil then
                exports['qb-radialmenu']:RemoveOption(MenuItemId)
                MenuItemId = nil
            end
            MenuItemId = exports['qb-radialmenu']:AddOption({
                id = 'mygarage0001',
                title = Lang:t('menu.garage'),
                icon = 'warehouse',
                type = 'client',
                event = 'mh-mygaragemenu:client:vehCategories',
                shouldClose = true
            }, MenuItemId)
        else
            MenuItemId = nil
        end
    end)
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    PlayerData = data
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    PlayerData.gang = gang
end)

RegisterNetEvent('mh-mygaragemenu:client:parkVehicle', function(data)
    ParkCar(data.player, data.vehicle)
end)

RegisterNetEvent('mh-mygaragemenu:client:takeOutVehicle', function(data)
    if not IsPedInAnyVehicle(PlayerPedId()) then
        QBCore.Functions.TriggerCallback('mh-mygaragemenu:server:isOwner', function(owned)
            if owned then
                TakeOutVehicle(data)
            else
                QBCore.Functions.Notify(Lang:t('error.not_the_owner'), "error")
            end
        end, data.plate)
    else
        QBCore.Functions.Notify(Lang:t('error.is_in_vehicle'), "error")
    end
end)

local current_cat = nil
RegisterNetEvent('mh-mygaragemenu:client:vehCategories', function(coords)
    QBCore.Functions.TriggerCallback("mh-mygaragemenu:server:getMyVehicles", function(myVehicles)
        local categoryMenu = {{
            header = Lang:t('menu.header_cotegories'),
            isMenuHeader = true
        }}
        if IsPedInAnyVehicle(PlayerPedId()) then
            categoryMenu[#categoryMenu + 1] = {
                header = Lang:t('menu.parking'),
                icon = "fa-solid fa-angle-right",
                params = {
                    event = 'mh-mygaragemenu:client:parkVehicle',
                    args = {
                        player = PlayerPedId(),
                        vehicle = GetVehiclePedIsIn(PlayerPedId())
                    }
                }
            }
        end
        if myVehicles ~= nil then
            for category, label in pairs(Config.Categories) do
                for _, data in pairs(myVehicles) do
                    if QBCore.Shared.Vehicles[data.vehicle:lower()] then
                        if QBCore.Shared.Vehicles[data.vehicle:lower()]["category"] == category and category ~=
                            current_cat then
                            current_cat = category
                            if not IsValueExists(categoryMenu, category) then
                                categoryMenu[#categoryMenu + 1] = {
                                    header = label,
                                    params = {
                                        event = 'mh-mygaragemenu:client:openVehCats',
                                        args = {
                                            cateName = category:lower()
                                        }
                                    }
                                }
                            end
                        end
                    end
                end
            end
        end
        categoryMenu[#categoryMenu + 1] = {
            header = Lang:t('menu.close_menu'),
            params = {
                event = ''
            }
        }
        exports['qb-menu']:openMenu(categoryMenu)
    end)
end)

RegisterNetEvent('mh-mygaragemenu:client:openVehCats', function(rs)
    QBCore.Functions.TriggerCallback("mh-mygaragemenu:server:getMyVehicles", function(myVehicles)
        local categoryMenu = {{
            header = Lang:t('menu.header_txt', {
                name = rs.cateName:upper()
            }),
            isMenuHeader = true
        }}
        categoryMenu[#categoryMenu + 1] = {
            header = Lang:t('menu.back_menu'),
            icon = "fa-solid fa-angle-left",
            params = {
                event = 'mh-mygaragemenu:client:vehCategories'
            }
        }
        if myVehicles ~= nil then
            for _, data in pairs(myVehicles) do
                if QBCore.Shared.Vehicles[data.vehicle:lower()] then
                    if QBCore.Shared.Vehicles[data.vehicle:lower()]["category"] == rs.cateName then
                        local enginePercent = QBCore.Shared.Round(data.engine / 10, 0)
                        local bodyPercent = QBCore.Shared.Round(data.body / 10, 0)
                        local currentFuel = data.fuel
                        categoryMenu[#categoryMenu + 1] = {
                            header = data.vehicle:lower(),
                            icon = "fa-solid fa-angle-right",
                            txt = Lang:t('vehicle.plate', {
                                plate = data.plate
                            }) .. Lang:t('vehicle.fuel', {
                                fuel = currentFuel
                            }) .. Lang:t('vehicle.engine', {
                                engine = enginePercent
                            }) .. Lang:t('vehicle.body', {
                                body = bodyPercent
                            }),
                            params = {
                                event = 'mh-mygaragemenu:client:takeOutVehicle',
                                args = {
                                    vehicle = data.vehicle,
                                    plate = data.plate,
                                    fuel = data.fuel,
                                    body = data.body,
                                    engine = data.engine
                                }
                            }
                        }
                    end
                end
            end
        end
        categoryMenu[#categoryMenu + 1] = {
            header = Lang:t('menu.close_menu'),
            params = {
                event = ''
            }
        }
        exports['qb-menu']:openMenu(categoryMenu)
    end)
end)
