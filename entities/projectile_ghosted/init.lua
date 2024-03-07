--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NoNails = true

ENT.Base = "projectile_arrow_sli"

ENT.HitOneTime = false
ENT.LifeSpan = 25
ENT.Model = "models/props_junk/sawblade001a.mdl"
ENT.LengthTraceForward = 15

ENT.HitOneTime = false
ENT.MaxHitCounts = 20
ENT.HitCounts = 0

function ENT:InitProjectile()
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(2, 0)
	self:SetupGenericProjectile(false)
	self:SetTrigger(true)

	self.Creation = UnPredictedCurTime()
	self:Fire("kill", "", 10)
end

function ENT:PhysicsCollide(data, phys)
	if self.PhysicsData then return end

	self:Remove()
	self:EmitSound("npc/scanner/scanner_electric2.wav", 65, 100, 1)

	self:NextThink(CurTime())
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	self:Explode(self:GetPos(), self:GetForward(), ent)
end

function ENT:Explode(hitpos, hitnormal, ent)
	local owner = self:GetOwner()
	if owner:IsValidLivingHuman() then
		local source = self:ProjectileDamageSource()

		util.BlastDamagePlayer(source, owner, self:GetPos(), 64, (self.ProjDamage or 50), DMG_DIRECT, 0.75)
	end

	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 75, math.random(135, 150))
	self.HitCounts = self.HitCounts + 1
	if self.HitCounts > self.MaxHitCounts then
		self:Remove()
	end
end