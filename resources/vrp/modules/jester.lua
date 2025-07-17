-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
tvRP = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNER/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy.addInterface("vRP",vRP)
Tunnel.bindInterface("vRP",tvRP)
DEVICE = Tunnel.getInterface("device")
MEMORY = Tunnel.getInterface("memory")
REQUEST = Tunnel.getInterface("request")
TASKBAR = Tunnel.getInterface("taskbar")
SURVIVAL = Tunnel.getInterface("survival")
SAFECRACK = Tunnel.getInterface("safecrack")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetMapName(ServerName)
	SetGameType(ServerName)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ClearInventory(Passport,Ignore)
	local Passport = parseInt(Passport)
	local Inventory = vRP.Inventory(Passport)

	exports["inventory"]:CleanWeapons(Passport)
	TriggerEvent("DebugWeapons",Passport)
	TriggerEvent("DebugObjects",Passport)

	for _,v in pairs(Inventory) do
		if not BlockDelete(v.item) then
			vRP.RemoveItem(Passport,v.item,v.amount)
		end
	end

	if not Ignore then
		local Weight = 50
		for Permission,Multiplier in pairs({ Ouro = 25, Prata = 15, Bronze = 5 }) do
			if vRP.HasService(Passport,Permission) then
				Weight = Weight - Multiplier
			end
		end

		if Weight > 0 then
			vRP.UpgradeWeight(Passport,Weight,"-")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function GeneratePhone()
	local Phone = ""
	local Passport = nil

	repeat
		Phone = GenerateString("DDD-DDD")
		Passport = vRP.SingleQuery("characters/Phone",{ Phone = Phone })
	until not Passport

	return Phone
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Phone(Passport)
	local source = vRP.Source(Passport)
	if Characters[source] and Characters[source]["Phone"] then
		return Characters[source]["Phone"]
	end

	local Consult = vRP.SingleQuery("characters/Person", { Passport = Passport })

	if Consult and Consult.Phone then
		if Characters[source] then
			Characters[source]["Phone"] = Consult.Phone
		end

		return Consult.Phone
	end

	local PhoneNumber = GeneratePhone()
	vRP.Query("characters/UpdatePhone",{ Passport = Passport, Phone = PhoneNumber })

	return PhoneNumber
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CleanPhone(Passport)
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SMARTPHONE:SERVICE_REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("smartphone:service_request",function(Data)
	local Answered = false
	local Service = vRP.NumPermission(Data["service"]["permission"])

	for Passport,Sources in pairs(Service) do
		async(function()
			TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Chamado", text = Data["content"], name = Data["name"], phone = Data["phone"], x = Data["location"][1], y = Data["location"][2], z = Data["location"][3], color = 2 })

			if vRP.Request(Sources,"Chamado","Aceitar o chamado de <b>"..Data["name"].."?") then
				if not Answered then
					Answered = true
					TriggerClientEvent("smartphone:pusher",Data["source"],"SERVICE_RESPONSE",{})
					TriggerClientEvent("smartphone:pusher",Sources,"GPS",{ location = Data["location"] })
				else
					TriggerClientEvent("Notify",Sources,"Sucesso","Chamado atendido.","verde",5000)
				end
			end
		end)
	end

	SetTimeout(30000,function()
		if not Answered then
			TriggerClientEvent("smartphone:pusher",Data["source"],"SERVICE_REJECT",{})
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SMARTPHONE:IS_SERVICE_CUSTOM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("smartphone:is_service_custom",function(_,Reply)
	Reply(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Request(source,Title,Message)
	return REQUEST.Function(source,Title,Message)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Revive(source,Health,Arena)
	return SURVIVAL.Revive(source,Health,Arena)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.TASK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Task(source,Amount,Speed)
	return TASKBAR.Task(source,Amount,Speed)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.MEMORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Memory(source)
	return MEMORY.Memory(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.SAFECRACK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Safecrack(source,Number)
	return SAFECRACK.Safecrack(source,Number)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.DEVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Device(source,Seconds)
    return DEVICE.Device(source,Seconds)
end