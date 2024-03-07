--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + 3

	self:SetModel("models/dav0r/hoverball.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.5, 0)

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode()
	end

	if self.Exploded then
		local pos = self:GetPos()
		local alt = self:GetDTBool(0)

		if not alt then
			local effectdata = EffectData()
				effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata)
			util.Effect("explosion_sniperexp", effectdata)
		end

		self:Remove()
	elseif self.DieTime <= CurTime() then
		self:Explode()
	end

	if IsValid(self.PlayerParent) and not self.IsParentNULL then
		if self.PlayerParent:IsPlayer() and not self.PlayerParent:Alive() then
			self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetParent(NULL)
			self.IsParentNULL = true
		end
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidLivingHuman() then
		local pos = self:GetPos()
		local source = self:ProjectileDamageSource()

		util.BlastDamagePlayer(source, owner, pos, self.ProjRadius * (owner.ExpDamageRadiusMul or 1), self.ProjDamage, DMG_ALWAYSGIB, 0.75)

		local taper = 1
		for _, ent in pairs(util.BlastAlloc(self, owner, pos, self.ProjRadius * (owner.ExpDamageRadiusMul or 1))) do
			if ent:IsValidLivingZombie() and not SpawnProtection[ent] then
				ent:AddBurnDamage(self.ProjDamage * 0.2 * taper, owner, owner.BurnTickRate or 1)
				taper = taper * 0.98
			end
		end

		self:EmitSound("npc/env_headcrabcanister/explosion.wav", 85, 100)
	end
end
