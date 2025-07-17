-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("propertys",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Lock = {}
local Saved = {}
local Inside = {}
local Active = {}
local Robbery = {}
local Markers = {}
local CountClothes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:ROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Robbery")
AddEventHandler("propertys:Robbery",function(Name)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport or Active[Passport] then
		return false
	end

	Active[Passport] = true
	TriggerClientEvent("dynamic:Close",source)

	local Service = vRP.HasService(Passport,"Policia")
	local Lockpick = vRP.ConsultItem(Passport,"lockpick")
	local LockpickPlus = vRP.ConsultItem(Passport,"lockpickplus")
	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })
	local Warehouse = Consult and Consult.Interior == "Galpao"

	if not Warehouse and (Service or ((Lockpick or LockpickPlus) and vRP.Task(source,5,5000))) then
		Saved[Name] = Saved[Name] or (Consult and Consult.Interior or exports["propertys"]:Informations())
		Robbery[Name] = Robbery[Name] or {}

		if not Service then
			if Lockpick then
				vRP.RemoveItem(Passport,Lockpick.Item,1,true)
			end

			if Consult then
				local Online = vRP.Source(Consult.Passport)
				if Online then
					TriggerClientEvent("Notify",Online,"Alerta de Segurança","Sua propriedade está sendo invadida, chame as autoridades para ajudar no local.","policia",10000)
				end
			end
		end

		TriggerClientEvent("propertys:Enter",source,Name,Saved[Name])
	end

	Active[Passport] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:ROBBERYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:RobberyItem")
