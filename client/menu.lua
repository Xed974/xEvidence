local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

--

local open = false
local mainMenu = RageUI.CreateMenu(Config.Title, Config.Subtitle, nil, nil, Config.TextureDictionary, Config.TextureName)
mainMenu.Closed = function() open = false FreezeEntityPosition(PlayerPedId(), false) end

local function openMenuAnalyze()
    if open then
        open = false
        RageUI.Visible(mainMenu, false)
    else
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)
                RageUI.IsVisible(mainMenu, function()
                    if #myEvidence > 0 then
                        RageUI.Separator("Vos échantillons :")
                        RageUI.Line()
                        for _,v in pairs(myEvidence) do
                            RageUI.Button(("Analyser l'échantillon (n°~%s~%s~s~)"):format(Config.Color, v.id), nil, {RightLabel = "→→"}, true, {
                                onSelected = function()
                                    local chance = math.random(Config.ChanceMin, Config.ChanceMax)
                                    if Config.ChanceRequis == chance then
                                        ESX.ShowNotification(("(~y~Information~s~)\nBalle appartenant à ~%s~%s~s~, tiré à partir d\'un(e) ~%s~%s~s~."):format(Config.Color, v.name, Config.Color, v.type))
                                    else
                                        ESX.ShowNotification("(~r~Erreur~s~)\nL\'analyse à mener à rien.")
                                    end
                                    table.remove(myEvidence, _)
                                end
                            })
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Vous avez aucun échantillon.")
                        RageUI.Separator("")
                    end
                end)
            end
        end)
    end
end

CreateThread(function()
    while true do
        local wait = 1000
        for k in pairs(Config.positionAnalyze) do
            local pos = Config.positionAnalyze
            local pPos = GetEntityCoords(PlayerPedId())
            local dst = Vdist(pPos.x, pPos.y, pPos.z, pos[k].x, pos[k].y, pos[k].z)

            if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobRequis then
                if dst <= Config.MarkerDistance then
                    wait = 0
                    DrawMarker(Config.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)
                end
                if dst <= Config.OpenMenuDistance then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour intéragir.")
                    if IsControlJustPressed(1, 51) then
                        local keyboard = KeyboardInput("Code:", "", 4)
                        if tonumber(keyboard) == Config.CodeMenu then
                            FreezeEntityPosition(PlayerPedId(), true)
                            openMenuAnalyze()
                        else
                            ESX.ShowNotification("(~r~Erreur~s~)\nCode incorrecte.")
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

--- Xed#1188 | https://discord.gg/HvfAsbgVpM