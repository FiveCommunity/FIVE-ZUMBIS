-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("target")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Zones = {}
local Models = {}
local Focus = false
local Selected = {}
local Sucess = false
local Actived = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
local Dismantle = {
	vec3(943.23,-1497.87,30.11),
	vec3(-1172.57,-2037.65,13.75),
	vec3(-524.94,-1680.63,19.21),
	vec3(1358.14,-2095.41,52.0),
	vec3(602.47,-437.82,24.75),
	vec3(-413.86,-2179.29,10.31),
	vec3(146.51,320.62,112.14),
	vec3(520.91,169.14,99.36),
	vec3(1137.99,-794.32,57.59),
	vec3(-93.07,-2549.6,6.0),
	vec3(820.07,-488.43,30.46),
	vec3(1078.62,-2325.56,30.25),
	vec3(1204.69,-3116.71,5.50)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOWEDSOUTH
-----------------------------------------------------------------------------------------------------------------------------------------
local TowedSouth = PolyZone:Create({
	vec2(409.48,-1629.45),
	vec2(402.95,-1624.08),
	vec2(393.87,-1634.91),
	vec2(400.25,-1640.29)
},{ name = "TowedSouth" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOWEDNORTH
-----------------------------------------------------------------------------------------------------------------------------------------
local TowedNorth = PolyZone:Create({
	vec2(1992.2,3777.87),
	vec2(1974.84,3769.01),
	vec2(1966.07,3784.13),
	vec2(1983.1,3793.9)
},{ name = "TowedNorth" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tyres = {
	{ ["Bone"] = "wheel_lf", ["Index"] = 0 },
	{ ["Bone"] = "wheel_rf", ["Index"] = 1 },
	{ ["Bone"] = "wheel_lm", ["Index"] = 2 },
	{ ["Bone"] = "wheel_rm", ["Index"] = 3 },
	{ ["Bone"] = "wheel_lr", ["Index"] = 4 },
	{ ["Bone"] = "wheel_rr", ["Index"] = 5 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Fuels = {
	vec3(273.83,-1253.46,28.29),
	vec3(273.83,-1261.29,28.29),
	vec3(273.83,-1268.63,28.29),
	vec3(265.06,-1253.46,28.29),
	vec3(265.06,-1261.29,28.29),
	vec3(265.06,-1268.63,28.29),
	vec3(256.43,-1253.46,28.29),
	vec3(256.43,-1261.29,28.29),
	vec3(256.43,-1268.63,28.29),
	vec3(2680.90,3266.40,54.39),
	vec3(2678.51,3262.33,54.39),
	vec3(-2104.53,-311.01,12.16),
	vec3(-2105.39,-319.21,12.16),
	vec3(-2106.06,-325.57,12.16),
	vec3(-2097.48,-326.48,12.16),
	vec3(-2096.81,-320.11,12.16),
	vec3(-2096.09,-311.90,12.16),
	vec3(-2087.21,-312.81,12.16),
	vec3(-2088.08,-321.03,12.16),
	vec3(-2088.75,-327.39,12.16),
	vec3(-2551.39,2327.11,32.24),
	vec3(-2558.02,2326.70,32.24),
	vec3(-2558.48,2334.13,32.24),
	vec3(-2552.60,2334.46,32.24),
	vec3(-2558.77,2341.48,32.24),
	vec3(-2552.39,2341.89,32.24),
	vec3(186.97,6606.21,31.06),
	vec3(179.67,6604.93,31.06),
	vec3(172.33,6603.63,31.06),
	vec3(818.99,-1026.24,25.44),
	vec3(810.7,-1026.24,25.44),
	vec3(810.7,-1030.94,25.44),
	vec3(818.99,-1030.94,25.44),
	vec3(818.99,-1026.24,25.44),
	vec3(827.3,-1026.24,25.64),
	vec3(827.3,-1030.94,25.64),
	vec3(1207.07,-1398.16,34.39),
	vec3(1204.2,-1401.03,34.39),
	vec3(1210.07,-1406.9,34.39),
	vec3(1212.94,-1404.03,34.39),
	vec3(1178.97,-339.54,68.37),
	vec3(1186.4,-338.23,68.36),
	vec3(1184.89,-329.7,68.31),
	vec3(1177.46,-331.01,68.32),
	vec3(1175.71,-322.3,68.36),
	vec3(1183.13,-320.99,68.36),
	vec3(629.64,263.84,102.27),
	vec3(629.64,273.97,102.27),
	vec3(620.99,273.97,102.27),
	vec3(621.0,263.84,102.27),
	vec3(612.44,263.84,102.27),
	vec3(612.43,273.96,102.27),
	vec3(2588.41,358.56,107.66),
	vec3(2588.65,364.06,107.66),
	vec3(2581.18,364.39,107.66),
	vec3(2580.94,358.89,107.66),
	vec3(2573.55,359.21,107.66),
	vec3(2573.79,364.71,107.66),
	vec3(174.99,-1568.44,28.33),
	vec3(181.81,-1561.96,28.33),
	vec3(176.03,-1555.91,28.33),
	vec3(169.3,-1562.26,28.33),
	vec3(-329.81,-1471.63,29.73),
	vec3(-324.74,-1480.41,29.73),
	vec3(-317.26,-1476.09,29.73),
	vec3(-322.33,-1467.31,29.73),
	vec3(-314.92,-1463.03,29.73),
	vec3(-309.85,-1471.79,29.73),
	vec3(1786.08,3329.86,40.42),
	vec3(1785.04,3331.48,40.35),
	vec3(50.31,2778.54,57.05),
	vec3(48.92,2779.59,57.05),
	vec3(264.98,2607.18,43.99),
	vec3(263.09,2606.8,43.99),
	vec3(1035.45,2674.44,38.71),
	vec3(1043.22,2674.45,38.71),
	vec3(1043.22,2667.92,38.71),
	vec3(1035.45,2667.91,38.71),
	vec3(1209.59,2658.36,36.9),
	vec3(1208.52,2659.43,36.9),
	vec3(1205.91,2662.05,36.9),
	vec3(2539.8,2594.81,36.96),
	vec3(2001.55,3772.21,31.4),
	vec3(2003.92,3773.48,31.4),
	vec3(2006.21,3774.96,31.4),
	vec3(2009.26,3776.78,31.4),
	vec3(1684.6,4931.66,41.23),
	vec3(1690.1,4927.81,41.23),
	vec3(1705.74,6414.61,31.77),
	vec3(1701.73,6416.49,31.77),
	vec3(1697.76,6418.35,31.77),
	vec3(-97.06,6416.77,30.65),
	vec3(-91.29,6422.54,30.65),
	vec3(-1808.71,799.96,137.69),
	vec3(-1803.62,794.4,137.69),
	vec3(-1797.22,800.56,137.66),
	vec3(-1802.31,806.12,137.66),
	vec3(-1795.93,811.97,137.7),
	vec3(-1790.83,806.41,137.7),
	vec3(-1438.07,-268.69,45.41),
	vec3(-1444.5,-274.23,45.41),
	vec3(-1435.5,-284.68,45.41),
	vec3(-1429.07,-279.15,45.41),
	vec3(-732.64,-932.51,18.22),
	vec3(-732.64,-939.32,18.22),
	vec3(-724.0,-939.32,18.22),
	vec3(-724.0,-932.51,18.22),
	vec3(-715.43,-932.51,18.22),
	vec3(-715.43,-939.32,18.22),
	vec3(-532.28,-1212.71,17.33),
	vec3(-529.51,-1213.96,17.33),
	vec3(-524.92,-1216.15,17.33),
	vec3(-522.23,-1217.42,17.33),
	vec3(-518.52,-1209.5,17.33),
	vec3(-521.21,-1208.23,17.33),
	vec3(-525.8,-1206.04,17.33),
	vec3(-528.57,-1204.8,17.33),
	vec3(-72.03,-1765.1,28.53),
	vec3(-69.45,-1758.01,28.55),
	vec3(-77.59,-1755.05,28.81),
	vec3(-80.17,-1762.14,28.8),
	vec3(-63.61,-1767.93,28.27),
	vec3(-61.03,-1760.85,28.31)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	RegisterCommand("+entityTarget",TargetEnable)
	RegisterCommand("-entityTarget",TargetDisable)
	RegisterKeyMapping("+entityTarget","Interação auricular.","keyboard","LMENU")

	AddCircleZone("Trash:01",vec3(-330.36,-1564.11,25.47),0.25,{
		name = "Trash:01",
		heading = 0.0,
		useZ = true
	},{
		Distance = 1.25,
		shop = "Trasher",
		options = {
			{
				event = "inventory:Products",
				label = "Despejar Lixo",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("Trash:02",vec3(12.99,6501.61,31.84),0.25,{
		name = "Trash:02",
		heading = 0.0,
		useZ = true
	},{
		Distance = 1.25,
		shop = "Trasher",
		options = {
			{
				event = "inventory:Products",
				label = "Despejar Lixo",
				tunnel = "server"
			}
		}
	})

	AddTargetModel({ 654385216,161343630,-430989390,1096374064,-1519644200,-1932041857,207578973,-487222358 },{
		options = {
			{
				event = "slotmachine:Init",
				label = "Sentar",
				tunnel = "client"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ -832573324,-1430839454,1457690978,1682622302,402729631,-664053099,1794449327,307287994,-1323586730,111281960,-541762431,-745300483,-417505688 },{
		options = {
			{
				event = "inventory:Animals",
				label = "Esfolar",
				tunnel = "server"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -206690185,666561306,218085040,-58485588,1511880420,682791951 },{
		options = {
			{
				event = "player:enterTrash",
				label = "Esconder",
				tunnel = "client"
			},{
				event = "player:checkTrash",
				label = "Verificar",
				tunnel = "server"
			},{
				event = "chest:Open",
				label = "Abrir",
				tunnel = "entity",
				service = "Trash"
			}
		},
		Distance = 1.0
	})

	AddBoxZone("Pdm",vec3(-56.98,-1098.79,26.42),1.0,1.0,{
		name = "Pdm",
		heading = 25.52,
		minZ = 26.42 - 1.0,
		maxZ = 26.42 + 1.0
	},{
		Distance = 2.5,
		options = {
			{
				event = "pdm:Open",
				label = "Abrir",
				tunnel = "client"
			}
		}
	})

	AddTargetModel({ -1691644768,-742198632 },{
		options = {
			{
				event = "inventory:Drink",
				label = "Beber",
				tunnel = "server"
			},{
				event = "inventory:RefillGallon",
				label = "Encher Galão",
				tunnel = "server"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ 690372739 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Coffee"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -654402915,1421582485 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Donut"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ 992069095,1114264700 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Soda"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ 1129053052 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Hamburger"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -1581502570 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Hotdog"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ 73774428 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Cigarette"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -272361894 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Chihuahua"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ 1099892058 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Water"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -2007231801,1339433404,1694452750,1933174915,-462817101,-469694731,-164877493,486135101 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Fuel"
			}
		},
		Distance = 1.25
	})
		AddTargetModel( { 1898296526, 1069797899, 1434516869, -896997473, -1748303324, -1366478936, 2090224559, -52638650, 591265130, -915224107, -273279397, 322493792, 10106915, 1120812170 }, {
		options = {
			{
				event = "inventory:Carro",
				label = "Vasculhar",
				tunnel = "server"
			}
		},
		Distance = 1.0
	})
	AddTargetModel({ 
	808859815, -1106743555, -1606864033, 1004114196, 532905404, 1699403886, -1656894598, 1674107025, -88831029, -1244692252, 951767867, 1956335717, 1261149561, 1388848350, 1090617681, 379310561, -569505431, -1332260293, 1951946145, -215821512, -840346158, 1347814329, 1224306523, -1935621530, 1640504453, -1160266880, 1204772502, -855671414, 1039800368, -1519524074, -945854168, -1189032917, 1146800212, 1546450936, 549978415, 920595805, -1830296211, 664399832, 826475330, -1366884940, -1211756494, -49756853, 238774192, 1744231373, 357447289, 10751269, 786557344, -173013091, 70821038, 1371553700, 1755064960, 1348537411, 1165780219, 331645324, -1860463438, 793439294, 2111372120, 813893651, 343259175, -2109222095, -1745486195, -1514497514, 429425116, 153984193, -619494093, -951490775, 1064866854, -614546432, 1767892582, 279228114, 744758650, 1519319503, -2018356203, 1152702280, 1984313950, 1426880966, -1661836925, 1446741360, -1859912896, 435429221, -625565461, 933092024, -85696186, -1004861906, 1413662315, -781039234, -649199638, 1077785853, 2021631368, 1423699487, 1068876755, 2120901815, -106498753, 131961260, -1806291497, 1641152947, -555647618, 115168927, 330231874, -1444213182, 1809430156, 1822107721, 2064532783, -573920724, -782401935, 803106487, -578715987, -1302522190, 1561088805, 1746653202, -322270187, -1445349730, -1760377969, 1001210244, 1328415626, 1626646295, -1299428795, -1773858377, -640198516, 32417469, 193817059, 1750583735, -1620232223, -1948675910, -1023672578, -1029146878, -1952882651, 1416254276, -929103484, 516505552, 1404403376, -521758348, -150026812, 1430544400, 1268862154, -2077764712, -1051505166, -1386944600, 355916122, 539004493, 718836251, 1082572151, 238213328, 390939205, -1251702741, -2132435154, -771835772, 600300561, -408329255, -1189443908, 2114544056, -900269486, 1982350912, 1720428295, 933205398, -1697435671, -912318012, -1280051738, -1589423867, 1751120084, -1504742226, -1481174974, -969978574, -722081089, -501152491, -37334073, -12678997, 766375082, -1538846349, 377976310, 2010389054, -1434255461, -775102410, -1519253631, -1694204705, -1736970383, 891398354, -685776591, -512913663, 1358380044, 2097407511, 587703123, 349505262, 1312913862, 706935758, 767028979, -1849016788, 452351020, 696250687, 321657486, 1768677545, 810804565, 1694362237, 2007797722, 1264920838, -920443780, -2088436577, -178150202, 623927022, -2076336881, -681546704, -1044093321, -1342520604, 553826858, -417940021, -1398552374, -1007618204, -1976105999, -812470807, -1731772337, -2039163396, -1305402723, 605602864, 919005580, -1222037748, -356333586, -1675683303, -1047300121, 1264851357, 1561705728, 534725268, 835315305, -1425378987, -1779492637, -413773017, 650367097, -1755309778, 1767447799, -1267809450, -270159898, 1915268960, -1932625649, -359228352, 819699067, -1041006362, -607414220, 216536661, -2054740852, -321892375, 1870669624, 788622594, 1198698306, 1012965715, -1549575121, -1117346540, 1191403201, 1482427218, 103106535, 261428209,
	-1022036185, 1531218220, 808778210, 1145088004, 60192701, -1194552652, 1836024091, -258122199, -91572095, 1167549130, 1158606749, 1269774364, 1162230285, 22425093, 949295643, 1598839101, -1248528957, 191074589, 496317824, 1918178165, 1477887514, -72125238, 1464721716, 1129928304, 161007533, 1890499016, -1217776881, 1167167044, 1270514905, -1922568579, -1010001291, 1334976110, -872569905, 1325314544, 2023152276, 731167118, -515400693, 518814684, -1728452752, -1955548155, -1389097126, 1798879480, -544533759, 788179139, 1299047806, 512955554, 1179785778, -1064078846, -154017714, -1528782338, -1992464379, 1123963760, -2006710211, 650034742, 1397974313, -1277678289, 1545995274, 978452933, 1776856003, -1945119518, 101298480, -765011498, -357782800, -1988720319, 756308504, -680474188, 1925887591, 117698822, -1513650250, -1235461810, -367559459, 1427949869, -1979777824, 399022197, 406009421, -1196880365, -1410400252, -897293993, 1594283837, -2101379423, -933188075, 2006035933, -1931689897, 1613083234, 779177722, 71501447, 327394568, 592225333, 10366540, -1555576182, -2065959231, -1369710022, -1463670378, -890640939, -1699520669, -1538297973, 1117614067, -1249041111, -337629947, 1835399538, 949115134, -761757122, -581343889, 466359675, -1567723049, 345107131, 2120159624, -588394844, 2058033618, -396800478, -1963705054, -325152996, -1083052141, -1619099144, 1591881099, 1064198787, 1863555924, 1987160310, -482210853, 2053038501, 887084708, 1712601360, -1854205987, -1296280993, 1153203121, -1280067589, -1040164288, -199344646, -1567908307, -592375632, -1847841943, 2108278433, -682917575, 1491358515, 1373135346, -1127975477, 1928962749, -609128318, -2034106392, -1593989291, -1728841192, -1734476390, -1921063516, 1841036427, -1652965338, -943940052, 1631478380, -1059388209, -199280229, -1029737694, 1528799427, -1730657121, 1635617250, 793443893, -267695653, 2141384740, -1031795266, -2054384456, 569740212, 1634506681, -162605104, 411081129, 776079908, -1997051078, -1436281204, -1948177172, 734593052, -742733856, 1324952405, 543190380, -522462112, -1360365899, -2126242959, -902822792, -509558803, -208086447, -806300485, 1665391897, 1566545691, -567724045, -277325206, -2093814811, 1224690857, -1116269626, 520636071, -1512010208, -2145008981, 1437043119, -1585526420, -2069778150, -1589392435, 361513884, 1309468115, -44746786, 1520708641, -1130181398, -236444766, -39239064, -412008429, -1722073185, 2127932792, 1821116645, 1020431539, -166363761, -1176698112, 275618457, 2119136831, -9308122, 620276966, 80921836, -754777973, 1642910562, 891945583, -1807124056, 1466037421, 1226102803, 565446671, 662575004, -971278255, -1739285308, 396172111, -984709238, 1752208920, -198252413, 588969535, 599294057, -398748745, -613248456, -2077218039, 611648169, -1880237687, 2093736314, 1330042375, 1032073858, 850468060, -1109568186, 653210662, 832784782, -1773333796, 1329576454, -1561829034, -1872961334, 663522487, 846439045, 62440720, -48477765, 228715206, 994527967, 193469166, -1715797768, 1074457665, -109594583, 1855569864, 610988552, 1183124263, 927014855, 1830688247, 1206185632, 999842350, -821268425, -2019608977, 2129936603, -1206698129, -559488763, 2100370963, -52268862, -616450833, -1492432238, -1868718465, 797459875, -994634286, 1943113851, 1464257942, -1113448868, 28135809, -1529370981, 1574377635, -1886323690, -372985740, -604039959, -1733259699, -1111799518, 1633872967, -401698464, -1422444081, -1844443263, -2063996617, 1975732938, -520477356, -618860476, 1818503341, 1240128502, -156001325, -2054645053, -1427838341, 678319271, 1825562762, -1660909656, -429715051, 1182012905, 365775923, -244824852, -2113195075, 1952555184, -86969715, -75756443, 914073350, 400495475, -1237168065, -73600578, -1714117555, 1241432569, -1808665269, 2123514453, 795497466, 1194880004, -1322513804, -1507505719, -1674727288, -872673803, -1602228847, 520923037, 205318924, 905946442, 435539666, -932795467, -795819184, 988062523, -1313761614, -485249910, 944592636, 1344679353, -2078561997, -280253649, 1067129421, 1858893999, -20018299, -1664379255, 1520835918, -1249529321, 1704428387, -259821216, -675159375, -2132402289, 2017183759, -1076715213, -837606178, 772427594, -492622232, 1866942414, 1562223483, 322310057, -2140247524, -1315717782, -34187730, 590182749, 2040422902, 1011548258, 225287241, 2050158196, 1283622549, 1457317744, 257763003, -308279251, 1135976220, 1459905209, -2077375786, 1937203007, -800592322, 1043886488, -1105179493, 658984954, -2016771922, -518348876, 2040438510, 507392637, -346957479, -1484715741, 1530648845, -666714478, -1612882478, -868827412, 1706635382, 421830750, -538688539, -2063317268, 1302784073, 1849883942, 2013139108, 1401530684, 666718676, -938608286, -131188087, -52653814, -239294183, -46035440, 411185872, -1552967674, 1224757029, 1005070462, 1581050842, 482489509, 1590147279, 1349590050, -1080659212, -1513259816, -886023758, 2018483349, 761115490, 952584644, -1358701087, 939183526, -1747893069, -67533719, -304305299, 503621995, 946007720, 595139263, -568861381, -1124046095, 74809322, -927525251, 1906124788, -283816889, 1006915658, 1625728984, 768005095, 1641334641, 648372919, 1042644412, 357551935, -1717894970, -2051496907, -982642292, -1022276431, -2055174042, -2041653618, 183230355, 645279998, 1681385341, 666086773, -449965460, 1165307954, -554721426, -424905564, 940330470, -350789612, -709209345, 2086307585, 1024089777, 1476581877, -1689993, 793664635, 924556713, 1283141381, -508849828, -2034368986, -633610776, 991486725, 941695432, 915948376, -493049219, -466345309, -409745176, 1182156569, 226559113, -597926235, 1506159504, 2089096292, -466413665, -1573167273, 1728056212, -1812018217, 55858852, -847807830, -892841148, 761829301, -566941131, 1461287021, 1382414087, 1511543927, -2089065250, -100858228, -843935326, 736659122, 197443027, 363712933, 1764259993, -1835459726, 1108376739, 1850188817, 1608114028, 188012277, 2139205821, 848542158, 606876839, -1007230075, 1264941816, -1215761931, 1943971979, 1126998116, 1500695792, 2014985464, -1667301416, 431423238, -760054079, -785842275, 695248020, -1301974109, 1822283721, 1173958009, -1676424299, -933295480, 1297520375, -1057787465, 1456705429, -1739208332, 1161072059, 1048844220, 866411749, 1558115333, 1631482011, 1885233650, -995747907, 943915367, -306958529, -287649847, -634611634, -140033735, 921328393, 1099321454, -1853959079, -839953400, -1357857450, -1692214353, -1686040670, 225514697, 12394276, 373000027, -527186490, -1046731678, -1371020112, -1051349824, 824925120, -449373294, 1567728751, 2014052797, 1250841910, -1025304054, -1131233579, -1054459573, 1438999163, 368603149, 1777626099, 42647445, 348382215, 51789996, -715445259, 587253782, -1614285257, -1420211530, 1096929346, -1452399100, 1055701597, 1381498905, 1846523796, 1544875514, -2063419726, 233415434, -1782092083, 1669696074, 68070371, -261389155, 109850898, 173935423, -1613485779, 1376128402, -907676309, -1214099228, -427708766, 788443093, 1650288984, 436345731, 1762753038, 349680864, -730659924, 1547070595, -306416314, 653289389, 2072724299, -1871394224, -1453933154, 1240094341, 411102470, 1099825042, -606915623, -245247470, 691061163, 518696223, 1442749254, 985359552, -1452549652, -1635724594, -570394627, -610530921, 1985653476, 2124742566, -220552467, -265970301, 1684083350, -664900312, -407694286, -1286380898, -413447396, -163714847, 1650036788, 1936142927, 1456041926, -1697018471, -681004504, 451459928, 2035992488, 469792763, -829353047, -1615763160, -475853889, -569850864, -556406421, -1005108245, 1498487404, -1614577886, -792862442, 660117393, -1382092357, 1644266841, -1643617475, 1657546978, -1306051250, -442429178, 189425762, -1275859404, 1349953339, -654717625, 337826907, 261586155, 71929310, 1299424319, -673538407, -973145378, 1581098148, -459818001, -1688898956, -2039072303, 579932932, 1976765073, -175076858, 1097048408, -1229853272, -294281201, 815693290, 1939545845, 1702441027, 1490458366, 1925237458, 1021093698, 1209091352, -1422914553, 1596003233, -1313105063, -277793362, -1067576423, -1320879687, 1846684678, -1837161693, -1920001264, -905948951, 999748158, -1387498932, 1221043248, -1575488699, -1094177627, 1426951581, 1142162924, -1105135100, 1762949645, 1057201338, -2056455422, 762327283, -1156746507, 338154536, 773063444, 223828550, -671910391, 1095737979, -340063052, -1576494617, 1415150394, -1664281608, 894928436, -988619485, -1791002229, -96953009, -1230338610, -1670377315, 228356856, 222643882, 130590395, -1394433551, -1768198658, -254493138, 967594628, 1573528872, 602513566, 1823868411, -756833660, 1535236204, 450271392, -252946718, -1022961931, 1984382277, -1751606120, -133862795, 1646160893, 712602007, 874722259, 728636342, 1169888870, -1001079621, -835930287, -1395868234, -422822692, -1614075238, 479578891, -2114499097, 1888624839, -829029621, 1624626906, -1408326184, 1813637474, -1767998346, -1871275377, -1931041674, -751898707, -106226549, 732742363, 1189322339, -1709285806, 1787764635, -257153498, -815646164, -636391810, 1380197501, -1954728090, -144649940, 610290475, -1799184321, 2145640135, 755956971, 1443057394, -92584602, 2145639711, -2051422616, 1278330017, -961242577, -1289578670, -264140789, 880829941, -1863364300,
	-1556023849, 2109968527, -927261102, 1191548746, 1346941736, 921110016, -598109171, 2073775040, -2057423197, 1011059922, 1794381917, -848871003, -1852518909, -1800524916, -76805225, -1404353274
	},{
		options = {
			{
				event = "inventory:Zombies",
				label = "Vasculhar",
				tunnel = "server"
			}
		},
		Distance = 1.25
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLEACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function DisableActions()
	if Focus then
		DisableControlAction(0,1,true)
		DisableControlAction(0,2,true)
	end

	DisableControlAction(0,18,true)
	DisableControlAction(0,55,true)
	DisableControlAction(0,76,true)
	DisableControlAction(0,22,true)
	DisableControlAction(0,23,true)
	DisableControlAction(0,24,true)
	DisableControlAction(0,25,true)
	DisableControlAction(0,75,true)
	DisableControlAction(0,140,true)
	DisableControlAction(0,141,true)
	DisableControlAction(0,142,true)
	DisableControlAction(0,143,true)
	DisableControlAction(0,243,true)
	DisableControlAction(0,257,true)
	DisableControlAction(0,263,true)
	DisableControlAction(0,311,true)
	DisableControlAction(0,102,true)
	DisableControlAction(0,179,true)
	DisableControlAction(0,203,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function TargetEnable()
	local Ped = PlayerPedId()
	if LocalPlayer["state"]["Arena"] or LocalPlayer["state"]["Cancel"] or LocalPlayer["state"]["ItemCamera"] or LocalPlayer["state"]["Freecam"] or LocalPlayer["state"]["Carry"] or not LocalPlayer["state"]["Active"] or IsPauseMenuActive() or exports["lb-phone"]:IsOpen() or not MumbleIsConnected() or LocalPlayer["state"]["Buttons"] or LocalPlayer["state"]["Commands"] or LocalPlayer["state"]["Handcuff"] or Sucess or IsPedInAnyVehicle(Ped) then
		return
	end

	Actived = true
	SendNUIMessage({ Action = "Open" })

	while Actived do
		DisableActions()

		local Coords = GetEntityCoords(Ped)
		local HitCoords,Entitys,EntityHit = RayCastGamePlayCamera()

		for Index,v in pairs(Zones) do
			if #(Coords - Zones[Index]["center"]) <= 5 then
				SetDrawOrigin(Zones[Index]["center"]["x"],Zones[Index]["center"]["y"],Zones[Index]["center"]["z"])
				DrawSprite("Textures","Normal",0.0,0.0,0.02,0.02 * GetAspectRatio(false),0.0,255,255,255,255)
				ClearDrawOrigin()
			end

			if Zones[Index]:isPointInside(HitCoords) and #(Coords - Zones[Index]["center"]) <= v["targetoptions"]["Distance"] then
				if v["targetoptions"]["shop"] then
					Selected = v["targetoptions"]["shop"]
				end

				SendNUIMessage({ Action = "Valid", data = Zones[Index]["targetoptions"]["options"] })

				Sucess = true
				while Sucess do
					SetDrawOrigin(Zones[Index]["center"]["x"],Zones[Index]["center"]["y"],Zones[Index]["center"]["z"])
					DrawSprite("Textures","Selected",0.0,0.0,0.02,0.02 * GetAspectRatio(false),0.0,255,255,255,255)
					ClearDrawOrigin()
					DisableActions()

					if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
						SetCursorLocation(0.5,0.5)
						SetNuiFocus(true,true)
						Focus = true
					end

					local Ped = PlayerPedId()
					local OtherCoords = RayCastGamePlayCamera()
					if not Zones[Index]:isPointInside(OtherCoords) or #(GetEntityCoords(Ped) - Zones[Index]["center"]) > v["targetoptions"]["Distance"] then
						SendNUIMessage({ Action = "Left" })
						Sucess = false
					end

					Wait(1)
				end
			end
		end

		if EntityHit and GetEntityType(Entitys) ~= 0 then
			if LocalPlayer["state"]["Admin"] and IsControlJustPressed(1,38) then
				TriggerServerEvent("admin:Doords",GetEntityCoords(Entitys),GetEntityModel(Entitys),GetEntityHeading(Entitys))
			end

			if IsEntityAVehicle(Entitys) and GetEntityHealth(Ped) > 100 and #(Coords - HitCoords) <= 1.0 then
				local Menu = {}
				local Network = nil
				local Combustivel = false
				local Vehicle = GetLastDrivenVehicle()

				SetEntityAsMissionEntity(Entitys,true,true)
				if NetworkGetEntityIsNetworked(Entitys) then
					Network = NetworkGetNetworkIdFromEntity(Entitys)
				end

				Selected = { GetVehicleNumberPlateText(Entitys),GetEntityArchetypeName(Entitys),Entitys,Network,GetEntityModel(Entitys),false }

				for _,v in pairs(Fuels) do
					if #(Coords - v) <= 2.5 then
						Combustivel = true
						break
					end
				end

				if not Combustivel then
					if GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_PETROLCAN") then
						Selected[6] = true
						Menu[#Menu + 1] = { event = "engine:Supply", label = "Abastecer", tunnel = "client" }
					else
						if (TowedSouth:isPointInside(HitCoords) or TowedNorth:isPointInside(HitCoords)) and not Entity(Entitys)["state"]["Tow"] then
							Menu[#Menu + 1] = { event = "towed:Payment", label = "Entregar", tunnel = "paramedic" }
						else
							local Lockpick = Entity(Entitys)["state"]["Lockpick"]
							if Lockpick then
								if GetVehicleDoorLockStatus(Entitys) <= 1 and GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_WRENCH") then
									for Index = 1,#Tyres do
										local BoneIndex = GetEntityBoneIndexByName(Entitys,Tyres[Index]["Bone"])
										local TyreCoords = GetWorldPositionOfEntityBone(Vehicle,BoneIndex)
										if #(Coords - TyreCoords) <= 1.0 then
											Selected[6] = Tyres[Index]["Index"]
											Menu[#Menu + 1] = { event = "inventory:RemoveTyres", label = "Retirar Pneu", tunnel = "server" }
										end
									end
								end

								if not IsPedArmed(Ped,7) and GetVehicleDoorLockStatus(Entitys) <= 1 then
									if VehicleWeight(Selected[2]) > 0 then
										Menu[#Menu + 1] = { event = "trunkchest:openTrunk", label = "Abrir Porta-Malas", tunnel = "server" }
									end

									Menu[#Menu + 1] = { event = "inventory:ChangePlate", label = "Trocar Placa", tunnel = "server" }

									if Lockpick and Lockpick == LocalPlayer["state"]["Passport"] then
										Menu[#Menu + 1] = { event = "garages:Key", label = "Chave Veícular", tunnel = "server" }
									end
								end

								Menu[#Menu + 1] = { event = "engine:Vehrify", label = "Verificar", tunnel = "client" }
							else
								if GetEntityBoneIndexByName(Entitys,"boot") ~= -1 and IsVehicleSeatFree(Entitys,-1) and GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_CROWBAR") then
									Menu[#Menu + 1] = { event = "inventory:StealTrunk", label = "Arrombar Porta-Malas", tunnel = "server" }
								end

								if Selected[2] == "stockade" then
									Menu[#Menu + 1] = { event = "inventory:Stockade", label = "Vasculhar", tunnel = "server" }
								end
							end

							if not IsThisModelABike(Selected[5]) then
								local Rolling = GetEntityRoll(Entitys)
								if Rolling > 75.0 or Rolling < -75.0 then
									Menu[#Menu + 1] = { event = "player:RollVehicle", label = "Desvirar", tunnel = "server" }
								end

								if GetEntityBoneIndexByName(Entitys,"boot") ~= -1 and not IsPedArmed(Ped,7) and GetVehicleDoorLockStatus(Entitys) <= 1 then
									Menu[#Menu + 1] = { event = "player:checkTrunk", label = "Checar Porta-Malas", tunnel = "server" }
									Menu[#Menu + 1] = { event = "player:enterTrunk", label = "Entrar no Porta-Malas", tunnel = "client" }
								end
							end

							if GetEntityArchetypeName(Vehicle) == "flatbed" and Selected[2] ~= "flatbed" then
								Menu[#Menu + 1] = { event = "inventory:Tow", label = "Rebocar", tunnel = "client" }
							end

							if CheckPolice() then
								Menu[#Menu + 1] = { event = "towed:Impound", label = "Impound", tunnel = "server" }

								if GetResourceState("mdt") == "started" then
									Menu[#Menu + 1] = { event = "mdt:Vehicle", label = "Apreender", tunnel = "server" }
								else
									Menu[#Menu + 1] = { event = "prison:Vehicle", label = "Apreender", tunnel = "server" }
								end
							else
								for _,v in pairs(Dismantle) do
									if #(Coords - v) <= 15 then
										Menu[#Menu + 1] = { event = "inventory:Dismantle", label = "Desmanchar", tunnel = "server" }
										break
									end
								end
							end
						end
					end
				else
					Menu[#Menu + 1] = { event = "engine:Supply", label = "Abastecer", tunnel = "client" }
				end

				if #Menu >= 1 then
					SendNUIMessage({ Action = "Valid", data = Menu })

					Sucess = true
					while Sucess do
						DisableActions()

						if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
							SetCursorLocation(0.5,0.5)
							SetNuiFocus(true,true)
							Focus = true
						end

						local Ped = PlayerPedId()
						local OtherCoords,OtherEntity = RayCastGamePlayCamera()
						if GetEntityType(OtherEntity) == 0 or #(GetEntityCoords(Ped) - OtherCoords) > 1.0 then
							SendNUIMessage({ Action = "Left" })
							Sucess = false
						end

						Wait(1)
					end
				end
			elseif IsPedAPlayer(Entitys) and GetEntityHealth(Ped) > 100 and #(Coords - HitCoords) <= 2.0 then
				local Menu = {}
				local Index = NetworkGetPlayerIndexFromPed(Entitys)
				local source = GetPlayerServerId(Index)

				Selected = { source }

				Menu[#Menu + 1] = { event = "inspect:Player", label = "Revistar", tunnel = "paramedic" }
				Menu[#Menu + 1] = { event = "paramedic:Diagnostic", label = "Informações", tunnel = "paramedic" }

				if GetEntityHealth(Entitys) <= 100 then
					if Player(source)["state"]["Crawl"] then
						Menu[#Menu + 1] = { event = "paramedic:Adrenaline", label = "Ajudar", tunnel = "paramedic" }
					end

					if LocalPlayer["state"]["Paramedico"] then
						Menu[#Menu + 1] = { event = "paramedic:Revive", label = "Reanimar", tunnel = "paramedic" }
					end
				else
					Menu[#Menu + 1] = { event = "player:Demand", label = "Cobrança", tunnel = "paramedic" }

					if IsEntityPlayingAnim(Entitys,"random@mugging3","handsup_standing_base",3) then
						Menu[#Menu + 1] = { event = "player:checkShoes", label = "Roubar Sapatos", tunnel = "paramedic" }
					end

					if LocalPlayer["state"]["Paramedico"] then
						Menu[#Menu + 1] = { event = "paramedic:Treatment", label = "Tratamento", tunnel = "paramedic" }
						Menu[#Menu + 1] = { event = "paramedic:Bandage", label = "Passar Ataduras", tunnel = "paramedic" }
						Menu[#Menu + 1] = { event = "paramedic:presetBurn", label = "Roupa de Queimadura", tunnel = "paramedic" }
						Menu[#Menu + 1] = { event = "paramedic:presetPlaster", label = "Colocar Gesso", tunnel = "paramedic" }
						Menu[#Menu + 1] = { event = "paramedic:extractBlood", label = "Extrair Sangue", tunnel = "paramedic" }
						Menu[#Menu + 1] = { event = "target:Repose", label = "Repouso", tunnel = "paramedic" }
					end
				end

				if CheckPolice() then
					Menu[#Menu + 1] = { event = "prison:Itens", label = "Apreender", tunnel = "paramedic" }
				end

				if #Menu >= 1 then
					SendNUIMessage({ Action = "Valid", data = Menu })

					Sucess = true
					while Sucess do
						DisableActions()

						if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
							SetCursorLocation(0.5,0.5)
							SetNuiFocus(true,true)
							Focus = true
						end

						local Ped = PlayerPedId()
						local OtherCoords,OtherEntity = RayCastGamePlayCamera()
						if GetEntityType(OtherEntity) == 0 or #(GetEntityCoords(Ped) - OtherCoords) > 2.0 then
							SendNUIMessage({ Action = "Left" })
							Sucess = false
						end

						Wait(1)
					end
				end
			else
				for Index,_ in pairs(Models) do
					if DoesEntityExist(Entitys) and Index == GetEntityModel(Entitys) then
						local OtherCoords = GetEntityCoords(Entitys)
						if #(Coords - OtherCoords) <= 5 then
							SetDrawOrigin(OtherCoords["x"],OtherCoords["y"],OtherCoords["z"] + 1)
							DrawSprite("Textures","Normal",0.0,0.0,0.02,0.02 * GetAspectRatio(false),0.0,255,255,255,255)
							ClearDrawOrigin()
						end

						if #(Coords - HitCoords) <= Models[Index]["Distance"] then
							if not IsEntityAMissionEntity(Entitys) then
								SetEntityAsMissionEntity(Entitys,true,true)
							end

							local Network = nil
							if NetworkGetEntityIsNetworked(Entitys) then
								Network = NetworkGetNetworkIdFromEntity(Entitys)
							end

							Selected = { Entitys,Index,Network,GetEntityCoords(Entitys),IsEntityDead(Entitys) }

							SendNUIMessage({ Action = "Valid", data = Models[Index]["options"] })

							Sucess = true
							while Sucess do
								local EntityCoords = GetEntityCoords(Entitys)

								SetDrawOrigin(EntityCoords["x"],EntityCoords["y"],EntityCoords["z"] + 1)
								DrawSprite("Textures","Selected",0.0,0.0,0.02,0.02 * GetAspectRatio(false),0.0,255,255,255,255)
								ClearDrawOrigin()
								DisableActions()

								if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
									SetCursorLocation(0.5,0.5)
									SetNuiFocus(true,true)
									Focus = true
								end

								local Ped = PlayerPedId()
								local OtherCoords,OtherEntity = RayCastGamePlayCamera()
								if GetEntityType(OtherEntity) == 0 or #(GetEntityCoords(Ped) - OtherCoords) > Models[Index]["Distance"] then
									SendNUIMessage({ Action = "Left" })
									Sucess = false
								end

								Wait(1)
							end
						end
					end
				end
			end
		end

		Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ROLLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:RollVehicle")
AddEventHandler("target:RollVehicle",function(Network)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			SetVehicleOnGroundProperly(Vehicle)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function TargetDisable()
	if Focus or not Actived then
		return false
	end

	TriggerEvent("target:Debug")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Select",function(Data,Callback)
	TriggerEvent("target:Debug")

	if not LocalPlayer["state"]["Cancel"] then
		if Data["tunnel"] == "client" then
			TriggerEvent(Data["event"],Selected,Data["service"])
		elseif Data["tunnel"] == "entity" then
			TriggerEvent(Data["event"],Selected[1],Data["service"])
		elseif Data["tunnel"] == "products" then
			TriggerEvent(Data["event"],Data["service"])
		elseif Data["tunnel"] == "server" then
			TriggerServerEvent(Data["event"],Selected,Data["service"])
		elseif Data["tunnel"] == "paramedic" then
			TriggerServerEvent(Data["event"],Selected[1],Data["service"])
		elseif Data["tunnel"] == "proserver" then
			TriggerServerEvent(Data["event"],Data["service"])
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	TriggerEvent("target:Debug")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Debug")
AddEventHandler("target:Debug",function()
	Focus = false
	Sucess = false
	Actived = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Close" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCOORDSFROMCAM
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCoordsFromCam(Distance,Coords)
	local Rotation = GetGameplayCamRot()
	local Adjuste = vec3((math.pi / 180) * Rotation["x"],(math.pi / 180) * Rotation["y"],(math.pi / 180) * Rotation["z"])
	local Direction = vec3(-math.sin(Adjuste[3]) * math.abs(math.cos(Adjuste[1])),math.cos(Adjuste[3]) * math.abs(math.cos(Adjuste[1])),math.sin(Adjuste[1]))

	return vec3(Coords[1] + Direction[1] * Distance, Coords[2] + Direction[2] * Distance, Coords[3] + Direction[3] * Distance)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAYCASTGAMEPLAYCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
function RayCastGamePlayCamera()
	local Ped = PlayerPedId()
	local Cam = GetGameplayCamCoord()
	local Cam2 = GetCoordsFromCam(10.0,Cam)
	local Handle = StartExpensiveSynchronousShapeTestLosProbe(Cam,Cam2,-1,Ped,4)
	local Hit,__,Coords,_,Entitys = GetShapeTestResult(Handle)

	return Coords,Entitys,Hit
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddCircleZone(Name,Center,Radius,Options,Target)
	Zones[Name] = CircleZone:Create(Center,Radius,Options)
	Zones[Name]["targetoptions"] = Target
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function RemCircleZone(Name)
	if Zones[Name] then
		Zones[Name]:destroy()
		Zones[Name] = nil
	end

	if Sucess then
		TriggerEvent("target:Debug")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTARGETMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function AddTargetModel(Model,Options)
	for _,v in pairs(Model) do
		Models[v] = Options
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function LabelText(Name,Text)
	if Zones[Name] then
		Zones[Name]["targetoptions"]["options"][1]["label"] = Text
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function LabelOptions(Name,Text)
	if Zones[Name] then
		Zones[Name]["targetoptions"]["options"] = Text
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBOXZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddBoxZone(Name,Center,Length,Width,Options,Target)
	Zones[Name] = BoxZone:Create(Center,Length,Width,Options)
	Zones[Name]["targetoptions"] = Target
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("LabelText",LabelText)
exports("AddBoxZone",AddBoxZone)
exports("LabelOptions",LabelOptions)
exports("RemCircleZone",RemCircleZone)
exports("AddCircleZone",AddCircleZone)
exports("AddTargetModel",AddTargetModel)