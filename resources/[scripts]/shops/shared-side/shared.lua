-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
ItemList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTARTSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Shop,v in pairs(List) do
		if not ItemList[Shop] then
			ItemList[Shop] = {}
		end

		for Item,Value in pairs(v["List"]) do
			local Number = #ItemList[Shop] + 1

			ItemList[Shop][Number] = {
				["name"] = ItemName(Item),
				["weight"] = ItemWeight(Item),
				["index"] = ItemIndex(Item),
				["rarity"] = ItemRarity(Item),
				["economy"] = ItemEconomy(Item),
				["desc"] = ItemDescription(Item),
				["key"] = Item,
				["price"] = Value
			}
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
Location = {
	{
		["Coords"] = vec3(-409.17,1156.03,326.2),
		["Mode"] = "Departament",
	},{
		["Coords"] = vec3(-1816.64,-1193.73,14.31),
		["Mode"] = "Fishing"
	},{
		["Coords"] = vec3(-1593.08,5202.9,4.31),
		["Mode"] = "Hunting"
	},{
		["Coords"] = vec3(-679.14,5834.37,17.32),
		["Mode"] = "Hunting2"
	},{
		["Coords"] = vec3(-297.68,1442.2,338.98),
		["Mode"] = "Miners"
	},{
		["Coords"] = vec3(-423.21,1073.93,327.7),
		["Mode"] = "Clandestine"
	},{
		["Coords"] = vec3(-425.76,1207.74,326.13),
		["Mode"] = "Ammunation"
	},{
		["Coords"] = vec3(-377.12,1215.47,326.12),
		["Mode"] = "Acougueiro"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
List = {
	["Acougueiro"] = {
		["Mode"] = "Sell",
		["Type"] = "Cash",
		["List"] = {
			["foodrottingflesh"] = 35
		}
	},
	["Ammunation"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["WEAPON_HATCHET"] = 975,
			["WEAPON_BAT"] = 975,
			["WEAPON_BATTLEAXE"] = 975,
			["WEAPON_CROWBAR"] = 975,
			["WEAPON_SWITCHBLADE"] = 975,
			["WEAPON_GOLFCLUB"] = 975,
			["WEAPON_HAMMER"] = 975,
			["WEAPON_MACHETE"] = 975,
			["WEAPON_POOLCUE"] = 975,
			["WEAPON_STONE_HATCHET"] = 975,
			["WEAPON_WRENCH"] = 975,
			["WEAPON_KNUCKLE"] = 975,
			["WEAPON_FLASHLIGHT"] = 975
		}
	},
	["Departament"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["canPasta"] = 125,
			["canSoup"] = 125,
			["WEAPON_SWITCHBLADE"] = 1535,
			["water"] = 35,
			["cigarette"] = 15,
			["lighter"] = 225,
			["emptybottle"] = 15,
			["boilies"] = 5,
			["rope"] = 925,
			["scuba"] = 975,
			["GADGET_PARACHUTE"] = 225,
			["axe"] = 1225,
			["pickaxe"] = 1225,
			["fishingrod"] = 1225,
			["emptypurifiedwater"] = 1275
		}
	},
	["Megamall"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["radio"] = 975,
			["boilies"] = 5,
			["rope"] = 925,
			["scuba"] = 975,
			["notepad"] = 10,
			["suitcase"] = 275,
			["WEAPON_BRICK"] = 25,
			["WEAPON_SHOES"] = 25,
			["alliance"] = 525,
			["GADGET_PARACHUTE"] = 225,
			["axe"] = 1225,
			["pickaxe"] = 1225,
			["fishingrod"] = 1225,
			["emptypurifiedwater"] = 1275
		}
	},
	["Eletronics"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["radio"] = 975,
			["vape"] = 4750,
			["cellphone"] = 725,
			["camera"] = 425,
			["binoculars"] = 425
		}
	},
	["Clandestine"] = {
		["Mode"] = "Sell",
		["Type"] = "Consume",
		["Item"] = "zcoin",
		["List"] = {
			["scotchtape"] = 45,
			["insulatingtape"] = 55,
			["rammemory"] = 375,
			["powersupply"] = 475,
			["processorfan"] = 325,
			["processor"] = 725,
			["screws"] = 45,
			["screwnuts"] = 45,
			["videocard"] = 4225,
			["ssddrive"] = 525,
			["safependrive"] = 3225,
			["powercable"] = 225,
			["weaponparts"] = 125,
			["electroniccomponents"] = 375,
			["batteryaa"] = 225,
			["batteryaaplus"] = 275,
			["goldnecklace"] = 625,
			["silverchain"] = 425,
			["horsefigurine"] = 2425,
			["toothpaste"] = 175,
			["techtrash"] = 95,
			["tarp"] = 65,
			["sheetmetal"] = 65,
			["roadsigns"] = 65,
			["explosives"] = 105,
			["sulfuric"] = 75,
			["races"] = 425,
			["pistolbody"] = 275,
			["smgbody"] = 525,
			["riflebody"] = 975,
			["pager"] = 425
		}
	},
	["Coffee"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["coffeecup"] = 20
		}
	},
	["Soda"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["cola"] = 20,
			["soda"] = 20,
			["water"] = 35
		}
	},
	["Donut"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["donut"] = 15,
			["chocolate"] = 20
		}
	},
	["Hamburger"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["hamburger"] = 25
		}
	},
	["Hotdog"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["hotdog"] = 20
		}
	},
	["Chihuahua"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["hotdog"] = 20,
			["hamburger"] = 25,
			["cola"] = 20,
			["soda"] = 20,
			["water"] = 35
		}
	},
	["Water"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["water"] = 35
		}
	},
	["Cigarette"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["cigarette"] = 15,
			["lighter"] = 225
		}
	},
	["Fuel"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["WEAPON_PETROLCAN"] = 325
		}
	},
	["Paramedico"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["Permission"] = "Paramedico",
		["List"] = {
			["syringe01"] = 45,
			["syringe02"] = 45,
			["syringe03"] = 45,
			["syringe04"] = 45,
			["bandage"] = 115,
			["gauze"] = 75,
			["gdtkit"] = 25,
			["medkit"] = 285,
			["sinkalmy"] = 185,
			["analgesic"] = 65,
			["ritmoneury"] = 235,
			["medicbag"] = 725,
			["adrenaline"] = 3225
		}
	},
	["Hunting"] = {
		["Mode"] = "Sell",
		["Type"] = "Cash",
		["List"] = {
			["boar1star"] = 275,
			["boar2star"] = 300,
			["boar3star"] = 325,
			["deer1star"] = 275,
			["deer2star"] = 300,
			["deer3star"] = 325,
			["coyote1star"] = 275,
			["coyote2star"] = 300,
			["coyote3star"] = 325,
			["mtlion1star"] = 275,
			["mtlion2star"] = 300,
			["mtlion3star"] = 325
		}
	},
	["Hunting2"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["List"] = {
			["ration"] = 125,
			["WEAPON_MUSKET"] = 4225,
			["WEAPON_MUSKET_AMMO"] = 10
		}
	},
	["Fishing"] = {
		["Mode"] = "Sell",
		["Type"] = "Cash",
		["List"] = {
			["sardine"] = 65,
			["smalltrout"] = 65,
			["orangeroughy"] = 65,
			["anchovy"] = 70,
			["catfish"] = 70,
			["herring"] = 75,
			["yellowperch"] = 75,
			["salmon"] = 125,
			["smallshark"] = 250
		}
	},
	["Miners"] = {
		["Mode"] = "Sell",
		["Type"] = "Cash",
		["List"] = {
			["tin_pure"] = 40,
			["lead_pure"] = 40,
			["copper_pure"] = 42,
			["iron_pure"] = 45,
			["gold_pure"] = 50,
			["diamond_pure"] = 50,
			["ruby_pure"] = 60,
			["sapphire_pure"] = 60,
			["emerald_pure"] = 75
		}
	},
	["Policia"] = {
		["Mode"] = "Buy",
		["Type"] = "Cash",
		["Permission"] = "Policia",
		["List"] = {
			["gsrkit"] = 25,
			["gdtkit"] = 25,
			["barrier"] = 25,
			["handcuff"] = 125,
			["spikestrips"] = 275
		}
	}
}