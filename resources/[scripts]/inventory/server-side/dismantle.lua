-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Travel = {}
Boosting = {}
Dismantle = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
exports("GeneratePlate",function()
	repeat
		Plate = GenerateString("DDLLLDDD")
	until Plate and not Dismantle[Plate] and not Boosting[Plate]

	return Plate
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BOOSTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:Boosting",function(Plate,Status)
	if not Boosting[Plate] then
		Boosting[Plate] = Status
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Delete")
AddEventHandler("garages:Delete",function(Network,Plate)
	if Plate then
		if Dismantle[Plate] and vRP.Passport(Dismantle[Plate]) then
			TriggerClientEvent("dismantle:Reset",Dismantle[Plate])
			Dismantle[Plate] = nil
		end

		if Boosting[Plate] and vRP.Passport(Boosting[Plate]["Source"]) then
			TriggerClientEvent("boosting:Reset",Boosting[Plate]["Source"])
			exports["boosting"]:Remove(Boosting[Plate]["Passport"],Plate)
			Boosting[Plate] = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreateVehicle(Model,Coords)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicle = CreateVehicle(Model,Coords,true,true)

		while not DoesEntityExist(Vehicle) do
			Wait(1)
		end

		if DoesEntityExist(Vehicle) then
			local Plate = exports["inventory"]:GeneratePlate()

			SetEntityOrphanMode(Vehicle,2)
			SetVehicleNumberPlateText(Vehicle,Plate)
			SetVehicleCustomPrimaryColour(Vehicle,math.random(255),math.random(255),math.random(255))
			SetVehicleCustomSecondaryColour(Vehicle,math.random(255),math.random(255),math.random(255))

			Entity(Vehicle)["state"]:set("Nitro",0,true)
			Entity(Vehicle)["state"]:set("Fuel",100,true)
			Entity(Vehicle)["state"]:set("Tower",true,true)

			Dismantle[Plate] = source

			exports["vrp"]:CallPolice({
				["Source"] = source,
				["Passport"] = Passport,
				["Permission"] = "Policia",
				["Name"] = "Desmanche de Veículo",
				["Vehicle"] = VehicleName(Model).." - "..Plate,
				["Coords"] = Coords,
				["Code"] = 31,
				["Color"] = 44
			})

			return NetworkGetNetworkIdFromEntity(Vehicle)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Dismantle")
AddEventHandler("inventory:Dismantle",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	local UserVehicle = vRP.PassportPlate(Entity[1])
	local Plate,Name,Network = Entity[1],Entity[2],Entity[4]
	if Passport and not Active[Passport] and VehicleExist(Name) and (UserVehicle or Dismantle[Plate]) then
		Active[Passport] = os.time() + 30
		Player(source).state.Buttons = true
		TriggerClientEvent("Progress",source,"Desmanchando",30000)
		vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

		CreateThread(function()
			while Active[Passport] and os.time() < Active[Passport] do
				Wait(100)
			end

			if Active[Passport] then
				vRPC.Destroy(source)
				Active[Passport] = nil
				Player(source).state.Buttons = false

				if not UserVehicle and not Dismantle[Plate] then
					return false
				end

				TriggerClientEvent("dismantle:Reset",source)
				TriggerEvent("garages:Deleted",Network,Plate)

				local Experience = 3
				local _,Level = vRP.GetExperience(Passport,"Dismantle")
				local Amount = VehiclePrice(Name) * (UserVehicle and 0.050 or 0.025)
				local Valuation = Amount + (Amount * (0.025 * Level))

				if exports["inventory"]:Buffs("Dexterity",Passport) then
					Valuation = Valuation + (Valuation * 0.1)
				end

				for Permission,Multiplier in pairs({ Ouro = 0.100, Prata = 0.075, Bronze = 0.050 }) do
					if vRP.HasService(Passport,Permission) then
						Experience = Experience + 1
						Valuation = Valuation + (Valuation * Multiplier)
					end
				end

				local Members = 1
				if exports["party"]:DoesExist(Passport,2) then
					Members = #exports["party"]:Room(Passport,source,25)
				end

				if UserVehicle and vRP.SingleQuery("vehicles/plateVehicles",{ Plate = Plate }) then
					vRP.Query("vehicles/Arrest",{ Plate = Plate })
				end

				vRP.BattlepassPoints(Passport,Experience)
				vRP.PutExperience(Passport,"Dismantle",Experience)
				vRP.GenerateItem(Passport,"ironfilings",Valuation * Members,true)
			end
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Experience()
	local source = source
	local Passport = vRP.Passport(source)

	return vRP.GetExperience(Passport,"Dismantle")
end