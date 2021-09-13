ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('genius:verifierplaquedispo', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM vehicles_society WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)

ESX.RegisterServerCallback('genius:verifsousentreprise', function(source,cb,soc, prixvoiture)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..soc, function (account)
        if account.money >= prixvoiture then
			account.removeMoney(prixvoiture)
            cb(true)
        else
            cb(false)
        end
    end)
end)


RegisterServerEvent("genius:addvehtogarage")
AddEventHandler("genius:addvehtogarage", function(modelevoiture, vehiclemodel, vehicleplate, soc, tunning)
	print("ici")
	MySQL.Async.execute("INSERT INTO `vehicles_society` (Label, model, plate, jobname, Tunning) VALUES (@label, @model, @plate, @jobname, @Tunning)", {
		['@label'] = modelevoiture,
		['@model'] = vehiclemodel,
		['@plate'] = vehicleplate,
		['@jobname'] = soc,
		["@Tunning"] = json.encode(tunning)
	}, function() end)
end)

ESX.RegisterServerCallback('genius:getSocietyMoney', function(source, cb, soc)
	local money = nil
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @society ', {
			['@society'] = soc,
		}, function(data)
			for _,v in pairs(data) do
				money = v.money
			end
			cb(money)
		end)
end)

ESX.RegisterServerCallback("genius:getVehicleSociety", function(source, cb, soc)
    MySQL.Async.fetchAll('SELECT * FROM `vehicles_society` WHERE jobname = @jobname', {
		['@jobname'] = soc
	}, function(vehicleResult)
        cb(vehicleResult)
   end)
end)




RegisterServerEvent('genius:updateVehicle')
AddEventHandler('genius:updateVehicle', function(plate, state)

	MySQL.Async.execute('UPDATE vehicles_society SET `isStored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print("error")
		end
	end)
end)

RegisterServerEvent('genius:deleteVehicle')
AddEventHandler('genius:deleteVehicle', function(plate)

	MySQL.Async.execute('DELETE FROM vehicles_society WHERE plate = @plate', {
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print("error")
		end
	end)
end)


Citizen.Trace('^0======================================================================^7 \n')
Citizen.Trace('^0[^4Author^0] ^7:^0 ^5"GAYA Devellopement^7 \n')
Citizen.Trace('^0[^7Version^0] ^7:^0 ^01.0^7 \n')
Citizen.Trace('^0[^1Support^0] ^7https://discord.gg/uaYK2AN \n')
Citizen.Trace('^0======================================================================^7 \n')