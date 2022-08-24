--[[ ===================================================== ]]--
--[[          QBCore My Garage Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-mygaragemenu:server:GetVehicleOutGarage', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    MySQL.Async.execute('UPDATE player_vehicles SET state = ? WHERE plate = ? AND citizenid = ?', {0, plate, citizenid})		
end)

RegisterNetEvent('qb-mygaragemenu:server:PutVehicleInGarage', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    MySQL.Async.execute('UPDATE player_vehicles SET state = ? WHERE plate = ? AND citizenid = ?', {1, plate, citizenid})		
end)

QBCore.Functions.CreateCallback('qb-mygaragemenu:server:isOwner', function(source, cb, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?', {plate, citizenid}, function(result)
		if result[1] ~= nil then
			cb(true)
		else
			cb(false)
		end
	end)
end)

QBCore.Functions.CreateCallback("qb-mygaragemenu:server:GetVehicleProperties", function(source, cb, plate)
    local properties = {}
    local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] ~= nil then
        properties = json.decode(result[1].mods)
    end
    cb(properties)
end)

QBCore.Functions.CreateCallback("qb-mygaragemenu:server:getMyVehicles", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE state = 1 AND citizenid = ?', {citizenid}, function(result)
		if result[1] ~= nil then
			cb(result)
		else
			cb(nil)
		end
	end)
end)