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

		for Item,v in pairs(v["List"]) do
			local Number = #ItemList[Shop] + 1

			ItemList[Shop][Number] = {
				["name"] = ItemName(Item),
				["weight"] = ItemWeight(Item),
				["index"] = ItemIndex(Item),
				["rarity"] = ItemRarity(Item),
				["economy"] = ItemEconomy(Item),
				["desc"] = ItemDescription(Item),
				["price"] = v["Amount"],
				["required"] = {},
				["key"] = Item
			}

			for Index,Amount in pairs(v["Required"]) do
				local Rarity = ItemRarity(Index)
				ItemList[Shop][Number]["required"][#ItemList[Shop][Number]["required"] + 1] = "<"..Rarity..">"..Dotted(Amount).."x "..ItemName(Index).."</"..Rarity..">"
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
Location = {
	{
		["Coords"] = vec3(-412.07,1050.87,322.51),
		["Mode"] = "Vidrak_bench",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-412.0,1052.21,322.03),
		["Mode"] = "Vidrak",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-443.6,1120.19,326.86),
		["Mode"] = "Lester",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-416.86,1237.33,325.69),
		["Mode"] = "Mecanico",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-396.44,1156.16,326.15),
		["Mode"] = "Pharmacy_bench",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-397.06,1156.27,325.68),
		["Mode"] = "Pharmacy",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-421.98,1100.63,332.35),
		["Mode"] = "pistol_bench",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-426.44,1091.2,332.35),
		["Mode"] = "smg_bench",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-441.21,1102.77,332.36),
		["Mode"] = "rifle_bench",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-377.82,1214.01,325.69),
		["Mode"] = "AprendizadoArmamento",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-291.58,1437.45,338.38),
		["Mode"] = "Furnace",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-480.73,1133.21,320.41),
		["Mode"] = "FoodRestaurante",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-627.69,222.96,82.1),
		["Mode"] = "DrinkRestaurante",
		["Circle"] = 0.5
	},{
		["Coords"] = vec3(-393.83,1131.86,322.44),
		["Mode"] = "FutureWeapons",
		["Circle"] = 0.5
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
List = {
	["Vidrak_bench"] = {
		["List"] = {
			["blueprint_goldenrodTea"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 7800
				}
			},
			["blueprint_redtea"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 7900
				}
			}
		}
	},
	["Vidrak"] = {
		["List"] = {
			["goldenrodTea"] = {
				["Amount"] = 1,
				["Required"] = {
					["solidagoleaf"] = 4,
					["water"] = 1
				}
			},
			["redtea"] = {
				["Amount"] = 1,
				["Required"] = {
					["sangruinaleaf"] = 4,
					["water"] = 1
				}
			}
		}
	},
	["FutureWeapons"] = {
		["List"] = {
			["WEAPON_RAILGUN_AMMO"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["WEAPON_SPECIALCARBINEMK2RAIO"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["WEAPON_RAILGUN"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["WEAPON_RAILGUN_AMMO"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["WEAPON_MINIGUN"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["WEAPON_EMPLAUNCHER"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			}
		}
	},
	["AprendizadoArmamento"] = {
		["List"] = {
			["blueprint_WEAPON_ADVANCEDRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_WEAPON_COMPACTRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_ATTACH_GRIP"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 8625
				}
			},
			["blueprint_WEAPON_SAWNOFFSHOTGUN"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_WEAPON_MICROSMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_WEAPON_HEAVYRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_ASSAULTRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_WEAPON_MUSKET"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 16125
				}
			},
			["blueprint_WEAPON_BULLPUPRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_ATTACH_MAGAZINE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 11125
				}
			},
			["blueprint_WEAPON_ASSAULTRIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_HEAVYPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 12000
				}
			},
			["blueprint_WEAPON_CARBINERIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_ATTACH_FLASHLIGHT"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 10625
				}
			},
			["blueprint_WEAPON_PISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 28625
				}
			},
			["blueprint_WEAPON_SNSPISTOL_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 26125
				}
			},
			["blueprint_ATTACH_SILENCER"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 23625
				}
			},
			["blueprint_WEAPON_SPECIALCARBINE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_PISTOL50"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 41125
				}
			},
			["blueprint_WEAPON_MINISMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_WEAPON_TACTICALRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_SNSPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 23625
				}
			},
			["blueprint_WEAPON_GUSENBERG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 76125
				}
			},
			["blueprint_WEAPON_ASSAULTSMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 76125
				}
			},
			["blueprint_WEAPON_SMG_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 76125
				}
			},
			["blueprint_WEAPON_SMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 63625
				}
			},
			["blueprint_WEAPON_PUMPSHOTGUN_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 76375
				}
			},
			["blueprint_WEAPON_PUMPSHOTGUN"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_WEAPON_SPECIALCARBINE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_WEAPON_BULLPUPRIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_CARBINERIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_ATTACH_CROSSHAIR"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 13625
				}
			},
			["blueprint_WEAPON_MACHINEPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 41125
				}
			},
			["blueprint_WEAPON_APPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 31125
				}
			},
			["blueprint_WEAPON_PISTOL_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 31125
				}
			},
			["blueprint_WEAPON_SMOKEGRENADE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 6125
				}
			},
			["blueprint_WEAPON_MOLOTOV"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 6125
				}
			},
			["blueprint_WEAPON_COMBATPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 31125
				}
			},
			["blueprint_WEAPON_VINTAGEPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 23625
				}
			}
		}
	},
	["FoodRestaurante"] = {
--		["Permission"] = "Restaurante",
		["List"] = {
			["nigirizushi"] = {
				["Amount"] = 3,
				["Required"] = {
					["fishfillet"] = 3,
					["ricebag"] = 1
				}
			},
			["sushi"] = {
				["Amount"] = 2,
				["Required"] = {
					["fishfillet"] = 2,
					["sugarbox"] = 1
				}
			},
			["cupcake"] = {
				["Amount"] = 3,
				["Required"] = {
					["milkbottle"] = 1,
					["chocolate"] = 1,
					["sugarbox"] = 1
				}
			},
			["applelove"] = {
				["Amount"] = 2,
				["Required"] = {
					["sugarbox"] = 1,
					["apple"] = 1
				}
			},
			["cookies"] = {
				["Amount"] = 3,
				["Required"] = {
					["milkbottle"] = 1,
					["chocolate"] = 1,
					["sugarbox"] = 1
				}
			},
			["hamburger2"] = {
				["Amount"] = 1,
				["Required"] = {
					["meatfillet"] = 1,
					["mayonnaise"] = 1,
					["ryebread"] = 1
				}
			},
			["hamburger3"] = {
				["Amount"] = 1,
				["Required"] = {
					["meatfillet"] = 1,
					["mayonnaise"] = 1,
					["ryebread"] = 1
				}
			},
			["pizzamozzarella"] = {
				["Amount"] = 1,
				["Required"] = {
					["milkbottle"] = 1,
					["ryebread"] = 1,
					["water"] = 1,
					["tomato"] = 1
				}
			},
			["pizzabanana"] = {
				["Amount"] = 1,
				["Required"] = {
					["milkbottle"] = 1,
					["ryebread"] = 1,
					["water"] = 1,
					["banana"] = 1
				}
			},
			["pizzachocolate"] = {
				["Amount"] = 1,
				["Required"] = {
					["milkbottle"] = 1,
					["ryebread"] = 1,
					["water"] = 1,
					["chocolate"] = 1
				}
			},
			["milkshake"] = {
				["Amount"] = 1,
				["Required"] = {
					["milkbottle"] = 1,
					["strawberry"] = 1
				}
			},
			["cappuccino"] = {
				["Amount"] = 1,
				["Required"] = {
					["milkbottle"] = 1,
					["chocolate"] = 1,
					["coffee"] = 1
				}
			},
			["passionjuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["passion"] = 2,
					["water"] = 1
				}
			},
			["tangejuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["tange"] = 1,
					["water"] = 1
				}
			},
			["orangejuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["orange"] = 1,
					["water"] = 1
				}
			},
			["applejuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["apple"] = 1,
					["water"] = 1
				}
			},
			["grapejuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["grape"] = 1,
					["water"] = 1
				}
			},
			["lemonjuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["lemon"] = 1,
					["water"] = 1
				}
			},
			["bananajuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["banana"] = 1,
					["water"] = 1
				}
			},
			["acerolajuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["acerola"] = 1,
					["water"] = 1
				}
			},
			["strawberryjuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["strawberry"] = 1,
					["water"] = 1
				}
			},
			["blueberryjuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueberry"] = 1,
					["water"] = 1
				}
			},
			["coffeemilk"] = {
				["Amount"] = 1,
				["Required"] = {
					["coffee"] = 1,
					["milkbottle"] = 1
				}
			}
		}
	},
	["DrinkRestaurante"] = {
		["Permission"] = "Restaurante",
		["List"] = {
			["milkshake"] = {
				["Amount"] = 1,
				["Required"] = {
					["milkbottle"] = 1,
					["strawberry"] = 1
				}
			},
			["cappuccino"] = {
				["Amount"] = 1,
				["Required"] = {
					["milkbottle"] = 1,
					["chocolate"] = 1,
					["coffee"] = 1
				}
			},
			["passionjuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["passion"] = 2,
					["water"] = 1
				}
			},
			["tangejuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["tange"] = 1,
					["water"] = 1
				}
			},
			["orangejuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["orange"] = 1,
					["water"] = 1
				}
			},
			["applejuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["apple"] = 1,
					["water"] = 1
				}
			},
			["grapejuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["grape"] = 1,
					["water"] = 1
				}
			},
			["lemonjuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["lemon"] = 1,
					["water"] = 1
				}
			},
			["bananajuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["banana"] = 1,
					["water"] = 1
				}
			},
			["acerolajuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["acerola"] = 1,
					["water"] = 1
				}
			},
			["strawberryjuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["strawberry"] = 1,
					["water"] = 1
				}
			},
			["blueberryjuice"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueberry"] = 1,
					["water"] = 1
				}
			},
			["coffeemilk"] = {
				["Amount"] = 1,
				["Required"] = {
					["coffee"] = 1,
					["milkbottle"] = 1
				}
			}
		}
	},
	["Furnace"] = {
		["List"] = {
			["plastic"] = {
				["Amount"] = 25,
				["Required"] = {
					["emptybottle"] = 3,
					["latex"] = 1
				}
			},
			["glass"] = {
				["Amount"] = 5,
				["Required"] = {
					["sand"] = 1
				}
			},
			["latex"] = {
				["Amount"] = 1,
				["Required"] = {
					["woodlog"] = 5,
					["emptybottle"] = 1
				}
			},
			["rubber"] = {
				["Amount"] = 20,
				["Required"] = {
					["latex"] = 1
				}
			},
			["aluminum"] = {
				["Amount"] = 5,
				["Required"] = {
					["bauxite"] = 1
				}
			},
			["copper"] = {
				["Amount"] = 5,
				["Required"] = {
					["chalcopyrite"] = 1
				}
			}
		}
	},
	["Pharmacy_bench"] = {
		["List"] = {
			["blueprint_firstaidbandage"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 3800
				}
			},
			["blueprint_medkit"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 11362
				}
			},
			["blueprint_bandage"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 9625
				}
			},
			["blueprint_gauze"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 7625
				}
			},
			["blueprint_analgesic"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 8625
				}
			}
		}
	},
	["Pharmacy"] = {
		["List"] = {
			["firstaidbandage"] = {
				["Amount"] = 1,
				["Required"] = {
					["aloeveraleaf"] = 4,
					["cloth"] = 1,
				}
			},
			["medkit"] = {
				["Amount"] = 1,
				["Required"] = {
					["saline"] = 1,
					["acetone"] = 1,
					["alcohol"] = 1,
					["zcoin"] = 275
				}
			},
			["bandage"] = {
				["Amount"] = 1,
				["Required"] = {
					["saline"] = 1,
					["alcohol"] = 1,
					["zcoin"] = 75
				}
			},
			["gauze"] = {
				["Amount"] = 1,
				["Required"] = {
					["alcohol"] = 1,
					["zcoin"] = 25
				}
			},
			["analgesic"] = {
				["Amount"] = 1,
				["Required"] = {
					["saline"] = 1,
					["zcoin"] = 65
				}
			}
		}
	},
	["Mecanico"] = {
		["List"] = {
			["coilover"] = {
				["Amount"] = 1,
				["Required"] = {
					["screws"] = 24,
					["screwnuts"] = 24,
					["copper"] = 725,
					["aluminum"] = 725,
					["metalspring"] = 4,
					["sheetmetal"] = 10,
					["roadsigns"] = 4,
					["scotchtape"] = 2,
					["insulatingtape"] = 2,
					["scrapmetal"] = 425
				}
			},
			["advtoolbox"] = {
				["Amount"] = 1,
				["Required"] = {
					["screws"] = 2,
					["screwnuts"] = 2,
					["rubber"] = 100,
					["copper"] = 85,
					["aluminum"] = 75
				}
			},
			["toolbox"] = {
				["Amount"] = 1,
				["Required"] = {
					["screws"] = 1,
					["screwnuts"] = 1,
					["rubber"] = 50,
					["copper"] = 18,
					["aluminum"] = 15
				}
			},
			["tyres"] = {
				["Amount"] = 1,
				["Required"] = {
					["rubber"] = 35
				}
			},
			["plate"] = {
				["Amount"] = 1,
				["Required"] = {
					["copper"] = 50,
					["aluminum"] = 45
				}
			},
			["nitro"] = {
				["Amount"] = 1,
				["Required"] = {
					["scotchtape"] = 2,
					["insulatingtape"] = 1,
					["screws"] = 2,
					["screwnuts"] = 2,
					["glass"] = 125,
					["copper"] = 60,
					["aluminum"] = 55
				}
			}
		}
	},
	["pistol_bench"] = {
		["List"] = {
			["WEAPON_PISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["weaponparts"] = 3,
					["metalspring"] = 1,
					["glass"] = 100,
					["rubber"] = 100,
					["plastic"] = 120,
					["copper"] = 75,
					["aluminum"] = 75
				}
			},
			["WEAPON_PISTOL_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["weaponparts"] = 3,
					["metalspring"] = 1,
					["glass"] = 115,
					["rubber"] = 115,
					["plastic"] = 135,
					["copper"] = 75,
					["aluminum"] = 75
				}
			},
			["WEAPON_HEAVYPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 1,
					["glass"] = 155,
					["rubber"] = 155,
					["plastic"] = 175,
					["copper"] = 100,
					["aluminum"] = 100
				}
			},
			["WEAPON_SNSPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["weaponparts"] = 3,
					["metalspring"] = 1,
					["glass"] = 75,
					["rubber"] = 100,
					["plastic"] = 65,
					["copper"] = 55,
					["aluminum"] = 65
				}
			},
			["WEAPON_SNSPISTOL_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["weaponparts"] = 3,
					["metalspring"] = 1,
					["glass"] = 75,
					["rubber"] = 100,
					["plastic"] = 110,
					["copper"] = 75,
					["aluminum"] = 75
				}
			},
			["WEAPON_VINTAGEPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["weaponparts"] = 3,
					["metalspring"] = 1,
					["glass"] = 75,
					["rubber"] = 75,
					["plastic"] = 100,
					["copper"] = 50,
					["aluminum"] = 50
				}
			},
			["WEAPON_PISTOL50"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 1,
					["glass"] = 155,
					["rubber"] = 155,
					["plastic"] = 165,
					["copper"] = 100,
					["aluminum"] = 100
				}
			},
			["WEAPON_COMBATPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["weaponparts"] = 3,
					["metalspring"] = 1,
					["glass"] = 115,
					["rubber"] = 125,
					["plastic"] = 125,
					["copper"] = 75,
					["aluminum"] = 75
				}
			}
		}
	},
	["smg_bench"] = {
		["List"] = {
			["WEAPON_APPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["smgbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 2,
					["glass"] = 145,
					["rubber"] = 145,
					["plastic"] = 155,
					["copper"] = 100,
					["aluminum"] = 100
				}
			},
			["WEAPON_MACHINEPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["smgbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 2,
					["glass"] = 145,
					["rubber"] = 145,
					["plastic"] = 155,
					["copper"] = 100,
					["aluminum"] = 100
				}
			},
			["WEAPON_MICROSMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["smgbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 2,
					["glass"] = 225,
					["rubber"] = 235,
					["plastic"] = 275,
					["copper"] = 175,
					["aluminum"] = 175
				}
			},
			["WEAPON_MINISMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["smgbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 2,
					["glass"] = 225,
					["rubber"] = 235,
					["plastic"] = 275,
					["copper"] = 175,
					["aluminum"] = 175
				}
			},
			["WEAPON_SMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["smgbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 2,
					["glass"] = 275,
					["rubber"] = 305,
					["plastic"] = 315,
					["copper"] = 225,
					["aluminum"] = 225
				}
			},
			["WEAPON_SMG_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["smgbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 2,
					["glass"] = 375,
					["rubber"] = 305,
					["plastic"] = 305,
					["copper"] = 225,
					["aluminum"] = 225
				}
			},
			["WEAPON_GUSENBERG"] = {
				["Amount"] = 1,
				["Required"] = {
					["smgbody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 2,
					["glass"] = 275,
					["rubber"] = 305,
					["plastic"] = 305,
					["copper"] = 225,
					["aluminum"] = 225
				}
			}
		}
	},
	["rifle_bench"] = {
		["List"] = {
			["WEAPON_PUMPSHOTGUN"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 1,
					["glass"] = 225,
					["rubber"] = 265,
					["plastic"] = 255,
					["copper"] = 175,
					["aluminum"] = 175
				}
			},
			["WEAPON_PUMPSHOTGUN_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 8,
					["metalspring"] = 2,
					["glass"] = 375,
					["rubber"] = 425,
					["plastic"] = 345,
					["copper"] = 175,
					["aluminum"] = 175
				}
			},
			["WEAPON_SAWNOFFSHOTGUN"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 5,
					["metalspring"] = 1,
					["glass"] = 225,
					["rubber"] = 255,
					["plastic"] = 265,
					["copper"] = 175,
					["aluminum"] = 175
				}
			},
			["WEAPON_COMPACTRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 8,
					["metalspring"] = 2,
					["glass"] = 305,
					["rubber"] = 325,
					["plastic"] = 265,
					["copper"] = 175,
					["aluminum"] = 175
				}
			},
			["WEAPON_CARBINERIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 405,
					["rubber"] = 405,
					["plastic"] = 405,
					["copper"] = 345,
					["aluminum"] = 335
				}
			},
			["WEAPON_CARBINERIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 405,
					["rubber"] = 415,
					["plastic"] = 375,
					["copper"] = 355,
					["aluminum"] = 375
				}
			},
			["WEAPON_ADVANCEDRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 385,
					["rubber"] = 405,
					["plastic"] = 405,
					["copper"] = 335,
					["aluminum"] = 325
				}
			},
			["WEAPON_BULLPUPRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 385,
					["rubber"] = 465,
					["plastic"] = 400,
					["copper"] = 325,
					["aluminum"] = 325
				}
			},
			["WEAPON_BULLPUPRIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 305,
					["rubber"] = 425,
					["plastic"] = 425,
					["copper"] = 300,
					["aluminum"] = 425
				}
			},
			["WEAPON_SPECIALCARBINE"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 305,
					["rubber"] = 425,
					["plastic"] = 425,
					["copper"] = 425,
					["aluminum"] = 300
				}
			},
			["WEAPON_SPECIALCARBINE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 275,
					["rubber"] = 400,
					["plastic"] = 400,
					["copper"] = 425,
					["aluminum"] = 345
				}
			},
			["WEAPON_TACTICALRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 275,
					["rubber"] = 400,
					["plastic"] = 400,
					["copper"] = 345,
					["aluminum"] = 425
				}
			},
			["WEAPON_HEAVYRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 305,
					["rubber"] = 425,
					["plastic"] = 425,
					["copper"] = 335,
					["aluminum"] = 375
				}
			},
			["WEAPON_ASSAULTRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 305,
					["rubber"] = 425,
					["plastic"] = 425,
					["copper"] = 425,
					["aluminum"] = 300
				}
			},
			["WEAPON_ASSAULTRIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["riflebody"] = 1,
					["weaponparts"] = 10,
					["metalspring"] = 3,
					["glass"] = 275,
					["rubber"] = 400,
					["plastic"] = 400,
					["copper"] = 425,
					["aluminum"] = 345
				}
			}
		}
	},
	["blueprint_bench"] = {
		["List"] = {
			["blueprint_WEAPON_ADVANCEDRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_WEAPON_COMPACTRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_ATTACH_GRIP"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 8625
				}
			},
			["blueprint_WEAPON_SAWNOFFSHOTGUN"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_WEAPON_MICROSMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_WEAPON_HEAVYRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_ASSAULTRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_WEAPON_MUSKET"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 16125
				}
			},
			["blueprint_WEAPON_BULLPUPRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_ATTACH_MAGAZINE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 11125
				}
			},
			["blueprint_WEAPON_ASSAULTRIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_HEAVYPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 6125
				}
			},
			["blueprint_WEAPON_CARBINERIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_ATTACH_FLASHLIGHT"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 10625
				}
			},
			["blueprint_WEAPON_PISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 28625
				}
			},
			["blueprint_WEAPON_SNSPISTOL_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 26125
				}
			},
			["blueprint_ATTACH_SILENCER"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 23625
				}
			},
			["blueprint_WEAPON_SPECIALCARBINE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_PISTOL50"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 41125
				}
			},
			["blueprint_WEAPON_MINISMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_WEAPON_TACTICALRIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_SNSPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 23625
				}
			},
			["blueprint_WEAPON_GUSENBERG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 76125
				}
			},
			["blueprint_WEAPON_ASSAULTSMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 76125
				}
			},
			["blueprint_WEAPON_SMG_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 76125
				}
			},
			["blueprint_WEAPON_SMG"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 63625
				}
			},
			["blueprint_WEAPON_PUMPSHOTGUN_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 76375
				}
			},
			["blueprint_WEAPON_PUMPSHOTGUN"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 66125
				}
			},
			["blueprint_WEAPON_SPECIALCARBINE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_WEAPON_BULLPUPRIFLE_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 121125
				}
			},
			["blueprint_WEAPON_CARBINERIFLE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 113625
				}
			},
			["blueprint_ATTACH_CROSSHAIR"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 13625
				}
			},
			["blueprint_WEAPON_MACHINEPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 41125
				}
			},
			["blueprint_WEAPON_APPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 31125
				}
			},
			["blueprint_WEAPON_PISTOL_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 31125
				}
			},
			["blueprint_WEAPON_SMOKEGRENADE"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 6125
				}
			},
			["blueprint_WEAPON_MOLOTOV"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 6125
				}
			},
			["blueprint_WEAPON_COMBATPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 31125
				}
			},
			["blueprint_WEAPON_VINTAGEPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 23625
				}
			},
			["blueprint_metalspring"] = {
				["Amount"] = 1,
				["Required"] = {
					["blueprint_fragment"] = 265
				}
			}
		}
	},
	["drugs_bench"] = {
		["List"] = {
			["cocaine"] = {
				["Amount"] = 1,
				["Required"] = {
					["coke"] = 1
				}
			},
			["cokesack"] = {
				["Amount"] = 1,
				["Required"] = {
					["cocaine"] = 10
				}
			},
			["joint"] = {
				["Amount"] = 1,
				["Required"] = {
					["weed"] = 1
				}
			},
			["weedsack"] = {
				["Amount"] = 1,
				["Required"] = {
					["joint"] = 10
				}
			},
			["meth"] = {
				["Amount"] = 5,
				["Required"] = {
					["saline"] = 1,
					["sulfuric"] = 1
				}
			},
			["methsack"] = {
				["Amount"] = 1,
				["Required"] = {
					["meth"] = 10
				}
			},
			["crack"] = {
				["Amount"] = 1,
				["Required"] = {
					["cocaine"] = 10,
					["acetone"] = 2
				}
			},
			["heroin"] = {
				["Amount"] = 1,
				["Required"] = {
					["meth"] = 7,
					["saline"] = 2,
					["alcohol"] = 2,
					["sulfuric"] = 2
				}
			},
			["metadone"] = {
				["Amount"] = 1,
				["Required"] = {
					["analgesic"] = 1,
					["sulfuric"] = 2,
					["alcohol"] = 2
				}
			},
			["codeine"] = {
				["Amount"] = 1,
				["Required"] = {
					["analgesic"] = 1,
					["sulfuric"] = 2,
					["alcohol"] = 2
				}
			},
			["amphetamine"] = {
				["Amount"] = 1,
				["Required"] = {
					["meth"] = 6,
					["cocaine"] = 6
				}
			}
		}
	},
	["pistol_bench"] = {
		["List"] = {
			["WEAPON_PISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["plastic"] = 85,
					["copper"] = 85,
					["decay"] = 5,
					["aluminum"] = 85
				}
			},
			["WEAPON_PISTOL_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["plastic"] = 85,
					["copper"] = 85,
					["decay"] = 5,
					["aluminum"] = 85
				}
			},
			["WEAPON_HEAVYPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["plastic"] = 85,
					["copper"] = 85,
					["decay"] = 5,
					["aluminum"] = 85
				}
			},
			["WEAPON_SNSPISTOL_MK2"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["plastic"] = 85,
					["copper"] = 85,
					["decay"] = 5,
					["aluminum"] = 85
				}
			},
			["WEAPON_VINTAGEPISTOL"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["plastic"] = 85,
					["copper"] = 85,
					["decay"] = 5,
					["aluminum"] = 85
				}
			},
			["WEAPON_PISTOL50"] = {
				["Amount"] = 1,
				["Required"] = {
					["pistolbody"] = 1,
					["plastic"] = 85,
					["copper"] = 95,
					["decay"] = 5,
					["aluminum"] = 95
				}
			}
		}
	},
	["Lester"] = {
		["List"] = {
			["ballisticplate"] = {
				["Amount"] = 1,
				["Required"] = {
					["tarp"] = 3,
					["sheetmetal"] = 3,
					["roadsigns"] = 3,
					["copper"] = 20,
					["aluminum"] = 15
				}
			},
			["lockpick"] = {
				["Amount"] = 1,
				["Required"] = {
					["copper"] = 30,
					["aluminum"] = 30,
					["sheetmetal"] = 2
				}
			},
			["handcuff"] = {
				["Amount"] = 1,
				["Required"] = {
					["copper"] = 60,
					["aluminum"] = 65
				}
			},
			["hood"] = {
				["Amount"] = 1,
				["Required"] = {
					["tarp"] = 5,
					["rubber"] = 85
				}
			},
			["WEAPON_SHOTGUN_AMMO"] = {
				["Amount"] = 4,
				["Required"] = {
					["aluminum"] = 7,
					["gunpowder"] = 1
				}
			},
			["WEAPON_PISTOL_AMMO"] = {
				["Amount"] = 10,
				["Required"] = {
					["rusty_ammo"] = 20
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["Amount"] = 15,
				["Required"] = {
					["copper"] = 8,
					["aluminum"] = 8,
					["gunpowder"] = 1
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["Amount"] = 15,
				["Required"] = {
					["copper"] = 10,
					["aluminum"] = 15,
					["gunpowder"] = 1
				}
			},
			["ATTACH_FLASHLIGHT"] = {
				["Amount"] = 1,
				["Required"] = {
					["scotchtape"] = 1,
					["insulatingtape"] = 1,
					["batteryaa"] = 1,
					["batteryaaplus"] = 1,
					["glass"] = 75,
					["plastic"] = 75
				}
			},
			["ATTACH_CROSSHAIR"] = {
				["Amount"] = 1,
				["Required"] = {
					["scotchtape"] = 1,
					["insulatingtape"] = 1,
					["batteryaa"] = 1,
					["batteryaaplus"] = 1,
					["glass"] = 95,
					["plastic"] = 95,
					["copper"] = 25
				}
			},
			["ATTACH_SILENCER"] = {
				["Amount"] = 1,
				["Required"] = {
					["scotchtape"] = 5,
					["insulatingtape"] = 5,
					["emptybottle"] = 1,
					["toothpaste"] = 1,
					["plastic"] = 200,
					["copper"] = 200
				}
			},
			["ATTACH_MAGAZINE"] = {
				["Amount"] = 1,
				["Required"] = {
					["scotchtape"] = 1,
					["insulatingtape"] = 1,
					["rubber"] = 95,
					["plastic"] = 95,
					["aluminum"] = 25
				}
			},
			["ATTACH_GRIP"] = {
				["Amount"] = 1,
				["Required"] = {
					["scotchtape"] = 1,
					["insulatingtape"] = 1,
					["electroniccomponents"] = 1,
					["rubber"] = 65,
					["plastic"] = 65
				}
			}
		}
	}
}