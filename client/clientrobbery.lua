ESX = nil

nextVitrin = 0
cd = 47000
codealarm = false
robstate = false
alarmcode = math.random(125362, 999999)
inputalrmcode = tonumber(0)
alarmid = GetSoundId()

------------------------------------------
--------- language notifications ---------
------------------------------------------

menu1 = 'Briser la vitrine' -- modify traduction here
menu2 = 'Chercher Code Alarme'  -- modify traduction here
menu3 = 'Saisir Code'  -- modify traduction here
nocop = 'Le Braquage est compromis, revenez plus tard' -- modify traduction here
alreadyrob = 'Un Braquage est déjà en cours, revenez plus tard' -- modify traduction here
spam = 'Respire, ça n\'ira pas plus vite !' -- modify traduction here
zonealreadydone = 'Vous avez déjà volé dans cette vitrine' -- modify traduction here
nospace = 'Vous n\'avez plus de place sur vous' -- modify traduction here
loot = 'Vous avez volé' -- modify traduction here
nocode = 'Rien ici' -- modify traduction here
coderobbery = 'Comencez d\'abord le braquage' -- modify traduction here

------------------------------------------
------------------------------------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    Wait(500)
	while PlayerData == nil do
        PlayerData = ESX.GetPlayerData()
        Wait(10)
    end	

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

-- ** qtarget documentation : https://overextended.github.io/qtarget/model.html
-- ** ox_inventory documentation : https://overextended.github.io/docs
-- ** ox_lib documentation : https://overextended.github.io/docs

------------------------------------------------------------------------------
---------------------- launch menus depending on the job ---------------------
------------------------------------------------------------------------------

AddEventHandler('esx:onPlayerSpawn', function()
    Citizen.Wait(30000)
    Citizen.CreateThread(function()
        -- you can modify / add jobs here --
        local jobs = {
            {name = 'police'},          -- LSPD in service
            {name = 'offpolice'},       -- LSPD out of service
            {name = 'ambulance'},       -- EMS in service
            {name = 'offambulance'},    -- EMS out of service
        }
        for a = 1, #jobs, 1 do
            local jobsname = jobs[a].name
            if ESX.PlayerData.job.name ~= jobsname then     -- test on jobname
                TriggerEvent('tofjew:menus')                -- call menu qtarget jewels robbery
            else
                return
            end
        end
    end)
end)

------------------------------------------------------------------------------
------------------------ menu qtarget jewelsrobbery --------------------------
------------------------------------------------------------------------------

