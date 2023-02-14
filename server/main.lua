RegisterNetEvent("xEvidence:actualiseAll")
AddEventHandler("xEvidence:actualiseAll", function()
    MySQL.Async.fetchAll("SELECT * FROM evidence", {}, function(result)
        TriggerClientEvent("xEvidence:refresh", -1, result)
    end)
end)

RegisterNetEvent("xEvidence:shoot")
AddEventHandler("xEvidence:shoot", function(pPos, type)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    MySQL.Async.execute("INSERT INTO evidence (type, pos, name) VALUES (@type, @pos, @name)", {
        ["@type"] = type,
        ["@pos"] = json.encode(pPos),
        ["@name"] = xPlayer.getName()
    }, function(result) if result == 1 then TriggerEvent("xEvidence:actualiseAll") end end)
end)

RegisterNetEvent("xEvidence:clear")
AddEventHandler("xEvidence:clear", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    MySQL.Async.execute("DELETE FROM evidence WHERE id = @id", { ["@id"] = id }, function(result) if result == 1 then TriggerEvent("xEvidence:actualiseAll") end end)
end)
