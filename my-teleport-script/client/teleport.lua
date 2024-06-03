-- Path: resources/my-teleport-script/client/teleport.lua

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('my-teleport-script:teleport')
AddEventHandler('my-teleport-script:teleport', function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    QBCore.Functions.Notify("Teleported to the specified location", "success")
    print("Teleported to coordinates: " .. tostring(coords))
end)

RegisterNetEvent('my-teleport-script:openUI')
AddEventHandler('my-teleport-script:openUI', function(locations)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openUI',
        locations = locations
    })
end)

RegisterNetEvent('my-teleport-script:returnLocations')
AddEventHandler('my-teleport-script:returnLocations', function(locations)
    SendNUIMessage({
        action = 'updateLocations',
        locations = locations
    })
end)

RegisterNUICallback('teleport', function(data, cb)
    TriggerServerEvent('my-teleport-script:teleportMe', data.coords)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeUI' })
    cb('ok')
end)

RegisterNUICallback('save', function(data, cb)
    TriggerServerEvent('my-teleport-script:saveCoords')
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeUI' })
    cb('ok')
end)

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 322) then -- ESC
            SetNuiFocus(false, false)
            SendNUIMessage({ action = 'closeUI' })
        end
    end
end)
