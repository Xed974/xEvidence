local function getNameWeapon(hash)
    for _,v in pairs(Config.Weapons) do
        if hash == v.hash then
            return v.name
        end
    end
    return "Arme non répertoriré"
end

CreateThread(function()
    while true do
        local wait = 1000
        if IsPedArmed(PlayerPedId(), 4) then
            wait = 0
            if IsPedShooting(PlayerPedId()) then
                TriggerServerEvent("xEvidence:shoot", GetEntityCoords(PlayerPedId()), getNameWeapon(GetSelectedPedWeapon(PlayerPedId())))
            end
        end
        Wait(wait)
    end
end)

--- Xed#1188 | https://discord.gg/HvfAsbgVpM