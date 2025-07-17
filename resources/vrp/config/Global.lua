-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
MaxRepair = 1
MinimumWeight = 15
SalaryCooldowns = 1800
GroupsSetCooldown = 259200
CreatorCoords = vec4(-2006.95,2960.77,31.81,305.82)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
BATTLEPASS_POINTS = 500
BATTLEPASS_PRICE = 10000
BATTLEPASS_START = 1744165448
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
Currency = "$"
DiscordBot = false
BaseMode = "steam"
Whitelisted = false
Liberation = "Token"
ServerName = "Zombie Enchanted"
NameDefault = "Indivíduo Indigente"
ServerLink = "https://discord.gg/fivecommunity"
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
SpawnCoords = {
	vec3(-429.08,1111.24,327.68)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTUREPACK
-----------------------------------------------------------------------------------------------------------------------------------------
TexturePack = {
	"Drop","E","H","Normal","Selected"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
Theme = {
    shadow = true,
    -- cor principal de interface (neon cyan)
    main     = "#FF0000",
    mainText = "#000000",
    currency = Currency,
    -- raridades (neon)
    common    = "#39FF14",  -- neon green
    rare      = "#FF007F",  -- neon pink
    epic      = "#8A2BE2",  -- neon violet
    legendary = "#FFD300",  -- neon yellow
    -- botões de confirmação/cancelamento
    accept = {
        letter     = "#000000",
        background = "#7CFC00",  -- neon lawn green
    },
    reject = {
        letter     = "#000000",
        background = "#FF1493",  -- deep neon pink
    },
    -- loading screen
    loading = {
        mode     = "dark",
        model    = 2,
        progress = true,
	},
	chat = {
		LSPD = {
			background = "#FF0000",
			letter = "#ffffff"
		},
		BCSO = {
			background = "#463939",
			letter = "#ffffff"
		},
		BCPR = {
			background = "#2d402d",
			letter = "#ffffff"
		},
		Paramedico = {
			background = "#9f1918",
			letter = "#ffffff"
		},
		Families = {
			background = "#4d7a06",
			letter = "#ffffff"
		},
		Ballas = {
			background = "#430d8e",
			letter = "#ffffff"
		},
		Vagos = {
			background = "#948209",
			letter = "#ffffff"
		}
	},
    hud = {
        modes = {
            info    = 3,
            icon    = "fill",
            status  = 10,
            vehicle = 3,
        },
        percentage = true,
        icons      = "#FFFFFF",
        nitro      = "#00CED1",  -- neon dark turquoise
        rpm        = "#00FFFF",  -- neon cyan
        fuel       = "#FF4500",  -- neon orange-red
        engine     = "#FF0000",  -- neon red
        health     = "#FF073A",  -- neon scarlet red
        armor      = "#DA00FF",  -- neon purple
        hunger     = "#FFD300",  -- neon yellow
        thirst     = "#00F5FF",  -- neon sky blue
        stress     = "#39FF14",  -- neon green (radiação/infecção)
        luck       = "#FF00FF",  -- neon magenta
        dexterity  = "#7FFF00",  -- chartreuse neon
        repose     = "#00FF7F",  -- neon spring green
        pointer    = "#FF4500",  -- neon orange-red
        progress = {
            background = "#000000",
            circle     = "#00FFFF",  -- neon cyan
            letter     = "#000000",
		}
	},
	notifyitem = {
		add = {
			letter = "#dcffe9",
			background = "#3fa466"
		},
		remove = {
			letter = "#ffe8e8",
			background = "#ad4443"
		}
	},
	pause = {
		premium = true,
		propertys = true,
		store = true,
		battlepass = true,
		boxes = true,
		marketplace = true,
		skinweapon = true,
		ranking = true,
		daily = true,
		code = true,
		map = true,
		settings = true,
		disconnect = true
	},
	scripts = {
		taximeter = {
			main = "#efcf2f",
			mainText = "#120b02"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
	Admin = {
		Permission = {
			Admin = true
		},
		Hierarchy = { "Administrador","Moderador","Suporte" },
		Name = "Adminstradores",
		Service = {},
		Chat = true,
		Client = true,
		Max = 30
	},
	Ouro = {
		Permission = {
			Ouro = true
		},
		Hierarchy = { "Membro" },
		Salary = { 3750 },
		Backpack = { 25 },
		Service = {},
		Client = true,
		Block = true
	},
	Prata = {
		Permission = {
			Prata = true
		},
		Hierarchy = { "Membro" },
		Salary = { 2500 },
		Backpack = { 15 },
		Service = {},
		Client = true,
		Block = true
	},
	Bronze = {
		Permission = {
			Bronze = true
		},
		Hierarchy = { "Membro" },
		Salary = { 1250 },
		Backpack = { 5 },
		Service = {},
		Client = true,
		Block = true
	},
	LSPD = {
		Permission = {
			LSPD = true
		},
		Hierarchy = { "Chefe","Capitão","Tenente","Sargento","Oficial","Cadete" },
		Salary = { 3750,3625,3500,3375,3250,3125 },
		Name = "Los Santos Police Department",
		Service = {},
		Client = true,
		Type = "Work",
		Markers = true,
		Chat = true
	},
	BCSO = {
		Permission = {
			BCSO = true
		},
		Hierarchy = { "Chefe","Capitão","Tenente","Sargento","Oficial","Cadete" },
		Salary = { 3750,3625,3500,3375,3250,3125 },
		Name = "Blaine County Sheriff Officer",
		Service = {},
		Client = true,
		Type = "Work",
		Markers = true,
		Chat = true
	},
	SAPR = {
		Permission = {
			SAPR = true
		},
		Hierarchy = { "Chefe","Capitão","Tenente","Sargento","Oficial","Cadete" },
		Salary = { 3750,3625,3500,3375,3250,3125 },
		Name = "San Andreas Park Ranger",
		Service = {},
		Client = true,
		Type = "Work",
		Markers = true,
		Chat = true
	},
	Paramedico = {
		Permission = {
			Paramedico = true
		},
		Hierarchy = { "Chefe","Médico","Enfermeiro","Residente" },
		Salary = { 3750,3625,3500,3375 },
		Service = {},
		Client = true,
		Type = "Work",
		Markers = true,
		Chat = true
	},
	Ballas = {
		Permission = {
			Ballas = true
		},
		Hierarchy = { "Líder","Sub-Líder","Membro","Recruta" },
		Service = {},
		Client = true,
		Type = "Work"
	},
	Vagos = {
		Permission = {
			Vagos = true
		},
		Hierarchy = { "Líder","Sub-Líder","Membro","Recruta" },
		Service = {},
		Client = true,
		Type = "Work"
	},
	Families = {
		Permission = {
			Families = true
		},
		Hierarchy = { "Líder","Sub-Líder","Membro","Recruta" },
		Service = {},
		Client = true,
		Type = "Work"
	},
	Marabunta = {
		Permission = {
			Marabunta = true
		},
		Hierarchy = { "Líder","Sub-Líder","Membro","Recruta" },
		Service = {},
		Client = true,
		Type = "Work"
	},
	Bennys = {
		Permission = {
			Bennys = true
		},
		Hierarchy = { "Líder","Sub-Líder","Membro","Recruta" },
		Service = {},
		Client = true,
		Type = "Work"
	},
	Aztecas = {
		Permission = {
			Aztecas = true
		},
		Hierarchy = { "Líder","Sub-Líder","Membro","Recruta" },
		Service = {},
		Client = true,
		Type = "Work"
	},
	Bahamas = {
		Permission = {
			Bahamas = true
		},
		Hierarchy = { "Líder","Sub-Líder","Membro","Recruta" },
		Service = {},
		Client = true,
		Type = "Work"
	},
	Restaurante = {
		Permission = {
			Restaurante = true
		},
		Hierarchy = { "Chefe","Supervisor","Funcionário" },
		Service = {},
		Client = true,
		Type = "Work"
	},
	Booster = {
		Permission = {
			Booster = true
		},
		Hierarchy = { "Membro" },
		Service = {},
		Client = true,
		Salary = { 2500 },
		Block = true
	},
	Freecam = {
		Permission = {
			Freecam = true
		},
		Hierarchy = { "Membro" },
		Service = {},
		Client = true,
		Block = true
	},
	Policia = {
		Permission = {
			LSPD = true,
			BCSO = true,
			SAPR = true
		},
		Hierarchy = { "Membro" },
		Block = true
	},
	Emergencia = {
		Permission = {
			LSPD = true,
			BCSO = true,
			SAPR = true,
			Paramedico = true
		},
		Hierarchy = { "Membro" },
		Block = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERITENS
-----------------------------------------------------------------------------------------------------------------------------------------
CharacterItens = {
	["redtea"] = 2,
	["WEAPON_SWITCHBLADE"] = 1,
	["WEAPON_BAT"] = 1
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOXES
-----------------------------------------------------------------------------------------------------------------------------------------
Boxes = {
	["treasurebox"] = {
		Multiplier = { Min = 1, Max = 1 },
		List = {
			{ Item = "zcoin", Chance = 100, Min = 4250, Max = 6250 }
		}
	},
	["christmas_04"] = {
		Multiplier = { Min = 1, Max = 1 },
		List = {
			{ Item = "christmas_01", Chance = 100, Min = 1, Max = 1 },
			{ Item = "christmas_02", Chance = 100, Min = 1, Max = 1 },
			{ Item = "christmas_03", Chance = 100, Min = 1, Max = 1 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPPERLEVEL
-----------------------------------------------------------------------------------------------------------------------------------------
UpperLevel = {
	["Trucker"] = { -- Experiência do emprego
		["2"] = { -- Nível que vai receber a recompensa
			{ Item = "bandage", Min = 1, Max = 2 },
			{ Item = "advtoolbox", Min = 1, Max = 1 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
SkinshopInit = {
	["mp_m_freemode_01"] = {
		pants = { item = 4, texture = 1 },
		arms = { item = 0, texture = 0 },
		tshirt = { item = 15, texture = 0 },
		torso = { item = 273, texture = 0 },
		vest = { item = 0, texture = 0 },
		shoes = { item = 1, texture = 6 },
		mask = { item = 0, texture = 0 },
		backpack = { item = 0, texture = 0 },
		hat = { item = -1, texture = 0 },
		glass = { item = 0, texture = 0 },
		ear = { item = -1, texture = 0 },
		watch = { item = -1, texture = 0 },
		bracelet = { item = -1, texture = 0 },
		accessory = { item = 0, texture = 0 },
		decals = { item = 0, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		pants = { item = 4, texture = 1 },
		arms = { item = 14, texture = 0 },
		tshirt = { item = 3, texture = 0 },
		torso = { item = 338, texture = 2 },
		vest = { item = 0, texture = 0 },
		shoes = { item = 1, texture = 6 },
		mask = { item = 0, texture = 0 },
		backpack = { item = 0, texture = 0 },
		hat = { item = -1, texture = 0 },
		glass = { item = 0, texture = 0 },
		ear = { item = -1, texture = 0 },
		watch = { item = -1, texture = 0 },
		bracelet = { item = -1, texture = 0 },
		accessory = { item = 0, texture = 0 },
		decals = { item = 0, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
BarbershopInit = {
	mp_m_freemode_01 = { 13,25,0,3,0,-1,-1,-1,-1,13,38,38,0,0,0,0,0.5,0,0,1,0,10,1,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,38 },
	mp_f_freemode_01 = { 13,25,1,3,0,-1,-1,-1,-1,1,38,38,0,0,0,0,1,0,0,1,0,0,0,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,38 }
}