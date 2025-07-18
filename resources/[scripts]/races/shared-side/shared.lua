-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
ResultFinish = 5
ColourMarker = 77
RankingTablet = 10
SecondsResult = 5000
SecondsExplode = 5000
PropFlags = "prop_beachflag_01"
PropTyre = "prop_offroad_tyres02"
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUTES
-----------------------------------------------------------------------------------------------------------------------------------------
Routes = {
	{
		Time = 275,
		Runners = 4, -- Precisa ser o mesmo número da quantidade dos Positions.
		Record = 250,
		Payment = 1675,
		Checkpoints = 44,
		Difficulty = "Fácil",
		Image = "littlebighorn.png",
		Name = "Little Bighorn Avenue",
		Init = vec4(513.24,-641.03,24.13,172.92),
		Positions = {
			vec4(514.77,-654.59,24.13,175.75),
			vec4(510.26,-653.03,24.13,175.75),
			vec4(515.19,-647.47,24.13,175.75),
			vec4(510.9,-645.66,24.13,172.92)
		},
		Coords = {
			{
				Left = vec3(498.41,-724.38,24.25),
				Center = vec3(506.0,-724.45,24.29),
				Right = vec3(513.6,-724.51,24.33),
				Distance = 6.08
			},{
				Left = vec3(482.24,-817.27,24.99),
				Center = vec3(481.97,-824.87,24.97),
				Right = vec3(481.7,-832.46,24.96),
				Distance = 6.08
			},{
				Left = vec3(398.7,-835.81,28.8),
				Center = vec3(406.25,-836.73,28.72),
				Right = vec3(413.79,-837.65,28.64),
				Distance = 6.08
			},{
				Left = vec3(260.03,-888.5,28.43),
				Center = vec3(275.07,-893.0,28.42),
				Right = vec3(290.11,-897.51,28.41),
				Distance = 12.56
			},{
				Left = vec3(200.98,-1020.1,28.74),
				Center = vec3(196.28,-1033.4,28.76),
				Right = vec3(191.58,-1046.69,28.78),
				Distance = 11.28
			},{
				Left = vec3(6.82,-946.11,28.8),
				Center = vec3(2.1,-958.76,28.8),
				Right = vec3(-2.61,-971.41,28.8),
				Distance = 10.8
			},{
				Left = vec3(-65.06,-991.25,28.6),
				Center = vec3(-50.1,-996.93,28.6),
				Right = vec3(-35.15,-1002.61,28.6),
				Distance = 12.8
			},{
				Left = vec3(-143.68,-1127.09,24.04),
				Center = vec3(-143.5,-1140.39,24.06),
				Right = vec3(-143.31,-1153.69,24.07),
				Distance = 10.64
			},{
				Left = vec3(-338.36,-1123.32,26.42),
				Center = vec3(-339.78,-1136.54,26.49),
				Right = vec3(-341.21,-1149.76,26.57),
				Distance = 10.64
			},{
				Left = vec3(-485.14,-1082.02,24.4),
				Center = vec3(-489.71,-1094.51,24.49),
				Right = vec3(-494.29,-1107.0,24.58),
				Distance = 10.64
			},{
				Left = vec3(-554.33,-1141.54,19.57),
				Center = vec3(-544.35,-1144.1,19.52),
				Right = vec3(-534.38,-1146.67,19.48),
				Distance = 8.24
			},{
				Left = vec3(-648.4,-1324.42,10.08),
				Center = vec3(-637.83,-1328.13,10.06),
				Right = vec3(-627.27,-1331.85,10.03),
				Distance = 8.96
			},{
				Left = vec3(-663.24,-1417.11,10.07),
				Center = vec3(-649.96,-1417.8,10.06),
				Right = vec3(-636.67,-1418.49,10.06),
				Distance = 10.64
			},{
				Left = vec3(-712.21,-1507.73,11.75),
				Center = vec3(-704.71,-1509.87,11.68),
				Right = vec3(-697.21,-1512.0,11.61),
				Distance = 6.24
			},{
				Left = vec3(-868.64,-1716.03,18.52),
				Center = vec3(-863.18,-1721.61,18.5),
				Right = vec3(-857.73,-1727.18,18.48),
				Distance = 6.24
			},{
				Left = vec3(-1075.3,-1922.26,12.53),
				Center = vec3(-1069.92,-1927.91,12.52),
				Right = vec3(-1064.55,-1933.56,12.5),
				Distance = 6.24
			},{
				Left = vec3(-946.44,-2177.85,8.33),
				Center = vec3(-940.88,-2172.37,8.37),
				Right = vec3(-935.32,-2166.9,8.41),
				Distance = 6.24
			},{
				Left = vec3(-677.15,-2354.16,12.77),
				Center = vec3(-682.95,-2348.94,12.71),
				Right = vec3(-688.75,-2343.73,12.66),
				Distance = 6.24
			},{
				Left = vec3(-514.43,-2167.06,7.03),
				Center = vec3(-520.39,-2162.04,7.07),
				Right = vec3(-526.36,-2157.01,7.1),
				Distance = 6.24
			},{
				Left = vec3(-390.89,-2161.64,9.66),
				Center = vec3(-391.62,-2153.88,9.75),
				Right = vec3(-392.35,-2146.11,9.83),
				Distance = 6.24
			},{
				Left = vec3(-150.67,-2184.0,9.66),
				Center = vec3(-153.24,-2176.64,9.73),
				Right = vec3(-155.82,-2169.27,9.8),
				Distance = 6.24
			},{
				Left = vec3(12.05,-2045.89,9.7),
				Center = vec3(4.25,-2045.91,9.75),
				Right = vec3(-3.55,-2045.93,9.79),
				Distance = 6.24
			},{
				Left = vec3(-127.98,-1933.42,23.12),
				Center = vec3(-133.13,-1939.27,23.06),
				Right = vec3(-138.28,-1945.13,23.0),
				Distance = 6.24
			},{
				Left = vec3(-234.02,-1835.43,29.03),
				Center = vec3(-242.97,-1831.7,28.79),
				Right = vec3(-251.92,-1827.97,28.55),
				Distance = 7.76
			},{
				Left = vec3(-186.23,-1806.12,29.36),
				Center = vec3(-194.85,-1792.64,29.26),
				Right = vec3(-203.47,-1779.16,29.16),
				Distance = 12.8
			},{
				Left = vec3(-18.36,-1716.46,28.74),
				Center = vec3(-23.11,-1704.57,28.74),
				Right = vec3(-27.86,-1692.69,28.75),
				Distance = 10.24
			},{
				Left = vec3(117.56,-1646.26,28.68),
				Center = vec3(111.11,-1634.75,28.73),
				Right = vec3(104.65,-1623.24,28.78),
				Distance = 10.56
			},{
				Left = vec3(208.15,-1624.58,28.67),
				Center = vec3(214.89,-1618.76,28.71),
				Right = vec3(221.62,-1612.94,28.76),
				Distance = 7.12
			},{
				Left = vec3(343.13,-1735.85,29.0),
				Center = vec3(348.59,-1728.82,28.78),
				Right = vec3(354.05,-1721.8,28.55),
				Distance = 7.12
			},{
				Left = vec3(444.36,-1819.96,27.36),
				Center = vec3(449.44,-1814.17,27.39),
				Right = vec3(454.52,-1808.38,27.42),
				Distance = 6.16
			},{
				Left = vec3(500.48,-1771.44,28.02),
				Center = vec3(493.14,-1773.76,27.95),
				Right = vec3(485.8,-1776.08,27.88),
				Distance = 6.16
			},{
				Left = vec3(527.59,-1694.86,28.68),
				Center = vec3(518.39,-1694.89,28.69),
				Right = vec3(509.19,-1694.92,28.7),
				Distance = 7.36
			},{
				Left = vec3(423.99,-1580.18,28.63),
				Center = vec3(418.87,-1586.06,28.73),
				Right = vec3(413.75,-1591.95,28.82),
				Distance = 6.24
			},{
				Left = vec3(103.12,-1326.75,28.73),
				Center = vec3(88.36,-1335.38,28.74),
				Right = vec3(73.59,-1344.0,28.75),
				Distance = 13.68
			},{
				Left = vec3(92.33,-1074.85,28.71),
				Center = vec3(78.26,-1068.59,28.81),
				Right = vec3(64.19,-1062.33,28.91),
				Distance = 12.32
			},{
				Left = vec3(173.34,-818.49,30.55),
				Center = vec3(161.37,-823.82,30.57),
				Right = vec3(149.41,-829.15,30.59),
				Distance = 10.48
			},{
				Left = vec3(-70.64,-712.59,33.03),
				Center = vec3(-73.7,-719.65,33.42),
				Right = vec3(-76.76,-726.7,33.8),
				Distance = 6.16
			},{
				Left = vec3(-81.5,-651.22,35.76),
				Center = vec3(-95.83,-645.87,35.78),
				Right = vec3(-110.17,-640.51,35.79),
				Distance = 12.24
			},{
				Left = vec3(-14.33,-450.66,40.02),
				Center = vec3(-29.82,-445.25,40.02),
				Right = vec3(-45.3,-439.84,40.03),
				Distance = 13.12
			},{
				Left = vec3(68.24,-201.37,53.56),
				Center = vec3(60.68,-198.2,53.65),
				Right = vec3(53.12,-195.02,53.74),
				Distance = 6.56
			},{
				Left = vec3(120.44,-64.78,66.1),
				Center = vec3(112.92,-62.05,66.28),
				Right = vec3(105.4,-59.32,66.45),
				Distance = 6.4
			},{
				Left = vec3(198.59,148.55,102.77),
				Center = vec3(188.74,152.17,102.68),
				Right = vec3(178.88,155.8,102.59),
				Distance = 8.4
			},{
				Left = vec3(265.87,328.61,104.88),
				Center = vec3(263.41,336.12,104.91),
				Right = vec3(260.96,343.63,104.94),
				Distance = 6.32
			},{
				Left = vec3(366.95,286.27,102.74),
				Center = vec3(373.91,290.01,102.65),
				Right = vec3(380.87,293.75,102.56),
				Distance = 6.32
			}
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES
-----------------------------------------------------------------------------------------------------------------------------------------
Races = {
	{
		Global = true,
		Explode = true,
		Icon = "bomb.png",
		Name = "Detonação",
		Description = "Modo de corrida explosivo onde pilotos enfrentam não apenas a velocidade, mas também armadilhas mortais e explosivos em cada curva, transformando pistas em arenas de destruição e desafio extremo.",
		Routes = Routes
	},{
		Global = false,
		Explode = false,
		Icon = "flag.png",
		Name = "Treinamento",
		Description = "Modo de treinamento com pistas desafiadoras e feedback em tempo real ajudam pilotos a melhorar suas habilidades técnicas e estratégicas, visando a excelência na arte de conduzir um veículo.",
		Routes = Routes
	}
}