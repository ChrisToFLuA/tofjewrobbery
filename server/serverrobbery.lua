
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local mincops = 0  --- nb minimum de lspd en ville
local nextrob = 0
local cd = 3600000
local zone = {}
zonedonevit1 = false
zonedonevit2 = false
zonedonevit3 = false
zonedonevit4 = false
zonedonevit5 = false
zonedonevit6 = false
zonedonevit7 = false
zonedonevit8 = false
zonedonevit9 = false
zonedonevit10 = false
local count = 0
robstate = false

local function SetNextRob()
    nextrob = GetGameTimer() + cd
end

RegisterServerEvent('tofjew:onrob')
AddEventHandler('tofjew:onrob', function(coord, zone)
    print('verif on rob')
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
	local copsOnline = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' then     -- modify here if you want or not take care about the offpolice
			copsOnline = copsOnline + 1
		end
	end

    if copsOnline >= mincops then
        if nextrob ~= 0 then
            if GetGameTimer() < nextrob then
                for j=1, #xPlayers, 1 do
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[j])
                    if xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' then     -- modify here if you want or not take care about the offpolice
                        TriggerClientEvent('tofjew:msgpolice', xPlayer.source)
                    end
                end
                TriggerClientEvent('tofjew:onrobbing', xPlayer.source)
            end
            if GetGameTimer() > nextrob then
                SetNextRob()
                zonedonevit1 = false
                zonedonevit2 = false
                zonedonevit3 = false
                zonedonevit4 = false
                zonedonevit5 = false
                zonedonevit6 = false
                zonedonevit7 = false
                zonedonevit8 = false
                zonedonevit9 = false
                zonedonevit10 = false
                print('envoi client robstate')
                TriggerClientEvent('tofjew:robstate', xPlayer.source)
                Citizen.Wait(500)
                TriggerEvent('tofjew:alarmcode_s', xPlayer.source)
                TriggerEvent('tofjew:zone', xPlayer.source, coord, zone)
                for j=1, #xPlayers, 1 do
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[j])
                    if xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' then     -- modify here if you want or not take care about the offpolice
                        TriggerClientEvent('tofjew:msgpolice', xPlayer.source)
                    end
                end
            end
        end
        if nextrob == 0 then
            print('envoi client robstate')
            TriggerClientEvent('tofjew:robstate', xPlayer.source)
            SetNextRob()
            Citizen.Wait(500)
            TriggerEvent('tofjew:alarmcode_s', xPlayer.source)
            TriggerEvent('tofjew:zone', xPlayer.source, coord, zone)
            print('envoi verif zone')
            for j=1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[j])
                if xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' then     -- modify here if you want or not take care about the offpolice
                    TriggerClientEvent('tofjew:msgpolice', xPlayer.source)
                end
            end
        end
    else
        TriggerClientEvent('tofjew:nocops', xPlayer.source)
        print('no cops')
    end
end)

RegisterServerEvent('tofjew:zone')
AddEventHandler('tofjew:zone', function(source, coord, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    if zone == 'vit1' and zonedonevit1 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit1' and zonedonevit1 == false then
        zonedonevit1 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit2' and zonedonevit2 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit2' and zonedonevit2 == false then
        zonedonevit2 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit3' and zonedonevit3 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit3' and zonedonevit3 == false then
        zonedonevit3 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit4' and zonedonevit4 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit4' and zonedonevit4 == false then
        zonedonevit4 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit5' and zonedonevit5 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit5' and zonedonevit5 == false then
        zonedonevit5 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit6' and zonedonevit6 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit6' and zonedonevit6 == false then
        zonedonevit6 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit7' and zonedonevit7 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit7' and zonedonevit7 == false then
        zonedonevit7 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit8' and zonedonevit8 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit8' and zonedonevit8 == false then
        zonedonevit8 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit9' and zonedonevit9 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit9' and zonedonevit9 == false then
        zonedonevit9 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit10' and zonedonevit10 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit10' and zonedonevit10 == false then
        zonedonevit10 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
end)

RegisterServerEvent('tofjew:zonerobon')
AddEventHandler('tofjew:zonerobon', function(coord, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    if zone == 'vit1' and zonedonevit1 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit1' and zonedonevit1 == false then
        zonedonevit1 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit2' and zonedonevit2 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit2' and zonedonevit2 == false then
        zonedonevit2 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit3' and zonedonevit3 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit3' and zonedonevit3 == false then
        zonedonevit3 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit4' and zonedonevit4 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit4' and zonedonevit4 == false then
        zonedonevit4 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit5' and zonedonevit5 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit5' and zonedonevit5 == false then
        zonedonevit5 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit6' and zonedonevit6 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit6' and zonedonevit6 == false then
        zonedonevit6 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit7' and zonedonevit7 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit7' and zonedonevit7 == false then
        zonedonevit7 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit8' and zonedonevit8 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit8' and zonedonevit8 == false then
        zonedonevit8 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit9' and zonedonevit9 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit9' and zonedonevit9 == false then
        zonedonevit9 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit10' and zonedonevit10 == true then
        print(zone)
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit10' and zonedonevit10 == false then
        zonedonevit10 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
end)

RegisterNetEvent('tofjew:lootjewels')
AddEventHandler('tofjew:lootjewels', function(codealarm)
    local xPlayer = ESX.GetPlayerFromId(source)
    if codealarm == false then
        count = math.random(25,38)    
    end
    if codealarm == true then
        count = round(math.random(25,38) * 1.20)
    end
    local item = 'jewels'           -- modify item here
    local itemlabel = 'Bijoux'      -- modify label item here
        if exports.ox_inventory:CanCarryItem(xPlayer.source, item, count) then      -- check cancarry items
            exports.ox_inventory:AddItem(xPlayer.source, item, count)
            TriggerClientEvent('tofjew:lootmsg', xPlayer.source, itemlabel, count)
        else
            TriggerClientEvent('tofjew:nospace', xPlayer.source)
        end
end)

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end