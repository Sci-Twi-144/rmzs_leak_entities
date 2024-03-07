--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Model = "models/dav0r/hoverball.mdl"

ENT.LifeSpan = 5.75
ENT.HitOneTime = true

function ENT:InitProjectile()
	self:PhysicsInitSphere(4)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.55, 0)
	self:SetupGenericProjectile(false)

	self:EmitSound("weapons/physcannon/energy_sing_flyby2.wav", 70, math.random(245, 255))
	self:Fire("kill", "", self.LifeSpan)
	self.Creation = UnPredictedCurTime()
end

local vecDown = Vector()
function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end

	local livetime = UnPredictedCurTime() - self.Creation
	local vel = phys:GetVelocity()

	vecDown.x = vel.x * 0.95
	vecDown.y = vel.y * 0.95
	vecDown.z = (200 + livetime * -300) + math.sin(self.Rot + livetime * 10) * 250

	phys:SetVelocityInstantaneous(vecDown)
end

function ENT:ProcessHitEntity(ent)
	self:Hit(self:GetPos(), ent)
end

function ENT:Hit(vHitPos, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()

	if owner:IsValidLivingHuman() then
		local source = self:ProjectileDamageSource()
		if eHitEntity and eHitEntity:IsValid() then
			eHitEntity:TakeSpecialDamage((self.ProjDamage or 25) * (owner.ProjectileDamageMul or 1), DMG_DISSOLVE, owner, source, hitpos)

			util.BlastDamagePlayer(source, owner, vHitPos, 67, self.ProjDamage/2, DMG_DISSOLVE)
		end
	end
end
