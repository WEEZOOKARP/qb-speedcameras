QBCore = exports['qb-core']:GetCoreObject()

local useBilling = false -- OPTIONS: (true/false) DONT CHANGE THIS
local useCameraSound = true -- OPTIONS: (true/false)
local useFlashingScreen = true -- OPTIONS: (true/false)
local useBlips = true -- OPTIONS: (true/false)
local alertPolice = true -- OPTIONS: (true/false)
local alertSpeed = 150 -- OPTIONS: (1-5000 KMH)

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local PlayerData = {}
local hasBeenCaught = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        PlayerData = QBCore.Functions.GetPlayerData()
    end)
    
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


--Blips
local blips = {
	-- 60KM/H ZONES
	{title="Speedcamera (60KM/H)", colour=1, id=1, x = -524.2645, y = -1776.3569, z = 21.3384},
	
	-- 80KM/H ZONES
	{title="Speedcamera (80KM/H)", colour=1, id=1, x = 2506.0671, y = 4145.2431, z = 38.1054}, 
	
	-- 120KM/H ZONES
	{title="Speedcamera (120KM/H)", colour=1, id=1, x = 1584.9281, y = -993.4557, z = 59.3923},
	{title="Speedcamera (120KM/H)", colour=1, id=1, x = 2442.2006, y = -134.6004, z = 88.7765},
	{title="Speedcamera (120KM/H)", colour=1, id=1, x = 2871.7951, y = 3540.5795, z = 53.0930}
}

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
		if useBlips == true then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.5)
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end
end)

-- Blips
local Speedcamera60Zone = {
    {x = -524.2645,y = -1776.3569,z = 21.3384}
}

local Speedcamera80Zone = {
    {x = 2506.0671,y = 4145.2431,z = 38.1054}
}

local Speedcamera120Zone = {
    {x = 1584.9281,y = -993.4557,z = 59.3923},
    {x = 2442.2006,y = -134.6004,z = 88.7765},
    {x = 2871.7951,y = 3540.5795,z = 53.0930}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Speedcamera60Zone) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera60Zone[k].x, Speedcamera60Zone[k].y, Speedcamera60Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 60.0
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
							if hasBeenCaught == false then
                                -- Made Job only
								if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
								--if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											
											local playerPed = PlayerPedId()
	                                        PedPosition		= GetEntityCoords(playerPed)
	
	                                        local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
										end
									end

									if useFlashingScreen == true then
										TriggerServerEvent('qb-speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('qb-speedcamera:closeGUI')
									end
								
									QBCore.Functions.Notify("you have been fined for speed exceeding maximum limit exceeded: 60KM", "error")
									
									if useBilling == true then
                                        -- OLD esx
									else
										TriggerServerEvent('qb-speedcamera:PayBill60Zone')
										
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000)
								end
							end
						end
					end
					
					hasBeenCaught = false
                    Citizen.Wait(5000) 
				end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Speedcamera80Zone) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera80Zone[k].x, Speedcamera80Zone[k].y, Speedcamera80Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 80.0
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then					
							if hasBeenCaught == false then
                                -- Made Job only
								if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
								--if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											
											local playerPed = PlayerPedId()
	                                        PedPosition		= GetEntityCoords(playerPed)
	
	                                        local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
										end
									end
									
									if useFlashingScreen == true then
										TriggerServerEvent('qb-speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('qb-speedcamera:closeGUI')
									end
								
									QBCore.Functions.Notify("you have been fined for speed exceeding maximum limit exceeded: 80KM.", "error")
									
									if useBilling == true then
                                        -- old ESX function
									else
										TriggerServerEvent('qb-speedcamera:PayBill80Zone')
										
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) 
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Speedcamera120Zone) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera120Zone[k].x, Speedcamera120Zone[k].y, Speedcamera120Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 120.0
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
							if hasBeenCaught == false then
                                -- Made for jobs 
								if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
								--if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								--elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											
											
											local playerPed = PlayerPedId()
	                                        PedPosition		= GetEntityCoords(playerPed)
	
	                                        local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
										
										end
									end
								
									
									if useFlashingScreen == true then
										TriggerServerEvent('qb-speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('qb-speedcamera:closeGUI')
									end
								
									QBCore.Functions.Notify("you have been fined for speed exceeding maximum limit exceeded: 120KM.", "error")
									
									if useBilling == true then
                                        -- OLD ESX
									else
										TriggerServerEvent('qb-speedcamera:PayBill120Zone')
										
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000)
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

RegisterNetEvent('qb-speedcamera:openGUI')
AddEventHandler('qb-speedcamera:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('qb-speedcamera:closeGUI')
AddEventHandler('qb-speedcamera:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)