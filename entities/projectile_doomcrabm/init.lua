--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Debuffed = 0

function ENT:Initialize()
	self.DeathTime = CurTime() + 7--30

	self:SetModel("models/Roller.mdl")
	self:SetMaterial("models/flesh")
	self:SetColor(Color(0, 230, 0, 255))

	self:PhysicsInitSphere(10)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetupGenericProjectile(false)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end

	if self.DeathTime <= CurTime() then
		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("explosion_doomball", effectdata)

	-- Massive damage to drones and manhacks.
	if eHitEntity and eHitEntity:IsValid() then
		eHitEntity:TakeDamage(eHitEntity.BeingControlled and 200 or 7, owner, self)

		if eHitEntity.FizzleStatusAOE then return end
	end
	local type = self:GetDTInt(5)
	for _, ent in pairs(util.BlastAlloc(self, owner, vHitPos, 128)) do 
		if IsValid(ent) and ent:WorldSpaceCenter():DistToSqr(vHitPos) < (128 ^ 2) and WorldVisible(vHitPos, ent:NearestPoint(vHitPos))then
			if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) and ent ~= owner then
				if type == 1 then
					ent:ApplyZombieDebuff("enfeeble", 5, {Applier = owner, Stacks = 1}, true, 6)
				elseif type == 2 then
					ent:ApplyZombieDebuff("sickness", 5, {Applier = owner}, true, 12)
				elseif type == 3 then
					ent:ApplyZombieDebuff("slow", 5, {Applier = owner}, true, 8)
				elseif type == 4 then
					ent:ApplyZombieDebuff("frightened", 3, {Applier = owner}, true, 39)
				end
				self.Debuffed = self.Debuffed + 1
			end
			if self.Debuffed >= 6 then break end
		end
	end
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
