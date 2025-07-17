-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Locations = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Itens")
AddEventHandler("prison:Itens",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(OtherSource)
	if Passport and OtherPassport and vRP.GetHealth(source) > 100 and vRP.HasService(Passport,"Policia") then
		TriggerClientEvent("Notify",source,"Sucesso","Objetos apreendidos.","verde",5000)
		exports["inventory"]:CleanWeapons(OtherPassport)
		vRP.ArrestItens(OtherPassport)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Vehicle")
AddEventHandler("prison:Vehicle",function(Entity)
	local source = source
	local Plate = Entity[1]
	local Passport = vRP.Passport(source)
	if Passport and vRP.Request(source,"Garagem","Apreender o veículo?") and vRP.PassportPlate(Plate) then
		local Vehicle = vRP.Query("vehicles/plateVehicles",{ Plate = Plate })
		if Vehicle[1] then
			if not Vehicle[1]["Arrest"] then
				vRP.Query("vehicles/Arrest",{ Plate = Plate })
				TriggerClientEvent("Notify",source,"Departamento Policial","Veículo apreendido.","policia",5000)
			else
				TriggerClientEvent("Notify",source,"Departamento Policial","Veículo já se encontra apreendido.","policia",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Plate")
AddEventHandler("prison:Plate",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Policia") then
		local Keyboard = vKEYBOARD.Primary(source,"Placa")
		if Keyboard and Keyboard[1] then
			local OtherPassport = vRP.PassportPlate(Keyboard[1])
			if OtherPassport then
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					TriggerClientEvent("Notify",source,"Emplacamento","<b>Passaporte:</b> "..Identity["id"].."<br><b>Telefone:</b> "..vRP.Phone(OtherPassport).."<br><b>Nome:</b> "..Identity["Name"].." "..Identity["Lastname"],"policia",10000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Service")
AddEventHandler("prison:Service",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	local Identity = vRP.Identity(Passport)
	if Passport and Identity and Identity.Prison > 0 then
		Locations[Passport] = Locations[Passport] or {}

		local CurrentTimer = os.time()
		local LastTimer = Locations[Passport][Number]

		if LastTimer then
			local RemainingTime = LastTimer - CurrentTimer
			if RemainingTime > 0 then
				TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(RemainingTime)..".","amarelo",5000)

				return false
			end
		end

		Reduction(source,Passport,Number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REDUCTION
-----------------------------------------------------------------------------------------------------------------------------------------
function Reduction(source,Passport,Number)
	if Active[Passport] then
		return false
	end

	local CurrentTimer = os.time()
	Player(source).state.Cancel = true
	Player(source).state.Buttons = true
	Active[Passport] = CurrentTimer + 10
	Locations[Passport][Number] = CurrentTimer + 300
	TriggerClientEvent("Progress",source,"Vasculhando",10000)
	vRPC.playAnim(source,false,{"amb@prop_human_bum_bin@base","base"},true)

	while Active[Passport] do
		if os.time() >= Active[Passport] then
			vRPC.Destroy(source)
			Active[Passport] = nil
			vRP.UpdatePrison(Passport,2)
			Player(source).state.Cancel = false
			Player(source).state.Buttons = false

			local Identity = vRP.Identity(Passport)
			if Identity and Identity.Prison <= 0 then
				vRP.Teleport(source,1896.15,2604.44,45.75)
				TriggerClientEvent("Notify",source,"Boolingbroke","Serviços finalizados.","policia",5000)
			else
				TriggerClientEvent("Notify",source,"Boolingbroke","Reduzimos 2 serviços, restando um total de "..Identity.Prison..".","policia",5000)
			end

			break
		end

		Wait(100)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)