AddEventHandler("propertys:RobberyItem",function(Number,Name)
	local source = source
	local Passport = vRP.Passport(source)

	if not (Passport and Robbery[Name]) then
		return false
	end

	local Lockpick = vRP.ConsultItem(Passport,"lockpick")
	local LockpickPlus = vRP.ConsultItem(Passport,"lockpickplus")
	if not (Lockpick or LockpickPlus) then
		return false
	end

	if Robbery[Name][Number] then
		TriggerClientEvent("chest:Open",source,"Propertys:"..Name..":"..Number,"Custom",false,true)

		return false
	end

	local Locker = (Number == "Locker")
	if (Locker and not vRP.Safecrack(source,6)) or (not Locker and not vRP.Task(source,5,5000)) then
		if Lockpick and math.random(100) >= 95 then
			vRP.RemoveItem(Passport,Lockpick.Item,1,true)
		end

		local Coords = Propertys[Name].Coords
		TriggerClientEvent("sounds:Area",-1,"alarm",1.0,Coords,75)
		TriggerClientEvent("sounds:Area",-1,"alarm",1.0,vRP.GetEntityCoords(source),125,GetPlayerRoutingBucket(source))

		exports["vrp"]:CallPolice({
			Source = source,
			Passport = Passport,
			Coords = Coords,
			Permission = "Policia",
			Name = "Roubo a Propriedade",
			Wanted = 30,
			Code = 31,
			Color = 44
		})

		return false
	end

	local Container = "Propertys:"..Name..":"..Number
	local Itens = Locker and LockerItens or OtherItens
	local Amount = Locker and 1 or math.random(3)

	vRP.MountContainer(Passport,Container,Itens,Amount,false,Locker and 675 or 775)
	TriggerClientEvent("chest:Open",source,Container,"Custom",false,true)
	TriggerClientEvent("propertys:RemCircleZone",source,Number)
	Robbery[Name][Number] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Police(Outside,Inside)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	TriggerClientEvent("sounds:Area",-1,"alarm",1.0,Outside,75)
	TriggerClientEvent("sounds:Area",-1,"alarm",1.0,Inside,125,GetPlayerRoutingBucket(source))

	exports["vrp"]:CallPolice({
		Source = source,
		Passport = Passport,
		Coords = Outside,
		Permission = "Policia",
		Name = "Roubo a Propriedade",
		Wanted = 300,
		Code = 31,
		Color = 44
	})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Propertys(Name)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if Name == "Hotel" then
		return vRP.Scalar("propertys/Count",{ Passport = Passport }) <= 0 and "Hotel" or false
	end

	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })
	if not Consult then
		return "Nothing"
	end

	if Consult.Passport ~= Passport and Lock[Name] and not vRP.InventoryFull(Passport,"propertys-"..Consult.Serial) then
		return false
	end

	if not Saved[Name] then
		Saved[Name] = Consult.Interior
	end

	local Interior = Saved[Name]
	local CurrentTimer = os.time()
	local Price = Informations[Interior].Price * 0.25
	local Tax = CompleteTimers(Consult.Tax - CurrentTimer)

	if CurrentTimer > Consult.Tax then
		Tax = "Efetue o pagamento da <b>Hipoteca</b>."

		if vRP.Request(source,"Propriedades","Deseja pagar a hipoteca de <b>"..Currency..Dotted(Price).."</b>?") and vRP.PaymentFull(Passport,Price) then
			TriggerClientEvent("Notify",source,"Propriedades","Pagamento concluído.","verde",5000)
			vRP.Query("propertys/Tax",{ Name = Name })
			Tax = CompleteTimers(2592000)
		else
			return false
		end
	end

	return {
		Interior = Interior,
		Tax = Tax
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Toggle(Name,Mode)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if Mode == "Exit" then
		Inside[Passport] = nil
		exports["vrp"]:Bucket(source,"Exit")
		TriggerEvent("vRP:ReloadWeapons",source)
	else
		TriggerEvent("DebugWeapons",Passport)
		Inside[Passport] = Propertys[Name].Coords

		local Bucket = Name == "Hotel" and (200000 + Passport) or (100000 + string.sub(Name,-4))
		exports["vrp"]:Bucket(source,"Enter",Bucket)
	end

	TriggerEvent("animals:Delete",Passport,source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:BUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Buy")
AddEventHandler("propertys:Buy",function(Name)
	local source = source
	local Split = splitString(Name)
	local Passport = vRP.Passport(source)

	if not Passport or exports["bank"]:CheckFines(Passport) then
		return false
	end

	local Name,Interior,Mode = Split[1],Split[2],Split[3]
	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })

	if Consult then
		return false
	end

	TriggerClientEvent("dynamic:Close",source)

	if not vRP.Request(source,"Propriedades","Deseja comprar a propriedade?") then
		return false
	end

	local Payment = false
	if Mode == "Zcoin" then
		Payment = vRP.PaymentFull(Passport,Informations[Interior].Price)
	elseif Mode == "Gemstone" then
		Payment = vRP.PaymentGems(Passport,Informations[Interior].Gemstone)
	end

	if not Payment then
		TriggerClientEvent("Notify",source,"Propriedades",Mode == "Zcoin" and "Dinheiro insuficiente." or "Diamante insuficiente.","amarelo",10000)

		return false
	end

	Lock[Name] = true
	Saved[Name] = Interior
	local Serial = PropertysSerials()
	vRP.GiveItem(Passport,"propertys-"..Serial,3,true)
	TriggerClientEvent("Notify",source,"Propriedades","Compra concluída.","verde",10000)

	if Mode == "Zcoin" then
		exports["bank"]:AddTaxs(Passport,source,"Propriedades",Informations[Interior].Price,"Compra de propriedade.")
	end

	vRP.Query("propertys/Buy",{
		Name = Name,
		Interior = Interior,
		Passport = Passport,
		Serial = Serial,
		Vault = Informations[Interior].Vault or 0,
		Fridge = Informations[Interior].Fridge or 0
	})

	Markers[Name] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Lock")
AddEventHandler("propertys:Lock",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })

	if not (Passport and Consult) then
		return false
	end

	if Consult.Passport ~= Passport and not vRP.InventoryFull(Passport,"propertys-"..Consult.Serial) then
		return false
	end

	Lock[Name] = not Lock[Name]

	TriggerClientEvent("Notify",source,"Aviso","Propriedade "..(Lock[Name] and "trancada" or "destrancada")..".","default",10000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:INTERIOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Interior")
AddEventHandler("propertys:Interior",function(Table)
	local source = source
	local Split = splitString(Table)
	local Passport = vRP.Passport(source)
	local Name,Interior = Split[1],Split[2]
	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })

	if not Passport or not Consult or Consult.Passport ~= Passport or Consult.Interior == Interior then
		return false
	end

	TriggerClientEvent("dynamic:Close",source)

	local InteriorPrice = Informations[Interior].Gemstone
	local CurrentPrice = Informations[Consult.Interior].Gemstone
	if vRP.Request(source,"Propriedades","Deseja efetuar a troca do interior atual para o <b>"..Interior.."</b> por <b>"..Dotted(InteriorPrice - CurrentPrice).." diamantes</b>?") then
		if vRP.PaymentGems(Passport,InteriorPrice - CurrentPrice) then
			exports["oxmysql"]:query_async("UPDATE propertys SET Interior = ? WHERE Name = ?",{ Interior,Name })
			TriggerClientEvent("Notify",source,"Propriedades","Compra concluída.","verde",10000)
			Saved[Name] = Interior
		else
			TriggerClientEvent("Notify",source,"Propriedades","Diamante insuficiente.","amarelo",10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:SELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Sell")
AddEventHandler("propertys:Sell",function(Name)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport or Active[Passport] then
		return false
	end

	Active[Passport] = true

	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })
	if not (Consult and Consult.Passport == Passport) then
		Active[Passport] = nil

		return false
	end

	TriggerClientEvent("dynamic:Close",source)

	local Price = Informations[Consult.Interior].Price * 0.25
	if vRP.Request(source,"Propriedades","Vender por <b>"..Currency..Dotted(Price).."</b>?") then
		if Markers[Name] then
			Markers[Name] = nil
		end

		vRP.GiveBank(Passport,Price)
		vRP.RemSrvData("Vault:"..Name)
		vRP.RemSrvData("Fridge:"..Name)
		vRP.Query("propertys/Sell",{ Name = Name })

		TriggerClientEvent("garages:Clean",-1,Name)
		TriggerClientEvent("Notify",source,"Propriedades","Venda concluída.","verde",10000)
	end

	Active[Passport] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Transfer")
