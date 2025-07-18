-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = {
	Register = {
		Timer = 15,
		Wanted = 60,
		Delay = 3600,
		Cooldown = {},
		Percentage = 750,
		Name = "Roubo a Registradora",
		Residual = "Resquício de Línter",
		Payment = {
			Multiplier = { Min = 1, Max = 1 },
			List = {
				{ Item = "zcoin", Chance = 100, Min = 325, Max = 375 }
			}
		},
		Animation = {
			Dict = "oddjobs@shop_robbery@rob_till",
			Name = "loop"
		}
	},
	Container = {
		Timer = 30,
		Wanted = 120,
		Delay = 3600,
		Cooldown = {},
		Percentage = 750,
		Name = "Roubo a Container",
		Residual = "Resquício de Línter",
		Payment = {
			Multiplier = { Min = 2, Max = 3 },
			List = {
				{ Item = "weedclone", Chance = 5, Min = 1, Max = 1 },
				{ Item = "cokeclone", Chance = 5, Min = 1, Max = 1 },
				{ Item = "adrenaline", Chance = 7, Min = 1, Max = 1 },
				{ Item = "pistolbody", Chance = 15, Min = 1, Max = 1 },
				{ Item = "smgbody", Chance = 10, Min = 1, Max = 1 },
				{ Item = "riflebody", Chance = 5, Min = 1, Max = 1 },
				{ Item = "dismantle", Chance = 35, Min = 1, Max = 1 },
				{ Item = "ration", Chance = 80, Min = 1, Max = 2 },
				{ Item = "gunpowder", Chance = 100, Min = 3, Max = 5 },
				{ Item = "platinum", Chance = 35, Min = 50, Max = 75 },
				{ Item = "treasurebox", Chance = 3, Min = 1, Max = 1 },
				{ Item = "boilies", Chance = 100, Min = 4, Max = 6 },
				{ Item = "binoculars", Chance = 75, Min = 1, Max = 1 },
				{ Item = "camera", Chance = 75, Min = 1, Max = 1 },
				{ Item = "repairkit01", Chance = 25, Min = 1, Max = 1 },
				{ Item = "races", Chance = 100, Min = 1, Max = 1 },
				{ Item = "postit", Chance = 100, Min = 2, Max = 5 },
				{ Item = "techtrash", Chance = 50, Min = 1, Max = 3 },
				{ Item = "tarp", Chance = 50, Min = 1, Max = 3 },
				{ Item = "sheetmetal", Chance = 50, Min = 1, Max = 3 },
				{ Item = "roadsigns", Chance = 50, Min = 1, Max = 3 },
				{ Item = "explosives", Chance = 50, Min = 1, Max = 3 },
				{ Item = "sulfuric", Chance = 50, Min = 1, Max = 3 },
				{ Item = "saline", Chance = 50, Min = 1, Max = 3 },
				{ Item = "alcohol", Chance = 50, Min = 1, Max = 3 },
				{ Item = "radio", Chance = 45, Min = 1, Max = 1 },
				{ Item = "bandage", Chance = 80, Min = 1, Max = 2 },
				{ Item = "medkit", Chance = 25, Min = 1, Max = 1 },
				{ Item = "pouch", Chance = 75, Min = 2, Max = 4 },
				{ Item = "woodlog", Chance = 75, Min = 2, Max = 4 },
				{ Item = "fishingrod", Chance = 35, Min = 1, Max = 1 },
				{ Item = "pickaxe", Chance = 25, Min = 1, Max = 1 },
				{ Item = "joint", Chance = 100, Min = 1, Max = 2 },
				{ Item = "cocaine", Chance = 100, Min = 1, Max = 2 },
				{ Item = "meth", Chance = 100, Min = 1, Max = 2 },
				{ Item = "crack", Chance = 60, Min = 1, Max = 1 },
				{ Item = "heroin", Chance = 60, Min = 1, Max = 1 },
				{ Item = "metadone", Chance = 60, Min = 1, Max = 1 },
				{ Item = "codeine", Chance = 60, Min = 1, Max = 1 },
				{ Item = "amphetamine", Chance = 60, Min = 1, Max = 1 },
				{ Item = "acetone", Chance = 50, Min = 1, Max = 3 },
				{ Item = "plate", Chance = 75, Min = 1, Max = 1 },
				{ Item = "circuit", Chance = 15, Min = 1, Max = 1 },
				{ Item = "lockpick", Chance = 45, Min = 1, Max = 1 },
				{ Item = "toolbox", Chance = 35, Min = 1, Max = 1 },
				{ Item = "tyres", Chance = 55, Min = 1, Max = 2 },
				{ Item = "cellphone", Chance = 65, Min = 1, Max = 1 },
				{ Item = "handcuff", Chance = 15, Min = 1, Max = 1 },
				{ Item = "rope", Chance = 45, Min = 1, Max = 1 },
				{ Item = "hood", Chance = 15, Min = 1, Max = 1 },
				{ Item = "plastic", Chance = 100, Min = 6, Max = 10 },
				{ Item = "glass", Chance = 100, Min = 6, Max = 10 },
				{ Item = "rubber", Chance = 100, Min = 6, Max = 10 },
				{ Item = "aluminum", Chance = 75, Min = 3, Max = 5 },
				{ Item = "copper", Chance = 75, Min = 3, Max = 5 },
				{ Item = "ritmoneury", Chance = 75, Min = 1, Max = 1 },
				{ Item = "sinkalmy", Chance = 45, Min = 1, Max = 1 },
				{ Item = "cigarette", Chance = 100, Min = 2, Max = 5 },
				{ Item = "lighter", Chance = 60, Min = 1, Max = 1 },
				{ Item = "vape", Chance = 20, Min = 1, Max = 1 },
				{ Item = "zcoin", Chance = 100, Min = 275, Max = 375 },
				{ Item = "pager", Chance = 10, Min = 1, Max = 1 },
				{ Item = "analgesic", Chance = 100, Min = 2, Max = 3 },
				{ Item = "gauze", Chance = 100, Min = 2, Max = 4 },
				{ Item = "soap", Chance = 50, Min = 1, Max = 1 },
				{ Item = "alliance", Chance = 50, Min = 1, Max = 1 },
				{ Item = "WEAPON_PISTOL_AMMO", Chance = 10, Min = 25, Max = 50 },
				{ Item = "blueprint_WEAPON_SNSPISTOL", Chance = 2, Min = 1, Max = 1 },
				{ Item = "scotchtape", Chance = 25, Min = 1, Max = 1 },
				{ Item = "insulatingtape", Chance = 25, Min = 1, Max = 1 },
				{ Item = "rammemory", Chance = 12, Min = 1, Max = 1 },
				{ Item = "powersupply", Chance = 35, Min = 1, Max = 1 },
				{ Item = "processorfan", Chance = 10, Min = 1, Max = 1 },
				{ Item = "processor", Chance = 5, Min = 1, Max = 1 },
				{ Item = "screws", Chance = 30, Min = 1, Max = 1 },
				{ Item = "screwnuts", Chance = 30, Min = 1, Max = 1 },
				{ Item = "videocard", Chance = 2, Min = 1, Max = 1 },
				{ Item = "ssddrive", Chance = 15, Min = 1, Max = 1 },
				{ Item = "safependrive", Chance = 5, Min = 1, Max = 1 },
				{ Item = "powercable", Chance = 35, Min = 1, Max = 1 },
				{ Item = "weaponparts", Chance = 10, Min = 1, Max = 1 },
				{ Item = "electroniccomponents", Chance = 30, Min = 1, Max = 1 },
				{ Item = "batteryaa", Chance = 50, Min = 1, Max = 1 },
				{ Item = "batteryaaplus", Chance = 40, Min = 1, Max = 1 },
				{ Item = "goldnecklace", Chance = 15, Min = 1, Max = 1 },
				{ Item = "silverchain", Chance = 25, Min = 1, Max = 1 },
				{ Item = "horsefigurine", Chance = 2, Min = 1, Max = 1 },
				{ Item = "toothpaste", Chance = 35, Min = 1, Max = 1 }
			}
		},
		Animation = {
			Dict = "oddjobs@shop_robbery@rob_till",
			Name = "loop"
		}
	},
	Eletronic = {
		Police = 5,
		Timer = 30,
		Wanted = 600,
		Delay = 300,
		Cooldown = {},
		Percentage = 750,
		Name = "Caixa Eletrônico",
		Residual = "Resquício de Línter",
		Need = {
			Amount = 1,
			Consume = true,
			Item = "c4"
		},
		Payment = { Min = 1000, Max = 1500 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ROBBERYMULTIPLIER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:RobberyMultiplier")
AddEventHandler("inventory:RobberyMultiplier",function(Number,Mode)
	local Required,Mode = nil,Mode
	local source,Number = source,Number
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and Config[Mode] then
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

		if not Config[Mode].Cooldown[Number] or os.time() > Config[Mode].Cooldown[Number] then
			Player(source).state.Buttons = true
			Active[Passport] = os.time() + Config[Mode].Timer
			Config[Mode].Cooldown[Number] = os.time() + Config[Mode].Delay
			TriggerClientEvent("player:Residual",source,Config[Mode].Residual)
			TriggerClientEvent("Progress",source,"Roubando",Config[Mode].Timer * 1000)

			if Config[Mode].Animation then
				vRPC.playAnim(source,false,{Config[Mode].Animation.Dict,Config[Mode].Animation.Name},true)
			elseif Mode == "Eletronic" then
				vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

				SetTimeout(5000,function()
					vRPC.Destroy(source)
				end)
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

					if not Config[Mode].Need or (Config[Mode].Need and Required and (not Config[Mode].Need.Consume or (Config[Mode].Need.Consume and vRP.TakeItem(Passport,Required.Item,Config[Mode].Need.Amount)))) then
						if Mode == "Eletronic" then
							local Valuation = math.random(Config[Mode].Payment.Min,Config[Mode].Payment.Max)

							if exports["party"]:DoesExist(Passport,2) then
								Valuation = Valuation + (Valuation * 0.1)
							end

							if exports["inventory"]:Buffs("Dexterity",Passport) then
								Valuation = Valuation + (Valuation * 0.1)
							end

							for Permission,Multiplier in pairs({ Ouro = 0.1, Prata = 0.075, Bronze = 0.05 }) do
								if vRP.HasService(Passport,Permission) then
									Valuation = Valuation + (Valuation * Multiplier)
								end
							end

							TriggerClientEvent("inventory:Explosion",source,Multiplier[Number].Coords)
							exports["inventory"]:Drops(Passport,source,"zcoin",Valuation,false,Multiplier[Number].Coords)
						else
							vRP.MountContainer(Passport,Mode..":"..Number,Config[Mode].Payment.List,math.random(Config[Mode].Payment.Multiplier.Min,Config[Mode].Payment.Multiplier.Max))
							TriggerClientEvent("chest:Open",source,Mode..":"..Number,"Custom",false,true)
						end
					end
				end
			end)
		else
			local TimeRemaining = Config[Mode].Cooldown[Number] - os.time()
			if Mode ~= "Eletronic" and TimeRemaining >= (Config[Mode].Delay - 300) then
				TriggerClientEvent("chest:Open",source,Mode..":"..Number,"Custom",false,true)
			else
				TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(TimeRemaining)..".","amarelo",5000)
			end
		end
	end
end)