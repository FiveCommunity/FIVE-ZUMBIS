-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = "config.json"
local Permissions = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADCRONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function LoadCrons()
    local File = LoadResourceFile(GetCurrentResourceName(),Config)
    if File then
        Permissions = json.decode(File) or {}
    else
        Permissions = {}
        SaveResourceFile(GetCurrentResourceName(),Config,json.encode(Permissions),-1)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODE
-----------------------------------------------------------------------------------------------------------------------------------------
local function Mode(Amount,Level)
    local Indent = string.rep("    ", Level)
    local Next = string.rep("    ", Level + 1)
    
    if type(Amount) == "table" then
        local Parts = {}
        local Array = #Amount > 0
        
        if Array then
            table.insert(Parts, "[\n")
            for i, v in ipairs(Amount) do
                table.insert(Parts, Next)
                table.insert(Parts, Mode(v, Level + 1))
                if i < #Amount then
                    table.insert(Parts, ",")
                end
                table.insert(Parts, "\n")
            end
            table.insert(Parts, Indent .. "]")
        else
            table.insert(Parts, "{\n")
            
            local Keys = {"Mode", "Params", "Passport", "Timer"}
            local First = true
            
            for _, key in ipairs(Keys) do
                if Amount[key] ~= nil then
                    if not First then
                        table.insert(Parts, ",\n")
                    end
                    First = false
                    
                    table.insert(Parts, Next)
                    table.insert(Parts, '"' .. key .. '": ')
                    table.insert(Parts, Mode(Amount[key], Level + 1))
                end
            end
            
            for key, val in pairs(Amount) do
                local Standard = false
                for _, k in ipairs(Keys) do
                    if k == key then
                        Standard = true
                        break
                    end
                end
                
                if not Standard then
                    if not First then
                        table.insert(Parts, ",\n")
                    end
                    First = false
                    
                    table.insert(Parts, Next)
                    table.insert(Parts, '"' .. key .. '": ')
                    table.insert(Parts, Mode(val, Level + 1))
                end
            end
            
            table.insert(Parts, "\n" .. Indent .. "}")
        end
        
        return table.concat(Parts)
    elseif type(Amount) == "string" then
        return '"' .. Amount .. '"'
    else
        return tostring(Amount)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
local function Save()
    if #Permissions == 0 then
        SaveResourceFile(GetCurrentResourceName(),Config,"[]",-1)
    else
        local Mode = Mode(Permissions, 0)
        SaveResourceFile(GetCurrentResourceName(),Config,Mode,-1)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPIRED
-----------------------------------------------------------------------------------------------------------------------------------------
local function Expired()  
    local OsTime = os.time()  
    local Updated = false  

    for i = #Permissions, 1, -1 do  
        local Crons = Permissions[i]  

        if OsTime >= Crons.Timer then  
            if Crons.Mode == "RemovePermission" then  
                vRP.RemovePermission(Crons.Passport, Crons.Params.Permission)  
            elseif Crons.Mode == "WipePermission" then
                vRP.RemSrvData("Permissions:"..Crons.Params.Permission)
            end  

            table.remove(Permissions, i)  
            Updated = true  
        end  
    end  

    if Updated then  
        Save()  
    end  
end  
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Check",function(Passport,Permission)    
    for _, Crons in ipairs(Permissions) do
        if Crons.Mode == "RemovePermission" or "WipePermission" and Crons.Passport == Passport and Crons.Params.Permission == Permission then
            return Crons
        end
    end
    
    return false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWAP
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Swap",function(Ancient,New)
    local Updated = false
    
    for _, Crons in ipairs(Permissions) do
        if Crons.Passport == Ancient then
            Crons.Passport = New
            Updated = true
        end
    end
    
    if Updated then
        Save()
    end
    
    return true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERT
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Insert", function(Passport, Mode, Duration, Params)
    local OsTime = os.time()
    local Expiration = OsTime + Duration
    local Updated = false

    for i, Cron in ipairs(Permissions) do
        if Cron.Passport == Passport and 
           Cron.Mode == Mode and 
           Cron.Params.Permission == Params.Permission then
            
            Permissions[i].Timer = Cron.Timer + Duration
            Updated = true
            break
        end
    end

    if not Updated then
        table.insert(Permissions, { Mode = Mode, Params = Params, Passport = Passport, Timer = Expiration })
    end

    Save()
    return true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Remove",function(Passport,Mode,Permission)
    local Updated = false

    for i = #Permissions, 1, -1 do
        local Cron = Permissions[i]
        
        local matchPassport = tostring(Cron.Passport) == tostring(Passport)
        local matchMode = Cron.Mode == Mode
        local matchPermission = not Permission or (Cron.Params and Cron.Params.Permission == Permission)
        
        if matchPassport and matchMode and matchPermission then
            table.remove(Permissions, i)
            Updated = true
        end
    end

    if Updated then
        Save()
        return true
    end
    
    return false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    LoadCrons()
    
    while true do
        Expired()
        Wait(60000)
    end
end)