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
Tunnel.bindInterface("chest",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Open = {}
local Cooldown = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTITENS
-----------------------------------------------------------------------------------------------------------------------------------------
local ChestItens = {
	["storage25"] = {
		Slots = 25,
		Weight = 25,
		Block = true
	},
	["storage50"] = {
		Slots = 25,
		Weight = 50,
		Block = true
	},
	["storage75"] = {
		Slots = 25,
		Weight = 75,
		Block = true
	},
	["suitcase"] = {
		Slots = 25,
		Weight = 10,
		Close = true,
		Itens = {
			["zcoin"] = true,
			["zcoin"] = true,
			["wetdollar"] = true,
			["promissory"] = true
		}
	},
	["ammobox"] = {
		Slots = 25,
		Weight = 12,
		Close = true,
		Itens = {
			["WEAPON_PISTOL_AMMO"] = true,
			["WEAPON_SMG_AMMO"] = true,
			["WEAPON_RIFLE_AMMO"] = true,
			["WEAPON_SHOTGUN_AMMO"] = true,
			["WEAPON_MUSKET_AMMO"] = true
		}
	},
	["weaponbox"] = {
		Slots = 50,
		Weight = 100,
		Close = true,
		Itens = {
			["WEAPON_STUNGUN"] = true,
			["WEAPON_PISTOL"] = true,
			["WEAPON_PISTOL_MK2"] = true,
			["WEAPON_COMPACTRIFLE"] = true,
			["WEAPON_APPISTOL"] = true,
			["WEAPON_HEAVYPISTOL"] = true,
			["WEAPON_MACHINEPISTOL"] = true,
			["WEAPON_MICROSMG"] = true,
			["WEAPON_RPG"] = true,
			["WEAPON_MINISMG"] = true,
			["WEAPON_SNSPISTOL"] = true,
			["WEAPON_SNSPISTOL_MK2"] = true,
			["WEAPON_VINTAGEPISTOL"] = true,
			["WEAPON_PISTOL50"] = true,
			["WEAPON_COMBATPISTOL"] = true,
			["WEAPON_CARBINERIFLE"] = true,
			["WEAPON_CARBINERIFLE_MK2"] = true,
			["WEAPON_ADVANCEDRIFLE"] = true,
			["WEAPON_BULLPUPRIFLE"] = true,
			["WEAPON_BULLPUPRIFLE_MK2"] = true,
			["WEAPON_SPECIALCARBINE"] = true,
			["WEAPON_SPECIALCARBINE_MK2"] = true,
			["WEAPON_PUMPSHOTGUN"] = true,
			["WEAPON_PUMPSHOTGUN_MK2"] = true,
			["WEAPON_MUSKET"] = true,
			["WEAPON_SAWNOFFSHOTGUN"] = true,
			["WEAPON_SMG"] = true,
			["WEAPON_SMG_MK2"] = true,
			["WEAPON_TACTICALRIFLE"] = true,
			["WEAPON_HEAVYRIFLE"] = true,
			["WEAPON_ASSAULTRIFLE"] = true,
			["WEAPON_ASSAULTRIFLE_MK2"] = true,
			["WEAPON_ASSAULTSMG"] = true,
			["WEAPON_GUSENBERG"] = true
		}
	},
	["medicbag"] = {
		Slots = 25,
		Weight = 10,
		Close = true,
		Itens = {
			["bandage"] = true,
			["gauze"] = true,
			["gdtkit"] = true,
			["medkit"] = true,
			["sinkalmy"] = true,
			["analgesic"] = true,
			["ritmoneury"] = true,
			["adrenaline"] = true
		}
	},
	["treasurebox"] = {
		Slots = 25,
		Weight = 50,
		Close = true
	},
	["christmas_04"] = {
		Slots = 25,
		Weight = 50,
		Close = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permissions(Name,Mode,Item)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if Mode == "Personal" then
--		local ServiceName = SplitOne(Name)
--		if vRP.HasService(Passport,ServiceName) then
			Open[Passport] = {
				Name = "Personal:"..Passport,
				Weight = 50,
				Save = true,
				Slots = 25
			}

			return true
	--	end
	elseif Mode == "Tray" then
		local isRecycle = (Name == "Recycle")

		Open[Passport] = {
			Slots = 25,
			Name = Name,
			Recycle = isRecycle,
			Weight = isRecycle and 100 or 25
		}

		return true
	elseif Mode == "Custom" or Mode == "Trash" then
		if SplitBoolean(Name,"Helicrash",":") and Cooldown[Name] and Cooldown[Name] > os.time() then
			TriggerClientEvent("Notify",source,"Atenção","Aguarde até que esfrie o compartimento.","amarelo",10000)
			vRPC.DowngradeHealth(source,10)

			return false
		end

		Open[Passport] = {
			Name = (Mode == "Trash" and "Trash:"..Name or Name),
			Weight = 50,
			Slots = 25,
			Mode = "Custom"
		}

		return true
	elseif Mode == "Item" then
		local UniqueName = SplitOne(Name,":")
		if ChestItens[UniqueName] then
			Open[Passport] = {
				Name = Name,
				Save = true,
				Unique = UniqueName,
				Slots = ChestItens[UniqueName].Slots,
				Weight = ChestItens[UniqueName].Weight,
				Item = Item
			}

			return true
		end
	else
		local Consult = vRP.SingleQuery("chests/GetChests",{ Name = Name })
		if not Consult then
			vRP.Query("chests/AddChests",{ Name = Name })
			Consult = vRP.SingleQuery("chests/GetChests",{ Name = Name })
		end

		if Consult and vRP.HasService(Passport,Consult.Permission) then
			local IsPremium = vRP.Permissions(Consult.Permission, "Premium") > os.time()

			Open[Passport] = {
				Weight = IsPremium and Consult.Weight * 2 or Consult.Weight,
				Chest = Name,
				Slots = Consult.Slots,
				Name = "Chest:"..Name,
				Permission = Consult.Permission,
				Save = true
			}

			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount()
	local source = source
	local Passport = vRP.Passport(source)

	if not (Passport and Open[Passport]) then
		return false
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

	local Primary = {}
	local Secondary = {}
	local Inventory = vRP.Inventory(Passport)
	local Chest = vRP.GetSrvData(Open[Passport].Name,Open[Passport].Save)

	for Index,v in pairs(Inventory) do
		local Processed = ProcessItem(Index,v,true)
		if Processed then
			Primary[Index] = Processed
		end
	end

	for Index,v in pairs(Chest) do
		local Processed = ProcessItem(Index,v)
		if Processed then
			Secondary[Index] = Processed
		end
	end

	return Primary,Secondary,vRP.GetWeight(Passport),Open[Passport].Weight,Open[Passport].Slots
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target,Inactived)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not (Passport and Open[Passport] and not Inactived) then
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	if Open[Passport].Recycle then
		local Recycled = ItemRecycle(Item)
		if Recycled and vRP.TakeItem(Passport,Item,Amount) then
			for Index,Number in pairs(Recycled) do
				vRP.GenerateItem(Passport,Index,Number * Amount)
			end

			TriggerClientEvent("inventory:Update",source)
		else
			TriggerClientEvent("inventory:Notify",source,"Atenção",ItemName(Item).." não pode ser reciclado.","amarelo")
			TriggerClientEvent("inventory:Update",source)
		end

		return false
	end

	if Item == "diagram" and Open[Passport].Chest and vRP.TakeItem(Passport,Item,Amount) then
		vRP.Query("chests/UpdateWeight",{ Name = Open[Passport].Chest, Multiplier = Amount })
		TriggerClientEvent("inventory:Notify",source,"Sucesso","Armazenamento melhorado.","verde")
		Open[Passport].Weight = Open[Passport].Weight + (10 * Amount)
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	local CleanedItem = SplitOne(Item)
	local Unique = Open[Passport].Unique
	if (ChestItens[CleanedItem] and ChestItens[CleanedItem].Block) or (Unique and ChestItens[Unique] and ChestItens[Unique].Itens and not ChestItens[Unique].Itens[CleanedItem]) then
		if Unique and CleanedItem == Unique then
			TriggerClientEvent("inventory:Open",source,{ Type = "Inventory", Resource = "inventory" },true)
		else
			TriggerClientEvent("inventory:Update",source)
		end

		return false
	end

	if vRP.StoreChest(Passport,Open[Passport].Name,Amount,Open[Passport].Weight,Slot,Target,Open[Passport].Save,ChestItens[Unique]) then
		TriggerClientEvent("inventory:Update",source)

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport or not Open[Passport] then
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	local Name = Open[Passport].Name
	local Saved = Open[Passport].Save
	if vRP.TakeChest(Passport,Name,Amount,Slot,Target,Saved) then
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	local Data = vRP.GetSrvData(Name,Saved)    
	if (Open[Passport].Mode or Open[Passport].Item) and json.encode(Data) == "[]" then
		if Open[Passport].Item and vRP.TakeItem(Passport,Open[Passport].Item) then
			TriggerClientEvent("inventory:Open",source,{ Type = "Inventory", Resource = "inventory" },true)
		end

		if SplitBoolean(Name,"Helicrash",":") then
			GlobalState.Helibox = GlobalState.Helibox - 1
		elseif SplitBoolean(Name,"Christmas",":") then
			GlobalState.ChristmasBox = GlobalState.ChristmasBox - 1
			GlobalState["ChristmasBlock:"..SplitTwo(Name,":")] = true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport or not Open[Passport] then
		return false
	end

	local Name = Open[Passport].Name
	local Saved = Open[Passport].Save
	if vRP.UpdateChest(Passport,Name,Slot,Target,Amount,Saved) then
		TriggerClientEvent("inventory:Update",source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:COOLDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Cooldown",function(Name)
	Cooldown[Name] = os.time() + 600
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:ARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chest:Armour")
AddEventHandler("chest:Armour",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Policia") then
		vRP.Armour(source,100)
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