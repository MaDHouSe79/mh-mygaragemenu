--[[ ===================================================== ]]--
--[[          QBCore My Garage Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()
local adminOnly = true -- if false, everybody can use it anywhere on the map.

QBCore.Functions.CreateCallback('mh-mygaragemenu:server:isAllowed', function(source, cb)
    local src = source
    local isAllowed = false
    if adminOnly then
        if IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
            isAllowed = true
        end
    else
        isAllowed = true
    end
    cb(isAllowed)
end)

QBCore.Functions.CreateCallback('mh-mygaragemenu:server:isOwner', function(source, cb, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.query.await('SELECT plate, citizenid FROM player_vehicles WHERE plate = ? AND citizenid = ?', {plate, Player.PlayerData.citizenid})
    if result[1] ~= nil then cb(true) else cb(false) end
end)

QBCore.Functions.CreateCallback("mh-mygaragemenu:server:GetVehicleProperties", function(source, cb, plate)
    local properties = {}
    local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] ~= nil then properties = json.decode(result[1].mods) end
    cb(properties)
end)

QBCore.Functions.CreateCallback("mh-mygaragemenu:server:getMyVehicles", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		if result[1] ~= nil then cb(result) else cb(nil) end
	end)
end)

RegisterNetEvent('mh-mygaragemenu:server:GetVehicleOutGarage', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.Async.execute('UPDATE player_vehicles SET state = ? WHERE plate = ? AND citizenid = ?', {0, plate, Player.PlayerData.citizenid})		
end)

RegisterNetEvent('mh-mygaragemenu:server:PutVehicleInGarage', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.Async.execute('UPDATE player_vehicles SET state = ? WHERE plate = ? AND citizenid = ?', {1, plate, Player.PlayerData.citizenid})		
end)
