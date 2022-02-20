--
--	#     #
--	##    #  ######  #    #  ######   ####   #    #   ####
--	# #   #  #       ##  ##  #       #       #    #  #
--	#  #  #  #####   # ## #  #####    ####   #    #   ####
--	#   # #  #       #    #  #            #  #    #       #
--	#    ##  #       #    #  #       #    #  #    #  #    #
--	#     #  ######  #    #  ######   ####    ####    ####
--
-- Created by Nemesus for ESX Framework
-- Website: https://nemesus.de
-- Youtube: https://youtube.nemesus.de

-- Console / Delete if you want

print("^0======================================================================^7")
print("^0ESX_BOOMBOX loaded:")
print("^0[^4Author^0] ^7:^0 ^0Nemesus | Version 1.0^7")
print("^0[^2Website^0] ^7:^0 ^5https://nemesus.de^7")
print("^0[^2Youtube^0] ^7:^0 ^5https://youtube.nemesus.de^7")
print("^0======================================================================^7")

-- ONLY EDIT IF YOU KNOW WHAT YOU ARE DOING!

-- Local variables
ESX = nil
xSound = exports.xsound
local objectBoomboxCreated = nil
local PlayerData = {}
local playerVolume = 20
local IsMenuOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

--Register Net Events
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("boombox:soundStatus")
AddEventHandler("boombox:soundStatus", function(type, musicId, data)
    if type == "position" then
        if xSound:soundExists(musicId) then
            xSound:Position(musicId, data.position)
	        xSound:Distance(musicId, Config.MusicRange)
        end
    end

    if type == "play" then
        xSound:PlayUrlPos(musicId, data.link, 0.4, data.position)
        xSound:Distance(musicId, Config.MusicRange)
    end

    if type == "stop" then
		if xSound:soundExists(musicId) then
	  		xSound:Destroy(musicId)
		end
    end
	
end)

RegisterNetEvent("boombox:createClient")
AddEventHandler("boombox:createClient", function()
	local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.85, -1.05)
	objectBoomboxCreated = CreateObject(GetHashKey("prop_boombox_01"), pos.x, pos.y, pos.z, true, true, true)
	playerVolume = 20
	ESX.ShowNotification(_U('start_boombox'))
end)

-- Commands
Citizen.CreateThread(function()
	Citizen.Wait(1)
	RegisterCommand("boombox", function() 
		if not objectBoomboxCreated then
			TriggerServerEvent("boombox:createServer")
		else
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local pos2 = GetEntityCoords(objectBoomboxCreated)
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, true)
			if distance < 1.5 then
				TriggerServerEvent("boombox:soundStatus", "stop", "sound_boombox_"..PlayerPedId(), { position = pos, link = "" })
				DeleteObject(objectBoomboxCreated);
				objectBoomboxCreated = nil
				ESX.ShowNotification(_U('stop_boombox'))
			else
				ESX.ShowNotification(_U('near_boombox'))
			end
		end
	end)
end)

-- Keys
Citizen.CreateThread(function()
	Citizen.Wait(1)
	while true do
		if objectBoomboxCreated and IsControlJustReleased(0, 38) and not IsMenuOpen then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local pos2 = GetEntityCoords(objectBoomboxCreated)
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, true)
			if distance < 1.5 then
				OpenBoomboxMenu()
			end
		end
		if objectBoomboxCreated and not IsMenuOpen then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local pos2 = GetEntityCoords(objectBoomboxCreated)
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, true)
			if distance < 1.5 and not IsMenuOpen then
				ESX.ShowHelpNotification(_U('help_boombox'))
			end
		end
		Citizen.Wait(1)
	end
end)

-- Functions
function OpenBoomboxMenu()

	IsMenuOpen = true

	FreezeEntityPosition(GetPlayerPed(-1), true)

	local options = {
		{label = _U('play_music'), value = 'play_music'},
		{label = _U('stop_music'), value = 'stop_music'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boombox_menu', {
		title = _U('menu_boombox'),
		align = "top-left",
		elements = options
	}, function (data, menu)
		if data.current.value == 'play_music' then
			menu.close()
			OpenInputMenu()
		end
		if data.current.value == 'stop_music' then
			TriggerServerEvent("boombox:soundStatus", "stop", "sound_boombox_"..PlayerPedId(), { position = pos, link = "" })
			ESX.ShowNotification(_U('music_stopping'))
		end
	end,
	function(data, menu)
		menu.close();
		IsMenuOpen = false
		FreezeEntityPosition(GetPlayerPed(-1), false)
	end)
end

function OpenInputMenu()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'boombox_menu', {
		title = _U('music_title')
	}, function (data, menu)
			OpenBoomboxMenu()
			local pos = GetEntityCoords(GetPlayerPed(-1))
			TriggerServerEvent("boombox:soundStatus", "play", "sound_boombox_"..PlayerPedId(), { position = pos, link = data.value })
			ESX.ShowNotification(_U('music_playing'))
	end,
	function(data, menu)
		OpenBoomboxMenu()
	end)
end

