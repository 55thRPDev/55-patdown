
local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('patdown:client:PatDownPlayer', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = QBCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 3 then
                local playerId = GetPlayerServerId(player)
                if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(PlayerPedId()) then
                    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
                    Wait(2000)
                    TriggerServerEvent("patdown:server:PatDownPlayer", playerId)
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})

                else
                    QBCore.Functions.Notify("Can't pat someone down in a vehicle", "error")
                end
        else
            QBCore.Functions.Notify("Nobody is near you", "error")
        end
    else
        Wait(2000)
    end
end)