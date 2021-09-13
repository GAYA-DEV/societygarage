ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)  
	PlayerData.job2 = job2 
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

local garage_info = {
    PosSpawn = nil,
    HedSpawn = nil,
    society = ""
}

------------------------------ Menu ------------------------------
local mainMenu = RageUI.CreateMenu("Garage", " ")
local gestMenu = RageUI.CreateSubMenu(mainMenu, "Gestion du Garage", " ")
local commandMenu = RageUI.CreateSubMenu(gestMenu, "Commande", " ")
local gestCarMenu = RageUI.CreateSubMenu(gestMenu, "Gestion du Garage", " ")
local confirmMenu = RageUI.CreateSubMenu(commandMenu, "Confirmation", " ")

mainMenu:DisplayPageCounter(false)
gestMenu:DisplayPageCounter(false)
gestCarMenu:DisplayPageCounter(false)
commandMenu:DisplayPageCounter(false)
confirmMenu:DisplayPageCounter(false)

------------------------------ VARIABLES ------------------------------

local isBoss = false
local derniervoituresorti = {}
local CarSoc = {}
local societymoney = nil
local open = false

------------------------------ Code ------------------------------

mainMenu.Closed = function()
    open = false
    activePlate = false
    supprimervehicule() 
end

gestMenu.Closed = function()
    RefreshCar()
end


