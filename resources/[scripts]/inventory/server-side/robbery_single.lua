-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = {
	Ammunation = {
		Last = 1,
		Police = 6,
		Timer = 300,
		Wanted = 1800,
		Delay = 3600,
		Active = false,
		Cooldown = os.time(),
		Name = "Loja de Armamentos",
		Residual = "Resquício de Línter",
		Payment = {
			Multiplier = { Min = 1, Max = 1 },
			List = {
				{ Item = "zcoin", Chance = 100, Min = 50000, Max = 75000 }
			}
		},
		Need = {
			Amount = 1,
			Consume = true,
			Item = "lockpick"
		},
		Animation = {
			Dict = "mini@safe_cracking",
			Name = "dial_turn_anti_fast_1"
		}
	},
	Department = {
		Last = 1,
		Police = 8,
		Timer = 300,
		Wanted = 1800,
		Delay = 3600,
		Active = false,
		Cooldown = os.time(),
		Name = "Loja de Departamento",
		Residual = "Resquício de Línter",
		Payment = {
			Multiplier = { Min = 1, Max = 1 },
			List = {
				{ Item = "zcoin", Chance = 100, Min = 75000, Max = 100000 }
			}
		},
		Need = {
			Amount = 1,
			Consume = true,
			Item = "lockpick"
		},
		Animation = {
			Dict = "mini@safe_cracking",
			Name = "dial_turn_anti_fast_1"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ROBBERYSINGLEACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:RobberySingleActive",function(Mode)
	if Config[Mode] and Config[Mode].Active then
		Config[Mode].Active = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ROBBERYSINGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:RobberySingle")
AddEventHandler("inventory:RobberySingle",function(Number,Mode)
	local source = source
	local Required = false
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and Config[Mode] and not Config[Mode].Active then
		if Config[Mode].Police and vRP.AmountService("Policia") < Config[Mode].Police then
			TriggerClientEvent("Notify",source,"Atenção","Contingente indisponível.","amarelo",5000)
			return false
		end

		if Config[Mode].Need then
			Required = vRP.ConsultItem(Passport,Config[Mode].Need.Item,Config[Mode].Need.Amount)

			if not Required then
				TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>"..Config[Mode].Need.Amount.."x "..ItemName(Config[Mode].Need.Item).."</b>.","amarelo",5000)
				return false
			end
		end

		if Config[Mode].Cooldown <= os.time() then
			RobberyActive[Passport] = Mode
			Config[Mode].Active = Passport
			Player(source).state.Buttons = true
			Active[Passport] = os.time() + Config[Mode].Timer
			TriggerClientEvent("player:Residual",source,Config[Mode].Residual)
			TriggerClientEvent("Progress",source,"Roubando",Config[Mode].Timer * 1000)

			if Config[Mode].Animation then
				vRPC.playAnim(source,false,{ Config[Mode].Animation.Dict,Config[Mode].Animation.Name },true)
			end

			exports["vrp"]:CallPolice({
				Source = source,
				Passport = Passport,
				Permission = "Policia",
				Name = Config[Mode].Name,
				Percentage = Config[Mode].Percentage,
				Wanted = Config[Mode].Wanted,
				Code = 31,
				Color = 22
			})

			CreateThread(function()
				while Active[Passport] and os.time() < Active[Passport] do
					Wait(100)
				end

				if Active[Passport] then
					vRPC.Destroy(source)
					Active[Passport] = nil
					Player(source).state.Buttons = false

					if Config[Mode].Active == Passport and Config[Mode].Cooldown <= os.time() and (not Config[Mode].Need or Required and vRP.ConsultItem(Passport,Required.Item,Config[Mode].Need.Amount) and (not Config[Mode].Need.Consume or (Config[Mode].Need.Consume and vRP.TakeItem(Passport,Required.Item,Config[Mode].Need.Amount)))) then
						Config[Mode].Last = Number
						Config[Mode].Active = false
						Config[Mode].Cooldown = os.time() + Config[Mode].Delay
						vRP.MountContainer(Passport,Mode..":"..Number,Config[Mode].Payment.List,math.random(Config[Mode].Payment.Multiplier.Min,Config[Mode].Payment.Multiplier.Max))
						TriggerClientEvent("chest:Open",source,Mode..":"..Number,"Custom",false,true)
					end
				end
			end)
		else
			if Config[Mode].Last == Number then
				TriggerClientEvent("chest:Open",source,Mode..":"..Number,"Custom",false,true)
			else
				TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(Config[Mode].Cooldown - os.time())..".","amarelo",5000)
			end
		end
	end
end)