-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface('painel', Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Avatar = {}
local Permission = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPARTMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Department(Group)
    local source = source
    local Passport = vRP.Passport(source)
	Permission[Passport] = Passport and Group and vRP.HasPermission(Passport, Group) and Group or false
    return Permission[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Player()
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
    local Hierarchy, Name = vRP.HasPermission(Passport, Permission)

    local Permissions = Config.OtherPermissions[Permission] and Config.OtherPermissions[Permission][Hierarchy] or Config.Permissions
    
    local Avatars = exports['oxmysql']:single_async('SELECT Image FROM avatars WHERE Passport = ?', {Passport})
    local Avatar = Avatars and Avatars.Image or vRP.DiscordAvatar(Passport)

    local Departments = { { Max = vRP.Permissions(Permission, 'Members'), Name = Name, Hierarchy = vRP.Hierarchy(Permission) }, { Level = Hierarchy, Passport = Passport, Name = vRP.FullName(Passport), Avatar = Avatar }, Permissions }
    
    return Departments
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.User(Target)
    local source = source
    local UserPassport = vRP.Passport(source)
    local Permission = Permission[UserPassport]
    local Hierarchy = vRP.HasPermission(UserPassport,Permission)

    if not Config.Permissions.Paramedic.View == Hierarchy then
        TriggerClientEvent("painel:Notify", source, "Erro", "Você não possui permissões necessárias.", "vermelho")
        return false
    end

    local Records = exports['oxmysql']:query_async('SELECT id AS Id, Timestamp AS Date, Doctor FROM painel_creative_paramedic WHERE Passport = ? ORDER BY Timestamp DESC', { Target })

    local AvatarData = exports['oxmysql']:single_async('SELECT Image FROM avatars WHERE Passport = ?', { Target })
    local Avatar = AvatarData and AvatarData.Image or vRP.DiscordAvatar(Target)

    local MedicPlan = exports['oxmysql']:single_async('SELECT Medic FROM characters WHERE id = ?', { Target })

    for i = 1, #Records do
        Records[i].Doctor = vRP.FullName(Records[i].Doctor)
    end

    return { { Passport = Target, Name = vRP.FullName(Target), Phone = vRP.Phone(Target) or "N/A", Gender = vRP.Identity(Target).Sex or "N/A", Blood = Sanguine(vRP.Identity(Target).Blood) or "N/A", MedicPlan = MedicPlan and MedicPlan.Medic ~= 0 or false, Avatar = Avatar }, Records }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AVATAR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Avatar(Target,Image)
    local source = source
    local UserPassport = vRP.Passport(source)
    local Permission = Permission[UserPassport]
    local Hierarchy = vRP.HasPermission(UserPassport, Permission)

    if not Config.Permissions.Paramedic.Avatar == Hierarchy then
        TriggerClientEvent("painel:Notify", source, "Erro", "Você não possui permissões necessárias.", "vermelho")
        return false
    end
    
    if not Target then
        TriggerClientEvent("painel:Notify", source, "Erro", "Passaporte inválido.", "vermelho")
        return false
    end

    local Avatar = exports['oxmysql']:single_async('SELECT id FROM avatars WHERE Passport = ?', {Target})
    
    if Avatar then
        local Consult = exports['oxmysql']:execute_async('UPDATE avatars SET Image = ?, Permission = ? WHERE Passport = ?', {Image, Permission, Target})
        
        if Consult then
            TriggerClientEvent('painel:Notify', source, 'Sucesso', 'Avatar atualizado com sucesso.', 'verde')
            return true
        else
            TriggerClientEvent('painel:Notify', source, 'Erro', 'Falha ao atualizar o avatar.', 'vermelho')
            return false
        end
    else
        local Consult = exports['oxmysql']:insert_async('INSERT INTO avatars (Passport, Image, Permission) VALUES (?, ?, ?)', {Target, Image, Permission})
        
        if Consult then
            TriggerClientEvent('painel:Notify', source, 'Sucesso', 'Avatar definido com sucesso.', 'verde')
            return true
        else
            TriggerClientEvent('painel:Notify', source, 'Erro', 'Falha ao definir o avatar.', 'vermelho')
            return false
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MedicPlan(Passport)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)

	if not Config.Permissions.Paramedic.MedicPlan == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    exports['oxmysql']:execute_async('UPDATE characters SET Medic = CASE WHEN Medic IS NULL OR Medic = 0 THEN UNIX_TIMESTAMP() ELSE 0 END WHERE id = ?', { Passport })
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMEDICALRECORD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetMedicalRecord(Id)    
    local Records = exports['oxmysql']:single_async("SELECT p.id AS Id, p.Timestamp AS Date, p.Description, CONCAT(d.Name, ' ', d.Lastname) AS Doctor, CONCAT(c.Name, ' ', c.Lastname) AS Patient FROM painel_creative_paramedic p LEFT JOIN characters d ON d.id = p.Doctor LEFT JOIN characters c ON c.id = p.Passport WHERE p.id = ?", { Id })
    return Records
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEMEDICALRECORD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreateMedicalRecord(Data)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
    local Hierarchy = vRP.HasPermission(Passport, Permission)

    if not Config.Permissions.Paramedic.Create == Hierarchy then
        TriggerClientEvent("painel:Notify", source, "Erro", "Você não possui permissões necessárias.", "vermelho")
        return false
    end

    local Description = Data.Description
    Description = Description:gsub("<script>.-</script>", "")
    Description = Description:gsub("on%w+=", "data-removed=")

    exports['oxmysql']:insert_async('INSERT INTO painel_creative_paramedic (Passport, Doctor, Permission, Timestamp, Description) VALUES (?, ?, ?, UNIX_TIMESTAMP(), ?)', { Data.Passport, Passport, Permission, Description  })    
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEMEDICALRECORD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdateMedicalRecord(Data)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)

	if not Config.Permissions.Paramedic.Edit == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    exports['oxmysql']:update_async('UPDATE painel_creative_paramedic SET Description = ?, Timestamp = UNIX_TIMESTAMP() WHERE id = ?', { Data.Description, Data.Id })
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESTROYMEDICALRECORD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DestroyMedicalRecord(Id)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)

	if not Config.Permissions.Paramedic.Delete == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    exports['oxmysql']:update_async('DELETE FROM painel_creative_paramedic WHERE id = ?', { Id })
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHUSER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SearchUser(Search)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
    local Results = {}

    if Permission == "Paramedico" then
        local Lookup = '%' .. tostring(Search):lower() .. '%'
        local Users = exports['oxmysql']:query_async('SELECT id AS Passport, Name, Lastname, Medic FROM characters WHERE Deleted = 0 AND ( LOWER(Name) LIKE ? OR LOWER(Lastname) LIKE ? OR CAST(id AS CHAR) = ? ) LIMIT 50',{ Lookup, Lookup, Search })

        for _, User in ipairs(Users) do
            table.insert(Results, { Passport = User.Passport, Name = User.Name .. ' ' .. User.Lastname, MedicPlan = User.Medic ~= 0 })
        end

        return Results
    end

    local Groups = vRP.DataGroups(Permission)
    for Target in pairs(Groups) do
        local Identity = vRP.Identity(Target)
        if Identity then
            local Found = false
            if tostring(Target) == Search then
                Found = true
            else
                if Identity.Name and Identity.Name:lower():find(Search) then
                    Found = true
                elseif Identity.Lastname and Identity.Lastname:lower():find(Search) then
                    Found = true
                end
            end

            if Found and vRP.HasPermission(Target, Permission) then
                table.insert(Results, { Passport = Target, Name = vRP.FullName(Target), MedicPlan = true })
            end
        end
    end

    return Results
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MEMBERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Members()
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
    local Groups = vRP.DataGroups(Permission)
	local Service = vRP.NumPermission(Permission)
    local Members = {}

    local Consult = exports['oxmysql']:query_async('SELECT Image, Name, Members FROM painel_creative_Tags WHERE Permission = ?', { Permission }) or {}
    for _, Tag in ipairs(Consult) do
        Tag.Decoded = Tag.Members and json.decode(Tag.Members) or {}
    end

    for Target in pairs(Groups) do
        local Identity = vRP.Identity(Target)
        local Hierarchy = vRP.HasPermission(Target,Permission)

        if Identity then
            local Assigned = {}
            for _, Tag in ipairs(Consult) do
                for _, Number in ipairs(Tag.Decoded) do
                    if tonumber(Number) == tonumber(Target) then
                        table.insert(Assigned, { Image = Tag.Image, Name = Tag.Name })
                        break
                    end
                end
            end

            local Timer = os.time() - Identity.Login or 0
            local Calculated = CompleteTimers(Timer)

            table.insert(Members, { Passport = Target, Name = vRP.FullName(Target), Hierarchy = Hierarchy, Tags = Assigned, Service = Service[Target] and 1 or 0, Hours = vRP.Playing(Target,Permission) or 0, Status = vRP.Source(Target) and "Ativo a "..Calculated or "Inativo a "..Calculated })
        end
    end

    return { Members, vRP.Permissions(Permission,"Members") }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAGS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Tags()
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)

	if not Config.Permissions.Tags.View == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end
    
    local Consult = exports['oxmysql']:query_async('SELECT * FROM painel_creative_tags WHERE Permission = ?', { Permission }) or {}
	if Consult[1] then
		for i = 1, #Consult do
			Consult[i].Members = json.decode(Consult[i].Members)
		end
	end
    return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTAG 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetTag(Data)
    local Consult = exports['oxmysql']:single_async('SELECT Id, Name, Members FROM painel_creative_tags WHERE Id = ?', { Data.Id })
    local List = json.decode(Consult.Members) or {}
    local Members = {}

    for _, Passport in ipairs(List) do
            table.insert(Members, { Passport = Passport, Name = vRP.FullName(Passport) })
        end

    return { Id = Consult.Id, Name = Consult.Name, Members = Members }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATETAG 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreateTag(Data)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)
	
	if not Config.Permissions.Tags.Create == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end
	
    local Consult = exports['oxmysql']:scalar_async('SELECT COUNT(*) as Total FROM painel_creative_tags WHERE Permission = ?', { Permission })

    if Consult >= Config.MaxAmountTags then
        TriggerClientEvent("painel:Notify",source,"Erro","O limite de <b class=\"text-white\">"..Config.MaxAmountTags.. " tags</b> foi atingido.","vermelho")
        return false
    end

    local Consult = exports['oxmysql']:insert_async('INSERT INTO painel_creative_tags (Name, Image, Permission) VALUES (@Name, @Image, @Permission)', { Name = Data.Name, Image = Data.Image, Permission = Permission })

    if Consult then
        TriggerClientEvent("painel:Notify",source,"Sucesso","A tag <b class=\"text-white\">" .. Data.Name .. "</b> foi criada com sucesso.","verde")
    else
        TriggerClientEvent("painel:Notify",source,"Erro","Falha ao criar a tag <b class=\"text-white\">" .. Data.Name .."</b>.", "vermelho")
		return false
    end

    return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETAG 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdateTag(Data)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)
	
	if not Config.Permissions.Tags.Edit == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    local Consult = exports['oxmysql']:execute_async('UPDATE painel_creative_tags SET Name = ?, Image = ? WHERE Id = ? AND Permission = ?', { Data.Name, Data.Image, Data.Id, Permission })

    if Consult then
        TriggerClientEvent("painel:Notify",source,"Sucesso","A tag <b class=\"text-white\">" .. Data.Name .. "</b> foi atualizada com sucesso.","verde")
        return true
    else
        TriggerClientEvent("painel:Notify",source,"Erro","Falha ao atualizar a tag <b class=\"text-white\">" .. Data.Name .. "</b>.","vermelho")
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASSIGNTAG
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AssignTag(Data)
	local source = source
    local Passport = vRP.Passport(source)
	local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport, Permission)
	
	if not Config.Permissions.Tags.Assign == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end
	
    local Consult = exports['oxmysql']:single_async('SELECT Name, Members FROM painel_creative_tags WHERE Id = ?', { Data.Id })
	
    local Members = json.decode(Consult.Members) or {}
    for _, Member in ipairs(Members) do
        if Member == Data.Passport then
			TriggerClientEvent("painel:Notify",source,"Error","O passaporte <b class=\"text-white\">" .. Data.Passport .. "</b> já possui a tag <b class=\"text-white\">".. Consult.Name.."</b>.","vermelho")
            return false
        end
    end
	
    table.insert(Members, Data.Passport)

    exports['oxmysql']:execute_async('UPDATE painel_creative_tags SET Members = ? WHERE Id = ?', { json.encode(Members), Data.Id })
	
	TriggerClientEvent("painel:Notify",source,"Sucesso","O passaporte <b class=\"text-white\">" .. Data.Passport .. "</b> foi adicionado com sucesso à tag <b class=\"text-white\">".. Consult.Name.."</b>.","verde")
	
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVETAG 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RemoveTag(Data)
	local source = source
    local Passport = vRP.Passport(source)	
	local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)
	
	if not Config.Permissions.Tags.View == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end
	
    local Consult = exports['oxmysql']:single_async('SELECT Name, Members FROM painel_creative_tags WHERE Id = ?', { Data.Id })
	
	if not Consult then
		TriggerClientEvent("painel:Notify",source,"Erro","Não foi possível localizar a tag.","vermelho")
		return false
	end
	
    local Members, Sucess = json.decode(Consult.Members) or {}, false
    for Index, Member in ipairs(Members) do
        if Member == Data.Passport then
			Sucess = not Sucess
            table.remove(Members, Index)
            break
        end
    end

    exports['oxmysql']:execute_async('UPDATE painel_creative_tags SET Members = ? WHERE Id = ?', { json.encode(Members), Data.Id })
	
	if Sucess then
		TriggerClientEvent("painel:Notify",source,"Sucesso","O passaporte <b class=\"text-white\">" .. Passport .. "</b> foi removido com sucesso da tag <b class=\"text-white\">".. Consult.Name.."</b>.","verde")
	else
		TriggerClientEvent("painel:Notify",source,"Erro","Não foi possível localizar o passaporte <b class=\"text-white\">" .. Passport .. "</b> na tag <b class=\"text-white\">".. Consult.Name.."</b>","vermelho")
	end

    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESTROYTAG 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DestroyTag(Data)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport, Permission)
	
	if not Config.Permissions.Tags.Delete == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end
	
    local Consult = exports['oxmysql']:execute_async('DELETE FROM painel_creative_tags WHERE id = ? AND Permission = ?', { Data['Id'], Permission })

    if Consult then
        TriggerClientEvent("painel:Notify",source,"Sucesso","A tag foi removida com sucesso.","verde")
    else
        TriggerClientEvent("painel:Notify",source,"Erro","Falha ao remover a tag.","vermelho")
        return false
    end

    return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVITE 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Invite(Data)
	local source = source
	local Passport = vRP.Passport(source)
	local Identity = vRP.Identity(Data.Passport)
	local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)

	if not Config.Permissions.Management.Invite == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

	local GroupType = vRP.GroupType(Permission)

	if GroupType == 'Work' and Identity.Groups >= os.time() then
		TriggerClientEvent("painel:Notify",source,"Atenção","O passaporte escolhido não pode ser convidado para um grupo no momento.","amarelo",5000)
		return false
	end

	if not GroupType or GroupType ~= 'Work' or (GroupType == 'Work' and not vRP.GetUserType(Data.Passport,'Work')) then
		TriggerClientEvent("painel:Notify",source,"Sucesso","Um convite foi enviado ao destinatário.","verde",5000)
		if vRP.Request(vRP.Source(Data.Passport),"Grupos","Você foi convidado(a) para participar do grupo <b class=\"text-white\">"..Permission.."</b>, gostaria de estar entrando do mesmo?") then
			vRP.SetPermission(Data.Passport, Permission)
			TriggerClientEvent("painel:Notify",source,"Sucesso","Passaporte adicionado.","verde",5000)				
				return { Passport = Data.Passport, Name = vRP.FullName(Passport), Hierarchy = vRP.HasPermission(Data.Passport,Permission), Service = 1 }
			else
				TriggerClientEvent("painel:Notify",source,"Atenção","Convite para o grupo recusado.","amarelo",5000)
			end
		else
			TriggerClientEvent("painel:Notify",source,"Atenção","O passaporte já pertence a um grupo.","amarelo",5000)
		end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIERARCHY 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Hierarchy(Data)
	local source = source
	local Passport = vRP.Passport(source)
	local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport, Permission)

	if not Config.Permissions.Management.Hierarchy == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end
	
	if Data.Mode:find('Promote') or Data.Mode:find('Demote') then
	
		vRP.SetPermission(Data.Passport,Permission,_,Data.Mode)
		TriggerClientEvent("painel:Notify",source,"Sucesso","Hierarquia atualizada.","verde",5000)
		
		return { Passport = Data.Passport, Name = vRP.FullName(Data.Passport), Hierarchy = vRP.HasPermission(Data.Passport,Permission), Service = vRP.Source(Data.Passport) and 1 or 0, }
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMISS 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Dismiss(Data)
	local source = source
	local Passport = vRP.Passport(source)
	local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport, Permission)
	
	if not Config.Permissions.Management.Dismiss == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end
	
	if vRP.HasGroup(Data.Passport,Permission) then
		TriggerClientEvent("painel:Notify",source,"Sucesso","Passaporte removido com sucesso.","verde",5000)
		vRP.RemovePermission(Data.Passport,Permission)
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCEMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Announcements()
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
    local Consult = exports['oxmysql']:query_async('SELECT * FROM painel_creative_announcements WHERE Permission = @Permission', { Permission = Permission })
    return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEANNOUNCEMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreateAnnouncement(Data)
    local source = source
    local Passport = vRP.Passport(source)
	local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport, Permission)
	
	if not Config.Permissions.Announcements.Create == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    local Consult = exports['oxmysql']:scalar_async('SELECT COUNT(*) FROM painel_creative_announcements WHERE Permission = ?', { Permission })
    
    if Consult >= Config.MaxAmountAnnouncements then
        TriggerClientEvent("painel:Notify",source,"Erro","O limite de <b class=\'text-white\">" .. Config.MaxAmountAnnouncements .. " avisos</b> foi atingido.","vermelho")
        return false
    end

    local Description = Data.Description
    Description = Description:gsub("<script>.-</script>", "")
    Description = Description:gsub("on%w+=", "data-removed=")

    local Consult = exports['oxmysql']:insert_async('INSERT INTO painel_creative_announcements (Title, Description, Date, Permission) VALUES (?, ?, ?, ?)', { Data.Title, Description, os.time(), Permission })

    if Consult then
		local Name = vRP.FullName(Passport)
		local Groups = vRP.NumPermission(Permission)
		for _, Target in pairs(Groups) do
			if Target ~= source then
				TriggerClientEvent("Notify",Target,Name,"<b class=\'text-white\">"..Data.Title.."</b>: ".. Description,"amarelo")
			end
		end
		TriggerClientEvent("painel:Notify",source,"Sucesso","Aviso criado com sucesso!","verde")
    else
        TriggerClientEvent("painel:Notify",source,"Erro","Falha ao criar o aviso.","vermelho")
    end

    return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEANNOUNCEMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdateAnnouncement(Data)
	local source = source
    local Passport = vRP.Passport(source)	
	local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport, Permission)

	if not Config.Permissions.Announcements.Update == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    local Description = Data.Description
    Description = Description:gsub("<script>.-</script>", "")
    Description = Description:gsub("on%w+=", "data-removed=")

    local Consult = exports['oxmysql']:execute_async('UPDATE painel_creative_announcements SET Title = ?, Description = ?, Updated = ? WHERE id = ? AND Permission = ?', { Data.Title, Description, os.time(), Data.Id, Permission })

	if Consult then
		local Name = vRP.FullName(Passport)
		local Groups = vRP.NumPermission(Permission)
		for _, Target in pairs(Groups) do
			if Target ~= source then
				TriggerClientEvent("Notify",Target,Name,"<b class=\"text-white\">"..Data.Title.."</b>: ".. Description,"amarelo")
			end
		end
	end

    return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESTROYANNOUNCEMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DestroyAnnouncement(Data)
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport, Permission)

	if not Config.Permissions.Announcements.Destroy == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    local Consult = exports['oxmysql']:execute_async('DELETE FROM painel_creative_announcements WHERE id = ? AND Permission = ?', { Data.Id, Permission })

    return Consult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERKS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Perks()
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
    local Data = {}
    for k,v in ipairs(Config.Perks) do
        local Price = type(v.Price) == "table" and v.Price[vRP.Permissions(Permission,"Members") + 1] or v.Price
        Data[#Data+1] = { Active = (v.Type == "Premium") and vRP.Permissions(Permission,"Premium") or false, Description = v.Description, Image = v.Image, Price = Price, Title = v.Title }
    end
    local Result = { Levels = TableLevel(), List = Data, Xp = vRP.Permissions(Permission,"Experience") }
    return Result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERKSBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PerksBuy(Id)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
    
    local Perks = Config.Perks[Id]
    local Price = type(Perks.Price) == "table" and Perks.Price[vRP.Permissions(Permission,"Members") + 1] or Perks.Price
    
    if vRP.Permissions(Permission, "Bank") < Price then
        TriggerClientEvent("painel:Notify", source, "Erro", "Saldo insuficiente no banco da organização.", "vermelho")
        return false
    end
    
    if Perks.Type == "Premium" then
        vRP.PermissionsUpdate(Permission,Perks.Type,"+",os.time() + Perks.Increase)
    elseif Perks.Type == "Members" and vRP.Permissions(Permission,"Members") < vRP.Groups()[Permission].Max then
        vRP.PermissionsUpdate(Permission,Perks.Type,"+",Perks.Increase)
    else
        vRP.PermissionsUpdate(Permission,Perks.Type,"+",Perks.Increase)
    end
    
    vRP.PermissionsUpdate(Permission,"Bank","-",Price)
    
    exports['oxmysql']:insert_async('INSERT INTO painel_creative_transactions (Type, Passport, Value, Date, Permission) VALUES (?, ?, ?, ?, ?)', { "Perks", Passport, Price, os.time(), Permission })
    
    TriggerClientEvent("painel:Notify",source,"Sucesso","Vantagem <b class=\"text-white\">"..Perks.Title.."</b> comprada com sucesso por <b class=\"text-white\">$"..Price.."</b>.","verde")
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Bank()
    local source = source
    local Passport = vRP.Passport(source)
	local Permission = Permission[Passport]

    local Consult = exports['oxmysql']:query_async('SELECT * FROM painel_creative_transactions WHERE Permission = @Permission LIMIT 10', { Permission = Permission })

    local Transactions = {}
    for _, Data in ipairs(Consult) do
        table.insert(Transactions, { Player = { Passport = Data.Passport, Name = vRP.FullName(Data.Passport) }, To = { Passport = Data.Transfer, Name = vRP.FullName(Data.Transfer) }, Type = Data.Type, Value = Data.Value, Date = Data.Date })
    end

    return { vRP.Permissions(Permission,"Bank"), Transactions }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSITBANK 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DepositBank(Data)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
	local Hierarchy = vRP.HasPermission(Passport,Permission)

	if not Config.Permissions.Bank.Deposit == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    if not Data.Value or Data.Value <= 0 then
        TriggerClientEvent("painel:Notify",source,"Erro","Valor inválido para depósito.","vermelho")
        return false
    end

    if vRP.PaymentBank(Passport, Data.Value, true) then
        exports['oxmysql']:insert_async('INSERT INTO painel_creative_transactions (Type, Passport, Value, Date, Permission) VALUES (\'Deposit\', ?, ?, ?, ?)', { Passport, Data.Value, os.time(), Permission })
		
        vRP.PermissionsUpdate(Permission,"Bank","+",Data.Value)

        TriggerClientEvent("painel:Notify",source,"Sucesso","Depósito de <b class=\"text-white\">$" .. Data.Value .. "</b> realizado com sucesso.","verde")
        return true
    else
        TriggerClientEvent("painel:Notify",source,"Erro","Saldo insuficiente para depósito.","vermelho")
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWBANK 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.WithdrawBank(Data)
    local source = source
    local Passport = vRP.Passport(source)
    local Permission = Permission[Passport]
    local Hierarchy = vRP.HasPermission(Passport,Permission)

	if not Config.Permissions.Bank.Withdraw == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    if not Data.Value or Data.Value <= 0 then
        TriggerClientEvent("painel:Notify",source,"Erro","Valor inválido para saque.","vermelho")
        return false
    end

    local Balance = vRP.Permissions(Permission,"Bank")
    local Tax = math.floor(Data.Value * (Config.BankTaxWithdraw or 0))

    if Balance < (Data.Value + Tax) then
        TriggerClientEvent("painel:Notify",source,"Erro","Saldo insuficiente.","vermelho")
        return false
    end

    vRP.PermissionsUpdate(Permission,"Bank","-",Data.Value + Tax)

    exports['oxmysql']:insert_async('INSERT INTO painel_creative_transactions (Type, Passport, Value, Date, Permission) VALUES (\'Withdraw\', ?, ?, ?, ?)', { Passport, Data.Value, os.time(), Permission })

    vRP.GenerateItem(Passport,"zcoin",Data.Value,true)
    
	if Tax > 0 then
		TriggerClientEvent("painel:Closed",source,"Refresh")
	end

    TriggerClientEvent("painel:Notify",source,"Sucesso","Saque de <b class=\"text-white\">$" .. Data.Value .. "</b> realizado com uma taxa de <b class=\"text-white\">$" .. Tax .. "</b> aplicada.","verde")
    
    return { Balance - Data.Value - Tax, { Passport = Target, Name = Name } }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERBANK 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TransferBank(Data)
    local source = source
    local Passport = vRP.Passport(source)   
    local Permission = Permission[Passport]
    local Hierarchy, Title = vRP.HasPermission(Passport,Permission)

	if not Config.Permissions.Bank.Transfer == Hierarchy then
		TriggerClientEvent("painel:Notify",source,"Erro","Você não possui permissões necessárias.","vermelho")
		return false
	end

    if not Data.Passport or not Data.Value or Data.Value <= 0 then
        TriggerClientEvent("painel:Notify",source,"Erro","Dados inválidos para transferência.","vermelho")
        return false
    end

    local Balance = vRP.Permissions(Permission,"Bank")
    local Tax = math.floor(Data.Value * (Config.BankTaxWithdraw or 0))

    if Balance < (Data.Value + Tax) then
        TriggerClientEvent("painel:Notify",source,"Erro","Saldo insuficiente na conta da organização.","vermelho")
        return false
    end
	
    vRP.PermissionsUpdate(Permission,"Bank","-",Data.Value + Tax)

    exports['oxmysql']:insert_async('INSERT INTO painel_creative_transactions (Type, Passport, Value, Transfer, Date, Permission) VALUES (\'Transfer\', ?, ?, ?, ?, ?)', { Passport, Data.Value, Data.Passport, os.time(), Permission })

    vRP.GiveBank(Data.Passport, Data.Value, true)

	if Tax > 0 then
		TriggerClientEvent("painel:Closed",source,"Refresh")
	end

	TriggerClientEvent("painel:Notify",source,"Sucesso","Transferência de <b class=\"text-white\">$" .. Data.Value .. "</b> para o passaporte <b class=\"text-white\">" .. Data.Passport .. "</b> realizada com uma taxa de <b class=\"text-white\">$" .. Tax .. "</b> aplicada.","verde")
   
    local Source = vRP.Source(Data.Passport)

    if Source then
        TriggerClientEvent("Notify",Source,"Sucesso","<b class=\"text-white\">" .. Title .. "</b> fez uma transferência de <b class=\"text-white\">$" .. Data.Value .. "</b> para você.","verde",10000)
    end

    return { Passport = Data.Passport, Name = vRP.FullName(Passport), Date = os.time() }
end