function GarageMenu()
    if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
            RefreshCar()
            while open do
            RageUI.IsVisible(mainMenu, function()
                RageUI.Button("~b~Gestion du garage", nil, {LeftBadge = RageUI.BadgeStyle.Car, RightLabel = ">"}, isBoss, {},gestMenu);

                RageUI.Button("Ranger le Véhicule", nil, {RightLabel = ">"}, true, {onSelected = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    DeleteVehicle(vehicle)
                    TriggerServerEvent("genius:updateVehicle", plate, 1)
                    if config.haveESXVehicleLock then
                        TriggerServerEvent('esx_vehiclelock:deletekeyjobs', 'no', plate) ---- vehiclelock
                    end
                    Wait(100)
                    RefreshCar()
                    
                    
                end});

                RageUI.Separator("~o~↓~s~ Véhicule ~o~↓")

                for k,v in pairs(CarSoc) do
                    if v.isStored == 1 then
                        RageUI.Button("Véhicule : ~o~"..v.Label, nil, {RightLabel = ">"}, true, {onSelected = function()
                            if ESX.Game.IsSpawnPointClear(garage_info.PosSpawn, 5.0) then
                                
                                ESX.Game.SpawnVehicle(GetHashKey(v.model), garage_info.PosSpawn, garage_info.HedSpawn, function(SpawnedVeh) 
                                    SetVehicleNumberPlateText(SpawnedVeh, tostring(v.plate))
                                    ESX.Game.SetVehicleProperties(SpawnedVeh, v.Tunning)
                                    
                                    if config.haveESXVehicleLock then
                                        TriggerServerEvent('esx_vehiclelock:givekey', 'no', tostring(v.plate)) ---- vehiclelock
                                    end
                                    TriggerServerEvent("genius:updateVehicle", tostring(v.plate), 0)

                                end)
                                Wait(100)
                                RefreshCar()
                            else
                                ESX.ShowNotification("~r~Vous ne pouvez pas faire apparaitre le point d'apparition est bloqué")
                            end
                        end});
                    end
                end

            end)

            RageUI.IsVisible(gestMenu, function()
                RageUI.Button("Gérer les Véhicule", nil, {RightLabel = ">"}, true, {},gestCarMenu);

                RageUI.Button("Commander des véhicule", nil, {RightLabel = ">"}, true, {onSelected = function()
                    RefreshMoney()
                end},commandMenu);

            end)

            RageUI.IsVisible(commandMenu, function()
                if societymoney ~= nil then
                    RageUI.Separator("Argent de la société: ~g~"..societymoney.."$")
                    RageUI.Separator("~o~↓~s~ Véhicule ~o~↓")
                end
                for k,v in pairs(config.veh) do
                    if v.society == garage_info.society then
                        RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."$ ~s~>"}, true, {onSelected = function()
                            nomvoiture = v.label
                            prixvoiture = v.price
                            modelevoiture = v.name
                            supprimervehicule()            
                            ESX.Game.SpawnVehicle(modelevoiture, garage_info.PosSpawn, garage_info.HedSpawn, function (vehicle)
                                table.insert(derniervoituresorti, vehicle)
                                FreezeEntityPosition(vehicle, true)
                                SetVehicleDoorsLocked(vehicle, 2)
                            end)
                        end},confirmMenu);
                    end
                end
            end)

            RageUI.IsVisible(confirmMenu, function()
                RageUI.Button("~g~Confirmer", nil, {RightLabel = ">"}, true, {onSelected = function()
                    
                    ESX.TriggerServerCallback('genius:verifsousentreprise', function(suffisantsous)
                        print(suffisantsous)
                        if suffisantsous then
                            local plaque = GeneratePlate()
                            local vehicleProps = ESX.Game.GetVehicleProperties(derniervoituresorti[#derniervoituresorti])
                            print(vehicleProps)
                            vehicleProps.plate = plaque

                            TriggerServerEvent("genius:addvehtogarage", nomvoiture,modelevoiture, vehicleProps.plate, garage_info.society, vehicleProps)
        
                            ESX.ShowNotification('Le véhicule '..nomvoiture..' avec la plaque '..vehicleProps.plate..' a été vendu à la société '..garage_info.society)
                            supprimervehicule() 
                            RefreshMoney()
                            RefreshCar()
    
                        else
                            ESX.ShowNotification('La société n\'as pas assez d\'argent pour ce véhicule!')
                            supprimervehicule() 
                        end

                        
        
                    end,garage_info.society, prixvoiture)



                end},commandMenu);

                RageUI.Button("~r~Annuler", nil, {RightLabel = ">"}, true, {onSelected = function()
                    supprimervehicule() 
                end},commandMenu);

            end)

            RageUI.IsVisible(gestCarMenu, function()
                for k,v in pairs(CarSoc) do
                        RageUI.Button("Véhicule : ~o~"..v.Label, nil, {RightLabel = "~r~Détruire le véhicule >"}, true, {onSelected = function()
                            TriggerServerEvent("genius:deleteVehicle", tostring(v.plate))
                            ESX.ShowNotification("~r~Véhicule détruit")
                            RefreshCar()
                        end});
                end

            end)


            Wait(0)
            end
        end)
    end
end

function supprimervehicule()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end


Citizen.CreateThread(function()

    for _,c in pairs(config.thegarage) do 
        local Spawnpedname = GetHashKey(c.name)
        while not HasModelLoaded(Spawnpedname) do
            RequestModel(Spawnpedname)
            Wait(60)
        end
        local Spawnpos = vector3(c.posx,c.posy,c.posz - 1)
        local heading = c.posh

        local Spawnped = CreatePed(9, Spawnpedname, Spawnpos, heading, false, false)

        SetEntityInvincible(Spawnped, true)
        SetBlockingOfNonTemporaryEvents(Spawnped, true)
        FreezeEntityPosition(Spawnped, true)
    end

    while true do
        local Timer = 500
        for _,c in pairs(config.thegarage) do
                if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job2.grade_name == 'boss' then
                    isBoss = true
                else 
                    isBoss = false
                end
                if ESX.PlayerData.job and ESX.PlayerData.job.name == c.society or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == c.society then
                    
            distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(c.posx,c.posy,c.posz - 1), true)
            if distance <= 4.0 then
                Timer = 0
                Visual.Subtitle("[~g~E~s~] Ouvrir le garage", 1)
                        if IsControlJustPressed(1,51) then
                            garage_info.PosSpawn = c.PosSpawn
                            garage_info.HedSpawn = c.HedSpawn
                            garage_info.society = c.society
                            GarageMenu()
                    end   
                end
            end 
        end
        Citizen.Wait(Timer)
    end
end)

function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('genius:getSocietyMoney', function(money)
            societymoney = money
        end, "society_"..garage_info.society)
    end
end

function RefreshCar()
    ESX.TriggerServerCallback('genius:getVehicleSociety', function(table)
        CarSoc = table
    end,garage_info.society)
end