-- VRP
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-- CONFIGURAÇÕES
local Shooting = false
local Running = false
local DebugMode = false -- Debug desativado

-- MODELOS DE ZUMBIS
local ZombieModels = {
    "u_m_y_zombie_01",
    "a_m_m_hillbilly_01",
    "a_m_m_hasjew_01",
    "a_m_m_rurmeth_01",
    "a_m_o_acult_01"
}

-- MODELOS E CONFIGURAÇÕES DE ZUMBIS ESPECIAIS
local EliteZombieModels = {
    {
        model = "s_m_y_blackops_03",
        type = "elite",
        health = 3500,
        armor = 150,
        damage = 15,
        speed = 1.0,
        chance = 30
    },
    {
        model = "u_m_y_juggernaut_01",
        type = "tanque",
        health = 8000,
        armor = 200,
        damage = 25,
        speed = 0.7,
        chance = 25
    },
    {
        model = "a_m_y_methhead_01",
        type = "inflamavel",
        health = 1900,
        armor = 0,
        damage = 10,
        speed = 1.0,
        chance = 25,
        fireDamage = true
    },
    {
        model = "a_m_y_acult_01",
        type = "rapido",
        health = 1800,
        armor = 50,
        damage = 10,
        speed = 1.5,
        chance = 30
    },
    {
        model = "s_m_m_chemsec_01",
        type = "radioativo",
        health = 1700,
        armor = 100,
        damage = 5,
        speed = 0.9,
        chance = 25,
        radiationDamage = true
    }
}

-- MULTIPLICADORES NOTURNOS
local NightMultipliers = {
    spawn = 3.0,
    health = 1.5,
    damage = 1.3
}

-- ZONAS INFECTADAS (AUMENTADAS)
local InfectedZones = {
    {x = -110.0, y = -1018.0, z = 27.0, radius = 150.0, spawnCount = 50, isCentral = true},
    {x = 1675.42, y = 3558.41, z = 35.0, radius = 150.0, spawnCount = 50, isCentral = true},
    {x = 26.31, y = -752.07, z = 31.61, radius = 200.0, spawnCount = 50, isCentral = true},
    {x = 179.48, y = -971.47, z = 29.57, radius = 150.0, spawnCount = 50, isCentral = true},
    {x = 386.15, y = -1052.62, z = 32.45, radius = 150.0, spawnCount = 50, isCentral = true},
    {x = -275.0, y = 6235.0, z = 31.0, radius = 150.0, spawnCount = 50, isCentral = true},
    {x = -1035.75, y = -2729.53, z = 13.75, radius = 150.0, spawnCount = 50, isCentral = true},
    {x = -830.07, y = -1018.0, z = 11.0, radius = 150.36, spawnCount = 50, isCentral = true}
}

-- PEDS EXCLUÍDOS
local ExcludedPeds = {
    "ig_shadow",
    "s_m_y_cop_01",
    "s_m_y_sheriff_01",
    "s_f_y_cop_01",
    "s_m_m_security_01",
    "s_m_m_scientist_01",
    "s_m_m_migrant_01",
    "ig_dale",
    "ig_dreyfuss",
    "mp_m_shopkeep_01",
    "s_m_m_paramedic_01",
    "s_m_y_blackops_02",
    "s_f_y_ranger_01"
}

-- ZONAS SEGURAS
local SafeZones = {
    {x = 957.95, y = -205.12, z = 282.6, radius = 30.0},
    {x = -409.33, y = 1184.17, z = 325.54, radius = 130.0},
}

-- LIMPEZA DE PEDS E VEÍCULOS
local clearPedsAndVehicle = {
    {coords = vec3(957.95,-205.12,282.6), radius = 30.0},
--    {coords = vec3(-409.33,1184.17,325.54), radius = 130.0}, -- 
}

CreateThread(function()
    while true do
        Wait(10000)
        for _,v in pairs(clearPedsAndVehicle) do
            ClearAreaOfVehicles(v.coords, v.radius)
            ClearAreaOfPeds(v.coords, v.radius, 1)
        end
    end
end)

