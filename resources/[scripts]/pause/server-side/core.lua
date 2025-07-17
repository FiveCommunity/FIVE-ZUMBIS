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
Tunnel.bindInterface("pause", Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Shop = {}
local Shopping = {}
local Battlepass = { Premium = {}, Free = {} }
-----------------------------------------------------------------------------------------------------------------------------------------
-- COUNTSHOPPING
-----------------------------------------------------------------------------------------------------------------------------------------
local function CountShopping()
    local History = {}
    table.sort(Shopping, function(a, b)
        return a.Timer > b.Timer
    end)
    for i = 1, math.min(#Shopping, 9) do
        local v = Shopping[i]
        History[#History + 1] = {
            Amount = v.Amount,
            Image = v.Image,
            Name = v.Name,
        }
    end

    return History
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    for k, v in pairs(ShopItens) do
        Shop[#Shop + 1] = { Index = k, Description = ItemDescription(k), Image = ItemIndex(k), Name = ItemName(k), Price = v.Price, Discount = v.Discount, Category = v.Category }
    end
    for Index,Value in pairs(RoleItens["Premium"]) do
        Battlepass["Premium"][Index] = { ["id"] = Index, ["Name"] = ItemName(Value["Item"]), ["Index"] = Value["Item"], ["Amount"] = Value["Amount"], ["Image"] = ItemIndex(Value["Item"]), ["Description"] = ItemDescription(Value["Item"]) }
    end
    for Index,Value in pairs(RoleItens["Free"]) do
        Battlepass["Free"][Index] = { ["id"] = Index, ["Name"] = ItemName(Value["Item"]), ["Index"] = Value["Item"], ["Amount"] = Value["Amount"], ["Image"] = ItemIndex(Value["Item"]), ["Description"] = ItemDescription(Value["Item"]) }
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Disconnect()
    local source = source
    local Passport = vRP.Passport(source)
    
    if Passport then
        vRP.Kick(source, "Volte mais tarde!")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Config()
    return { TableLevel(), {1,2}, Premium, Propertys, { Shop, true }, { BATTLEPASS_POINTS, BATTLEPASS_PRICE, BATTLEPASS_START - os.time(), Battlepass.Free, Battlepass.Premium }, Boxes, MarketplaceTax, #Daily }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Propertys()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Data = {}
        for k, v in ipairs(Propertys) do
            local Check = exports["crons"]:Check(Passport,v.Permission)
            local _,Count = vRP.DataGroups(v.Permission)
            if Count == 0 then
                Data[k] = false
            end
            if Count > 0 then
                if not vRP.HasPermission(Passport,v.Permission) then
                    Data[k] = true
                else
                    Data[k] = Check.Timer - os.time()
                end
            end
        end
        return Data
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PropertyBuy(Index)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Property = Propertys[Index]
        if Property then
            local Price = Property.Price
            if vRP.PaymentGems(Passport,Price) then
                exports["crons"]:Insert(Passport,"WipePermission",Property.Duration,{ Permission = Property.Permission })
                vRP.SetPermission(Passport,Property.Permission)
                TriggerClientEvent("Notify",source,"Sucesso","Propriedade comprada com sucesso.","verde",5000)
                return true
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Premium()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Data = {}
        for k, v in ipairs(Premium) do
            local Check = exports["crons"]:Check(Passport,v.Permission)
            if vRP.HasPermission(Passport, v.Permission) and Check then
                Data[k] = Check.Timer - os.time()
            else
                Data[k] = false
            end
        end
        return Data
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PremiumBuy(Index, Select)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Item = Premium[Index]
        if Item then
            local Price = Item.Price
            if vRP.PaymentGems(Passport, Price) then
                exports["crons"]:Insert(Passport,"RemovePermission",Item.Duration,{ Permission = Item.Permission })
                vRP.SetPermission(Passport, Item.Permission)
                TriggerClientEvent("Notify", source, "Sucesso", "Premium comprado com sucesso.", "verde", 5000)

                if Item.Selectables then
                    for Number, v in ipairs(Item.Selectables) do
                        local Option
                        
                        for _, Index in ipairs(v.Options) do
                            if Index.Index == Select[Number] then
                                Option = Index
                                break
                            end
                        end
                        if Option then
                            vRP.Query("vehicles/addVehicles", { Passport = Passport, Vehicle = Option.Index, Plate = vRP.GeneratePlate(), Weight = VehicleWeight(Option.Index), Work = 0 })
                        end
                    end
                end

                return true
            end
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Home()
	local source = source
	local Passport = vRP.Passport(source)

	if Passport then
	    local Identity = vRP.Identity(Passport)

		if Identity then
            local Experiences = {}
            
            for Index, v in pairs(Works) do
                local Experience = vRP.GetExperience(Passport, Index)
                table.insert(Experiences, { v, Experience })
            end

            local Medic = Identity["Medic"]
            local Days = 0

            if Medic then
                local Hour = os.time()
                local Seconds = Medic - Hour
                Days = (Seconds > 0) and math.ceil(Seconds / 86400) or 0
            end
            
            return {
                {
                    Name = vRP.FullName(Passport),
                    Blood = Sanguine(Identity.Blood),
                    Passport = Passport,
                    Bank = Identity.Bank,
                    Gemstone = vRP.UserGemstone(Identity.License),
                    Playing = CompleteTimers(os.time() - Identity.Created),
                    Medic = Days,
                },
                Experiences,
                CountShopping(),
            }
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StoreBuy(Item, Amount)
    if ShopItens[Item] then
        local source = source
        local Passport = vRP.Passport(source)
        local Identity = vRP.Identity(Passport)
        local Price = ShopItens[Item].Price * ((100 - ShopItens[Item].Discount) / 100)

        if vRP.PaymentGems(Passport, Amount * Price) then
            Shopping[#Shopping + 1] = {
                Amount = Amount,
                Image = ItemIndex(Item),
                Timer = os.time(),
                Name = Identity.Name,
            }
            TriggerClientEvent("pause:Notify", source, "Sucesso", "Compra concluida.", "verde")
            vRP.GenerateItem(Passport, Item, Amount)
        end

        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Battlepass()
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Data = vRP.Battlepass(Passport)
        return { Data.Free, Data.Premium, Data.Points, Data.Active }
    end

    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASSBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.BattlepassBuy()
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then   
        if vRP.PaymentGems(Passport, BATTLEPASS_PRICE) then
            vRP.BattlepassBuy(Passport)
            TriggerClientEvent("pause:Notify", source, "Compra concluída.", "Verifique o Passe de Batalha.", "verde")
            return true
        else
            TriggerClientEvent("pause:Notify", source, "Gemas insuficientes.", "Verifique suas Gemas.", "vermelho")
            return false
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASSRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.BattlepassRescue(Mode, Number)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then  
        if RoleItens[Mode] then
            if RoleItens[Mode][Number] then
                local Item = RoleItens[Mode][Number]["Item"]
                local ItemAmount = RoleItens[Mode][Number]["Amount"]
                vRP.BattlepassPayment(Passport,BATTLEPASS_POINTS,Mode)
                vRP.GenerateItem(Passport, Item, ItemAmount, false)
                TriggerClientEvent("pause:Notify", source, "Item Recebido.", "Você recebeu <b>" .. ItemAmount .. "x " .. ItemName(Item) .. "</b>.", "verde")
                return true
            end
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENBOX
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OpenBox(Data)
    local Source = source
    local Passport = vRP.Passport(Source)
    if not Passport then return false end

    local BoxData
    for _, Box in pairs(Boxes) do
        if Box.Id == Data then
            BoxData = Box
            break
        end
    end

    if not BoxData then return false end

    local Price = parseInt(BoxData.Price * BoxData.Discount)
    if not vRP.PaymentGems(Passport, Price) then
        TriggerClientEvent("pause:Notify", Source, "Gemas insuficientes", "Você não possui gemas suficientes", "vermelho")
        return false
    end

    local TotalChance = 0
    for _, Reward in pairs(BoxData.Rewards) do
        local AdjustedChance = Reward.Chance

        if Reward.Amount >= 2000 then
            AdjustedChance = math.floor(Reward.Chance * 0.1)
        elseif Reward.Amount >= 1500 then
            AdjustedChance = math.floor(Reward.Chance * 0.2)
        elseif Reward.Amount >= 1250 then
            AdjustedChance = math.floor(Reward.Chance * 0.3)
        elseif Reward.Amount >= 1000 then
            AdjustedChance = math.floor(Reward.Chance * 0.5)
        end

        TotalChance = TotalChance + AdjustedChance
        Reward.AdjustedChance = AdjustedChance
    end

    local Random = math.random(TotalChance)
    local CurrentChance = 0

    for _, Reward in pairs(BoxData.Rewards) do
        CurrentChance = CurrentChance + Reward.AdjustedChance
        if Random <= CurrentChance then
            vRP.GenerateItem(Passport, Reward.Item, Reward.Amount, false)
            Citizen.SetTimeout(6000, function()
                TriggerClientEvent("pause:Notify", Source, "Sucesso", "Você recebeu "..Reward.Amount.."x "..Reward.Name, "verde")
            end)
            return Reward.Id
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Marketplace()
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local List = {}
        local Datatable = vRP.GetSrvData("Marketplace")

        for k, v in pairs(Datatable) do
            local Testing = {
                Index = v.Index,
                Image = v.Key,
                Name = ItemName(v.Item),
                Price = v.Price,
                Amount = v.Quantity,
            }
            if ItemLoads(v.Item) then
                Testing.Charges = ItemLoads(v.Item)
            end
            if ItemDurability(v.Item) then
                Testing.Durability = os.time() - v.Timer
                Testing.Days = ItemDurability(v.Item)
            end
            List[#List + 1] = Testing
        end

        return List
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACEINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MarketplaceInventory(Mode)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Marketplace = {}
        local Inventory = vRP.Inventory(Passport)

        if Mode == "Announce" then
            local Datatable = vRP.GetSrvData("Marketplace")
            local PlayerItems = {}
            for k, v in pairs(Datatable) do
                if tonumber(v["Passport"]) == tonumber(Passport) then
                    local Testing = {
                        Index = k,
                        Image = v.Key,
                        Name = ItemName(v.Item),
                        Price = v.Price,
                        Amount = v.Quantity,
                    }
                    if ItemLoads(v.Item) then
                        Testing.Charges = ItemLoads(v.Item)
                    end
                    if ItemDurability(v.Item) then
                        Testing.Durability = os.time() - v.Timer
                        Testing.Days = ItemDurability(v.Item)
                    end
                    PlayerItems[#PlayerItems + 1] = Testing
                end
            end
            if #PlayerItems > 0 then
                return PlayerItems
            end
        end

        if Mode == "Create" then
            for k, v in pairs(Inventory) do
                if v.item and not vRP.CheckDamaged(v.item) and not BlockMarket(v.item) then
                    local Testing = {
                        Image = ItemIndex(v.item),
                        Name = ItemName(v.item),
                        Item = v.item,
                        Amount = v.amount,
                    }
                    if ItemLoads(v.item) then
                        Testing.Charges = ItemLoads(v.item)
                    end
                    if ItemDurability(v.item) then
                        Testing.Durability = os.time() - SplitTwo(v.item)
                        Testing.Days = ItemDurability(v.item)
                    end
                    Marketplace[#Marketplace + 1] = Testing
                end
            end
        end

        return Marketplace
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACEANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MarketplaceAnnounce(Data)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        if vRP.TakeItem(Passport, Data["Item"], Data["Amount"]) then
            local Datatable = vRP.GetSrvData("Marketplace")

            local Item = Data["Item"]
            local Price = Data["Price"]
            local Amount = Data["Amount"]

            if Price * MarketplaceTax > 1 then
                if vRP.PaymentFull(Passport, Price * MarketplaceTax) then
                    local Data = {
                        Passport = Passport,
                        Name = ItemName(Item),
                        Item = SplitOne(Item),
                        Key = ItemIndex(Item),
                        Price = Price,
                        Quantity = Amount,
                    }
                    if ItemLoads(Item) then
                        Data.Charges = ItemLoads(Item)
                    end
                    if SplitTwo(Item) ~= nil then
                        Data.Timer = SplitTwo(Item)
                    end
                    repeat
                        Selected = GenerateString("DDLLDDLL")
                    until Selected and not Datatable[Selected]
                    Datatable[Selected] = Data
        
                    vRP.SetSrvData("Marketplace", Datatable, true)
                    return true
                end
            else
                local Data = {
                    Passport = Passport,
                    Name = ItemName(Item),
                    Item = SplitOne(Item),
                    Key = ItemIndex(Item),
                    Price = Price,
                    Quantity = Amount,
                }
                if ItemLoads(Item) then
                    Data.Charges = ItemLoads(Item)
                end

                if SplitTwo(Item) ~= nil then
                    Data.Timer = SplitTwo(Item)
                end
                repeat
					Selected = GenerateString("DDLLDDLL")
				until Selected and not Datatable[Selected]
                Datatable[Selected] = Data
    
                vRP.SetSrvData("Marketplace", Datatable, true)
                return true
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACEBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MarketplaceBuy(Index)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Datatable = vRP.GetSrvData("Marketplace")

        if Datatable[Index] then
            if tostring(Datatable[Index]["Passport"]) == tostring(Passport) then
                TriggerClientEvent("pause:Notify", source, "Você não pode comprar seu próprio item.", "Verifique o item antes de comprar.")
                return false
            end
            if vRP.CheckWeight(Passport,Datatable[Index]["Item"]) and not vRP.MaxItens(Passport,Datatable[Index]["Item"]) then
                if vRP.PaymentFull(Passport, Datatable[Index]["Price"]) then
                    vRP.GiveBank(Datatable[Index]["Passport"], Datatable[Index]["Price"])
                    vRP.GiveItem(Passport, Datatable[Index]["Price"], Datatable[Index]["Quantity"])
                    
                    TriggerClientEvent("pause:Notify", source, "Compra realizada com sucesso.", "Verifique seu Inventario", "verde")
                    
                    local Seller = vRP.Source(Datatable[Index]["Passport"])
                    if Seller then
                        TriggerClientEvent("Notify", Seller, "Sucesso", "Seu item foi vendido por $" .. Datatable[Index]["Price"] .. ".", "verde", 5000)
                    end

                    Datatable[Index] = nil
                    vRP.SetSrvData("Marketplace", Datatable, true)

                    return true
                else
                    TriggerClientEvent("pause:Notify", source, "Dinheiro insuficiente.", "Verifique seu banco ou inventario.")
                    return false
                end
            else
                TriggerClientEvent("pause:Notify", source, "Espaço insuficiente.", "Verifique seu espaço no inventario.")
                return false
            end
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACECANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MarketplaceCancel(Index)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Datatable = vRP.GetSrvData("Marketplace")

        if Datatable[Index] then
            if Datatable[Index]["Timer"] then
                vRP.GiveItem(Passport,Datatable[Index]["Item"].."-"..Datatable[Index]["Timer"],Datatable[Index]["Quantity"])
            else
                vRP.GiveItem(Passport,Datatable[Index]["Item"],Datatable[Index]["Quantity"])
            end
            Datatable[Index] = nil

            vRP.SetSrvData("Marketplace", Datatable, true)
            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Ranking(Column, Direction)
    local source = source
    local Passport = vRP.Passport(source)
    
    if Passport then
        local Ranking = {}
        local Consult = vRP.Query("accounts/All", {})
        
        for _, Account in pairs(Consult) do
            local Characters = vRP.Query("characters/Characters", { License = Account.License })
            
            for _, Character in pairs(Characters) do
                local Killed = Character.Killed or 0
                local Death = Character.Death or 0
                local Ratio = (Death > 0 and Killed / Death) or (Killed > 0 and Killed) or 0

                Ranking[#Ranking + 1] = {
                    Name = vRP.FullName(Character.id),
                    Killed = Killed,
                    Death = Death,
                    Ratio = Ratio,
                    Status = vRP.Source(Character.id),
                    Hours = vRP.TimePlaying(Character.id),
                }
            end
        end
        
        return Ranking
    end

    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAILY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Daily()
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Identity = vRP.Identity(Passport)
        local Parts = {}
        for Part in string.gmatch(Identity["Daily"], "([^%-]+)") do
            table.insert(Parts, Part)
        end
        table.remove(Parts)
        return { table.concat(Parts, "-"), tonumber(Identity["Daily"]:match("([^%-]+)$")), #Daily }
    end

    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAILYRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DailyRescue(Day)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Identity = vRP.Identity(Passport)
        local Reward = Identity.Daily:match("([^%-]+)$")
        for Item, Amount in pairs(Daily[Day]) do
            vRP.GenerateItem(Passport, Item, Amount, false)
        end

        TriggerClientEvent("pause:Notify", source, "Sucesso", "Recompensa recebida.", "verde")

        vRP.UpdateDaily(Passport, source, os.date("%d-%m-%Y").."-"..Day)

        return true
    end

    return
end