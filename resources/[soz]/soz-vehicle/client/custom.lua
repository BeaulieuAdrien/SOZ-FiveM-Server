QBCore = exports["qb-core"]:GetCoreObject()
Gready = false
Gfinishready = false
Gveh = nil
Gped = nil
Gcoords = nil
Gdict = nil
Gmodel = nil
Goffset = nil
Gheadin = nil
Gvehicle = nil
Gvehpos = nil
Gvehjack = nil

function GetCurrentMod(id)
    local mod = GetVehicleMod(Config.AttachedVehicle, id)
    local modName = GetLabelText(GetModTextLabel(Config.AttachedVehicle, id, mod))

    return mod, modName
end

function GetCurrentTurboState()
    local isEnabled = IsToggleModOn(Config.AttachedVehicle, 18)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function CheckValidMods(category, id)
    local tempMod = GetVehicleMod(Config.AttachedVehicle, id)
    local validMods = {}
    local amountValidMods = 0
    local hornNames = {}
    local modAmount = GetNumVehicleMods(Config.AttachedVehicle, id)

    for i = 1, modAmount do
        local label = GetModTextLabel(Config.AttachedVehicle, id, (i - 1))
        local modName = GetLabelText(label)

        if modName == "NULL" then
            if id == 14 then
                if i <= #hornNames then
                    modName = hornNames[i].name
                else
                    modName = "Horn " .. i
                end
            else
                modName = category .. " " .. i
            end
        end

        validMods[i] = {id = (i - 1), name = modName}

        amountValidMods = amountValidMods + 1
    end

    if modAmount > 0 then
        table.insert(validMods, 1, {id = -1, name = "Stock " .. category})
    end

    return validMods, amountValidMods
end

RegisterNetEvent("soz-custom:client:applymod", function(categoryID, modID)
    if categoryID == 18 then
        ToggleVehicleMod(Config.AttachedVehicle, categoryID, modID)
    else
        SetVehicleMod(Config.AttachedVehicle, categoryID, modID)
    end
end)

