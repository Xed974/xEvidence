RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local data = {}
RegisterNetEvent("xEvidence:refresh")
AddEventHandler("xEvidence:refresh", function(result)
    data = result
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    TriggerServerEvent("xEvidence:actualiseAll")
end)

myEvidence = {}
TriggerServerEvent("xEvidence:actualiseAll")

CreateThread(function()
    while true do
        local wait = 1000
        for _,v in pairs(data) do
            local pos = json.decode(v.pos)
            local pPos = GetEntityCoords(PlayerPedId())
            local dst = Vdist(pPos.x, pPos.y, pPos.z, pos.x, pos.y, pos.z)
            
            if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobRequis then
                if dst <= 3.0 then
                    wait = 0
                    DrawMarker(Config.MarkerType, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)
                end
                if dst <= 1.0 then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ramasser un échantillon de la balle.")
                    if IsControlJustPressed(1, 51) then
                        if #myEvidence > 0 then
                            for a,b in pairs(myEvidence) do
                                if b.id ~= v.id then
                                    ESX.ShowNotification("(~g~Succès~s~)\nEchantillon récupérer.")
                                    table.insert(myEvidence, {type = v.type, pos = v.pos, name = v.name, id = v.id})
                                    TriggerServerEvent("xEvidence:clear", v.id)
                                end
                            end
                        else
                            ESX.ShowNotification("(~g~Succès~s~)\nEchantillon récupérer.")
                            table.insert(myEvidence, {type = v.type, pos = v.pos, name = v.name, id = v.id})
                            TriggerServerEvent("xEvidence:clear", v.id)
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)