-- INICIALIZAÇÃO
DecorRegister('RegisterZombie', 2)
DecorRegister('HordeMember', 2)
DecorRegister('HordeLeader', 2)
DecorRegister('ZombieType', 1)
DecorRegister('ZombieDamage', 1)
DecorRegister('DamageMultiplier', 2)

AddRelationshipGroup('ZOMBIE')
SetRelationshipBetweenGroups(0, GetHashKey('ZOMBIE'), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GetHashKey('ZOMBIE'))

-- VARIÁVEIS DE HORDAS
local ActiveHordes = {}
local HordeTrailEffects = {}

-- FUNÇÕES LOCAIS
function IsPlayerShooting()
    return Shooting
end

function IsPlayerRunning()
    return Running
end

function IsExcludedPed(ped)
    local model = GetEntityModel(ped)
    for _, excluded in ipairs(ExcludedPeds) do
        if model == GetHashKey(excluded) then 
            return true 
        end
    end
    return false
end

function IsInSafeZone(coords)
    for _, zone in pairs(SafeZones) do
        local distance = #(vector3(zone.x, zone.y, zone.z) - coords)
        if distance <= zone.radius then
            return true
        end
    end
    return false
end

function IsNightTime()
    local hour = GetClockHours()
    return hour >= 18 or hour <= 6
end

function IsEliteZombie(ped)
    local model = GetEntityModel(ped)
    for _, eliteModel in ipairs(EliteZombieModels) do
        if model == GetHashKey(eliteModel.model) then
            return true
        end
    end
    return false
end

function SetZombieFireImmunity(ped)
    if DoesEntityExist(ped) then
        local zombieType = DecorExistOn(ped, 'ZombieType') and DecorGetInt(ped, 'ZombieType') or 0
        if zombieType == 3 then -- inflamavel
            SetEntityProofs(ped, false, false, false, false, false, false, false, false)
            SetEntityCanBeDamaged(ped, false)
            SetTimeout(1000, function()
                if DoesEntityExist(ped) then
                    SetEntityCanBeDamaged(ped, true)
                end
            end)
        else
            SetEntityProofs(ped, false, false, false, false, true, false, false, false)
        end
    end
end

function ConfigureSpecialZombie(zombie)
    if not DoesEntityExist(zombie) then return end

    local model = GetEntityModel(zombie)
    local zombieConfig
    
    for i, config in ipairs(EliteZombieModels) do
        if model == GetHashKey(config.model) then
            zombieConfig = config
            zombieConfig.index = i
            break
        end
    end

    if not zombieConfig then return end

    local health = zombieConfig.health
    local damageMultiplier = 1.0

    if IsNightTime() then
        health = math.floor(health * NightMultipliers.health)
        damageMultiplier = NightMultipliers.damage
    end

    SetEntityHealth(zombie, health)
    
    if zombieConfig.armor > 0 then
        SetPedArmour(zombie, zombieConfig.armor)
    end

    if zombieConfig.type == "tanque" then
        SetPedMoveRateOverride(zombie, zombieConfig.speed)
        SetPedConfigFlag(zombie, 263, true)
    elseif zombieConfig.type == "inflamavel" then
        SetPedMoveRateOverride(zombie, zombieConfig.speed)
        StartEntityFire(zombie)
        SetZombieFireImmunity(zombie)
        
        CreateThread(function()
            while DoesEntityExist(zombie) and not IsPedDeadOrDying(zombie, true) do
                if not IsEntityOnFire(zombie) then
                    StartEntityFire(zombie)
                end
                Wait(5000)
            end
        end)
    elseif zombieConfig.type == "rapido" then
        SetPedMoveRateOverride(zombie, zombieConfig.speed)
    elseif zombieConfig.type == "radioativo" then
        SetPedPropIndex(zombie, 0, 0, 0, true)
    end

    SetEntityAsMissionEntity(zombie, true, true)
    SetPedCanRagdoll(zombie, true)
    SetPedRagdollOnCollision(zombie, true)
    DecorSetInt(zombie, 'ZombieDamage', zombieConfig.damage)
    DecorSetFloat(zombie, 'DamageMultiplier', damageMultiplier)
    DecorSetBool(zombie, 'RegisterZombie', true)
    DecorSetInt(zombie, 'ZombieType', zombieConfig.index)
