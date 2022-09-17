local nextVitrin = 0
local codealarm = false
local robstate = false
local alarmcode = math.random(125362, 999999)
local inputalrmcode = tonumber(0)
local theJewel = 'r7zXh6LBjj'

if GetResourceState('ox_lib') == 'started' then
    lib.locale()
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
    JobInit()
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
    JobInit()
end)


function JobInit()
    Citizen.CreateThread(function()
        local jobs = {
            {name = 'police'},          -- LSPD in service
            {name = 'offpolice'},       -- LSPD out of service
            {name = 'ambulance'},       -- EMS in service
            {name = 'offambulance'},    -- EMS out of service
        }
        for a = 1, #jobs, 1 do
            local jobsname = jobs[a].name
            if ESX.PlayerData.job.name ~= jobsname then
                JewelryInit()
            else
                return
            end
        end
    end)
end

function JewelryInit()
    Citizen.CreateThread(function()
        for i = 1, #cfg.SearchLocation, 1 do
            local theDataX = cfg.SearchLocation[i]
            local zone = theDataX.zone
            local coord = theDataX.coordalrm
            local long = theDataX.long
            local larg = theDataX.larg
            local minz = theDataX.minz
            local maxz = theDataX.maxz
            local headingalrm = theDataX.headingalrm
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
                        label = locale('find_code'),
                        action = function(entity)
                            TriggerEvent('tofjew:searchcode')
                        end,
                    },		    
                },
                distance = 1.5
            })    
        end
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
                    label = locale('enter_code'),
                    action = function(entity)
                        TriggerEvent('tofjew:codeinput')
                    end,
                },		    
            },
            distance = 1.5
        })
        for i = 1, #cfg.JewelryLoot, 1 do
            local theDataZ = cfg.JewelryLoot[i]
            local zone = theDataZ.zone
            local coord = theDataZ.coordvit
            local long = theDataZ.long
            local larg = theDataZ.larg
            local minz = theDataZ.minz
            local maxz = theDataZ.maxz
            local headingvit = theDataZ.headingvit
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
                        label = locale('break_window'),
                        action = function(entity)
                            if GetGameTimer() > nextVitrin then
                                if not robstate then  
                                    TriggerServerEvent('tofjew:onrob', coord, zone)
                                end
                                if robstate then
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
        end
        local blip = AddBlipForCoord(-626.92, -235.40, 38.06)  
        SetBlipSprite(blip, 675) 
        SetBlipScale(blip, 1.00)
        SetBlipColour(blip, 48)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Jewelry Robbery')
        EndTextCommandSetBlipName(blip)
    end)
end

local function SetnextVitrin()
    nextVitrin = GetGameTimer() + cfg.CLJewelryNextRob
end    

local function SetNextCode()
    Citizen.Wait(3540000)
    alarmcode = math.random(125362, 999999)
    codealarm = false
end    

RegisterNetEvent('tofjew:robstate')
AddEventHandler('tofjew:robstate', function()
    robstate = true
    SetNextCode()
    Citizen.Wait(3540000)
    robstate = false
end)

RegisterNetEvent('tofjew:breakglass')
AddEventHandler('tofjew:breakglass', function(coord)
    if not codealarm then
        PlaySoundFromCoord(GetSoundId(), "VEHICLES_HORNS_AMBULANCE_WARNING", -624.27, -232.19, 39.06, '', true, 10, false ) 
    end
    SetnextVitrin()
    PlaySoundFromCoord(-1, 'Glass_Smash', coord.x, coord.y, coord.z, '', true, 5, false)
    if not HasNamedPtfxAssetLoaded('scr_jewelheist') then RequestNamedPtfxAsset('scr_jewelheist') end
    while not HasNamedPtfxAssetLoaded('scr_jewelheist') do Citizen.Wait(0) end
    SetPtfxAssetNextCall('scr_jewelheist')
    StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', coord.x, coord.y, coord.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    lib.requestAnimDict('missheist_jewel', 100) 
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
    TriggerServerEvent('tofjew:lootjewels', codealarm, theJewel)
    Citizen.Wait(500)
    PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    ClearPedTasksImmediately(PlayerPedId())        
end)

RegisterNetEvent('tofjew:searchcode')
AddEventHandler('tofjew:searchcode', function()
    if robstate then
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
    local input = lib.inputDialog(locale('code'), {locale('enter_code')})
    if input then
        local inputalrmcode = tonumber(input[1])
        local theAlarmCode = tonumber(alarmcode)
        if input[1] == nil or input[1] == "" or type(inputalrmcode) ~= 'number' then
            lib.notify({title = 'Jewelry', description = locale('invalid_code'), type = 'error'})
        else
            if inputalrmcode ~= theAlarmCode then 
                codealarm = false
                lib.showTextUI(locale('invalid_code'), {
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
            else
                codealarm = true
                StopSound(GetSoundId())
                lib.showTextUI(locale('alarm_off'), {
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
            end
        end
    end
end)

RegisterNetEvent("tofjew:nocops")
AddEventHandler("tofjew:nocops", function()
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
end)

RegisterNetEvent("tofjew:onrobbing")
AddEventHandler("tofjew:onrobbing", function()
    lib.showTextUI(locale('robbing_inprogress'), {
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
end)

RegisterNetEvent("tofjew:spam")
AddEventHandler("tofjew:spam", function()
    lib.showTextUI(locale('spam'), {
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
end)

RegisterNetEvent("tofjew:zonealreadydone")
AddEventHandler("tofjew:zonealreadydone", function()
    lib.showTextUI(locale('already_broken'), {
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
end)

RegisterNetEvent("tofjew:nospace")
AddEventHandler("tofjew:nospace", function()
    lib.showTextUI(locale('inv_full'), {
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
end)

RegisterNetEvent("tofjew:lootmsg")
AddEventHandler("tofjew:lootmsg", function(item, count)
    lib.showTextUI(locale('loot')..' '..count..' x '..item, {
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
end)

RegisterNetEvent("tofjew:codeview")
AddEventHandler("tofjew:codeview", function()
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
end)

RegisterNetEvent("tofjew:nocode")
AddEventHandler("tofjew:nocode", function()
    lib.showTextUI(locale('no_code'), {
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
end)

RegisterNetEvent("tofjew:coderobbery")
AddEventHandler("tofjew:coderobbery", function()
    lib.showTextUI(locale('jewel_robbery'), {
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
end)

RegisterNetEvent("tofjew:msgpolice")
AddEventHandler("tofjew:msgpolice", function(coords)
    lib.showTextUI(locale('alarm_notify'), {
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
    TriggerEvent('tofjew:blipPolice')
end)

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