--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/healthvial.mdl"

ENT.TickTime = 1
ENT.Heal = 6
-- ENT.Ticks = 10

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetModelScale(0.3, 0)
	self:SetTrigger(true)
	self:EmitSound("weapons/crossbow/bolt_fly4.wav", 75, 130)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.OurOldVelocity, self.PhysicsData.HitEntity)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:ProcessHitEntity(ent)
	self:Hit(self:GetPos(), self:GetPos(), self:GetVelocity():Length(), ent)
end


function ENT:Hit(vHitPos, vHitNormal, vel, hitent)
	if self.Done then return end
	self.Done = true

	local taper = 1
	local owner = self:GetOwner()
	local pos = self:GetPos()

	
	for _, ent in pairs(util.BlastAlloc(self, owner, pos, self.Radius * (owner.CloudRadius or 1))) do
		local effectdata = EffectData()
			effectdata:SetOrigin(vHitPos)
			effectdata:SetNormal(vHitNormal)
		util.Effect("med_aoe", effectdata)
	if ent and ent:IsValid() then
		if ent:IsValidLivingHuman() then
			owner:HealPlayer(ent, self.Heal * taper, 1, true)
		end
		if ent:IsValidLivingZombie () then
			ent:ApplyZombieDebuff("sapping", 5, {Applier = owner}, true, 41)
			ent:TakeDamage(3, owner, self) -- dmginfo:GetDamage() * 0.135
		end
		taper = taper * 0.8
	end
	end
	
	-- else
		-- if oldhealth <= 0 or oldhealth >= hitent:GetMaxBarricadeHealth() or hitent:GetBarricadeRepairs() <= 0.01 then return end
		-- hitent:SetBarricadeHealth(math.min(hitent:GetMaxBarricadeHealth(), hitent:GetBarricadeHealth() + math.min(hitent:GetBarricadeRepairs(), healstrength)))
		-- local healed = hitent:GetBarricadeHealth() - oldhealth
		-- hitent:SetBarricadeRepairs(math.max(hitent:GetBarricadeRepairs() - healed, 0))
		-- hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
		
		-- local effectdata = EffectData()
			-- effectdata:SetOrigin(vHitPos)
			-- effectdata:SetNormal(vHitNormal)
		-- util.Effect("nailrepaired2", effectdata)
		
	-- end
	
	self:Remove()
end