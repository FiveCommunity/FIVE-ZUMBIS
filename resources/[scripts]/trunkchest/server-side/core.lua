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
Creative = {}
Tunnel.bindInterface("trunkchest",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Open = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
local Store = {
	ratloader = {
		woodlog = true
	},
	stockade = {
		pouch = true
	},
	trash = {
		binbag = true
	},
	flatbed = {
		plastic = true,
		glass = true,
		rubber = true,
		aluminum = true,
		tyres = true,
		copper = true,
		toolbox = true,
		advtoolbox = true
	},
	boxville2 = {
		package = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKED
-----------------------------------------------------------------------------------------------------------------------------------------
local Blocked = {
	zcoin = true,
	dirtydollar = true,
	wetdollar = true,
	promissory1000 = true,
	promissory2000 = true,
	promissory3000 = true,
	promissory4000 = true,
	promissory5000 = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount()
	local Primary = {}
	local Secondary = {}
	local source = source
	local Passport = vRP.Passport(source)

	if not (Passport and Open[Passport]) then
		return Primary,Secondary
	end

	local function ProcessItem(Index,v,Primary)
		if Primary and v.amount <= 0 or not ItemExist(v.item) then
			vRP.RemoveItem(Passport,v.item,v.amount,false)
			return false
		end

		v.name = ItemName(v.item)
		v.weight = ItemWeight(v.item)
		v.index = ItemIndex(v.item)
		v.amount = parseInt(v.amount)
		v.rarity = ItemRarity(v.item)
		v.economy = ItemEconomy(v.item)
		v.desc = ItemDescription(v.item)
		v.key = v.item
		v.slot = Index

		local Split = splitString(v.item)
		local Item = Split[1]

		if isPrimary and ChestItens[Item] and ChestItens[Item].Close then
			v.block = true
		end

		if not v.desc then
			if Item == "vehiclekey" and Split[3] then
				v.desc = "Placa do Veículo: <common>"..Split[3].."</common>"
			elseif ItemNamed(Item) and Split[2] then
				if Item == "identity" then
					v.desc = "Passaporte: <rare>"..Dotted(Split[2]).."</rare><br>Nome: <rare>"..vRP.FullName(Split[2]).."</rare><br>Telefone: <rare>"..vRP.Phone(Passport).."</rare>"
				else
					v.desc = "Propriedade: <common>"..vRP.FullName(Split[2]).."</common>"
				end
			end
		end

		if Split[2] then
			local Loaded = ItemLoads(v.item)
			if Loaded then
				v.charges = parseInt(Split[2] * (100 / Loaded))
			end

			if ItemDurability(v.item) then
				v.durability = parseInt(os.time() - Split[2])
				v.days = ItemDurability(v.item)
			end
		end

		return v
	end

	local Inventory = vRP.Inventory(Passport)
	for Index,v in pairs(Inventory) do
		local Processed = ProcessItem(Index,v,true)
		if Processed then
			Primary[Index] = Processed
		end
	end

	if Open[Passport] and Open[Passport].Data then
		local Chest = vRP.GetSrvData(Open[Passport].Data,true)
		for Index,v in pairs(Chest) do
			local Processed = ProcessItem(Index,v)
			if Processed then
				Secondary[Index] = Processed
			end
		end
	end

	return Primary,Secondary,vRP.GetWeight(Passport),Open[Passport] and Open[Passport].Weight or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] and vRP.UpdateChest(Passport,Open[Passport].Data,Slot,Target,Amount,true) then
		TriggerClientEvent("inventory:Update",source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		local Split = SplitOne(Item)
		local Name = Open[Passport].Model
		if (Store[Name] and not Store[Name][Split]) or Blocked[Split] then
			TriggerClientEvent("Notify",source,"Aviso","Armazenamento proibido.","amarelo",5000)
			TriggerClientEvent("inventory:Update",source)
		elseif Split == "diagram" then
			if (Open[Passport].Weight + (10 * Amount)) <= (VehicleWeight(Name) * 5) and vRP.TakeItem(Passport,Item,Amount) then
				Open[Passport].Weight = Open[Passport].Weight + (10 * Amount)
				vRP.Query("vehicles/UpdateWeight",{ Passport = Open[Passport].Passport, Vehicle = Open[Passport].Model, Multiplier = Amount })
				TriggerClientEvent("inventory:Notify",source,"Sucesso","Armazenamento melhorado.","verde")
			else
				TriggerClientEvent("inventory:Notify",source,"Atenção","Limite atingido.","vermelho")
			end

			TriggerClientEvent("inventory:Update",source)
		elseif Open[Passport].Data and Open[Passport].Weight and vRP.StoreChest(Passport,Open[Passport].Data,Amount,Open[Passport].Weight,Slot,Target,true) then
			TriggerClientEvent("inventory:Update",source)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] and vRP.TakeChest(Passport,Open[Passport].Data,Amount,Slot,Target,true) then
		TriggerClientEvent("inventory:Update",source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Close()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		Open[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:OPENTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trunkchest:openTrunk")
AddEventHandler("trunkchest:openTrunk",function(Entity)
	local source = source
	local Name = Entity[2]
	local Plate = Entity[1]
	local Passport = vRP.Passport(source)
	local Spawn = exports["garages"]:Spawn(Plate)
	local OtherPassport = vRP.PassportPlate(Plate)
	if Passport and OtherPassport and VehicleExist(Name) and Spawn and Spawn[1] == OtherPassport and Spawn and Spawn[2] == Name then
		local Consult = vRP.SelectVehicle(OtherPassport,Name)

		Open[Passport] = {
			Model = Name,
			Passport = OtherPassport,
			Weight = Consult and Consult.Weight or VehicleWeight(Name),
			Data = "Trunkchest:"..OtherPassport..":"..Name
		}

		TriggerClientEvent("trunkchest:Open",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Open[Passport] then
		Open[Passport] = nil
	end
end)