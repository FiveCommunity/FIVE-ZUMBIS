-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
vRP.Prepare("arena/Killed", "UPDATE characters SET Killed = Killed + 1 WHERE id = @Passport")
vRP.Prepare("arena/Death", "UPDATE characters SET Death = Death + 1 WHERE id = @Passport")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hyzan = {}
Tunnel.bindInterface("player", Hyzan)
vCLIENT = Tunnel.getInterface("player")
vMEMORY = Tunnel.getInterface("memory")
vSKINSHOP = Tunnel.getInterface("skinshop")
vKEYBOARD = Tunnel.getInterface("keyboard")

-- CONTROLE DE MENSAGENS DE CONTAMINAÇÃO
local lastContaminationMessage = {}

-- TIPOS DE DANO ESPECIAIS
local SPECIAL_DAMAGE_TYPES = {
    ["inflamavel"] = function(source)
        local Passport = vRP.Passport(source)
        if Passport then
            vRP.UpgradeStress(Passport, 15)
        end
    end,
    ["radioativo"] = function(source)
        local Passport = vRP.Passport(source)
        if Passport then
            vRP.UpgradeStress(Passport, 25)
        end
    end,
    ["elite"] = function(source)
        local Passport = vRP.Passport(source)
        if Passport then
            vRP.UpgradeStress(Passport, 10)
        end
    end,
    ["rapido"] = function(source)
        local Passport = vRP.Passport(source)
        if Passport then
            vRP.UpgradeStress(Passport, 5)
        end
    end,
    ["horda"] = function(source)
        local Passport = vRP.Passport(source)
        if Passport then
            vRP.UpgradeStress(Passport, 8)
            vRP.UpgradeStress(Passport, 15)
        end
    end
}

-- FUNÇÃO PARA VERIFICAR SE É NOITE
function IsNightTime()
    local hour = os.date("*t").hour
    return hour >= 18 or hour <= 6
end

-- FUNÇÃO PARA VERIFICAR SE JOGADOR ESTÁ EM PALETO BAY
function IsPlayerInPaletoBay(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local paletoCenter = vector3(-275.0, 6235.0, 31.0)
    return #(coords - paletoCenter) <= 300.0
end

-- FUNÇÃO PRINCIPAL DE CONTAMINAÇÃO
function Hyzan.ContaminatePlayer(source, extraCough)
    local Passport = vRP.Passport(source)
    if Passport and not vRP.Medicplan(source) then
        local currentTime = GetGameTimer()
        if not lastContaminationMessage[source] or (currentTime - (lastContaminationMessage[source] or 0)) > 30000 then
            TriggerClientEvent("Notify", source, "Atenção", "Você foi contaminado!", "infectado", 5000)
            vRP.UpgradeStress(Passport, math.random(10, 20) + (extraCough or 0))
            lastContaminationMessage[source] = currentTime
            
            -- Chance de atrair mais zumbis (aumentada para hordas)
            local inPaleto = IsPlayerInPaletoBay(source)
            local attractChance = IsNightTime() and (inPaleto and 70 or 50) or 30
            if math.random(100) <= attractChance then
                TriggerClientEvent("hyzan:attractZombies", source)
            end
        end
    end
end

-- EVENTO PARA CONTAMINAÇÃO POR ATAQUE
RegisterServerEvent("hyzan:zombieAttack")
AddEventHandler("hyzan:zombieAttack", function(zombieType, isHordeAttack)
    local source = source
    
    -- Se for um ataque de horda, aplicar efeito especial
    if isHordeAttack then
        SPECIAL_DAMAGE_TYPES["horda"](source)
    -- Se for um tipo especial, aplicar efeito adicional
    elseif zombieType and SPECIAL_DAMAGE_TYPES[zombieType] then
        SPECIAL_DAMAGE_TYPES[zombieType](source)
    end

    -- Lógica de contaminação normal
    local inPaleto = IsPlayerInPaletoBay(source)
    local isNight = IsNightTime()
    local chance = isNight and (inPaleto and 85 or 70) or 50
    
    if math.random(100) <= chance then
        local extraCough = (zombieType == "radioativo") and 10 or 0
        Hyzan.ContaminatePlayer(source, extraCough)
    end
end)

-- EFEITO DE RADIAÇÃO
RegisterServerEvent("hyzan:radiationEffect")
AddEventHandler("hyzan:radiationEffect", function()
    local source = source
    local Passport = vRP.Passport(source)
    
    if Passport and not vRP.Medicplan(source) then
        vRP.UpgradeStress(Passport, 5)
        TriggerClientEvent("Notify", source, "Atenção", "Você está sentindo os efeitos da radiação!", "radiacao", 5000)
    end
end)

-- EVENTO PARA ATRAIR HORDAS (CHAMADO QUANDO JOGADOR FAZ BARULHO)
RegisterServerEvent("hyzan:alertHordes")
AddEventHandler("hyzan:alertHordes", function(coords)
    -- Notificar todos os jogadores próximos
    local players = vRPC.players()
    for _, player in pairs(players) do
        local playerCoords = GetEntityCoords(GetPlayerPed(player))
        if #(playerCoords - coords) < 300.0 then
            TriggerClientEvent("hyzan:attractHordes", player, coords)
        end
    end
end)

RegisterServerEvent("arena:zombieKilled")
AddEventHandler("arena:zombieKilled", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        vRP.Query("arena/Killed", { Passport = Passport })
        local GainExperience = 1
		local _,Level = vRP.GetExperience(Passport,"Killed")
		vRP.PutExperience(Passport,"Killed",GainExperience)
    end
end)

RegisterServerEvent("arena:zombieDeath")
AddEventHandler("arena:zombieDeath", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        vRP.Query("arena/Death", { Passport = Passport })
    end
end)

-- LIMPEZA DE DADOS AO DESCONECTAR
AddEventHandler("playerDropped", function(reason)
    local source = source
    lastContaminationMessage[source] = nil
end)

-- COMANDO PARA DEBUG DE HORDAS (APENAS ADMIN)
RegisterCommand("debugHordes", function(source)
    if vRP.HasPermission(source, "admin") then
        TriggerClientEvent("hyzan:debugHordes", source)
    end
end)