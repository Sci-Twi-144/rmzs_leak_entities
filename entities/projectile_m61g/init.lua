--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_eq_fraggrenade_thrown.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(1)
		phys:SetMaterial("metal")
	end

	self.DieTime = CurTime() + self.LifeTime
	self:NextThink(self.DieTime)

end

function ENT:PhysicsCollide(data, phys)
	if self:GetOwner().InstantDetonation then
		self:Remove()
	end

	if 20 < data.Speed and 0.25 < data.DeltaTime then
		self:EmitSound("weapons/hegrenade/he_bounce-1.wav")
	end
end

function ENT:Think()
	if CurTime() >= self.DieTime then
		self:Remove()
	end
end

function ENT:OnRemove()
	self:Explode()
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	local pos = self:GetPos()

	if owner:IsValidHuman() then
		local pos = self:GetPos()
		local mul = owner.InstantDetonation and 0.9 or 1

		-- Some old ze maps use filter_damage_type with DMG_BLAST to check for grenades
		util.BlastDamagePlayer(self, owner, pos, self.GrenadeRadius or 256, (self.GrenadeDamage or 256) * mul, GAMEMODE.ZombieEscape and DMG_BLAST or DMG_ALWAYSGIB)
		
		for _, ent in pairs(util.BlastAlloc(self, owner, pos, 256 * (owner.ExpDamageRadiusMul or 1))) do
			if ent:IsValidLivingZombie() and not SpawnProtection[ent] then
				ent:AddBleedDamage(100, attacker)
				local bleed = ent:GiveStatus("bleed")
				if bleed and bleed:IsValid() then
				bleed:AddDamage(100)
				bleed.Damager = owner
				bleed:SetType(1)
			end
			end
		end
		
		local effectdata = EffectData()
			effectdata:SetOrigin(pos + Vector(0, 0, -1))
			effectdata:SetNormal(Vector(0, 0, -1))
		util.Effect("Explosion", effectdata)
	end

	self:EmitSound("weapons/hegrenade/explode5.wav")
end