local function finishAnimation()
    Gdict = "move_crawl"
    local coords2 = GetEntityCoords(Gped)
    RequestAnimDict(Gdict)
    while not HasAnimDictLoaded(Gdict) do
        Citizen.Wait(1)
    end
    TaskPlayAnimAdvanced(Gped, Gdict, "onback_fwd", coords2, 0.0, 0.0, Gheadin - 180, 1.0, 0.5, 2000, 1, 0.0, 1, 1)
    Citizen.Wait(3000)
    Gdict = "mp_car_bomb"
    RequestAnimDict(Gdict)
    while not HasAnimDictLoaded(Gdict) do
        Citizen.Wait(1)
    end

    FreezeEntityPosition(Gveh, true)
    SetVehicleFixed(Gvehicle)
    SetVehicleDeformationFixed(Gvehicle)
    SetVehicleUndriveable(Gvehicle, false)
    SetVehicleEngineOn(Gvehicle, true, true)
    ClearPedTasksImmediately(PlayerPedId())

    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
    Citizen.Wait(1250)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z + 0.4, true, true, true)
    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z + 0.3, true, true, true)
    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z + 0.2, true, true, true)
    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z + 0.15, true, true, true)
    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z + 0.1, true, true, true)
    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z + 0.05, true, true, true)
    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z + 0.025, true, true, true)
    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Gdict = "move_crawl"
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z + 0.01, true, true, true)
    TaskPlayAnimAdvanced(Gped, Gdict, "car_bomb_mechanic", Gcoords, 0.0, 0.0, Gheadin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    SetEntityCoordsNoOffset(Gveh, Gvehpos.x, Gvehpos.y, Gvehpos.z, true, true, true)
    FreezeEntityPosition(Gveh, false)
    Citizen.Wait(100)
    DetachEntity(Gvehjack, true, false)
    SetEntityCollision(Gvehjack, false, false)
    DeleteEntity(Gvehjack)

    SetEntityCollision(Gveh, true, true)
    Gfinishready = false
    exports["soz-hud"]:DrawNotification("Véhicule libéré")
end

local VehiculeOptions = MenuV:CreateMenu(nil, "LS Customs", "menu_shop_lscustoms", "soz", "custom:vehicle:options")
local Upgrade = MenuV:InheritMenu(VehiculeOptions, "Upgrade")
local UpgradeMenu = MenuV:InheritMenu(Upgrade, "Upgrade Menu")

local function OpenUpgrade(menu, v, k)
    menu:ClearItems()
    MenuV:OpenMenu(menu)
    menu:AddButton({
        icon = "◀",
        label = "Retour",
        select = function()
            menu:Close()
        end,
    })

    local validMods, amountValidMods = CheckValidMods(v.category, v.id)
    local currentMod, currentModName = GetCurrentMod(v.id)

    if amountValidMods > 0 or v.id == 18 then
        if v.id == 11 or v.id == 12 or v.id == 13 or v.id == 15 or v.id == 16 then -- Performance
            local tempNum = 0
            for m, n in pairs(validMods) do
                tempNum = tempNum + 1

                local price = 0
                for custompriceindex, customprice in ipairs(Config.vehicleCustomisationPricesCustom) do
                    if v.id == customprice.id then
                        price = customprice.prices[tempNum] *
                                    QBCore.Shared.Vehicles[GetDisplayNameFromVehicleModel(GetEntityModel(Config.AttachedVehicle)):lower()].price
                    end
                end

                if Config.maxVehiclePerformanceUpgrades == 0 then
                    if currentMod == n.id then
                        menu:AddButton({label = n.name .. " - ~g~Installed"})
                    else
                        menu:AddButton({
                            label = n.name .. " - $" .. price,
                            value = price,
                            description = "Acheter 💸",
                            select = function(btn)
                                menu:Close()
                                TriggerServerEvent("soz-custom:server:buyupgrade", v.id, n, btn.Value)
                            end,
                        })
                    end
                else
                    if tempNum <= (Config.maxVehiclePerformanceUpgrades + 1) then
                        if currentMod == n.id then
                            menu:AddButton({label = n.name .. " - ~g~Installed"})
                        else
                            menu:AddButton({
                                label = n.name .. " - $" .. price,
                                value = price,
                                description = "Acheter 💸",
                                select = function(btn)
                                    menu:Close()
                                    TriggerServerEvent("soz-custom:server:buyupgrade", v.id, n, btn.Value)
                                end,
                            })
                        end
                    end
                end
            end
        elseif v.id == 18 then
            local currentTurboState = GetCurrentTurboState()
            if currentTurboState == 0 then
                for custompriceindex, customprice in ipairs(Config.vehicleCustomisationPricesCustom) do
                    if customprice.id == v.id then
                        local price = customprice.prices[1] *
                                            QBCore.Shared.Vehicles[GetDisplayNameFromVehicleModel(GetEntityModel(Config.AttachedVehicle)):lower()].price
                        menu:AddButton({label = "Disable - ~g~Installed"})
                        menu:AddButton({
                            label = "Enable" .. " - $" .. price,
                            description = "Acheter 💸",
                            select = function()
                                menu:Close()
                                TriggerServerEvent("soz-custom:server:buyupgrade", v.id, 1, price)
                            end,
                        })
                    end
                end
            else
                menu:AddButton({
                    label = "Disable",
                    description = "Gratuit 💸",
                    select = function()
                        menu:Close()
                        TriggerEvent("soz-custom:client:applymod", v.id, 0)
                        exports["soz-hud"]:DrawNotification("Le turbo a été enlevé!")
                    end,
                })
                menu:AddButton({label = "Enable - Installed"})
            end
        end
    end
end

local function OpenUpgradesMenu(menu)
    menu:ClearItems()
    MenuV:OpenMenu(menu)
    menu:AddButton({
        icon = "◀",
        label = "Retour",
        select = function()
            menu:Close()
        end,
    })
    for k, v in ipairs(Config.vehicleCustomisationCustom) do
        local validMods, amountValidMods = CheckValidMods(v.category, v.id)
        if amountValidMods > 0 or v.id == 18 then
            menu:AddButton({
                label = v.category,
                select = function()
                    OpenUpgrade(UpgradeMenu, v, k)
                end,
            })
        end
    end
end

local function OpenMenu(menu)
    local veh = Config.AttachedVehicle
    FreezeEntityPosition(veh, true)
    menu:AddButton({
        icon = "◀",
        label = "Libérer le véhicule",
        description = "Détacher le véhicule de la plateforme",
        select = function()
            if Gready == true then
                TriggerEvent("soz-custom:client:UnattachVehicle")
                Gfinishready = true
                menu:Close()
                finishAnimation()
                SetVehicleDoorsLocked(veh, 1)
            else
                exports["soz-hud"]:DrawNotification("Veuillez attendre de monter le clic avant de le redescendre", "error")
            end
        end,
    })
    menu:AddButton({
        label = "Amélioration du véhicule",
        description = "Améliorer les pièces du véhicule",
        select = function()
            SetVehicleModKit(veh, 0)
            OpenUpgradesMenu(Upgrade)
        end,
    })
    menu:On("close", function()
        if Gready == true then
            Gready = false
            menu:Close()
        else
            exports["soz-hud"]:DrawNotification("Veuillez libérer le véhicule avant de partir", "error")
            menu:Open()
        end
    end)
end

local function GenerateOpenMenu()
    if VehiculeOptions.IsOpen then
        VehiculeOptions:Close()
    else
        VehiculeOptions:ClearItems()
        OpenMenu(VehiculeOptions)
        VehiculeOptions:Open()
    end
end

local function UnattachVehicle()
    FreezeEntityPosition(Config.AttachedVehicle, false)
    Config.AttachedVehicle = nil
    TriggerServerEvent("qb-vehicletuning:server:SetAttachedVehicle", false)
end

-- Events
RegisterNetEvent("soz-custom:client:UnattachVehicle", function()
    UnattachVehicle()
end)

RegisterNetEvent("soz-custom:client:SetAttachedVehicle", function(veh)
    if veh ~= false then
        Config.AttachedVehicle = veh
    else
        Config.AttachedVehicle = nil
    end
end)

RegisterNetEvent("vehiclemod:client:setPartLevel", function(part, level)
    if (IsPedInAnyVehicle(PlayerPedId(), false)) then
        local veh = Config.AttachedVehicle
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            local plate = QBCore.Functions.GetPlate(veh)
            if part == "engine" then
                SetVehicleEngineHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", GetVehicleEngineHealth(veh))
            elseif part == "body" then
                SetVehicleBodyHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", GetVehicleBodyHealth(veh))
            else
                TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
            end
        else
            exports["soz-hud"]:DrawNotification("You Are Not The Driver Or On A Bicycle", "error")
        end
    else
        exports["soz-hud"]:DrawNotification("You Are Not The Driver Or On A Bicycle", "error")
    end
end)

local function startAnimation()
    local veh = Config.AttachedVehicle
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local dict
    local model = "prop_carjack"
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, -2.0, 0.0)
    local headin = GetEntityHeading(ped)

    local vehicle = veh
    FreezeEntityPosition(veh, true)
    local vehpos = GetEntityCoords(veh)
    dict = "mp_car_bomb"
    RequestAnimDict(dict)
    RequestModel(model)
    while not HasAnimDictLoaded(dict) or not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
    local vehjack = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
    AttachEntityToEntity(vehjack, veh, 0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

    GenerateOpenMenu()
    TaskTurnPedToFaceEntity(ped, veh, 500)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
    Citizen.Wait(1250)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    dict = "move_crawl"
    Citizen.Wait(1000)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
    TaskPlayAnimAdvanced(ped, dict, "car_bomb_mechanic", coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
    SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.5, true, true, true)
    SetEntityCollision(veh, false, false)
    TaskPedSlideToCoord(ped, offset, headin, 1000)
    Citizen.Wait(1000)

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    TaskPlayAnimAdvanced(ped, dict, "onback_bwd", coords, 0.0, 0.0, headin - 180, 1.0, 0.5, 3000, 1, 0.0, 1, 1)
    dict = "amb@world_human_vehicle_mechanic@male@base"
    Citizen.Wait(1000)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end

    Gveh = veh
    FreezeEntityPosition(Gveh, true)
    while Gfinishready == false do
        TaskPlayAnim(ped, dict, "base", 8.0, -8.0, 710, 1, 0, false, false, false)
        Citizen.Wait(700)
        Gveh = veh
        Gped = ped
        Gcoords = coords
        Gdict = dict
        Gheadin = headin
        Gvehicle = vehicle
        Gvehpos = vehpos
        Gvehjack = vehjack
        Gready = true
    end
end

CreateThread(function()
    for k, v in pairs(Config.lscustom) do
        if v.blip then
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, 72)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 46)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("LS Custom")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

