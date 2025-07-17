-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawned = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	{ -- Essence
		["Distance"] = 50,
		["Coords"] = vec4(87.62,-1670.45,29.18,73.71),
		["Model"] = "s_m_m_scientist_01",
		["Collision"] = true
	},{ -- Cow
		["Distance"] = 50,
		["Coords"] = vec4(957.99,-2207.26,30.6,266.46),
		["Model"] = "a_c_cow",
		["Collision"] = true
	},{ -- Cow
		["Distance"] = 50,
		["Coords"] = vec4(956.66,-2220.51,30.58,266.46),
		["Model"] = "a_c_cow",
		["Collision"] = true
	},{ -- Cow
		["Distance"] = 50,
		["Coords"] = vec4(955.6,-2233.52,30.58,266.46),
		["Model"] = "a_c_cow",
		["Collision"] = true
	},{ -- Cow
		["Distance"] = 50,
		["Coords"] = vec4(954.49,-2247.07,30.58,266.46),
		["Model"] = "a_c_cow",
		["Collision"] = true
	},{ -- Desmanche
		["Distance"] = 100,
		["Coords"] = vec4(778.49,-395.89,33.43,99.22),
		["Model"] = "g_m_y_salvagoon_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Banco Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-404.09,1073.46,323.84,257.96),
		["Model"] = "s_m_m_scientist_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Fundição Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-297.7,1442.44,338.68,184.26),
		["Model"] = "s_m_m_scientist_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Ammunation Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-426.0,1207.81,325.76,255.12),
		["Model"] = "ig_shadow",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Bebidas/Chás Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-411.96,1050.64,322.15,25.52),
		["Model"] = "s_m_m_scientist_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Doctor Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-396.21,1156.08,325.84,76.54),
		["Model"] = "s_m_m_scientist_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Garagem Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-516.85,1190.51,324.93,263.63),
		["Model"] = "ig_dreyfuss",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Restaurante/Criação de Comida Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-480.69,1133.45,320.1,161.58),
		["Model"] = "ig_dreyfuss",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Mecanico Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-418.1,1235.42,325.76,249.45),
		["Model"] = "ig_dreyfuss",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Mercador Clandestino Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-423.21,1073.93,327.7,172.92),
		["Model"] = "ig_dreyfuss",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Mercador Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-443.36,1120.15,326.52,79.38),
		["Model"] = "ig_dreyfuss",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Açougueiro Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-376.87,1215.47,325.76,99.22),
		["Model"] = "s_m_m_migrant_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Banco Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(949.44,-182.75,79.31,240.95),
		["Model"] = "ig_dreyfuss",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Departament Store Enclave Inicial
		["Distance"] = 100,
		["Coords"] = vec4(-409.41,1155.95,325.89,291.97),
		["Model"] = "mp_m_shopkeep_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Jewelry
		["Distance"] = 15,
		["Coords"] = vec4(-628.79,-238.7,38.05,311.82),
		["Model"] = "cs_gurk",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Transporter
		["Distance"] = 20,
		["Coords"] = vec4(264.74,219.99,101.67,343.0),
		["Model"] = "ig_casey",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Leiteiro
		["Distance"] = 50,
		["Coords"] = vec4(963.13,-2215.33,30.55,272.13),
		["Model"] = "cs_manuel",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Lenhador
		["Distance"] = 50,
		["Coords"] = vec4(1961.61,5179.26,47.94,277.8),
		["Model"] = "a_m_o_ktown_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Caçador
		["Distance"] = 10,
		["Coords"] = vec4(-679.14,5834.37,17.32,127.56),
		["Model"] = "ig_hunter",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Caçador
		["Distance"] = 50,
		["Coords"] = vec4(-1593.08,5202.9,4.31,297.64),
		["Model"] = "a_m_o_ktown_01",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},{ -- Pescador
		["Distance"] = 30,
		["Coords"] = vec4(-1816.64,-1193.73,14.31,334.49),
		["Model"] = "a_f_y_eastsa_03",
		["Anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADLIST
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Number = 1,#List do
			local Distance = #(Coords - List[Number]["Coords"]["xyz"])
			if Distance <= List[Number]["Distance"] then
				if not Spawned[Number] and LoadModel(List[Number]["Model"]) then
					Spawned[Number] = CreatePed(4,List[Number]["Model"],List[Number]["Coords"]["x"],List[Number]["Coords"]["y"],List[Number]["Coords"]["z"] - 1,List[Number]["Coords"]["w"],false,false)
					SetPedArmour(Spawned[Number],100)
					SetEntityInvincible(Spawned[Number],true)
					FreezeEntityPosition(Spawned[Number],true)

					if not List[Number]["Collision"] then
						SetEntityNoCollisionEntity(Spawned[Number],Ped,false)
					end

					SetBlockingOfNonTemporaryEvents(Spawned[Number],true)
					SetModelAsNoLongerNeeded(List[Number]["Model"])

					if List[Number]["Anim"] and LoadAnim(List[Number]["Anim"][1]) then
						TaskPlayAnim(Spawned[Number],List[Number]["Anim"][1],List[Number]["Anim"][2],8.0,8.0,-1,1,1,0,0,0)
					end
				end
			else
				if Spawned[Number] then
					if DoesEntityExist(Spawned[Number]) then
						DeleteEntity(Spawned[Number])
					end

					Spawned[Number] = nil
				end
			end
		end

		Wait(1000)
	end
end)