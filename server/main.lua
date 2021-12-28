local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-speedcamera:PayBill60Zone') -- 60km camera
AddEventHandler('qb-speedcamera:PayBill60Zone', function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local totalAmount = 200 -- Change me to charge less/more
	xPlayer.Functions.RemoveMoney("bank", totalAmount)
end)

RegisterServerEvent('qb-speedcamera:PayBill80Zone') -- 80km camera
AddEventHandler('qb-speedcamera:PayBill80Zone', function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local totalAmount = 200 -- Change me to charge less/more
	xPlayer.Functions.RemoveMoney("bank", totalAmount)
end)

RegisterServerEvent('qb-speedcamera:PayBill120Zone') -- 120km camera
AddEventHandler('qb-speedcamera:PayBill120Zone', function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local totalAmount = 200 -- Change me to charge less/more
	xPlayer.Functions.RemoveMoney("bank", totalAmount)
end)

RegisterServerEvent('qb-speedcamera:openGUI')
AddEventHandler('qb-speedcamera:openGUI', function()
	TriggerClientEvent('qb-speedcamera:openGUI', source)
end)

RegisterServerEvent('qb-speedcamera:closeGUI')
AddEventHandler('qb-speedcamera:closeGUI', function()
	TriggerClientEvent('qb-speedcamera:closeGUI', source)
end)
