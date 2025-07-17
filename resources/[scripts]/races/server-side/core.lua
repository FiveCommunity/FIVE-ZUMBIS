-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("races", Creative)
vCLIENT = Tunnel.getInterface("races")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Payments = {}
local Cooldowns = {}
local ActiveRaces = {}
local Participants = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Finish(Mode, Route, Points)
    local source = source
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    local VehicleName = vRPC.VehicleName(source)
    if not Passport then return end

    local RaceKey = Mode .. ":" .. Route
    Points = Points and Points > 1000 and math.floor(Points / 1000) or 0

    if ActiveRaces[RaceKey] and ActiveRaces[RaceKey][Passport] then
        ActiveRaces[RaceKey][Passport] = nil
        if next(ActiveRaces[RaceKey]) == nil then
            GlobalState[RaceKey] = nil
        end
    end

    if Payments[Passport] then
        Payments[Passport] = nil

        local RouteData = Races[Mode]["Routes"][Route]
        if not RouteData then return end

        local Query = vRP.Query("Races/User", { Mode = Mode, Race = Route, Passport = Passport })
		local Action = Query[1] and "Update" or "Insert"

		if Points > 0 then
			vRP.Query("Races/"..Action, { Mode = Mode, Race = Route, Passport = Passport, Vehicle = VehicleName, Points = parseInt(Points) })
		end

        vRP.GenerateItem(Passport,"zcoin",RouteData["Payment"],true)
        exports["markers"]:Exit(source)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Start(Mode, Route)
    local source = source
    local Passport = vRP.Passport(source)
    local RaceKey = Mode .. ':' .. Route
    
    if Cooldowns[RaceKey]?[Passport] and (os.time() < Cooldowns[RaceKey]?[Passport]) then
        return TriggerClientEvent('Notify', source, 'Atenção', ('Aguarde <b>%s</b> para participar novamente.'):format(CompleteTimers(Cooldowns[RaceKey][Passport])), 'amarelo', 5000)
    end
        
    if vRP.ConsultItem(Passport,'races',1) and vRP.TakeItem(Passport,'races',1,true) then
        Cooldowns[RaceKey] = Cooldowns[RaceKey] or {}

        Cooldowns[RaceKey][Passport] = os.time() + 60
        Payments[Passport] = true
        GlobalState[RaceKey] = true
        ActiveRaces[RaceKey] = ActiveRaces[RaceKey] or {}
        ActiveRaces[RaceKey][Passport] = true

        Participants[RaceKey] = Participants[RaceKey] or {}

        TriggerClientEvent('races:Start', source, Mode, Route)
        local RouteData = Races[Mode].Routes[Route]
        return RouteData and RouteData.Time or 60
    else
        TriggerClientEvent('Notify', source, 'Atenção', ('São necessários <b>x%i %s</b> para iniciar a corrida.'):format(1, ItemName('races')), 'amarelo', 5000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdatePosition(Mode, Route, Checkpoint, Distance)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local RaceKey = Mode .. ":" .. Route
    Participants[RaceKey] = Participants[RaceKey] or {}
    Participants[RaceKey][Passport] = { checkpoint = Checkpoint, distance = Distance }

    local List = {}
    for Id, Data in pairs(Participants[RaceKey]) do
        table.insert(List, { passport = Id, Name = vRP.FullName(Id), checkpoint = Data.checkpoint, distance = Data.distance })
    end
	
    table.sort(List, function(a, b)
        if a.checkpoint == b.checkpoint then
            return a.distance < b.distance
        else
            return a.checkpoint > b.checkpoint
        end
    end)

    local Runners = {}
    local Position = 1
    for Index, Data in ipairs(List) do
        table.insert(Runners, { passport = Id, Name = Data.Name, checkpoint = Data.checkpoint, distance = Data.distance })
        if Data.passport == Passport then Position = Index end
    end
    vCLIENT.UpdatePosition(source, Position, Runners)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RUNNERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Runners(Mode, Route)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return {} end

    local RaceKey = Mode .. ":" .. Route
    Participants[RaceKey] = Participants[RaceKey] or {}

    local List = {}
    for Id, Data in pairs(Participants[RaceKey]) do
        table.insert(List, { passport = Id, Name = vRP.FullName(Id), checkpoint = Data.checkpoint, distance = Data.distance })
    end

    table.sort(List, function(a, b)
        if a.checkpoint == b.checkpoint then
            return a.distance < b.distance
        else
            return a.checkpoint > b.checkpoint
        end
    end)

    local Runners = {}
    for _, Data in ipairs(List) do
        table.insert(Runners, { passport = Id, Name = Data.Name, checkpoint = Data.checkpoint, distance = Data.distance })
    end
    return Runners
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Ranking(Mode, Route)
    local Query = vRP.Query("Races/Consult", { Mode = Mode, Race = Route, Count = 10 })
    local Ranking = {}

    for k, v in ipairs(Query) do
        Ranking[#Ranking + 1] = { Name = vRP.FullName(v['Passport']), Vehicle = VehicleName(v['Vehicle']), Time = v['Points'], Passport = v['Passport'] }
    end

    return Ranking
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GlobalState(Mode, Route)
	local source = source
	local RaceName = Mode .. ":" .. Route
    if Races[Mode] and Races[Mode]["Global"] and not GlobalState[RaceName] then
        GlobalState[RaceName] = true
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Cancel(source, Passport)
    local source = source
    local Passport = Passport or vRP.Passport(source)
    if not Passport then return end

    for RaceKey in pairs(ActiveRaces) do
        if Participants[RaceKey][Passport] then
            Participants[RaceKey][Passport] = nil
            if next(Participants) == nil then
                GlobalState[RaceKey] = nil
            end
        end
    end

    Payments[Passport] = nil
    exports["markers"]:Exit(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport, source)
    Creative.Cancel(source, Passport)
end)
