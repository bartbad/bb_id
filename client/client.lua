ESX = exports['es_extended']:getSharedObject()
local displayIDs = false
local displayRadius = 200.0 --max id display radius

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlPressed(0, 20) then
            if not displayIDs then
                displayIDs = true
            end
        else
            if displayIDs then
                displayIDs = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayIDs then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                if DoesEntityExist(ped) then
                    local targetCoords = GetEntityCoords(ped)
                    local distance = #(playerCoords - targetCoords)
                    if distance <= displayRadius then
                        local playerId = GetPlayerServerId(player)
                        local x, y, z = table.unpack(targetCoords)
                        z = z + 1.0 
                        local isTalking = MumbleIsPlayerTalking(player)
                        local textColor = isTalking and {120, 120, 255, 215} or {255, 255, 255, 215}
                        DrawText3D(x, y, z, tostring(playerId), textColor)
                    end
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.7, 0.7)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(color[1], color[2], color[3], color[4])
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end