RegisterNetEvent('tofjew:menus')
AddEventHandler('tofjew:menus', function()

    Citizen.CreateThread(function()

    -------------------------------------------------------------------------------------------------------------------------
    ---------------------------------------------- Alarm zones --------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------

    local codesearch = {
        {zone = 'alarm1', coordalrm = vector3(-629.23, -227.66, 37.06), long = 1.0, larg = 1.0, headingalrm = 35.24, minz = 37.06, maxz = 39.06},    
        {zone = 'alarm2', coordalrm = vector3(-630.77, -228.21, 37.06), long = 1.0, larg = 1.0, headingalrm = 11.6, minz = 37.06, maxz = 39.06},
        {zone = 'alarm3', coordalrm = vector3(-631.80, -229.35, 37.06), long = 1.0, larg = 1.0, headingalrm = 49.26, minz = 37.06, maxz = 39.06},
        {zone = 'alarm4', coordalrm = vector3(-630.99, -229.95, 37.06), long = 1.0, larg = 1.0, headingalrm = 212.34, minz = 37.06, maxz = 39.06},
    }

    for i = 1, #codesearch, 1 do -- start loop
        local zone = codesearch[i].zone
        local coord = codesearch[i].coordalrm
        local long = codesearch[i].long
        local larg = codesearch[i].larg
        local minz = codesearch[i].minz
        local maxz = codesearch[i].maxz
        local headingalrm = codesearch[i].headingalrm

        exports.qtarget:AddBoxZone(zone, coord, long, larg, {
	        name=zone,
	        heading=headingalrm,
	        debugPoly=false,
	        minZ=minz,  
	        maxZ=maxz,
	        }, {
		        options = {
			        {
				        icon = "fas fa-sign-in-alt",
				        label = menu2,
                        action = function(entity)
                            TriggerEvent('tofjew:searchcode')
                        end,
		    	    },		    
		        },
		        distance = 1.5
            })
    
    end -- en loop

    exports.qtarget:AddBoxZone('boitieralrm', vector3(-629.36, -230.80, 38.06), 1, 1, {
        name='boitieralrm',
        heading=39.52,
        debugPoly=false,
        minZ=38.06,  
        maxZ=40.06,
        }, {
            options = {
                {
                    icon = "fas fa-sign-in-alt",
                    label = menu3,
                    action = function(entity)
                        TriggerEvent('tofjew:codeinput')
                    end,
                },		    
            },
            distance = 1.5
        })

    -------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------- Vitrine zones --------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------

    local vitrines = {
        {zone = 'vit1', coordvit = vector3(-626.92, -235.40, 38.06), long = 1.0, larg = 1.0, headingvit = 37.91, minz = 38.06, maxz = 39.06},    
        {zone = 'vit2', coordvit = vector3(-625.78, -234.57, 38.06), long = 1.0, larg = 1.0, headingvit = 38.06, minz = 38.06, maxz = 39.06},    
        {zone = 'vit3', coordvit = vector3(-626.92, -233.14, 38.06), long = 1.0, larg = 1.0, headingvit = 213.21, minz = 38.06, maxz = 39.06},    
        {zone = 'vit4', coordvit = vector3(-627.93, -233.83, 38.06), long = 1.0, larg = 1.0, headingvit = 218.30, minz = 38.06, maxz = 39.06},
        {zone = 'vit5', coordvit = vector3(-626.78, -238.62, 38.06), long = 1.0, larg = 1.0, headingvit = 219.62, minz = 38.06, maxz = 39.06},        
        {zone = 'vit6', coordvit = vector3(-625.72, -237.84, 38.06), long = 1.0, larg = 1.0, headingvit = 218.60, minz = 38.06, maxz = 39.06},    
        {zone = 'vit7', coordvit = vector3(-623.06, -232.95, 38.06), long = 1.0, larg = 1.0, headingvit = 297.85, minz = 38.06, maxz = 39.06},
        {zone = 'vit8', coordvit = vector3(-624.56, -230.88, 38.06), long = 1.0, larg = 1.0, headingvit = 314.69, minz = 38.06, maxz = 39.06},        
        {zone = 'vit9', coordvit = vector3(-621.06, -228.56, 38.06), long = 1.0, larg = 1.0, headingvit = 124.19, minz = 38.06, maxz = 39.06},    
        {zone = 'vit10', coordvit = vector3(-619.47, -230.61, 38.06), long = 1.0, larg = 1.0, headingvit = 125.43, minz = 38.06, maxz = 39.06},    
    }

    for i = 1, #vitrines, 1 do -- start loop
        local zone = vitrines[i].zone
        local coord = vitrines[i].coordvit
        local long = vitrines[i].long
        local larg = vitrines[i].larg
        local minz = vitrines[i].minz
        local maxz = vitrines[i].maxz
        local headingvit = vitrines[i].headingvit

        exports.qtarget:AddBoxZone(zone, coord, long, larg, {
	        name=zone,
	        heading=headingvit,
	        debugPoly=false,
	        minZ=minz,  
	        maxZ=maxz,
	        }, {
		        options = {
			        {
				        icon = "fas fa-sign-in-alt",
				        label = menu1,
                        action = function(entity)
                            if GetGameTimer() > nextVitrin then
                                if robstate == false then  
                                    TriggerServerEvent('tofjew:onrob', coord, zone) -- verify the cooldown
                                end
                                if robstate == true then
                                    TriggerServerEvent('tofjew:zonerobon', coord, zone)
                                end 
                            else
                                TriggerEvent('tofjew:spam')
                            end
                        end,
		    	    },		    
		        },
		        distance = 1.5
            })
    
    end -- en loop

    -------------------------------------------------------------------------
    ---------------------- create blip on map ------------------------------
    -------------------------------------------------------------------------
    
      local blip = AddBlipForCoord(-626.92, -235.40, 38.06)  
      SetBlipSprite(blip, 675)  -- change blip sprite ** https://docs.fivem.net/docs/game-references/blips/
      SetBlipScale(blip, 1.00)  -- change blip scale
      SetBlipColour(blip, 48)    -- change blip color
      SetBlipAsShortRange(blip, true)
  
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentSubstringPlayerName('Bijouterie') -- name of blip
      EndTextCommandSetBlipName(blip)
    end)
end)

