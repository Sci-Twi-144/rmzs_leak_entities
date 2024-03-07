--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NoNails = true

ENT.Base = "projectile_arrow_sli"

ENT.HitOneTime = true

ENT.LifeSpan = 3
ENT.Model = "models/props/cs_italy/orange.mdl"

function ENT:InitProjectile()
	self:SetColor(Color(0, 255, 0))
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2, 0)
	self:SetTrigger(true)
	self:SetupGenericProjectile(true)
	self:SetMaterial("models/shadertest/shader2")
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	owner.PollutorShootCount = (owner.PollutorShootCount or 0) + 1 
	local source = self:ProjectileDamageSource()
	local pos = self:GetPos()
	local radius = 29

--	self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 66), self:GetPos(), owner)
	local type = self:GetDTInt(5)
	util.BlastDamagePlayer(source, owner, pos, radius, self.ProjDamage or 75, (type == 1) and DMG_BURN or DMG_ALWAYSGIB, 0.5)

	if ent:IsPlayer() then
		if type == 0 then 
			for _, hitent in pairs(util.BlastAlloc(self, owner, ent:GetPos(), radius)) do
				if hitent:IsValidLivingZombie() then
					--ent.Corrosion = CurTime()
					ent:AddLegDamageExt(3, owner, source, SLOWTYPE_ACID)
				end
			end
		end
		if type == 1 then
			if owner.PollutorShootCount >= 5 then
				--ent:AddBurnDamage(self.ProjDamage * 0.8, owner or self, owner.BurnTickRate or 1)
				for _, hitent in pairs(util.BlastAlloc(self, owner, ent:GetPos(), radius)) do
					if hitent:IsValidLivingZombie() then
						ent:AddBurnDamage(self.ProjDamage * 0.7, owner or self, owner.BurnTickRate or 1)
					end
				end
				owner.PollutorShootCount = 0
			end
		end
		if type == 2 then
			if owner.PollutorShootCount >= 2 then
				for _, hitent in pairs(util.BlastAlloc(self, owner, ent:GetPos(), radius)) do
					if hitent:IsValidLivingZombie() then
						local multi = (owner.IceRoundMulti or 1) * (owner.RoundTrinketMulti or 1)
						local damage = (self.ProjDamage * 0.5) * multi
						ent:AddLegDamageExt(damage, owner, source, SLOWTYPE_COLD)
					end
				end
				owner.PollutorShootCount = 0
			end
		end
	end
	--print(owner.PollutorShootCount)
	self:EmitSound(
		type == 0 and "npc/barnacle/barnacle_gulp2.wav" or
		type == 1 and "ambient/fire/mtov_flame2.wav" or
		"nox/scatterfrost.ogg",
		70, type == 2 and 230 or 120, 0.75, CHAN_WEAPON + 20
	)
	self:EmitSound("vehicles/airboat/pontoon_impact_hard1.wav", 65, 250, 0.5, CHAN_WEAPON + 21)

	util.Blood(ent:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

	self:Remove()
end

function ENT:ProcessHitWall()
	local type = self:GetDTInt(5)
	local owner = self:GetOwner()
	owner.PollutorShootCount = (owner.PollutorShootCount or 0) + 1 
	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 70, 250)
	self:EmitSound(
		type == 0 and "npc/barnacle/barnacle_gulp2.wav" or
		type == 1 and "ambient/fire/mtov_flame2.wav" or
		"nox/scatterfrost.ogg",
		70, type == 2 and 230 or 120, 0.75, CHAN_WEAPON + 20
	)
	self:EmitSound("vehicles/airboat/pontoon_impact_hard1.wav", 65, 250, 0.5, CHAN_WEAPON + 21)

	self:Remove()
end