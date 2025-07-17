-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
PercetageSelling = 0.5 -- Porcentagem a receber ao vender o veículo
PercentageTaxs = 0.15 -- Porcentagem a cobrar pela taxa mensal do veículo
PercentageArrest = 0.1 -- Porcentagem a cobrar para liberar o veículo apreendido
PercentageRescue = 0.1 -- Porcentagem a cobrar para resgatar o veículo em qualquer garagem
PercentageImpost = 0.25 -- Porcentagem de imposto ao comprar um veículo
CarPermission = "Admin" -- Permissão para utilizar o comando /car
DvPermission = "Admin" -- Permissão para utilizar o comando /dv
LockPermission = "Admin" -- Permissão para destrancar qualquer veículo
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
Garages = {
	["1"] = { ["Name"] = "Garage", ["Save"] = true }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
Works = {
	["Helicopters"] = {
		"maverick",
		"volatus",
		"supervolito",
		"havok"
	},
	["Paramedico"] = {
		"lguard",
		"blazer2",
		"firetruk",
		"ambulance2"
	},
	["Paramedico2"] = {
		"maverick2"
	},
	["Policia"] = {
		"ballerpol",
		"elegy2pol",
		"fugitivepol",
		"komodapol",
		"kurumapol",
		"nc700pol",
		"oracle2pol",
		"polchall",
		"polchar",
		"police3pol",
		"policepol",
		"policetpol",
		"poltang",
		"polvic",
		"r1250pol",
		"schafter2pol",
		"sheriff2pol",
		"silveradopol",
		"sultanrspol",
		"tahoepol",
		"tailgater2pol",
		"tauruspol"
	},
	["Policia2"] = {
		"polas350"
	},
	["Policia3"] = {
		"pbus",
		"riot"
	},
	["Driver"] = {
		"bus"
	},
	["Boats"] = {
		"dinghy",
		"jetmax",
		"marquis",
		"seashark",
		"speeder",
		"squalo",
		"suntrap",
		"toro",
		"tropic"
	},
	["Transporter"] = {
		"stockade"
	},
	["Lumberman"] = {
		"ratloader"
	},
	["Garbageman"] = {
		"trash"
	},
	["Trucker"] = {
		"packer"
	},
	["Taxi"] = {
		"taxi"
	},
	["Grime"] = {
		"boxville2"
	},
	["Towed"] = {
		"flatbed"
	},
	["Milkman"] = {
		"youga2"
	}
}