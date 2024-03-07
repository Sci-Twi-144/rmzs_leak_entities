--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + 30

	self:SetModel("models/props_junk/glassbottle01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetTrigger(true)
	self:SetupGenericProjectile(true)
end

function ENT:Think()
	if self.PhysicsData then
		self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	end
	
	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed >= 50 then
		self.PhysicsData = data
		self:NextThink(CurTime())
	end
end

function ENT:PhysicsUpdate(phys)
	self.LastPhysicsUpdate = UnPredictedCurTime()
	local vel = phys:GetVelocity()
	phys:SetAngles(phys:GetVelocity():Angle())
	phys:SetVelocityInstantaneous(vel)
end

function ENT:StartTouch(ent)
	if self.DieTime ~= 0 and ent:IsValidLivingPlayer() then
		local owner = self:GetOwner()
		if not owner:IsValid() then owner = self end

		if ent ~= owner and ent:Team() ~= self.Team then
			ent:TakeSpecialDamage(self.Damage, DMG_CLUB, owner, self, nil)
			ent:ApplyZombieDebuff("zombiestrdebuff", 5, {Applier = owner, Damage = 2}, true, 35)
			ent:EmitSound("physics/glass/glass_largesheet_break"..math.random(1, 3)..".wav", 80, math.Rand(165, 170))
			self:Explode()
		end
	end
end

function ENT:Explode(hitpos, hitnormal)
	if self.DieTime == 0 then return end
	self.DieTime = 0
	self:EmitSound("physics/glass/glass_largesheet_break"..math.random(1, 3)..".wav", 80, math.Rand(165, 170))
	self:Remove()
	self:NextThink(CurTime())
end
