--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"

ENT.HitOneTime = false
--ENT.HitCounts = 0
--ENT.MaxHitCounts = 1
ENT.MaxHitCounts = 20
ENT.Model = "models/dav0r/hoverball.mdl"

local math_round = math.Round

function ENT:InitProjectile()
	--self.Touched = {}
	self.Bounces = 0
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(2, 0)
	self:SetTrigger(true)

	self:Fire("kill", "", 10)
end

function ENT:InitProjectilePhys(phys)
	phys:EnableGravity(false)
	phys:EnableDrag(false)
end

function ENT:Explode(hitpos, hitnormal, ent)
	if self.Exploded then return end
--	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		if ent:IsValidLivingZombie() and not ent:GetZombieClassTable().NeverAlive then
			local radius = 48
			local pos = self:GetPos()
			for _, hitent in pairs(util.BlastAlloc(self, owner, pos, radius)) do
				local p = hitent:LocalToWorld(hitent:OBBCenter())
				if hitent:IsValidLivingZombie() then
					hitent:TakeSpecialDamage(self.Damage or 50, DMG_DISSOLVE, owner, source)
					self:DoElectricityEffectSmall()
				end
			end
		end
	end
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	self:Explode(self:GetPos(), self:GetForward(), ent)
	--self:Remove()
end

function ENT:DoElectricityEffectSmall()
	local teslacoil = ents.Create("point_tesla")
	if !teslacoil or !IsValid(teslacoil) then return false end
	teslacoil:SetPos(self:GetPos()--[[ + self:GetUp() * 26]])
	teslacoil:SetKeyValue( "m_SoundName", "DoSpark" )
	teslacoil:SetKeyValue("texture", "effects/tau_beam.vmt")
	teslacoil:SetKeyValue("m_Color", "255, 64, 0")
	teslacoil:SetKeyValue("m_flRadius", (32))
	teslacoil:SetKeyValue("interval_min", (0.016 * 0.75))
	teslacoil:SetKeyValue("interval_max", (0.022 * 1.25))
	teslacoil:SetKeyValue("beamcount_min", (math_round(6 * 0.75)))
	teslacoil:SetKeyValue("beamcount_max", (math_round(6 * 1.25)))
	teslacoil:SetKeyValue("thick_min", (1 * 0.75))
	teslacoil:SetKeyValue("thick_max", (1 * 1.25))
	teslacoil:SetKeyValue("lifetime_min", (0.3 * 0.75))
	teslacoil:SetKeyValue("lifetime_max", (0.3 * 1.25))
	teslacoil:Spawn()
	teslacoil:Fire("DoSpark", "", 0)
	teslacoil:Fire("kill", "", 0.1)
end