--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModelScale(1.3)
	self:SetModel("models/rmzs/stuff/sigil.mdl")
	self:PhysicsInitBox(Vector(-20, -20, 0), Vector(20, 20, 86))
	--self:SetCollisionBounds(mins, maxs)
	self:SetUseType(SIMPLE_USE)

	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetCreationTime(CurTime())

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	local ent = ents.Create("prop_sigilplatform")
	if ent:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z + 4.8
		ent:SetPos(pos)
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		self:DeleteOnRemove(ent)
	end

	local ent = ents.Create("point_worldhint")
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
		ent:SetParent(self)
		ent:Spawn()
		ent:SetViewable(TEAM_HUMAN)
		ent:SetRange(0)
		ent:SetTranslated(true)
		ent:SetHint("prop_obj_exit_h")
	end

	ent = ents.Create("point_worldhint")
	if ent:IsValid() then
		ent:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
		ent:SetParent(self)
		ent:Spawn()
		ent:SetViewable(TEAM_UNDEAD)
		ent:SetRange(0)
		ent:SetTranslated(true)
		ent:SetHint("prop_obj_exit_z")
	end
end

function ENT:Use(activator)
	self:OnUse(activator)
end

function ENT:OnUse(activator)
	if activator:IsPlayer() and activator:Alive() and activator:Team() == TEAM_HUMAN and self:GetOpenStartTime() == 0 and self:GetRise() == 1 then
		self:SetOpenStartTime(CurTime())
		self:EmitSound("weapons/rmzs/fusion_breaker/fusion_startup.ogg")
	end
end

function ENT:Touch(ent)
	-- so you don't have to walk away and go back to the sigil to activate it
	if self:GetOpenStartTime() == 0 and self:GetRise() == 1 then
		self:OnUse(ent)
	end

	if ent:IsPlayer() and ent:Team() == TEAM_HUMAN and ent:Alive() and ent:GetObserverMode() == OBS_MODE_NONE and self:IsOpened() then
		local pos = ent:EyePos()

		rawset(PLAYER_IsAlive, ent, false)

		ent:Spectate(OBS_MODE_ROAMING)
		ent:SpectateEntity(self)
		ent:StripWeapons()
		ent:GodEnable()
		ent:SetMoveType(MOVETYPE_NOCLIP)

		ent:SetPos(pos)

		gamemode.Call("OnPlayerWin", ent)

		net.Start("zs_survivor")
			net.WriteEntity(ent)
		net.Broadcast()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end


function ENT:Think()
	self.BaseClass.Think(self)
	if self:IsOpened() then
		self:Explode()
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local pos = self:GetPos()
	for _, ent in pairs(ents.FindInSphere(pos, 365)) do
		if ent:IsValid() and ent:IsPlayer()  then
			local eyepos = ent:EyePos()
			if TrueVisibleFilters(pos, eyepos, self, ent) then
				ent:ScreenFade(SCREENFADE.IN, nil, 2, 2)
				ent:SetDSP(36)
			end
		end
	end
end