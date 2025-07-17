-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("target",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Workout = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
for Number,_ in pairs(Academy) do
	GlobalState["Academy-"..Number] = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Academy(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not GlobalState["Academy-"..Number] and not Workout[Passport] then
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Cancel"] = true
		GlobalState["Academy-"..Number] = true
		Workout[Passport] = Number

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AcademyWeight(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Academy-"..Number] and Workout[Passport] == Number then
		local MaxWeight = 75
		for Permission,Multiplier in pairs({ Ouro = 60, Prata = 40, Bronze = 20 }) do
			if vRP.HasService(Passport,Permission) then
				MaxWeight = MaxWeight + Multiplier
			end
		end

		if vRP.GetWeight(Passport,true) < MaxWeight then
			vRP.UpgradeWeight(Passport,1,"+")
			TriggerClientEvent("Notify",source,"Academia","Sinto minha força alcançando novos patamares, não há limites quando se trata de determinação e dedicação.","verde",5000)
		end

		Player(source)["state"]["Buttons"] = false
		Player(source)["state"]["Cancel"] = false
		GlobalState["Academy-"..Number] = false
		Workout[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Workout[Passport] then
		GlobalState["Academy-"..Workout[Passport]] = false
		Workout[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckIn()
	local Return = false
	local source = source
	local Alimentation = false
	local Valuation,Repose = 1000,1200
	local Passport = vRP.Passport(source)
	if Passport then
		local MedicPlan = vRP.DatatableInformation(Passport,"MedicPlan")
		if MedicPlan and MedicPlan > os.time() then
			Valuation,Repose = 500,600
		end

		if vRP.Request(source,"Centro Médico","Deseja adicionar o serviço de alimentação pagando <b>$500</b>?") then
			Valuation = Valuation + 500
			Alimentation = true
		end

		if vRP.GetHealth(source) <= 100 then
			Valuation = Valuation + 500
			Repose = Repose + 600
		end

		if vRP.PaymentFull(Passport,Valuation) then
			if Alimentation then
				vRP.UpgradeThirst(Passport,25)
				vRP.UpgradeHunger(Passport,25)
			end

			TriggerEvent("Repose",source,Passport,Repose)
			Return = true
		else
			TriggerClientEvent("Notify",source,"Aviso","Dinheiro insuficiente.","amarelo",5000)
		end
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:REPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Repose")
AddEventHandler("target:Repose",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(OtherSource)
	local Keyboard = vKEYBOARD.Primary(source,"Minutos.")
	if Passport and OtherPassport and Keyboard and parseInt(Keyboard[1]) > 0 then
		TriggerClientEvent("Notify",source,"Centro Médico","Adicionou "..Keyboard[1].." minutos de repouso.","sangue",5000)
		TriggerEvent("Repose",OtherSource,OtherPassport,parseInt(Keyboard[1]) * 60)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Service")
AddEventHandler("target:Service",function(Permission)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport or not vRP.HasGroup(Passport,Permission) then
		return false
	end

	if Permission == "Policia" then
		if vRP.HasPermission(Passport,"LSPD") then
			Permission = "LSPD"
		elseif vRP.HasPermission(Passport,"SAPR") then
			Permission = "SAPR"
		elseif vRP.HasPermission(Passport,"BCSO") then
			Permission = "BCSO"
		end
	end

	vRP.ServiceToggle(source,Passport,Permission)
end)