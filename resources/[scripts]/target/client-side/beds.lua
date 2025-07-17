-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Previous = nil
local Treatment = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Beds = {
	-- Enclave Inicial
	{ ["Coords"] = vec4(-403.58,1153.77,325.62,257.96), ["Invert"] = 180.0 },
	{ ["Coords"] = vec4(-400.73,1153.15,325.62,255.12), ["Invert"] = 180.0 },
	{ ["Coords"] = vec4(-403.29,1157.7,325.62,257.96), ["Invert"] = 180.0 },
	{ ["Coords"] = vec4(-399.84,1156.79,325.62,260.79), ["Invert"] = 180.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Beds) do
		AddBoxZone("Beds:"..Number,v["Coords"]["xyz"],2.0,1.0,{
			name = "Beds:"..Number,
			heading = v["Coords"]["w"],
			minZ = v["Coords"]["z"] - 0.25,
			maxZ = v["Coords"]["z"] + 0.50
		},{
			shop = Number,
			Distance = 1.50,
			options = {
				{
					event = "target:PutBed",
					label = "Deitar",
					tunnel = "client"
				},{
					event = "target:Treatment",
					label = "Tratamento",
					tunnel = "client"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:PUTBED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("target:PutBed",function(Number)
	if Previous then
		return false
	end

	local Ped = PlayerPedId()
	Previous = GetEntityCoords(Ped)
	local Config = Beds[Number].Coords

	SetEntityHeading(Ped,Config.w - Beds[Number].Invert)
	SetEntityCoords(Ped,Config.x,Config.y,Config.z - 0.5)
	vRP.playAnim(false,{"amb@world_human_sunbathe@female@back@idle_a","idle_a"},true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPBED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("target:UpBed",function()
	if not Previous then
		return false
	end

	SetEntityCoords(PlayerPedId(),Previous.x,Previous.y,Previous.z - 0.5)
	Previous = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:TREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("target:Treatment",function(Number,Ignore)
	if Previous or not Beds[Number] or (not Ignore and not vSERVER.CheckIn()) then
		return false
	end

	local Ped = PlayerPedId()
	if GetEntityHealth(Ped) <= 100 then
		exports["survival"]:Revive(101)
	end

	Previous = GetEntityCoords(Ped)
	local Config = Beds[Number].Coords

	SetEntityHeading(Ped,Config.w - Beds[Number].Invert)
	SetEntityCoords(Ped,Config.x,Config.y,Config.z - 0.5)
	vRP.playAnim(false,{"amb@world_human_sunbathe@female@back@idle_a","idle_a"},true)

	LocalPlayer["state"]:set("Commands",true,true)
	LocalPlayer["state"]:set("Buttons",true,true)
	LocalPlayer["state"]:set("Cancel",true,true)
	NetworkSetFriendlyFireOption(false)
	Treatment = GetGameTimer() + 1000
	TriggerEvent("paramedic:Reset")
	SetEntityInvincible(Ped,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:StartTreatment")
AddEventHandler("target:StartTreatment",function()
	if Treatment then
		return false
	end

	LocalPlayer["state"]:set("Commands",true,true)
	LocalPlayer["state"]:set("Buttons",true,true)
	LocalPlayer["state"]:set("Cancel",true,true)
	SetEntityInvincible(PlayerPedId(),true)
	NetworkSetFriendlyFireOption(false)
	Treatment = GetGameTimer() + 1000
	TriggerEvent("paramedic:Reset")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Treatment and GetGameTimer() >= Treatment then
			local Ped = PlayerPedId()
			Treatment = GetGameTimer() + 1000
			local Health = GetEntityHealth(Ped)

			if Health < 200 then
				SetEntityHealth(Ped,Health + 1)

				if Previous and not IsEntityPlayingAnim(Ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then
					vRP.playAnim(false,{"amb@world_human_sunbathe@female@back@idle_a","idle_a"},true)
					SetEntityCoords(Ped,Previous.x,Previous.y,Previous.z - 0.5)
				end
			else
				Treatment = false
				SetEntityInvincible(Ped,false)
				NetworkSetFriendlyFireOption(true)
				LocalPlayer["state"]:set("Cancel",false,true)
				LocalPlayer["state"]:set("Buttons",false,true)
				LocalPlayer["state"]:set("Commands",false,true)
				TriggerEvent("Notify","Centro Médico","Tratamento concluido.","sangue",5000)
			end
		end

		Wait(1000)
	end
end)