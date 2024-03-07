--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/props_junk/harpoon002a.mdl"

ENT.LifeSpan = 30
ENT.HitOneTime = true

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
	self.LastPhysicsUpdate = UnPredictedCurTime()
end

function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end

	self.LastPhysicsUpdate = UnPredictedCurTime()
	local vel = phys:GetVelocity()
	phys:SetAngles(phys:GetVelocity():Angle())
	phys:SetVelocityInstantaneous(vel)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.OurOldVelocity, self.PhysicsData.HitEntity)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:ProcessHitEntity(ent)
	self:Hit(self:GetPos(), self:GetPos(), self:GetVelocity():Length(), ent)
end

function ENT:Hit(vHitPos, vHitNormal, vel, hitent)
	if self.Done then return end
	self.Done = true

	local owner = self:GetOwner()

	if hitent.IsCreeperNest then
		hitent:TakeSpecialDamage(self.ProjDamage or 45, DMG_GENERIC, owner, self, self:GetPos())
		hitent:EmitSound("npc/strider/strider_skewer1.wav", 70, 112)
		if self:GetOwner():IsValidLivingHuman() then
			self:GetOwner():Give(self.BaseWeapon)
		end
	end

	if hitent and hitent:IsValid() and hitent:IsPlayer() then
		hitent:AddLegDamage(hitent:PlayerIsBoss() and 15 or 30)

		local ent = ents.Create("prop_harpoon")
		if ent:IsValid() then
			ent:SetPos(vHitPos)
			ent.BaseWeapon = self.BaseWeapon
			ent.BleedPerTick = 2
			ent:Spawn()
			ent:SetOwner(self:GetOwner())
			ent:SetParent(hitent)
			ent:SetAngles(self:GetAngles())
		end

		hitent:TakeSpecialDamage(self.ProjDamage or 45, DMG_GENERIC, owner, self, self:GetPos())
		hitent:EmitSound("npc/strider/strider_skewer1.wav", 70, 112)
	else
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 180)

		local ent = ents.Create("prop_fakeweapon")
		if ent:IsValid() then
			ent:SetOwner(self:GetOwner())
			ent:SetWeaponType(self.BaseWeapon)
			ent:SetPos(self:GetPos())
			ent:SetAngles(ang)
			ent:Spawn()

			local physob = ent:GetPhysicsObject()
			if physob:IsValid() then
				physob:Wake()
				physob:SetVelocityInstantaneous(hitent.IsShadeShield and (self:GetVelocity() * -0.33) or vel)
			end
		end
		if self:GetOwner():IsValidLivingHuman() then
			self:GetOwner():Give(self.BaseWeapon)
		end
		self:EmitSound("physics/metal/metal_sheet_impact_bullet"..math.random(2)..".wav", 70, math.random(90, 95))
	end

	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