-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- anti spam loot-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

local function SetnextVitrin()
    nextVitrin = GetGameTimer() + cd
end    

-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- generate code -------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

local function SetNextCode()
    Citizen.Wait(3540000)
    alarmcode = math.random(125362, 999999)
    codealarm = false
end    

-----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- ROB State --------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('tofjew:robstate')
AddEventHandler('tofjew:robstate', function()
    robstate = true
    SetNextCode()
    Citizen.Wait(3540000)
    robstate = false
end)

-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ Robbery Action -------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('tofjew:breakglass')
AddEventHandler('tofjew:breakglass', function(coord)
    ------------------- alarm -------------------------------
    if codealarm == false then
        PlaySoundFromCoord(alarmid, "VEHICLES_HORNS_AMBULANCE_WARNING", -624.27, -232.19, 39.06, '', true, 10, false ) 
    end
    ------------------- fin alarm -------------------------------
        SetnextVitrin()
        PlaySoundFromCoord(-1, 'Glass_Smash', coord.x, coord.y, coord.z, '', true, 5, false)
        if not HasNamedPtfxAssetLoaded('scr_jewelheist') then RequestNamedPtfxAsset('scr_jewelheist') end
        while not HasNamedPtfxAssetLoaded('scr_jewelheist') do Citizen.Wait(0) end
        SetPtfxAssetNextCall('scr_jewelheist')
        StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', coord.x, coord.y, coord.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        loadAnimDict('missheist_jewel') 
        Citizen.Wait(200)
        TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
        Citizen.Wait(2000)
        DoScreenFadeOut(2000)
        Citizen.Wait(1000)
        TaskTurnPedToFaceCoord(PlayerPedId(), coord.x, coord.y, coord.z, 5000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, 1)
        Citizen.Wait(40000)
		TriggerServerEvent('tofjew:lootjewels', codealarm)
        Citizen.Wait(500)
		PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
        ClearPedTasksImmediately(PlayerPedId())
end)

-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ Alarm Actions --------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('tofjew:searchcode')
AddEventHandler('tofjew:searchcode', function()
    if robstate == true then
        local findchance = math.random(1,4)
        if findchance == 1 then
            TriggerEvent('tofjew:nocode')
        end
        if findchance > 2 then
            TriggerEvent('tofjew:codeview')
        end
    else
        TriggerEvent('tofjew:coderobbery')
    end
end)

RegisterNetEvent('tofjew:codeinput')
AddEventHandler('tofjew:codeinput', function()
    local input = lib.inputDialog('Code Alarme', {'Saisir Code'})
    if input then
        inputalrmcode = tonumber(input[1])
        if inputalrmcode ~= alarmcode then 
            codealarm = false
            ------------------**notification**----------------------
            lib.showTextUI('Code erronné', {
                position = "top-center",
                icon = 'gun-squirt',
                style = {
                    borderRadius = 0,
                    backgroundColor = '#FF1300',
                    color = 'white'
                }
            })
            Citizen.Wait(2000)
            lib.hideTextUI()
            ------------------**fin notification**-----------------
        end
        if inputalrmcode == alarmcode then 
            codealarm = true
            StopSound(alarmid)
            ------------------**notification**----------------------
            lib.showTextUI('Alarme éteinte', {
                position = "top-center",
                icon = 'gun-squirt',
                style = {
                    borderRadius = 0,
                    backgroundColor = '#FF1300',
                    color = 'white'
                }
            })
            Citizen.Wait(2000)
            lib.hideTextUI()
            ------------------**fin notification**-----------------
        end
    end
end)

