QBCore = exports["qb-core"]:GetCoreObject()
local VehicleStatus = {}

RegisterNetEvent("soz-bennys:server:SaveVehicleProps", function(vehicleProps)
    if IsVehicleOwned(vehicleProps.plate) then
        MySQL.Async.execute("UPDATE player_vehicles SET mods = ? WHERE plate = ?", {
            json.encode(vehicleProps),
            vehicleProps.plate,
        })
    end
end)

RegisterNetEvent("soz-bennys:server:setupVehicleStatus", function(plate, engineHealth, bodyHealth)
    engineHealth = engineHealth ~= nil and engineHealth or 1000.0
    bodyHealth = bodyHealth ~= nil and bodyHealth or 1000.0
    if VehicleStatus[plate] == nil then
        if IsVehicleOwned(plate) then
            local statusInfo = GetVehicleStatus(plate)
            if statusInfo == nil then
                statusInfo = {
                    ["engine"] = engineHealth,
                    ["body"] = bodyHealth,
                    ["radiator"] = Config.MaxStatusValues["radiator"],
                    ["axle"] = Config.MaxStatusValues["axle"],
                    ["brakes"] = Config.MaxStatusValues["brakes"],
                    ["clutch"] = Config.MaxStatusValues["clutch"],
                    ["fuel"] = Config.MaxStatusValues["fuel"],
                }
            end
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("soz-bennys:client:setVehicleStatus", -1, plate, statusInfo)
        else
            local statusInfo = {
                ["engine"] = engineHealth,
                ["body"] = bodyHealth,
                ["radiator"] = Config.MaxStatusValues["radiator"],
                ["axle"] = Config.MaxStatusValues["axle"],
                ["brakes"] = Config.MaxStatusValues["brakes"],
                ["clutch"] = Config.MaxStatusValues["clutch"],
                ["fuel"] = Config.MaxStatusValues["fuel"],
            }
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("soz-bennys:client:setVehicleStatus", -1, plate, statusInfo)
        end
    else
        TriggerClientEvent("soz-bennys:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterNetEvent("soz-bennys:server:LoadStatus", function(veh, plate)
    VehicleStatus[plate] = veh
    TriggerClientEvent("soz-bennys:client:setVehicleStatus", -1, plate, veh)
end)

RegisterNetEvent("soz-bennys:server:updatePart", function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        if part == "engine" or part == "body" then
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 1000 then
                VehicleStatus[plate][part] = 1000.0
            end
        else
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 100 then
                VehicleStatus[plate][part] = 100
            end
        end
        TriggerClientEvent("soz-bennys:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterNetEvent("soz-bennys:server:SetPartLevel", function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        VehicleStatus[plate][part] = level
        TriggerClientEvent("soz-bennys:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterNetEvent("soz-bennys:server:saveStatus", function(plate)
    if VehicleStatus[plate] ~= nil then
        MySQL.Async.execute("UPDATE player_vehicles SET status = ? WHERE plate = ?", {
            json.encode(VehicleStatus[plate]),
            plate,
        })
    end
end)

QBCore.Functions.CreateCallback("soz-bennys:server:IsVehicleOwned", function(source, cb, plate)
    local retval = false
    local result = MySQL.Sync.fetchScalar("SELECT 1 from player_vehicles WHERE plate = ?", {plate})
    if result then
        retval = true
    end
    cb(retval)
end)

function GetVehicleStatus(plate)
    local retval = nil
    local result = MySQL.Sync.fetchAll("SELECT status FROM player_vehicles WHERE plate = ?", {plate})
    if result[1] ~= nil then
        retval = result[1].status ~= nil and json.decode(result[1].status) or nil
    end
    return retval
end

QBCore.Commands.Add("setvehiclestatus", "Set Vehicle Status",
                    {
    {name = "part", help = "Type The Part You Want To Edit"},
    {name = "amount", help = "The Percentage Fixed"},
}, true, function(source, args)
    local part = args[1]:lower()
    local level = tonumber(args[2])
    TriggerClientEvent("soz-bennys:client:setPartLevel", source, part, level)
end, "god")

RegisterNetEvent("soz-bennys:server:fixEverything", function(plate)
    if VehicleStatus[plate] ~= nil then
        for k, v in pairs(Config.MaxStatusValues) do
            VehicleStatus[plate][k] = v
        end
        TriggerClientEvent("soz-bennys:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

QBCore.Functions.CreateCallback("soz-bennys:server:GetAttachedVehicle", function(source, cb)
    cb(Config.AttachedVehicle)
end)

QBCore.Functions.CreateCallback("soz-bennys:server:IsMechanicAvailable", function(source, cb)
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "bennys" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)

QBCore.Functions.CreateCallback("soz-bennys:server:GetStatus", function(source, cb, plate)
    if VehicleStatus[plate] ~= nil and next(VehicleStatus[plate]) ~= nil then
        cb(VehicleStatus[plate])
    else
        cb(nil)
    end
end)

RegisterNetEvent("soz-bennys:server:SetAttachedVehicle", function(veh)
    if veh ~= false then
        Config.AttachedVehicle = veh
        TriggerClientEvent("soz-bennys:client:SetAttachedVehicle", -1, veh)
    else
        Config.AttachedVehicle = nil
        TriggerClientEvent("soz-bennys:client:SetAttachedVehicle", -1, false)
    end
end)

RegisterNetEvent("soz-bennys:server:CheckForItems", function(part)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local RepairPart = Player.Functions.GetItemByName(Config.RepairCostAmount[part].item)

    if RepairPart ~= nil then
        if RepairPart.amount >= Config.RepairCostAmount[part].costs then
            TriggerClientEvent("soz-bennys:client:RepaireeePart", src, part)
            Player.Functions.RemoveItem(Config.RepairCostAmount[part].item, Config.RepairCostAmount[part].costs)

            for i = 1, Config.RepairCostAmount[part].costs, 1 do
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.RepairCostAmount[part].item], "remove")
                Wait(500)
            end
        else
            TriggerClientEvent("QBCore:Notify", src,
                               "You Dont Have Enough " .. QBCore.Shared.Items[Config.RepairCostAmount[part].item]["label"] .. " (min. " ..
                                   Config.RepairCostAmount[part].costs .. "x)", "error")
        end
    else
        TriggerClientEvent("QBCore:Notify", src, "You Do Not Have " .. QBCore.Shared.Items[Config.RepairCostAmount[part].item]["label"] .. " bij je!", "error")
    end
end)

RegisterNetEvent("soz-bennys:server:Removeitem", function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
end)

QBCore.Functions.CreateCallback("soz-bennys:server:GetStatus", function(source, cb, plate)
    if VehicleStatus[plate] ~= nil and next(VehicleStatus[plate]) ~= nil then
        cb(VehicleStatus[plate])
    else
        cb(nil)
    end
end)

RegisterNetEvent("updateVehicle", function(myCar)
    local src = source
    if IsVehicleOwned(myCar.plate) then
        MySQL.Async.execute("UPDATE player_vehicles SET mods = ? WHERE plate = ?", {json.encode(myCar), myCar.plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    local result = MySQL.Sync.fetchScalar("SELECT plate FROM player_vehicles WHERE plate = ?", {plate})
    if result then
        retval = true
    end
    return retval
end

-- Other
RegisterNetEvent("soz-bennys:server:buy", function(itemID)
    local player = QBCore.Functions.GetPlayer(source)
    local item = Config.BossShop[itemID]

    if player.Functions.RemoveMoney("money", item.price) then
        exports["soz-inventory"]:AddItem(player.PlayerData.source, item.name, item.amount, item.metadata, nil, function(success, reason)
            if success then
                TriggerClientEvent("hud:client:DrawNotification", player.PlayerData.source,
                                   ("Vous venez d'acheter ~b~%s %s~s~ pour ~g~$%s"):format(item.amount, QBCore.Shared.Items[item.name].label, item.price))
            end
        end)
    else
        TriggerClientEvent("hud:client:DrawNotification", player.PlayerData.source, "Vous n'avez pas assez d'argent", "error")
    end
end)
