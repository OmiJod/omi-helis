local QBCore = exports["qb-core"]:GetCoreObject()

Peds = {}
Targets = {}
local HelireturnZoneCombos = {}
local inReturnZone = nil
local vehiclecheck = nil
local vehicleout = false

function despawntargetshelis()
    for _, v in pairs(Peds) do unloadModel(GetEntityModel(v)) DeletePed(v) end
    for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
end

CreateThread(function()
    Wait(1000)
    while true do
        local sleep = 1000
        if inReturnZone then
            sleep = 5
            if IsControlJustReleased(0, 38) then
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(ped, false)
                if vehiclecheck then
                    DeleteEntity(vehicle)
                    vehiclecheck = nil
                    vehicleout = false
                else
                    QBCore.Functions.Notify('You Can Only Store Your Plane', "primary", 2500)
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    Peds[#Peds+1] = makePed(`a_m_y_business_02`,vector4(-719.69, -1448.18, 5.0, 51.18), 1, 1, "WORLD_HUMAN_CLIPBOARD")
    local name = "HeliSpawn"
    Targets[name] =
    exports['qb-target']:AddBoxZone("HeliSpawn", vector3(-719.69, -1448.18, 4.0), 1, 1, {
        name = "HeliSpawn",
        heading = 316.00,
        debugPoly = Config.Debug,
        minZ = 4.0 - 3,
        maxZ = 4.0 + 2,
    }, {
        options = {
            {
                event = 'moon-helis:client:OpenMenu',
                type = 'client',
                icon = "fas fa-helicopter",
                label = "Access Helipad",
            },
        },
        distance = 1.5
    })

    local returnZonesHeli = {}
    local zoneName = "Heli_return_"
    returnZonesHeli[#returnZonesHeli + 1] = BoxZone:Create(vector3(vector3(-745.42, -1468.6, 5.0)), 15, 15, {
        name = zoneName,
        debugPoly = Config.Debug,
        heading = -20,
        minZ = 5 - 2,
        maxZ = 5 + 6,
    })

    local HelireturnZoneCombo = ComboZone:Create(returnZonesHeli, {name = "HelireturnZoneCombo", debugPoly = false})
    HelireturnZoneCombos[#HelireturnZoneCombos + 1] = HelireturnZoneCombo
    HelireturnZoneCombo:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            inReturnZone = true
            exports['qb-core']:DrawText('[E] - Return Vehicle', 'left')
        else
            inReturnZone = nil
            exports['qb-core']:HideText()
        end
    end)
end)

RegisterNetEvent('moon-helis:client:OpenMenu', function()
    local staffList = {}
    staffList[#staffList + 1] = { -- create non-clickable header button
        isMenuHeader = true,
        header = 'Helipad',
        icon = 'fa-solid fa-infinity'
    }
    for k,v in pairs(Config.Table) do -- loop through our table
        staffList[#staffList + 1] = { -- insert data from our loop into the menu
            header = string.format('%s (%s)', QBCore.Shared.Vehicles[v].name, k),
            icon = "fas fa-helicopter",
            params = {
                event = 'moon-helis:clinet:spawnvehicle', -- event name
                args = {
                    name = k,
                    label = v
                }
            }
        }
    end
    exports['qb-menu']:openMenu(staffList) -- open our menu
end)

RegisterNetEvent('moon-helis:clinet:spawnvehicle', function(data)
    local Player = QBCore.Functions.GetPlayerData()
    if vehicleout then QBCore.Functions.Notify('You Already Have Your Heli Out SomeWhere', "error", 2500) return end
    if Player.citizenid ~= data.name then -- if the citizen ID doesn't match the vehicle name
        QBCore.Functions.Notify('You are Not Authorised To access this Vehicle', "error", 2500) -- show an error message
        return -- prevent the vehicle from spawning
    end
    QBCore.Functions.SpawnVehicle(data.label, function(veh3)
        exports['LegacyFuel']:SetFuel(veh3, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh3, -1)
        SetVehicleFixed(veh3)
        SetEntityHeading(veh3, 324.00)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh3))
        TriggerServerEvent('moon-helis:server:updatehelistatus', data.label, data.name, 0) -- Vehicle removed, set state to 0
        SetEntityAsMissionEntity(veh3, true, true)
        vehiclecheck = veh3
        vehicleout = true
    end, vector3(-724.62, -1443.96, 5.0), true)
end)

AddEventHandler('onResourceStop', function(resource) if resource == GetCurrentResourceName() then despawntargetshelis() end end)