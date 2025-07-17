-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState.Helibox = 0
GlobalState.Helifire = 0
GlobalState.Helicrash = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELICRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("helicrash",function(source,Message)
	local Passport = vRP.Passport(source)

	if not Passport or GlobalState.Helicrash or not vRP.HasGroup(Passport,"Admin") or not Message[1] then
		return
	end

	local Selected = parseInt(Message[1])

	if Components[Selected] then
		local Coords = Components[Selected].Coords
		local CountCoords = CountTable(Coords)

		for Number = 1,CountCoords do
			TriggerEvent("chest:Cooldown","Helicrash:"..Number)
			vRP.MountContainer(Passport,"Helicrash:"..Number,Loots,math.random(3,5))
		end

		TriggerClientEvent("Notify",-1,"Queda da Aeronave","Mayday! Mayday! Tivemos problemas técnicos em nossos motores e estamos em queda livre.","verde",30000)

		GlobalState.Helibox = CountCoords
		GlobalState.Helifire = GlobalState.Work + 60
		GlobalState.Helicrash = Selected
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Helibox",nil,function(Name,Key,Value)
	if Value <= 0 then
		GlobalState.Helicrash = false
	end
end)