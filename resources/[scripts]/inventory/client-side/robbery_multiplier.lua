-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Multiplier) do
		exports["target"]:AddCircleZone("RobberyMultiplier:"..Number,v.Coords,0.25,{
			name = "RobberyMultiplier:"..Number,
			heading = 0.0,
			useZ = true
		},{
			shop = Number,
			Distance = 1.25,
			options = {
				{
					event = "inventory:RobberyMultiplier",
					tunnel = "server",
					label = "Roubar",
					service = v.Mode
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:EXPLOSION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Explosion")
AddEventHandler("inventory:Explosion",function(Coords)
	AddExplosion(Coords.x,Coords.y,Coords.z,2,1.0,true,false,true)
end)