local lszones = {
    BoxZone:Create(vector3(-339.46, -136.73, 39.01), 10, 10, {
        name = "Vehiclecustom1_z",
        heading = 70,
        minZ = 38.01,
        maxZ = 42.01,
    }),
    BoxZone:Create(vector3(-1154.88, -2005.4, 13.18), 10, 10, {
        name = "Vehiclecustom2_z",
        heading = 45,
        minZ = 12.18,
        maxZ = 16.18,
    }),
    BoxZone:Create(vector3(731.87, -1087.88, 22.17), 10, 10, {
        name = "Vehiclecustom3_z",
        heading = 0,
        minZ = 21.17,
        maxZ = 25.17,
    }),
    BoxZone:Create(vector3(110.98, 6627.06, 31.89), 10, 10, {
        name = "Vehiclecustom4_z",
        heading = 45,
        minZ = 30.89,
        maxZ = 34.89,
    }),
    BoxZone:Create(vector3(1175.88, 2640.3, 37.79), 10, 10, {
        name = "Vehiclecustom5_z",
        heading = 45,
        minZ = 36.79,
        maxZ = 40.79,
    }),
}

Insidecustom = false
for int = 1, 5 do
    lszones[int]:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
        if isPointInside then
            if Config.AttachedVehicle == nil then
                Insidecustom = true
            else
                exports["soz-hud"]:DrawNotification("Il y a déjà une voiture en cours de modification", "error")
            end
        else
            Insidecustom = false
            VehiculeOptions:Close()
            Config.AttachedVehicle = nil
        end
    end)
end

CreateThread(function()
    exports["qb-target"]:AddGlobalVehicle({
        options = {
            {
                type = "client",
                icon = "c:mechanic/Ameliorer.png",
                label = "Améliorer",
                action = function(entity)
                    Config.AttachedVehicle = entity
                    TriggerServerEvent("qb-vehicletuning:server:SetAttachedVehicle", entity)
                    SetVehicleDoorsLocked(entity, 2)
                    startAnimation()
                end,
                canInteract = function(entity, distance, data)
                    return Insidecustom
                end,
            },
        },
        distance = 3.0,
    })
end)
