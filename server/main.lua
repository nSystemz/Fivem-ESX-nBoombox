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

-- ONLY EDIT IF YOU KNOW WHAT YOU ARE DOING!

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("boombox:soundStatus")
AddEventHandler("boombox:soundStatus", function(type, musicId, data)
    TriggerClientEvent("boombox:soundStatus", -1, type, musicId, data)
end)

RegisterNetEvent("boombox:createServer")
AddEventHandler("boombox:createServer", function()
    local _source       = source
    local xPlayer       = ESX.GetPlayerFromId(_source)
    local count         = xPlayer.getInventoryItem('Boombox').count

    if count <= 0 then
        xPlayer.showNotification(_U('no_boombox'), false, false)
    else
        TriggerClientEvent("boombox:createClient", _source)
    end
end)