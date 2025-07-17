-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
local Discord = {
	Connect = "",
	Disconnect = "",
	Airport = "",
	Deaths = "",
	Gemstone = "",
	Rename = "",
	Roles = "",
	Weaponskins = "",
	Marketplace = "",
	Shopping = "",
	Boxes = "",
	Battlepass = "",
	Hackers = "",
	Skin = "",
	ClearInv = "",
	Dima = "",
	God = "",
	Item = "",
	Delete = "",
	Kick = "",
	Ban = "",
	Group = "",
	AddCar = "",
	Print = "",
	Permissions = "",
	Sprays = "",
	Daily = "",
	Premium = "",
	Chest = "",
	Propertys = "",
	Crons = ""
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMBED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Embed",function(Hook,Message,source)
	PerformHttpRequest(Discord[Hook],function() end,"POST",json.encode({
		username = ServerName,
		embeds = {
			{ color = 0x2b2d31, description = Message }
		}
	}),{ ["Content-Type"] = "application/json" })

	if source then
		TriggerClientEvent("megazord:Screenshot",source,Discord[Hook])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTENT
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Content",function(Hook,Message)
	PerformHttpRequest(Discord[Hook],function() end,"POST",json.encode({
		username = ServerName,
		content = Message
	}),{ ["Content-Type"] = "application/json" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Webhook",function(Hook)
	return Discord[Hook] or ""
end)