AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"
ENT.Placeholdermodel = Model("models/props_wasteland/rockcliff06d.mdl")

ENT.Ephemeral = true
ENT.PlrModel = nil

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Magnitude", "Float", 5)
AccessorFuncDT(ENT, "KeyCooldown", "Float", 6)

util.PrecacheModel("models/props_wasteland/rockcliff06d.mdl")

if SERVER then
	util.AddNetworkString( "IsSpacePressed" )
	
	net.Receive( "IsSpacePressed", function( len, ply )
	local status = ply:GetStatus("freeze")
		if status and status:IsValid() and status:GetOwner() == ply and status:GetKeyCooldown() <= CurTime() then
			local float = net.ReadFloat()
			status.LastSpaceMash = float
			status.NeedCheck = true
		end
	end )
end

local imat = Material("models/shadertest/shader2")
function ENT:Initialize()
	self.BaseClass.Initialize(self)
	--self:SetModel(self.Placeholdermodel)
	--print(self.PlrModel)
	if self.PlrModel and util.IsValidModel(self.PlrModel) then
		self:SetModel(self.PlrModel)
		self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	else	
		self:SetModel(self.Placeholdermodel)
		self:SetModelScale(0.2, 0)
	end
	
	self:SetColor(Color(30, 150, 255, 255))
	self:DrawShadow(false)
    self:SetSolid(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	--self.ReleasePower = math.random()
	self:SetMagnitude(math.random())
	self.NeedCheck = false
	
	if CLIENT then
		self.CheckKey = false
		
		local ent = self:GetOwner()
		self.ParentEntity = ent
		self:SetPos( ent:GetPos())
		self:SetAngles( ent:GetAngles() )
		self:SetParent( ent )
		local position = ent:GetPos()
		--self.KeyCooldown = 0
		self:ChangeRate(0.00001, ent)
		ent:SetCycle(ent:GetCycle()) 
		
		local function Ghost(self)
			local num = render.GetBlend()
			render.SetBlend(0.5)
			self:DrawModel()
			render.SetBlend(num)
		end
		
		local cmodel = ClientsideModel("models/props_wasteland/rockcliff06d.mdl")
		if cmodel:IsValid() then
			cmodel.RenderOverride = Ghost
			cmodel:SetPos(position - (Vector(0, 0, 40)))
			cmodel:SetAngles(self:LocalToWorldAngles(Angle(180, 0, 0)))
			cmodel:SetMaterial(imat:GetName())
			cmodel:SetColor(Color(30, 150, 255, 255))
			cmodel:SetSolid(SOLID_NONE)
			cmodel:SetMoveType(MOVETYPE_NONE)
			cmodel:SetParent(self)
			cmodel:SetOwner(self)
			cmodel:SetModelScale(0.3, 0)
			cmodel:Spawn()

			self.CModel = cmodel
		end
		
		local matGlow = Material("sprites/glow04_noz")
		local texDownEdge = surface.GetTextureID("gui/gradient_down")
		local texGradDown = surface.GetTextureID("VGUI/gradient_down")
		local ent = self
		local ENTC = tostring(ent)

		hook.Add("PrePlayerDraw", ENTC, function(pl)
			if not IsValid(ent) then return end

			if pl ~= ent:GetOwner() then return end
		
			local b = 1 - math.abs(math.sin((CurTime() + ent:EntIndex()) * 3)) * 0.2
			render.SetColorModulation(0.1, 0.1, b)
		end)
		
		hook.Add("PostPlayerDraw", ENTC, function(pl)
			if not IsValid(ent) then return end

			if pl ~= ent:GetOwner() then return end
		
			render.SetColorModulation(1, 1, 1)
		end)

		local colModDimVision = {
			["$pp_colour_colour"] = 1,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_mulr"]	= 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0,
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0
		}
		
		hook.Add("RenderScreenspaceEffects", ENTC, function()
			if not IsValid(ent) then return end
			
			if MySelf ~= ent:GetOwner() then return end
		
			colModDimVision["$pp_colour_addb"] = ent:GetPower() * 0.2
			colModDimVision["$pp_colour_addg"] = ent:GetPower() * -0.05
			colModDimVision["$pp_colour_addr"] = ent:GetPower() * -0.13
			DrawColorModify(colModDimVision)
		end)
		
		hook.Add("PreDrawViewModel", ENTC, function(vm, ply, wep)
			if MySelf ~= ent:GetOwner() then return end
			render.ModelMaterialOverride(imat)
			render.SetColorModulation( 30/255, 150/255, 1 )
			vm:SetPlaybackRate(0.01)
		end)
		
		hook.Add("PostDrawHUD", ENTC, function()
			if MySelf ~= ent:GetOwner() then return end
			local screenscale = BetterScreenScale()
			local x = ScrW() * 0.5
			local y = ScrH() * 0.7
			local wid, hei = 200 * screenscale, 20 * screenscale
			x = x - wid/2
			y = y - hei/2
			surface.SetDrawColor(0, 0, 0, 230)
			surface.DrawRect(x, y, wid, hei)
			x = x + 1
			y = y + 1
			local color = Color(0, 125, 255, 220)
			surface.SetDrawColor(color)
			surface.SetTexture(texGradDown)
			surface.DrawTexturedRect(x, y, wid - 2, hei - 2)
			
			local pos = x + (self:GetMagnitude() * wid)
			local widthspace = wid * 0.15--18 * screenscale
			color = Color(255, 255, 50, 255)		
			--surface.SetMaterial(matGlow)
			surface.SetDrawColor(color)
			surface.DrawTexturedRect(pos - widthspace/2 , y, widthspace, hei)

			local temppos = x + self:GetMyState() * wid
			color = Color(255, 0, 0, 255)
			surface.SetDrawColor(color)
			surface.DrawTexturedRect(temppos, y, 3, hei)
			
			local coltext = not self:CanSmashSpace() and Color(255,50,50, math.abs(math.sin(CurTime() * 3)) *255) or Color(255,255,0,255)
			draw.SimpleText("Press SPACE to release!", "ZSHUDFontSmallest", x + (wid-2) * 0.5, y + hei * -0.5, coltext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end )
	end
	
	if SERVER then
		self:EmitSound("physics/glass/glass_impact_bullet"..math.random(4)..".wav", 70, 85)
	end
	local ENTC = tostring(ent)
end

function ENT:ChangeRate(num, target)
	local iter = 5
	if target and target:IsValid() then
		if num != 1 then
			target.ManualRate = true
			target.AnimationRate = num
			target:SetPlaybackRate(num)
			for i = 0, iter do
				target:SetLayerPlaybackRate(i, num)
			end
		else
			target.ManualRate = false
			target.AnimationRate = 1
			target:SetPlaybackRate(1)
			for i = 0, iter do
				target:SetLayerPlaybackRate(i, 1)
			end
		end
	end
end

function ENT:Think()
	local owner = self:GetOwner()
	if SERVER then
		if not owner:Alive() then
			self:Remove()
		end
	end
	if CLIENT then
		if input.IsKeyDown(KEY_SPACE) then
			if  not self.CheckKey then
				net.Start( "IsSpacePressed" )
					net.WriteFloat( CurTime() )
				net.SendToServer()
				self.CheckKey = true
			end
		else
			self.CheckKey = false
		end
	end
	
	if self.NeedCheck then
		if self:GetMyState() <= self:GetMagnitude() + 0.05 and self:GetMyState() >= self:GetMagnitude() - 0.05 then
			self:Remove()
		else
			self:SetKeyCooldown(CurTime() + 0.25)
			self.NeedCheck = false
		end
	end
	
	self.BaseClass.Think(self)
end

function ENT:OnRemove()
	local parent = self:GetOwner()
	if ( parent:IsNPC() ) then
		parent:NextThink( CurTime() )
		parent:SetSchedule( SCHED_WAKE_ANGRY )
		parent:StopMoving()
		self:ChangeRate(1, parent)
		parent:RemoveFlags( FL_FROZEN )
	elseif ( parent:IsPlayer() ) then
		self:ChangeRate(1, parent)
		parent:RemoveFlags( FL_FROZEN )
	end
	
	if SERVER then
		self:EmitSound("physics/glass/glass_impact_bullet"..math.random(4)..".wav", 70, 85)
	end
	
	self.BaseClass.OnRemove(self)
end

function ENT:HandleOwnerWeapon(owner, nlt)
	local wep = owner:GetActiveWeapon()
	local iszombie = owner:IsValidLivingZombie()
	if (wep:GetClass() != "weapon_zs_doomcrab") then
		if wep.IsMelee then
			if not iszombie and wep:IsWinding() then
				wep:StopWind()
			end
			if wep:IsSwinging() then
				if iszombie then
					wep:SetSwingEndTime(wep:GetSwingEndTime() + nlt)
				else
					wep:SetSwingEnd(wep:GetSwingEnd() + nlt)
				end
			end
		end
	else
		wep:SetPouncing(false)
	end
end

function ENT:PlayerSet()
	self.BaseClass.PlayerSet(self)
	local owner = self:GetOwner()
	local iszombie = owner:IsValidLivingZombie()
	--local placeholder = Model("models/props_wasteland/rockcliff06d.mdl")
	if not owner:Alive() then self:Remove() return end
	
	self:SetStartTime(CurTime())
	
	self.TargetCycle = owner:GetCycle()
	local nlt = self.DieTime - CurTime()

	self:HandleOwnerWeapon(owner, nlt)

	if ( owner:IsNPC() ) then
		owner:AddFlags( FL_FROZEN )
		owner:SetCycle( self.TargetCycle ) 
		self:ChangeRate(0.01, owner)
	elseif ( owner:IsPlayer() ) then
		self:ChangeRate(0.01, owner)
		owner:SetCycle( self.TargetCycle ) 
		owner:AddFlags( FL_FROZEN )
	end
end

function ENT:GetMyState()
	local range = CurTime() - self:GetStartTime()
	local pi = math.pi
	local number = math.abs(math.sin(0.5 * range * pi))

	return number
end

function ENT:CanSmashSpace()
	return self:GetKeyCooldown() <= CurTime()
end

function ENT:HandlePlrModel(mdl)
	if mdl and util.IsValidModel(mdl) then
		self:SetModel(mdl)
		self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	else	
		self:SetModel(self.Placeholdermodel)
		self:SetModelScale(0.2, 0)
	end
end