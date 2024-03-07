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
	self:SetModelScale(0.3, 0)
	self:SetTrigger(true)
	self:EmitSound("weapons/crossbow/bolt_fly4.wav", 75, 130)
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetForward())
	util.Effect("hit_charon", effectdata)
end

function ENT:ProcessHitWall()
	self:Explode(self.PhysicsData.HitPos, self.PhysicsData.HitNormal)
	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 70, 250)
	self:Remove()
end

function ENT:ProcessHitEntity( ent )
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end
	local is_marked = self.IsMarked and ent:IsPlayer()
	if is_marked then
		local time = rawget(PlayerIsMarked2, ent)["Time"] and rawget(PlayerIsMarked2, ent)["Time"] or 0
	end
	self:Explode()

	if is_marked then
		if time and time >= CurTime() then
			self.ProjDamage = self.ProjDamage * (1 + (0.25 * rawget(PlayerIsMarked2, ent)["Hitcount"] or 1))
		else
			rawset(PlayerIsMarked2, ent, {})
		end
	end

	self:DealProjectileTraceDamageNew(ent, self.ProjDamage, self:GetPos(), owner)

	if is_marked then
		local hitcount = rawget(PlayerIsMarked2, ent)["Hitcount"] and (rawget(PlayerIsMarked2, ent)["Hitcount"] + 1 ) or 1
		rawset(PlayerIsMarked2, ent, {Time = CurTime() + 0.25, Hitcount = hitcount})
	end

	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 70, 250)
	self:Remove()
end