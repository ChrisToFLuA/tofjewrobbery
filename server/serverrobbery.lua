local mincops = 0
local nextrob = 0
local RobberyCooldown = 3600000
local zone = {}
local zonedonevit1, zonedonevit2, zonedonevit3, zonedonevit4, zonedonevit5, zonedonevit6, zonedonevit7, zonedonevit8, zonedonevit9, zonedonevit10 = false, false, false, false, false, false, false, false, false, false
local count = 0
local robstate = false

local function SetNextRob()
    nextrob = GetGameTimer() + RobberyCooldown
end

RegisterServerEvent('tofjew:onrob')
AddEventHandler('tofjew:onrob', function(coord, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
	local copsOnline = ESX.GetExtendedPlayers('job', 'police')
    if #copsOnline >= mincops then
        if nextrob ~= 0 then
            if GetGameTimer() < nextrob then
                for j=1, #copsOnline, 1 do
                    local xPlayerx = copsOnline[j]
                    TriggerClientEvent('tofjew:msgpolice', xPlayerx.source)
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
                TriggerClientEvent('tofjew:robstate', xPlayer.source)
                Citizen.Wait(500)
                TriggerEvent('tofjew:alarmcode_s', xPlayer.source)
                TriggerEvent('tofjew:zone', xPlayer.source, coord, zone)
                for j=1, #copsOnline, 1 do
                    local xPlayerx = copsOnline[j]
                    TriggerClientEvent('tofjew:msgpolice', xPlayerx.source)
                end
            end
        end
        if nextrob == 0 then
            TriggerClientEvent('tofjew:robstate', xPlayer.source)
            SetNextRob()
            Citizen.Wait(500)
            TriggerEvent('tofjew:alarmcode_s', xPlayer.source)
            TriggerEvent('tofjew:zone', xPlayer.source, coord, zone)
            for j=1, #copsOnline, 1 do
                local xPlayerx = copsOnline[j]
                TriggerClientEvent('tofjew:msgpolice', xPlayerx.source)
            end
        end
    else
        TriggerClientEvent('tofjew:nocops', xPlayer.source)
    end
end)

RegisterServerEvent('tofjew:zone')
AddEventHandler('tofjew:zone', function(source, coord, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    if zone == 'vit1' and zonedonevit1 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit1' and not zonedonevit1 then
        zonedonevit1 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit2' and zonedonevit2 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit2' and not zonedonevit2 then
        zonedonevit2 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit3' and zonedonevit3 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit3' and not zonedonevit3 then
        zonedonevit3 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit4' and zonedonevit4 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit4' and not zonedonevit4 then
        zonedonevit4 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit5' and zonedonevit5 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit5' and not zonedonevit5 then
        zonedonevit5 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit6' and zonedonevit6 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit6' and not zonedonevit6 then
        zonedonevit6 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit7' and zonedonevit7 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit7' and not zonedonevit7 then
        zonedonevit7 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit8' and zonedonevit8 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit8' and not zonedonevit8 then
        zonedonevit8 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit9' and zonedonevit9 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit9' and not zonedonevit9 then
        zonedonevit9 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit10' and zonedonevit10 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit10' and not zonedonevit10 then
        zonedonevit10 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
end)

RegisterServerEvent('tofjew:zonerobon')
AddEventHandler('tofjew:zonerobon', function(coord, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    if zone == 'vit1' and zonedonevit1 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit1' and not zonedonevit1 then
        zonedonevit1 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit2' and zonedonevit2 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit2' and not zonedonevit2 then
        zonedonevit2 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit3' and zonedonevit3 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit3' and not zonedonevit3 then
        zonedonevit3 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit4' and zonedonevit4 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit4' and not zonedonevit4 then
        zonedonevit4 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit5' and zonedonevit5 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit5' and not zonedonevit5 then
        zonedonevit5 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit6' and zonedonevit6 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit6' and not zonedonevit6 then
        zonedonevit6 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit7' and zonedonevit7 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit7' and not zonedonevit7 then
        zonedonevit7 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit8' and zonedonevit8 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit8' and not zonedonevit8  then
        zonedonevit8 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit9' and zonedonevit9 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit9' and not zonedonevit9 then
        zonedonevit9 = true
        TriggerClientEvent('tofjew:breakglass', xPlayer.source, coord)
    end
    if zone == 'vit10' and zonedonevit10 then
        TriggerClientEvent('tofjew:zonealreadydone', xPlayer.source)
    elseif zone == 'vit10' and not zonedonevit10 then
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
    if codealarm then
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