end

function CreateHorde(zombies)
    local validZombies = {}
    for _, zombie in ipairs(zombies) do
        if DoesEntityExist(zombie) then
            table.insert(validZombies, zombie)
        end
    end

    if #validZombies < 3 then return nil end

    local hordeId = #ActiveHordes + 1
    local leader = validZombies[1]
    
    ActiveHordes[hordeId] = {
        id = hordeId,
        members = validZombies,
        leader = leader,
        lastPosition = GetEntityCoords(leader),
        size = #validZombies,
        formation = math.random(1, 3)
    }
    
    for _, zombie in ipairs(validZombies) do
        if DoesEntityExist(zombie) then
            DecorSetInt(zombie, 'HordeMember', hordeId)
            if zombie == leader then
                DecorSetBool(zombie, 'HordeLeader', true)
            end
        end
    end
    
    ConfigureHordeAI(hordeId)
    
    return hordeId
end

function ConfigureHordeAI(hordeId)
    local horde = ActiveHordes[hordeId]
    if not horde then return end
    
    local speedMultiplier = 1.0
    if horde.size > 15 then
        speedMultiplier = 0.8
    elseif horde.size > 30 then
        speedMultiplier = 0.7
    end
    
    for _, zombie in ipairs(horde.members) do
        if DoesEntityExist(zombie) then
            SetPedMoveRateOverride(zombie, speedMultiplier)
        end
    end
    
    CreateThread(function()
        while ActiveHordes[hordeId] do
            Wait(5000)
            
            local aliveMembers = {}
            for _, zombie in ipairs(horde.members) do
                if DoesEntityExist(zombie) and not IsPedDeadOrDying(zombie, true) then
                    table.insert(aliveMembers, zombie)
                end
            end
            
            horde.members = aliveMembers
            horde.size = #aliveMembers
            
            if horde.size < 3 then
                DissolveHorde(hordeId)
                return
            end
            
            if not DoesEntityExist(horde.leader) or IsPedDeadOrDying(horde.leader, true) then
                horde.leader = aliveMembers[1]
                if DoesEntityExist(horde.leader) then
                    DecorSetBool(horde.leader, 'HordeLeader', true)
                end
            end
            
            if DoesEntityExist(horde.leader) then
                horde.lastPosition = GetEntityCoords(horde.leader)
            end
            
            if horde.size >= 10 then
                CreateHordeTrail(hordeId)
            end
        end
    end)
end

function DissolveHorde(hordeId)
    if ActiveHordes[hordeId] then
        for _, zombie in ipairs(ActiveHordes[hordeId].members) do
            if DoesEntityExist(zombie) then
                DecorRemove(zombie, 'HordeMember')
                DecorRemove(zombie, 'HordeLeader')
            end
        end
        
        if HordeTrailEffects[hordeId] then
            for _, effect in ipairs(HordeTrailEffects[hordeId]) do
                if DoesParticleFxLoopedExist(effect) then
                    StopParticleFxLooped(effect, false)
                end
            end
            HordeTrailEffects[hordeId] = nil
        end
        
        ActiveHordes[hordeId] = nil
    end
end

