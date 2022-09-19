--[[ ===================================================== ]]--
--[[          QBCore My Garage Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()

local function DoVehicleDamage(vehicle, body, engine)
	local engine = engine + 0.0
	local body = body + 0.0
    if body < 150 then body = 150 end
    if engine < 150 then engine = 150 end
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

local function SetFuel(vehicle, fuel)
    if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
        SetVehicleFuelLevel(vehicle, fuel + 0.0)
        DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
    end
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
                QBCore.Functions.TriggerCallback("qb-mygaragemenu:server:GetVehicleProperties", function(properties)
                    QBCore.Functions.SetVehicleProperties(veh, properties)
                    SetVehicleNumberPlateText(veh, data.plate)
                    SetEntityHeading(veh, heading)
                    SetVehRadioStation(veh, 'OFF')
                    SetVehicleDirtLevel(veh, 0)
                    SetVehicleDoorsLocked(veh, 0)
                    SetEntityAsMissionEntity(veh, true, true)
                    --
                    TaskWarpPedIntoVehicle(playerPed, veh, -1)
                    DoVehicleDamage(veh, data.body, data.engine)
                    SetFuel(veh, data.fuel)
                    --
                    TriggerServerEvent(Config.KeyScriptTrigger, data.plate)
                    TriggerServerEvent('qb-mygaragemenu:server:GetVehicleOutGarage', data.plate)
                    if Config.AutoStartVehicle then 
                        SetVehicleEngineOn(veh, true, true) 
                    end
                    exports['qb-menu']:closeMenu()
                end, data.plate)
            end, tmpLocation, true)
        end
    end
end

local function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        if GetPedInVehicleSeat(vehicle, i) ~= 0 then
            local seat = GetPedInVehicleSeat(vehicle, i)
            TaskLeaveVehicle(seat, vehicle, 0)
            SetVehicleDoorsLocked(vehicle)
        end
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
    TriggerServerEvent('qb-mygaragemenu:server:PutVehicleInGarage', plate)
    QBCore.Functions.DeleteVehicle(vehicle)
	DeleteVehicle(vehicle)
end

local function CreateMenuItem()
    if MenuItemId ~= nil then
        exports['qb-radialmenu']:RemoveOption(MenuItemId)
    end
    Wait(10)
    MenuItemId = exports['qb-radialmenu']:AddOption({
        id = 'mygarage0001',
        title = 'My Garage',
        icon = 'warehouse',
        type = 'client',
        event = 'mh-mygaragemenu:client:myVehicles',
        shouldClose = true
    }, MenuItemId)
end

local function AddRadialMyGarageOption()
    QBCore.Functions.TriggerCallback("mh-mygaragemenu:server:isAdmin", function(isAdmin)
        if Config.AdminOnly and isAdmin then
            CreateMenuItem()
        else
            CreateMenuItem()
        end
    end)
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    if resource == GetCurrentResourceName() then
        AddRadialMyGarageOption()
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        AddRadialMyGarageOption()
    end
end)


RegisterKeyMapping(Config.ParkingCommand, Lang:t('command.info'), 'keyboard', Config.ParkingKeybinds) 
RegisterCommand(Config.ParkingCommand, function()
    TriggerEvent('qb-mygaragemenu:client:myVehicles')
end, false)

RegisterNetEvent('qb-mygaragemenu:client:takeOutVehicle', function(data)
    if not IsPedInAnyVehicle(PlayerPedId()) then
        QBCore.Functions.TriggerCallback('qb-mygaragemenu:server:isOwner', function(owned)
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

RegisterNetEvent('qb-mygaragemenu:client:parkVehicle', function(data)
    ParkCar(data.player, data.vehicle)
end)

RegisterNetEvent('qb-mygaragemenu:client:myVehicles', function()
    QBCore.Functions.TriggerCallback("qb-mygaragemenu:server:getMyVehicles", function(myVehicles)
        local categoryMenu = {
            {
                header = Lang:t('menu.garage'),
                isMenuHeader = true
            }
        }
        if myVehicles ~= nil then
            for k, vehicle in pairs(myVehicles) do
                if vehicle.state == 1 then
                    local enginePercent = QBCore.Shared.Round(vehicle.engine / 10, 0)
                    local bodyPercent = QBCore.Shared.Round(vehicle.body / 10, 0)
                    local currentFuel = vehicle.fuel
                    categoryMenu[#categoryMenu + 1] = {
                        header = vehicle.vehicle,
                        txt = Lang:t('vehicle.plate', {plate=vehicle.plate})..Lang:t('vehicle.fuel',{fuel=currentFuel})..Lang:t('vehicle.engine',{engine=enginePercent})..Lang:t('vehicle.body',{body=bodyPercent}),
                        params = {
                            event = 'qb-mygaragemenu:client:takeOutVehicle',
                            args = {
                                vehicle = vehicle.vehicle,
                                plate = vehicle.plate,
                                fuel = vehicle.fuel,
                                body = vehicle.body,
                                engine = vehicle.engine,
                            }
                        },
                    }
                end
            end
        end
        if IsPedInAnyVehicle(PlayerPedId()) then
            categoryMenu[#categoryMenu + 1] = {
                header = Lang:t('menu.parking'),
                params = {
                    event = 'qb-mygaragemenu:client:parkVehicle',
                    args = {
                        player = PlayerPedId(),
                        vehicle = GetVehiclePedIsIn(PlayerPedId()),
                    }
                },
            }
        end
        categoryMenu[#categoryMenu + 1] = {
            header = Lang:t('menu.close_menu'),
            params = {event = ''}
        }
        exports['qb-menu']:openMenu(categoryMenu)
    end)
end)
