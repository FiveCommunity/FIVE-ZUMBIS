-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("paramedic",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Damaged = {}
local Bleedings = 0
local Injuried = GetGameTimer()
local BloodTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(Event,Message)
	if Event ~= "CEventNetworkEntityDamage" or PlayerPedId() ~= Message[1] or LocalPlayer.state.Arena then
		return false
	end

	local Ped = Message[1]
	local Damage = Message[7]
	local Health = GetEntityHealth(Ped) > 100
	local Explosive = (Damage == 126349499 or Damage == 1064738331 or Damage == 85055149)

	if Explosive and Health then
		SetPedToRagdoll(Ped,2500,2500,0,0,0,0)

		return false
	end

	if GetGameTimer() >= Injuried and not IsPedInAnyVehicle(Ped) and Health then
		Injuried = GetGameTimer() + 1000

		local Hit,Mark = GetPedLastDamageBone(Ped)
		if Hit and not Damaged[Mark] and Mark ~= 0 then
			Bleedings = math.min(Bleedings + 1,5)
			ClearPedBloodDamage(Ped)
			Damaged[Mark] = true
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOODTICK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1000)

		local Ped = PlayerPedId()
		if not LocalPlayer.state.Arena and Bleedings >= 2 and GetGameTimer() >= BloodTimers and GetEntityHealth(Ped) > 100 then
			TriggerEvent("Notify","Sangramento","Ferimentos encontrados.","sangue",5000)
			BloodTimers = GetGameTimer() + 30000
			ApplyDamageToPed(Ped,1,false)
			ClearPedBloodDamage(Ped)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:RESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:Reset")
AddEventHandler("paramedic:Reset",function()
	Damaged = {}
	Bleedings = 0
	Injuried = GetGameTimer()
	BloodTimers = GetGameTimer()
	ClearPedBloodDamage(PlayerPedId())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLEEDING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bleeding()
	return Bleedings
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bandage()
	for Number in pairs(Damaged) do
		local Humane = Bone(Number)

		TriggerEvent("sounds:Private","bandage",0.5)
		TriggerEvent("Notify","Atenção","Passou ataduras no(a) <b>"..Humane.."</b>.","amarelo",10000)

		Bleedings = Bleedings - 1
		Damaged[Number] = nil

		ClearPedBloodDamage(PlayerPedId())

		return Humane
	end

	return ""
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OXYCONTIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Oxycontin()
	Damaged = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:INJURIES
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("paramedic:Injuries",function()
	if next(Damaged) == nil then
		TriggerEvent("Notify","Aviso","Nenhum ferimento encontrado.","amarelo",5000)

		return false
	end

	local Index = 1
	local Injuries = {}
	for Number in pairs(Damaged) do
		table.insert(Injuries,string.format("<b>%d</b>: %s<br>",Index,Bone(Number)))
		Index = Index + 1
	end

	TriggerEvent("Notify","Ferimentos",table.concat(Injuries),"amarelo",10000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Diagnostic()
	return Damaged,Bleedings
end