function CreateHordeTrail(hordeId)
    if not ActiveHordes[hordeId] or ActiveHordes[hordeId].size < 10 then return end
    
    local horde = ActiveHordes[hordeId]
    if not DoesEntityExist(horde.leader) then return end
    
    local coords = GetEntityCoords(horde.leader)
    
    if not HordeTrailEffects[hordeId] then
        HordeTrailEffects[hordeId] = {}
    end
    
    UseParticleFxAssetNextCall("core")
    local fx = StartParticleFxLoopedAtCoord("ent_anim_dog_poo", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    table.insert(HordeTrailEffects[hordeId], fx)
    
    UseParticleFxAssetNextCall("core")
    fx = StartParticleFxLoopedAtCoord("ent_dst_blood", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.5, false, false, false, false)
    table.insert(HordeTrailEffects[hordeId], fx)
    
    if #HordeTrailEffects[hordeId] > 20 then
        StopParticleFxLooped(HordeTrailEffects[hordeId][1], false)
        table.remove(HordeTrailEffects[hordeId], 1)
    end
end

function CheckForHordeFormation()
    local peds = GetGamePool('CPed')
    local zombies = {}
    
    for _, ped in ipairs(peds) do
        if DecorExistOn(ped, 'RegisterZombie') and not DecorExistOn(ped, 'HordeMember') and DoesEntityExist(ped) then
            table.insert(zombies, ped)
        end
    end
    
    local groups = {}
    for _, zombie in ipairs(zombies) do
        if DoesEntityExist(zombie) then
            local zombieCoords = GetEntityCoords(zombie)
            local added = false
            
            for _, group in ipairs(groups) do
                if DoesEntityExist(group[1]) then
                    local groupCoords = GetEntityCoords(group[1])
                    if #(zombieCoords - groupCoords) < 15.0 then
                        table.insert(group, zombie)
                        added = true
                        break
                    end
                end
            end
            
            if not added then
                table.insert(groups, {zombie})
            end
        end
    end
    
    for _, group in ipairs(groups) do
        if #group >= 5 then
            CreateHorde(group)
        end
    end
end

function UpdateHordeBehavior(hordeId)
    local horde = ActiveHordes[hordeId]
    if not horde or horde.size < 3 then return end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local hordeCoords = horde.lastPosition
    
    if DoesEntityExist(horde.leader) then
        hordeCoords = GetEntityCoords(horde.leader)
    end
    
    local distanceToPlayer = #(playerCoords - hordeCoords)
    
    if distanceToPlayer < 150.0 then
        for _, zombie in ipairs(horde.members) do
            if DoesEntityExist(zombie) and not IsPedDeadOrDying(zombie, true) then
                TaskGoToEntity(zombie, playerPed, -1, 0.0, 1.5, 1073741824, 0)
            end
        end
    else
        if distanceToPlayer > 200.0 or math.random(100) < 30 then
            local angle = math.random() * math.pi * 2
            local r = math.random(10.0, 50.0)
            local target = hordeCoords + vector3(r * math.cos(angle), r * math.sin(angle), 0.0)
            
            for i, zombie in ipairs(horde.members) do
                if DoesEntityExist(zombie) and not IsPedDeadOrDying(zombie, true) then
                    local offset = GetFormationOffset(horde.formation, i, horde.size)
                    local targetCoords = target + offset
                    
                    TaskGoToCoordAnyMeans(zombie, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, 0, false, 786603, -1.0)
                end
            end
        end
    end
end

function GetFormationOffset(formationType, index, hordeSize)
    if formationType == 1 then
        return vector3((index - math.floor(hordeSize/2)) * 1.5, 0.0, 0.0)
    elseif formationType == 2 then
        local side = index % 2 == 0 and 1 or -1
        local row = math.floor((index + 1)/2)
        return vector3(row * 1.2, side * row * 1.2, 0.0)
    else
        return vector3(math.random() * 2.0 - 1.0, math.random() * 2.0 - 1.0, 0.0)
    end
end

-- CONTROLE DE DENSIDADE OTIMIZADO
CreateThread(function()
    while true do
        -- Configurações agressivas de densidade
        SetPedDensityMultiplierThisFrame(3.0) -- Máximo possível
        SetScenarioPedDensityMultiplierThisFrame(3.0, 3.0) -- Áreas e cenários
        SetRandomVehicleDensityMultiplierThisFrame(0.0) -- Desativa veículos
        SetParkedVehicleDensityMultiplierThisFrame(0.0) -- Desativa veículos estacionados
        SetVehicleDensityMultiplierThisFrame(0.0) -- Desativa veículos completamente
        
        -- Forçar spawn de peds em todas as zonas
        for _, zone in pairs(InfectedZones) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(vector3(zone.x, zone.y, zone.z) - playerCoords)
            
            if distance < 500.0 then
                SetScenarioTypeEnabled('WORLD_HUMAN_SMOKING', false)
                SetScenarioTypeEnabled('WORLD_HUMAN_STAND_IMPATIENT', false)
                SetScenarioTypeEnabled('WORLD_HUMAN_AA_COFFEE', false)
                
                -- Força spawn de zumbis
                SetAmbientPedRangeMultiplierThisFrame(60.0)
                SetGarbageTrucks(false)
                SetRandomBoats(false)
            end
        end
        
        Wait(0)
    end
end)

RegisterNetEvent("hyzan:attractZombies")
AddEventHandler("hyzan:attractZombies", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    local peds = GetGamePool('CPed')
    for _, ped in ipairs(peds) do
        if DecorExistOn(ped, 'RegisterZombie') and DoesEntityExist(ped) then
            local pedCoords = GetEntityCoords(ped)
            if #(playerCoords - pedCoords) <= 100.0 then
                TaskGoToEntity(ped, playerPed, -1, 0.0, 1.5, 1073741824, 0)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if IsPedShooting(PlayerPedId()) then
            Shooting = true
            Wait(5000)
            Shooting = false
        end

        if IsPedSprinting(PlayerPedId()) or IsPedRunning(PlayerPedId()) then
            Running = true
        else
            Running = false
        end
    end
end)

CreateThread(function()
    while true do
        Wait(30000)
        CheckForHordeFormation()
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        
        for hordeId, _ in pairs(ActiveHordes) do
            UpdateHordeBehavior(hordeId)
        end
    end
end)

CreateThread(function()
    local lastNightState = nil
    while true do
        Wait(60000)
        
        local currentNightState = IsNightTime()
        if lastNightState ~= nil and currentNightState ~= lastNightState then
            if currentNightState then
                TriggerEvent("Notify", "Atenção", "A noite caiu! Os zumbis estão mais ativos e numerosos!", "vermelho", 10000)
            else
                TriggerEvent("Notify", "Atenção", "O sol nasceu! A atividade zumbi diminuiu.", "verde", 10000)
            end
        end
        lastNightState = currentNightState
    end
end)

CreateThread(function()
    for _, zone in pairs(SafeZones) do
        local Blip = AddBlipForRadius(zone.x, zone.y, zone.z, zone.radius)
        SetBlipHighDetail(Blip, true)
        SetBlipColour(Blip, 2)
        SetBlipAlpha(Blip, 128)
        
        local centerBlip = AddBlipForCoord(zone.x, zone.y, zone.z)
        SetBlipSprite(centerBlip, 487)
        SetBlipColour(centerBlip, 2)
        SetBlipAsShortRange(centerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zona Segura")
        EndTextCommandSetBlipName(centerBlip)
    end

    for _, zone in pairs(InfectedZones) do
        local Blip = AddBlipForRadius(zone.x, zone.y, zone.z, zone.radius)
        SetBlipHighDetail(Blip, true)
        SetBlipColour(Blip, 1)
        SetBlipAlpha(Blip, 128)
        
        local centerBlip = AddBlipForCoord(zone.x, zone.y, zone.z)
        SetBlipSprite(centerBlip, 84)
        SetBlipColour(centerBlip, 1)
        SetBlipAsShortRange(centerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zona Infectada")
        EndTextCommandSetBlipName(centerBlip)
    end

    while true do
        Wait(1000)
        
        local peds = GetGamePool('CPed')
        for _, ped in ipairs(peds) do
            if DecorExistOn(ped, 'RegisterZombie') and DoesEntityExist(ped) then
                local pedCoords = GetEntityCoords(ped)
                if IsInSafeZone(pedCoords) then
                    DeleteEntity(ped)
                end
            end
        end
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if IsInSafeZone(playerCoords) then
    --        TriggerEvent("Notify", "amarelo", "Você está em uma Zona Segura", "Atenção", 5000)
        end
    end
end)

-- SPAWN DE ZUMBIS OTIMIZADO
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local spawnMultiplier = IsNightTime() and NightMultipliers.spawn or 1
        local specialZombieChance = IsNightTime() and 50 or 30
        
        -- Verifica todas as zonas infectadas
        for _, zone in pairs(InfectedZones) do
            local distance = #(vector3(zone.x, zone.y, zone.z) - playerCoords)
            
            -- Se o jogador está perto o suficiente da zona
            if distance < (zone.radius + 100.0) then
                local zombieCount = 0
                local peds = GetGamePool('CPed')
                
                -- Conta zumbis existentes
                for _, ped in ipairs(peds) do
                    if DecorExistOn(ped, 'RegisterZombie') and DoesEntityExist(ped) then
                        local pedCoords = GetEntityCoords(ped)
                        if #(vector3(zone.x, zone.y, zone.z) - pedCoords) <= zone.radius then
                            zombieCount = zombieCount + 1
                        end
                    end
                end
                
                -- Calcula máximo de zumbis com multiplicador
                local maxZombies = math.floor(zone.spawnCount * spawnMultiplier)
                
                -- Se precisar spawnar mais zumbis
                if zombieCount < maxZombies then
                    local spawnAmount = math.min(30, maxZombies - zombieCount)
                    
                    for i = 1, spawnAmount do
                        local angle = math.random() * math.pi * 2
                        local r = math.sqrt(math.random()) * zone.radius
                        local spawnCoords = vector3(
                            zone.x + r * math.cos(angle),
                            zone.y + r * math.sin(angle),
                            zone.z
                        )
                        
                        local ground, z = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z)
                        if ground then
                            spawnCoords = vector3(spawnCoords.x, spawnCoords.y, z + 1.0)
                            
                            -- Escolhe o modelo
                            local isSpecial = math.random(100) <= specialZombieChance
                            local model
                            
                            if isSpecial then
                                local possibleElites = {}
                                for _, elite in ipairs(EliteZombieModels) do
                                    if math.random(100) <= elite.chance then
                                        table.insert(possibleElites, elite)
                                    end
                                end
                                
                                if #possibleElites > 0 then
                                    model = possibleElites[math.random(#possibleElites)].model
                                end
                            end
                            
                            model = model or ZombieModels[math.random(#ZombieModels)]
                            
                            -- Cria o ped assincronamente
                            CreateThread(function()
                                RequestModel(model)
                                while not HasModelLoaded(model) do Wait(0) end
                                
                                local zombie = CreatePed(4, model, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true)
                                if model ~= ZombieModels[math.random(#ZombieModels)] then
                                    ConfigureSpecialZombie(zombie)
                                else
                                    SetEntityHealth(zombie, 200)
                                    DecorSetBool(zombie, 'RegisterZombie', true)
                                end
                                
                                if DoesEntityExist(zombie) then
                                    RequestAnimSet('move_m@drunk@verydrunk')
                                    while not HasAnimSetLoaded('move_m@drunk@verydrunk') do
                                        Wait(0)
                                    end
                                    SetPedMovementClipset(zombie, 'move_m@drunk@verydrunk', 1.0)
                                    
                                    TaskWanderStandard(zombie, 10.0, 10)
                                    
                                    SetEntityAsMissionEntity(zombie, true, true)
                                end
                            end)
                        end
                    end
                end
            end
        end

        Wait(1000) -- Intervalo entre verificações de spawn
    end
end)

-- CONTROLE DE ZUMBIS EXISTENTES
CreateThread(function()
    while true do
        Wait(0)
        
        local Zombie = -1
        local Success = false
        local Handler, Zombie = FindFirstPed()

        repeat
            Wait(10)

            if DoesEntityExist(Zombie) and IsPedHuman(Zombie) and not IsPedAPlayer(Zombie) and not IsPedDeadOrDying(Zombie, true) and not IsExcludedPed(Zombie) then
                if not DecorExistOn(Zombie, 'RegisterZombie') then
                    ClearPedTasks(Zombie)
                    ClearPedSecondaryTask(Zombie)
                    ClearPedTasksImmediately(Zombie)
                    TaskWanderStandard(Zombie, 10.0, 10)
                    SetPedRelationshipGroupHash(Zombie, 'ZOMBIE')
                    ApplyPedDamagePack(Zombie, 'BigHitByVehicle', 0.0, 1.0)
                    SetEntityHealth(Zombie, 200)

                    RequestAnimSet('move_m@drunk@verydrunk')
                    while not HasAnimSetLoaded('move_m@drunk@verydrunk') do
                        Wait(0)
                    end
                    SetPedMovementClipset(Zombie, 'move_m@drunk@verydrunk', 1.0)

                    SetPedConfigFlag(Zombie, 100, false)
                    DecorSetBool(Zombie, 'RegisterZombie', true)
                end

                SetPedRagdollBlockingFlags(Zombie, 1)
                SetPedCanRagdollFromPlayerImpact(Zombie, false)
                SetPedSuffersCriticalHits(Zombie, true)
                SetPedEnableWeaponBlocking(Zombie, true)
                DisablePedPainAudio(Zombie, true)
                StopPedSpeaking(Zombie, true)
                SetPedDiesWhenInjured(Zombie, false)
                StopPedRingtone(Zombie)
                SetPedMute(Zombie)
                SetPedIsDrunk(Zombie, true)
                SetPedConfigFlag(Zombie, 166, false)
                SetPedConfigFlag(Zombie, 170, false)
                SetBlockingOfNonTemporaryEvents(Zombie, true)
                SetPedCanEvasiveDive(Zombie, false)
                RemoveAllPedWeapons(Zombie, true)

                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local PedCoords = GetEntityCoords(Zombie)
                local Distance = #(PedCoords - PlayerCoords)
                local DistanceTarget = IsPlayerShooting() and 120.0 or IsPlayerRunning() and 50.0 or 20.0

                if Distance <= DistanceTarget and not IsPedInAnyVehicle(PlayerPedId(), false) and not DecorExistOn(Zombie, 'HordeMember') then
                    TaskGoToEntity(Zombie, PlayerPedId(), -1, 0.0, 1.5, 1073741824, 0)
                end

                if Distance <= 1.3 then
                    if not IsPedRagdoll(Zombie) and not IsPedGettingUp(Zombie) then
                        local health = GetEntityHealth(PlayerPedId())
                        if health == 0 then
                            ClearPedTasks(Zombie)
                            TaskWanderStandard(Zombie, 10.0, 10)
                        else
                            RequestAnimSet('melee@unarmed@streamed_core_fps')
                            while not HasAnimSetLoaded('melee@unarmed@streamed_core_fps') do
                                Wait(10)
                            end

                            TaskPlayAnim(Zombie, 'melee@unarmed@streamed_core_fps', 'ground_attack_0_psycho', 8.0, 1.0, -1, 48, 0.001, false, false, false)
                            
                            local baseDamage = DecorExistOn(Zombie, 'ZombieDamage') and DecorGetInt(Zombie, 'ZombieDamage') or 5
                            local damageMultiplier = DecorExistOn(Zombie, 'DamageMultiplier') and DecorGetFloat(Zombie, 'DamageMultiplier') or 1.0
                            local damage = math.floor(baseDamage * damageMultiplier)
                            
                            ApplyDamageToPed(PlayerPedId(), damage, false)
                            local health = GetEntityHealth(PlayerPedId())
                            if health <= 0 then
                                TriggerServerEvent("arena:zombieDeath")
                            end
                            local zombieTypeIndex = DecorExistOn(Zombie, 'ZombieType') and DecorGetInt(Zombie, 'ZombieType') or 0
                            local zombieType = zombieTypeIndex > 0 and EliteZombieModels[zombieTypeIndex].type or nil
                            
                            TriggerServerEvent("hyzan:zombieAttack", zombieType)
                        end
                    end
                end
                
                if not NetworkGetEntityIsNetworked(Zombie) and DoesEntityExist(Zombie) then
                    DeleteEntity(Zombie)
                end
            end
            
            Success, Zombie = FindNextPed(Handler)
        until not (Success)

        EndFindPed(Handler)
    end
end)

local CountedZombies = {}

CreateThread(function()
    while true do
        Wait(1000) -- loop mais leve

        local playerPed = PlayerPedId()
        local allPeds = GetGamePool("CPed")

        for _, ped in ipairs(allPeds) do
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) and DecorExistOn(ped, "RegisterZombie") then
                if IsPedDeadOrDying(ped, true) then
                    if not CountedZombies[ped] then
                        local killer = GetPedSourceOfDeath(ped)
                    
                        if killer and (killer == playerPed or (IsPedAPlayer(killer) and NetworkGetPlayerIndexFromPed(killer) == PlayerId())) then
                            CountedZombies[ped] = true
                            TriggerServerEvent("arena:zombieKilled")
                        end
                    end
                end
            end
        end
    end
end)