-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------Notifications ------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("tofjew:nocops")
AddEventHandler("tofjew:nocops", function()
    ------------------**notification**----------------------
    lib.showTextUI(nocops, {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(1500)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
end)

RegisterNetEvent("tofjew:onrobbing")
AddEventHandler("tofjew:onrobbing", function()
    ------------------**notification**----------------------
    lib.showTextUI(alreadyrob, {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(1500)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
end)

RegisterNetEvent("tofjew:spam")
AddEventHandler("tofjew:spam", function()
    ------------------**notification**----------------------
    lib.showTextUI(spam, {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(1500)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
end)

RegisterNetEvent("tofjew:zonealreadydone")
AddEventHandler("tofjew:zonealreadydone", function()
    ------------------**notification**----------------------
    lib.showTextUI(zonealreadydone, {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(1500)
    lib.hideTextUI()
    ------------------**fin notification**-----
    ------------
end)

RegisterNetEvent("tofjew:nospace")
AddEventHandler("tofjew:nospace", function()
    ------------------**notification**----------------------
    lib.showTextUI(nospace, {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(1500)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
end)

RegisterNetEvent("tofjew:lootmsg")
AddEventHandler("tofjew:lootmsg", function(item, count)
    ------------------**notification**----------------------
    lib.showTextUI(loot..' '..count..' x '..item, {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(1500)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
end)

RegisterNetEvent("tofjew:codeview")
AddEventHandler("tofjew:codeview", function()
    ------------------**notification**----------------------
    lib.showTextUI('**' ..alarmcode.. '**', {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(5500)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
end)

RegisterNetEvent("tofjew:nocode")
AddEventHandler("tofjew:nocode", function()
    ------------------**notification**----------------------
    lib.showTextUI(nocode, {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(1500)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
end)

RegisterNetEvent("tofjew:coderobbery")
AddEventHandler("tofjew:coderobbery", function()
    ------------------**notification**----------------------
    lib.showTextUI(coderobbery, {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = '#FF1300',
            color = 'white'
        }
    })
    Citizen.Wait(1500)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
end)

-------------------------------------------------------------------------
------------------------- msg LSPD --------------------------------------
-------------------------------------------------------------------------

RegisterNetEvent("tofjew:msgpolice")
AddEventHandler("tofjew:msgpolice", function(coords)
    ------------------**notification**----------------------
    lib.showTextUI('Braquage en cours - Position GPS de l\'alarme dans 30s', {
        position = "top-center",
        icon = 'gun-squirt',
        style = {
            borderRadius = 0,
            backgroundColor = 'red',
            color = 'white'
        }
    })
    Citizen.Wait(30000)
    lib.hideTextUI()
    ------------------**fin notification**-----------------
    TriggerEvent('tofjew:blipPolice')
end)

-------------------------------------------------------------------------
------------------------ blip LSPD --------------------------------------
-------------------------------------------------------------------------

RegisterNetEvent("tofjew:blipPolice")
AddEventHandler("tofjew:blipPolice", function()
    local alertblip = AddBlipForCoord(-620.07, -233.89, 38.06)
    SetBlipSprite(alertblip, 161)
    SetBlipScale(alertblip, 2.0)
    SetBlipColour(alertblip, 5)
    PulseBlip(alertblip)
    Wait(600000)
    RemoveBlip(alertblip)
end)

-------------------------------------------------------------------------------------------
function loadAnimDict(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end 