AddEventHandler("propertys:Transfer",function(Name)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport or Active[Passport] then
		return false
	end

	Active[Passport] = true

	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })
	if not (Consult and Consult.Passport == Passport) then
		Active[Passport] = nil

		return false
	end

	TriggerClientEvent("dynamic:Close",source)

	local Keyboard = vKEYBOARD.Primary(source,"Passaporte")
	local OtherPassport = Keyboard and Keyboard[1]

	if OtherPassport and vRP.Identity(OtherPassport) and vRP.Request(source,"Propriedades","Deseja transferir para o passaporte <b>"..OtherPassport.."</b>?") then
		vRP.Query("propertys/Transfer",{ Name = Name, Passport = OtherPassport })
		TriggerClientEvent("Notify",source,"Propriedades","Transferência concluída.","verde",10000)
	end

	Active[Passport] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CREDENTIALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Credentials")
AddEventHandler("propertys:Credentials",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })

	if not (Passport and Consult and Consult.Passport == Passport) then
		return false
	end

	TriggerClientEvent("dynamic:Close",source)

	if vRP.Request(source,"Propriedades","Lembre-se que ao prosseguir todos os cartões atuais deixam de funcionar, deseja prosseguir?") then
		local Serial = PropertysSerials()
		vRP.Query("propertys/Credentials",{ Name = Name, Serial = Serial })
		vRP.GiveItem(Passport,"propertys-"..Serial,Consult.Item,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Item")
AddEventHandler("propertys:Item",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })

	if not (Passport and Consult and Consult.Passport == Passport and Consult.Item < 5) then
		return false
	end

	TriggerClientEvent("dynamic:Close",source)

	local Price = 150000
	if vRP.Request(source,"Propriedades","Comprar uma chave adicional por <b>"..Currency..Dotted(Price).."</b>?") then
		if vRP.PaymentFull(Passport,Price) then
			vRP.Query("propertys/Item",{ Name = Name })
			vRP.GiveItem(Passport,"propertys-"..Consult.Serial,1,true)
		else
			TriggerClientEvent("Notify",source,"Aviso","Dinheiro insuficiente.","amarelo",10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Clothes()
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return {}
	end

	CountClothes[Passport] = 2

	for Permission,Multiplier in pairs({ Ouro = 6, Prata = 4, Bronze = 2 }) do
		if vRP.HasService(Passport,Permission) then
			CountClothes[Passport] = CountClothes[Passport] + Multiplier
		end
	end

	local Clothes = {}
	local Consult = vRP.GetSrvData("Wardrobe:"..Passport,true)
	for Table in pairs(Consult) do
		table.insert(Clothes,Table)
	end

	return Clothes
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Clothes")
AddEventHandler("propertys:Clothes",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	local Split = splitString(Mode)
	local Consult = vRP.GetSrvData("Wardrobe:"..Passport,true)
	local Action,Name = Split[1],Split[2]

	if Action == "Save" then
		if CountTable(Consult) >= CountClothes[Passport] then
			TriggerClientEvent("Notify",source,"Armário","Limite atingido de roupas.","amarelo",10000)

			return false
		end

		local Keyboard = vKEYBOARD.Primary(source,"Nome")
		if Keyboard then
			local Check = sanitizeString(Keyboard[1],"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
			if string.len(Check) >= 4 then
				if not Consult[Check] then
					Consult[Check] = vSKINSHOP.Customization(source)
					vRP.SetSrvData("Wardrobe:"..Passport,Consult,true)
					TriggerClientEvent("dynamic:AddMenu",source,Check,"Informações da vestimenta.",Check,"wardrobe")
					TriggerClientEvent("dynamic:AddButton",source,"Aplicar","Vestir-se com as vestimentas.","propertys:Clothes","Apply-"..Check,Check,true)
					TriggerClientEvent("dynamic:AddButton",source,"Remover","Deletar a vestimenta do armário.","propertys:Clothes","Delete-"..Check,Check,true,true)
				end
			else
				TriggerClientEvent("Notify",source,"Armário","Nome escolhido precisa possuir mínimo de 4 letras.","amarelo",10000)
			end
		end
	elseif Action == "Delete" then
		if Consult[Name] then
			Consult[Name] = nil
			vRP.SetSrvData("Wardrobe:"..Passport,Consult,true)
		end
	elseif Action == "Apply" then
		if Consult[Name] then
			TriggerClientEvent("skinshop:Apply",source,Consult[Name])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYSSERIALS
-----------------------------------------------------------------------------------------------------------------------------------------
function PropertysSerials()
	repeat
		Serial = GenerateString("LDLDLDLDLD")
		Consult = vRP.SingleQuery("propertys/Serial",{ Serial = Serial })
	until Serial and not Consult

	return Serial
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Name)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if Name == "Hotel" then
		return true
	end

	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })
	if Consult and vRP.InventoryFull(Passport,"propertys-"..Consult.Serial) or Consult.Passport == Passport then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount(Name,Mode)
	local Weight = 25
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport or not Name or not Mode then
		return false
	end

	if Name == "Hotel" then
		Name = "Hotel:"..Passport
	else
		local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })
		if Consult and Consult[Mode] then
			Weight = Consult[Mode]
		end
	end

	local function ProcessItems(Items,Prefix)
		local Processed = {}

		for Index,v in pairs(Items) do
			if v.amount <= 0 or not ItemExist(v.item) then
				vRP.RemoveItem(Passport,v.item,v.amount)
			else
				v.name = ItemName(v.item)
				v.weight = ItemWeight(v.item)
				v.index = ItemIndex(v.item)
				v.amount = parseInt(v.amount)
				v.rarity = ItemRarity(v.item)
				v.economy = ItemEconomy(v.item)
				v.desc = ItemDescription(v.item) or ""
				v.key = v.item
				v.slot = Index

				local Split = splitString(v.item)

				if not v.desc then
					if Split[1] == "vehiclekey" and Split[3] then
						v.desc = "Placa do Veículo: <common>"..Split[3].."</common>"
					elseif ItemNamed(Split[1]) and Split[2] then
						if Split[1] == "identity" then
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

				Processed[Index] = v
			end
		end

		return Processed
	end

	local Inv = vRP.Inventory(Passport)
	local Primary = ProcessItems(Inv,"inventory")

	local Consult = vRP.GetSrvData(Mode..":"..Name,true)
	local Secondary = ProcessItems(Consult,"chest")

	return Primary,Secondary,vRP.GetWeight(Passport),Weight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target,Name,Mode)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if (Mode == "Vault" and ItemFridge(Item)) or (Mode == "Fridge" and not ItemFridge(Item)) then
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	if Name == "Hotel" then
		if vRP.StoreChest(Passport,Mode..":Hotel:"..Passport,Amount,25,Slot,Target,true) then
			TriggerClientEvent("inventory:Update",source)
		end

		return false
	end

	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })
	if Consult then
		if Item == "diagram" then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.Query("propertys/"..Mode,{ Name = Name, Weight = 10 * Amount })
				TriggerClientEvent("inventory:Update",source)
			end
		else
			if vRP.StoreChest(Passport,Mode..":"..Name,Amount,Consult[Mode],Slot,Target,true) then
				TriggerClientEvent("inventory:Update",source)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Slot,Amount,Target,Name,Mode)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if vRP.TakeChest(Passport,(Name == "Hotel") and Mode..":Hotel:"..Passport or Mode..":"..Name,Amount,Slot,Target,true) then
		TriggerClientEvent("inventory:Update",source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount,Name,Mode)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if vRP.UpdateChest(Passport,(Name == "Hotel") and Mode..":Hotel:"..Passport or Mode..":"..Name,Slot,Target,Amount,true) then
		TriggerClientEvent("inventory:Update",source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Inside[Passport] then
		vRP.InsidePropertys(Passport,Inside[Passport])
		Inside[Passport] = nil
	end

	CountClothes[Passport] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _,v in pairs(vRP.Query("propertys/All")) do
		if Propertys[v.Name] then
			Markers[v.Name] = true
			Lock[v.Name] = true
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("CharacterChosen",function(Passport,source)
	local Increments = {}
	if vRP.Scalar("propertys/Count",{ Passport = Passport }) <= 0 then
		table.insert(Increments,Propertys["Hotel"].Coords)
	else
		local Consult = vRP.Query("propertys/AllUser",{ Passport = Passport })
		if Consult and #Consult > 0 then
			for _,v in pairs(Consult) do
				if Propertys[v.Name] then
					table.insert(Increments,Propertys[v.Name].Coords)
				end
			end
		end
	end

	TriggerClientEvent("spawn:Increment",source,Increments)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Markers()
	return Markers
end