--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.LifeTime = 3

function ENT:Initialize()
	self:SetModel("models/Gibs/HGIBS.mdl")
	self:PhysicsInitSphere(10) --self:PhysicsInitSphere(13)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(2, 0) --self:SetModelScale(2.5, 0)
	self:SetupGenericProjectile(true)

	self:SetMaterial("models/flesh")

	self.DeathTime = CurTime() + 30
	self.ExplodeTime = CurTime() + self.LifeTime
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity)
	end

	if self.DeathTime <= CurTime() then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Explode(hitpos, hitnormal, hitent)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if hitent.IsForceFieldShield and hitent:IsValid() then
		hitent:PoisonDamage(24, owner, self)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
	util.Effect("explosion_bonemesh", effectdata)

	util.Blood(hitpos, 30, hitnormal, 300, true)

	for _, ent in pairs(util.BlastAlloc(self, owner, hitpos, 56)) do
		if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) and ent ~= owner then
			ent:ApplyZombieDebuff("slow", 8, {Applier = owner}, true, 8)
			ent:ApplyZombieDebuff("sickness", 8, {Applier = owner}, true, 12)
			ent:TakeDamage(5, owner, self)
		end
	end

	for i = 1, 4 do
		for _, pl in pairs(util.BlastAlloc(self, owner, hitpos, 90)) do
			if pl:IsValidLivingZombie() and not pl:GetStatus("zombie_regen") then
				local zombieclasstbl = pl:GetZombieClassTable()
				local ehp = zombieclasstbl.Boss and pl:GetMaxHealth() * 0.4 or pl:GetMaxHealth() * 1.25
				if pl:Health() <= ehp then
					local status = pl:GiveStatus("zombie_regen")
					if status and status:IsValid() then
						status:SetHealLeft(120)
					end
					break
				end
			end
		end
	end
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
