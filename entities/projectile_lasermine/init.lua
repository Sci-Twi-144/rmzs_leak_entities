--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NoNails = true
ENT.m_IsImpactMine = true
ENT.LastHit = 0
ENT.Timer = 0

function ENT:Initialize()
	self.ObjHealth = 66
	self:SetModel("models/props_combine/combine_mine01.mdl")
	self:SetModelScale(0.333, 0)
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	
	local g,f = GetProjectileFlags(self)
	self:SetCustomGroupAndFlags(g,f)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	self:SetUseType(SIMPLE_USE)

	self.CreateTime = CurTime()
	self:SetSelfTime(100)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(0.1)
		phys:SetBuoyancyRatio(0.002)
		phys:EnableMotion(true)
		phys:Wake()
	end

	self:Fire("kill", "", 900)
end

function ENT:Use(activator, caller)
	if self:GetSelfTime() >= 90 and activator:Team() == TEAM_HUMAN and (activator == self:GetOwner() or not self:GetOwner():IsValid()) then
		activator:GiveAmmo(4, "impactmine")

		net.Start("zs_ammopickup")
			net.WriteUInt(4, 16)
			net.WriteString("impactmine")
		net.Send(activator)

		self:Remove()
	end
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 or not eHitEntity:IsWorld() then return end
	self:SetHitTime(CurTime())

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = (vHitNormal or Vector(0, 0, -1)) * -0.1

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	local angle = vHitNormal:Angle()
	angle:RotateAroundAxis(angle:Right(), -90)

	self:SetMoveType(MOVETYPE_NONE)
	self:SetPos(vHitPos + vHitNormal)
	self:SetAngles(angle)

	self:EmitSound("physics/metal/metal_computer_impact_bullet3.wav", 100, 150)
	self:EmitSound("weapons/cguard/charging.wav", 100, 30)
end

local function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local mine = dmginfo:GetInflictor()
	local falloff = mine.Range ^ 2 * 0.5
	if ent:IsValid() then
		if mine:GetStartPos():DistToSqr(tr.HitPos) > falloff then
			dmginfo:SetDamage(math.max(1, dmginfo:GetDamage() * (1 - ((mine:GetStartPos():DistToSqr(tr.HitPos) - falloff) / falloff))))
		end

		local owner = dmginfo:GetInflictor():GetOwner()
		if not owner:IsValidLivingHuman() then
			local humans = table.Copy(team.GetPlayers(TEAM_HUMAN))
			if #humans > 0 then
				owner = humans[math.random(#humans)]

				dmginfo:SetAttacker(owner)
			end
		end
		local multi = (owner.PulseRoundMulti or 1)

		if ent:IsPlayer() then
			ent:AddLegDamageExt((dmginfo:GetDamage() / 15) * multi, owner, self, SLOWTYPE_PULSE)
		end
	end
end

local trace = {mask = MASK_SHOT}
function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity, self.PhysicsData.OurOldVelocity)
	end

	if self:GetSelfTime() <= 0 then
		self:Remove()
	end

	if self.Timer <= CurTime() then
		self.Timer = CurTime() + 2
		self:SetSelfTime(self:GetSelfTime() - 1)
	end

	if self:IsActive() then
		trace.start = self:GetPos()
		trace.endpos = trace.start + self:GetUp() * self.Range
		trace.filter = self:GetCachedScanFilter()
		local ent = util.TraceLine(trace).Entity
		if ent:IsValidLivingZombie() and ent:Health() > 0 then
			self:Explode()
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Explode()
	if self.LastHit >= CurTime() then return end
	self.LastHit = CurTime() + 0.1
	self:EmitSound("items/suitchargeok1.wav", 100, 100)
	local pos = self:GetStartPos()
	
	self:FireBulletsLua(pos, self:GetUp(), 1, 1, 1, 1, 30, self:GetOwner(), 0.01, "AR2Tracer", BulletCallback, nil, nil, nil, nil, self)
	self:SetSelfTime(self:GetSelfTime() - 1)
end
