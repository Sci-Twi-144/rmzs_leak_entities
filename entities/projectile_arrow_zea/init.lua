--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_arrow"
ENT.HitOneTime = false
ENT.MaxHitCounts = 25

local math_round = math.Round

function ENT:InitProjectile()
	self.HitShock = {}
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetTrigger(true)
	self:EmitSound("weapons/crossbow/bolt_fly4.wav")
end

function ENT:ShockHit()
	local radius = 80 ^ 2
	local basedmg = self.ProjDamage * 0.85
	local getpos = self:GetPos()
	local owner = self:GetOwner()
	local table = team.GetPlayers(TEAM_UNDEAD) --util.BlastAlloc(self:ProjectileDamageSource(), owner, getpos, radius)

	for i = 1, #table do
		local hitpl = table[i]
		if not hitpl or self.HitShock[hitpl] then continue end

		if hitpl:IsValid() and hitpl:IsValidLivingZombie() then
			local nearest = hitpl:NearestPoint(getpos)
			local datdmg = ((radius - nearest:DistToSqr(getpos)) / radius) * basedmg

			if datdmg > 1 and datdmg < 200 then
				hitpl:ApplyZombieDebuff("shockdebuff", 4, {Applier = owner}, true, 38)

				hitpl:TakeSpecialDamage(datdmg, DMG_SHOCK, owner, self:ProjectileDamageSource(), nearest)

				basedmg = basedmg * 0.6

				self.HitShock[hitpl] = true
			end
		end
	end
end

function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end
end

function ENT:ProcessHitWall()
	local data = self.PhysicsData

	self:Fire("kill", "", 8)
	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav")

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:ShockHit()
	self:SetPos(data.HitPos)
	self:SetAngles(data.HitNormal:Angle())

	local effectdata = EffectData()
		effectdata:SetOrigin(data.HitPos)
		effectdata:SetNormal(data.HitNormal)
	util.Effect("hit_zeus", effectdata)

	local hitent = self.PhysicsData.HitEntity
	if IsValid(hitent) then
		local hitphys = hitent:GetPhysicsObject()
		if IsValid(hitphys) and hitphys:IsMoveable() then
			self:SetParent(hitent)
		else
			local phy = self:GetPhysicsObject()
			if IsValid(phy) then
				phy:EnableMotion(true)
			end
		end
		self:ProcessHitEntity(hitent, data)
	end

	self.PhysicsData = nil
	self.bCanNotHit = true
	self.Touched = nil
end

function ENT:ProcessHitEntity( ent )
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	if not self.Exploded then
		util.ElectricWonder(self:ProjectileDamageSource(), owner, ent:GetPos(), 192, self.ProjDamage, 0.5, 2)
	end
	self.Exploded = true

	ent:EmitSound("weapons/physcannon/superphys_small_zap1.wav", 85, 90, 1, CHAN_AUTO)
	self:DealProjectileTraceDamageNew(ent, self.ProjDamage, self:GetPos(), owner)
	self.ProjDamage = self.ProjDamage * (self.ProjTaper or 1) 
end

function ENT:DoElectricityEffectSmall()
	local teslacoil = ents.Create("point_tesla")
	if !teslacoil or !IsValid(teslacoil) then return false end
	teslacoil:SetPos(self:GetPos()--[[ + self:GetUp() * 26]])
	teslacoil:SetKeyValue( "m_SoundName", "DoSpark" )
	teslacoil:SetKeyValue("texture", "effects/tau_beam.vmt")
	teslacoil:SetKeyValue("m_Color", "0, 64, 255")
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