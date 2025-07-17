-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("races",Creative)
vSERVER = Tunnel.getInterface("races")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Object = {}
local Position = 0
local Markers = {}
local Mode = false
local Checkpoint = 1
local InitSeconds = 0
local Selected = false
local Progressing = false
local ExplodeTimers = false
local Seconds = GetGameTimer()
local ExplodeCooldown = GetGameTimer()
local PositionCooldown = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer.state:set("Races",false,false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	LoadModel(PropTyre)
	LoadModel(PropFlags)
	SetGhostedEntityAlpha(254)

	while true do
		local TimeDistance = 999
		if not LocalPlayer.state.TestDrive then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)
			local Vehicle = GetLastDrivenVehicle()

			if LocalPlayer.state.Races and Mode and Races[Mode] and Selected then
				TimeDistance = 1

				local Distance = #(Coords - Races[Mode].Routes[Selected].Coords[Checkpoint].Center)
				if GetGameTimer() >= PositionCooldown then
					PositionCooldown = GetGameTimer() + 500
					vSERVER.UpdatePosition(Mode,Selected,Checkpoint,Distance)
				end

				if not Races[Mode].Global or (Races[Mode].Global and GlobalState[Mode..":"..Selected]) then
					Seconds = GetGameTimer() - InitSeconds

					if Progressing and ExplodeTimers and GetGameTimer() >= ExplodeCooldown then
						ExplodeTimers = ExplodeTimers - 1
						ExplodeCooldown = GetGameTimer() + 1000
					end

					if Distance <= (Races[Mode].Routes[Selected].Coords[Checkpoint].Distance + 1.0) then
						if Checkpoint >= #Races[Mode].Routes[Selected].Coords then
							vSERVER.Finish(Mode,Selected,Seconds)
							SendNUIMessage({ Action = "Close" })
							CleanObjects()
							CleanMarker()

							Checkpoint = 1
							InitSeconds = 0
							Progressing = false
							ExplodeTimers = false
							SetLocalPlayerAsGhost(false)
							SetNetworkVehicleAsGhost(Vehicle,false)
							LocalPlayer.state:set("Races",false,false)
							SendNUIMessage({ Action = "Results", Payload = vSERVER.Ranking(Mode,Selected,ResultFinish) })
							Selected = false
							Mode = false

							SetTimeout(SecondsResult,function()
								SendNUIMessage({ Action = "Close" })
							end)
						else
							if DoesBlipExist(Markers[Checkpoint]) then
								RemoveBlip(Markers[Checkpoint])
								Markers[Checkpoint] = nil
							end

							Checkpoint = Checkpoint + 1
							SetBlipRoute(Markers[Checkpoint],true)
							CreatedTyres()
						end
					end

					if not IsPedInAnyVehicle(Ped) or GetPedInVehicleSeat(Vehicle,-1) ~= Ped or (ExplodeTimers and ExplodeTimers <= 0) then
						SetNetworkVehicleAsGhost(Vehicle,false)
						SetLocalPlayerAsGhost(false)
						StopCircuit()
					end
				else
					if IsControlJustPressed(1,38) then
						vSERVER.GlobalState(Mode,Selected)
					end
				end
			else
				if IsPedInAnyVehicle(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyBoat(Ped) and not IsPedInAnyPlane(Ped) and GetPedInVehicleSeat(Vehicle,-1) == Ped and Mode and Selected and Races[Mode] and Races[Mode].Routes[Selected] then
					local Distance = #(Coords - Races[Mode].Routes[Selected].Init.xyz)
					if Distance <= 25 then
						DrawMarker(23,Races[Mode].Routes[Selected].Init.x,Races[Mode].Routes[Selected].Init.y,Races[Mode].Routes[Selected].Init.z - 0.35,0.0,0.0,0.0,0.0,0.0,0.0,10.0,10.0,10.0,88,101,242,175,0,0,0,0)
						TimeDistance = 1

						if Distance <= 5 and IsControlJustPressed(1,38) and vSERVER.Runners(Mode,Selected) then
							if Races[Mode].Explode then
								local Consult = vSERVER.Start(Mode,Selected)
								if Consult then
									ExplodeTimers = Consult
									ExplodeCooldown = GetGameTimer() + 1000
								else
									goto Ignore
								end
							end

							if Races[Mode].Global then
								SendNUIMessage({ Action = "Message", Payload = { "E","Pressione","para iniciar a corrida" } })
							end

							SetNetworkVehicleAsGhost(Vehicle,true)
							SetLocalPlayerAsGhost(true)

							InitSeconds = GetGameTimer()
							Checkpoint = 1

							LocalPlayer.state:set("Races",true,false)
							CreatedTyres()
							InitCircuit()
						end
					end

					::Ignore::
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITCIRCUIT
-----------------------------------------------------------------------------------------------------------------------------------------
function InitCircuit()
	for Number = 1,#Races[Mode].Routes[Selected].Coords do
		Markers[Number] = AddBlipForCoord(Races[Mode].Routes[Selected].Coords[Number].Center)
		SetBlipSprite(Markers[Number],1)
		SetBlipScale(Markers[Number],0.85)
		SetBlipColour(Markers[Number],ColourMarker)
		ShowNumberOnBlip(Markers[Number],Number)
		SetBlipAsShortRange(Markers[Number],true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEDTYRES
-----------------------------------------------------------------------------------------------------------------------------------------
function CreatedTyres()
	CleanObjects()

	local Prop = PropTyre
	if Checkpoint >= #Races[Mode].Routes[Selected].Coords then
		Prop = PropFlags
	end

	local Coords = Races[Mode].Routes[Selected].Coords[Checkpoint]
	Object.Left = CreateObjectNoOffset(Prop,Coords.Left.x,Coords.Left.y,Coords.Left.z,false,false,false)
	Object.Right = CreateObjectNoOffset(Prop,Coords.Right.x,Coords.Right.y,Coords.Right.z,false,false,false)

	SetEntityLodDist(Object.Left,0xFFFF)
	PlaceObjectOnGroundProperly(Object.Left)
	SetEntityCollision(Object.Left,false,false)

	SetEntityLodDist(Object.Right,0xFFFF)
	PlaceObjectOnGroundProperly(Object.Right)
	SetEntityCollision(Object.Right,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANMARKER
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanMarker()
	for Index,v in pairs(Markers) do
		if DoesBlipExist(v) then
			RemoveBlip(v)
		end

		Markers[Index] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanObjects()
	for Index,v in pairs(Object) do
		if DoesEntityExist(v) then
			DeleteEntity(v)
		end

		Object[Index] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPCIRCUIT
-----------------------------------------------------------------------------------------------------------------------------------------
function StopCircuit()
	LocalPlayer.state:set("Races",false,false)
	SendNUIMessage({ Action = "Close" })
	vSERVER.Cancel()
	CleanObjects()
	CleanMarker()

	Mode = false
	Selected = false
	Progressing = false

	if ExplodeTimers then
		ExplodeTimers = false

		SetTimeout(SecondsExplode,function()
			local Vehicle = GetLastDrivenVehicle()

			if Vehicle <= 0 then
				ApplyDamageToPed(PlayerPedId(),200,false)
			else
				NetworkExplodeVehicle(Vehicle,true,false,true)
			end
		end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdatePosition(Positioner,Runners)
	Position = Positioner
	SendNUIMessage({ Action = "Racing", Payload = { Position, #Runners, Runners, (not Races[Mode].Global and Seconds or Progressing and Seconds or 0), ExplodeTimers, "1/1", Checkpoint.."/"..Races[Mode].Routes[Selected].Checkpoints } })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:Start")
AddEventHandler("races:Start",function(Modez,Selectedz)
	if Mode and Mode == Modez and Selected and Selected == Selectedz and Races[Mode] then
		local Vehicle = GetLastDrivenVehicle()
		local Value = #(vSERVER.Runners(Mode, Selected) or {}) + 1
		SetEntityCoords(Vehicle,Races[Mode].Routes[Selected].Positions[Value].xyz)
		SetEntityHeading(Vehicle,Races[Mode].Routes[Selected].Positions[Value].w)
		SetTimeout(100,function()
			SendNUIMessage({ Action = "Message", Payload = false })
			SendNUIMessage({ Action = "Countdown" })
		end)
		FreezeEntityPosition(Vehicle,true)

		SetTimeout(4000,function()
			Progressing = true
			Seconds = GetGameTimer()
			InitSeconds = GetGameTimer()
			FreezeEntityPosition(Vehicle,false)
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:Open")
AddEventHandler("races:Open",function()
	if not LocalPlayer.state.Races then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		TriggerEvent("hud:Active",false)
		SendNUIMessage({ Action = "Open", Payload = { Races,LocalPlayer.state.Name } })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	TriggerEvent("hud:Active",true)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RUN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Run",function(Data,Callback)
	Mode = Data.Mode
	Selected = Data.Route

	if Mode and Selected and Races[Mode] and Races[Mode] and Races[Mode].Routes[Selected] and Races[Mode].Routes[Selected].Init then
		SetNewWaypoint(Races[Mode].Routes[Selected].Init.x + 0.0001,Races[Mode].Routes[Selected].Init.y + 0.0001)
	end

	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	TriggerEvent("hud:Active",true)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Ranking",function(Data,Callback)
	Callback(vSERVER.Ranking(Data.Mode,Data.Route,RankingTablet))
end)