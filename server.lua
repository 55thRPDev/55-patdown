
local QBCore = exports['qb-core']:GetCoreObject()

WeaponPatdownItems = Config.Weapons

DrugPatdownItems = Config.Drugs

QBCore.Commands.Add("patdown", "Pat down someones pockets", {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if (Player.PlayerData.job.type == "leo") then
        TriggerClientEvent("patdown:client:PatDownPlayer", src)
    else
        TriggerClientEvent('QBCore:Notify', src, "You can't do this", 'error')
    end
end)


RegisterNetEvent('patdown:server:PatDownPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local TestedPlayer = QBCore.Functions.GetPlayer(playerId)
    if not Player or not TestedPlayer then return end
        for slot, item in pairs(TestedPlayer.PlayerData.items) do
            if WeaponPatdownItems[item.name] then
               TriggerClientEvent('QBCore:Notify', src, "You feel something hard in thier pocket ", 'success')
               if Player.Functions.AddItem(item.name, amount, false, item.info) then
                    TriggerClientEvent('inventory:client:ItemBox',src, QBCore.Shared.Items[item.name], "add")
                    TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
                    TestedPlayer.Functions.RemoveItem(item.name, item.amount, slot)
                    TriggerClientEvent('inventory:client:ItemBox',playerId, QBCore.Shared.Items[item.name], "remove")
                    TriggerClientEvent("inventory:client:UpdatePlayerInventory", playerId, true)
                    TriggerClientEvent('QBCore:Notify', playerId, "They found your weapons! ", 'error')
                    TriggerClientEvent('QBCore:Notify', src, item.amount .. "x " .. item.name .. " found on person ", 'error')
                else
                    QBCore.Functions.Notify(src, "You found something, but your inventory is full", "error")
                    TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
                    TriggerClientEvent("inventory:client:UpdatePlayerInventory", playerId, false)
                end
            end
            if DrugPatdownItems[item.name] and item.amount >= Config.MinDrugs then
                TriggerClientEvent('QBCore:Notify', src, "You feel a bag of something in thier pocket ", 'success')
                if  Player.Functions.AddItem(item.name, item.amount) then
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "add", item.amount)
                    TestedPlayer.Functions.RemoveItem(item.name, item.amount, slot)
                    TriggerClientEvent('inventory:client:ItemBox', playerId, QBCore.Shared.Items[item.name], "remove", item.amount)
                    TriggerClientEvent('QBCore:Notify', playerId, "They found your drugs! ", 'error')
                    TriggerClientEvent('QBCore:Notify', src, item.amount .. "x " .. item.name .. " found on person ", 'error')
                else
                    QBCore.Functions.Notify(src, "You found something, but your inventory is full", "error")
                    TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
                    TriggerClientEvent("inventory:client:UpdatePlayerInventory", playerId, false)
                end

            end
        end
end)