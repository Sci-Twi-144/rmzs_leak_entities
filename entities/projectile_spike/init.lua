--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/Items/CrossbowRounds.mdl"

ENT.LifeSpan = 15
ENT.HitOneTime = true

ENT.IsMarked = nil

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetTrigger(true)
	self:EmitSound("weapons/crossbow/bolt_fly4.wav", 75, 130)
	
	self:SetupGenericProjectile(false)
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 116), self:GetPos(), owner)
	self:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 80)
	self:Remove()
end

function ENT:Hit(vHitPos, vHitNormal, vel, hitent)
	if self.Done then return end
	self.Done = true

	local owner = self:GetOwner()
	
	if hitent and hitent:IsValid() and hitent:IsPlayer() then

		local needle = ents.Create("prop_needle")
		if needle:IsValid() then
			needle:SetPos(vHitPos)
			needle.BaseWeapon = self.BaseWeapon
			needle.Weaken = true
			needle:Spawn()
			needle.BleedPerTick = self.ProjDamage * 0.075
			needle:SetOwner(self:GetOwner())
			needle:SetParent(hitent)
			needle:SetAngles(self:GetAngles())
		end
		hitent:TakeSpecialDamage(self.ProjDamage or 116, DMG_GENERIC, owner, self, self:GetPos())
	end
	self:Remove()
end
