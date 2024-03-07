AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.HitOneTime = false
ENT.ImpactDamage = 10
ENT.ImpactDamageType = DMG_GENERIC
ENT.PostKillTime = 0
ENT.HitCounts = 0
ENT.MaxHitCounts = 3

ENT.LengthTraceUp = 0
ENT.LengthTraceRight = 0
ENT.LengthTraceForward = -150

function ENT:Initialize()
	self.Touched = {}
	self.IsOnceEnts = {}

	self:SetModel(self.Model)

	local g,f = GetProjectileFlags(self)
	self:SetCustomGroupAndFlags(g,f)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:InitProjectile()

	local pl = self:GetOwner()
	if IsValid(pl) and pl:IsPlayer() then
		self:SetTeamID(pl:Team())
	end

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(4)
		self:InitProjectilePhys(phys)
		phys:Wake()
	end

	self.DieTime = CurTime() + self.LifeSpan
	self:Fire("kill", "", self.LifeSpan + self.PostKillTime)
end

function ENT:InitProjectilePhys( phys )
end

function ENT:InitProj( vel )
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocityInstantaneous(vel)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

local cb = {ignoreworld = true, mask = MASK_SHOT}
local util_TraceHull = util.TraceHull

local M_Entity = FindMetaTable("Entity")
local E_GetTable = M_Entity.GetTable

local function EntityHit(self)
	local stbl = E_GetTable(self)

	cb.start = self:GetPos()
	cb.endpos = cb.start + self:GetForward() * stbl.LengthTraceForward + self:GetRight() * stbl.LengthTraceRight + self:GetUp() * stbl.LengthTraceUp
	cb.filter = function(ent)
		local etbl = E_GetTable(ent)
		if ent ~= self
		and self:GetOwner() ~= ent
		and not etbl.NeverAlive
		and not SpawnProtection[ent]
		and not etbl.IgnoreBullets
		and not stbl.Touched[ent]
		and (etbl.IsCreeperNest or ent:IsValidLivingZombie()) or etbl.IsShadeShield then
			if etbl.ZombieConstruction or etbl.IsShadeShield then
				self:Remove()
			end

			-- Hit stack players?
			if not stbl.HitOneTime and stbl.HitCounts <= stbl.MaxHitCounts then
				self:ProcessHitEntity(ent)
				stbl.HitCounts = stbl.HitCounts + 1
			else
				if not stbl.HitEntity then
					stbl.HitEntity = ent
					self:ProcessHitEntity(ent)
				end
			end

			stbl.Touched[ent] = true
		end
	end

	util_TraceHull(cb)
end

-- When StartTouch not works then should to use this method to make work for sometimes.
function ENT:TraceHits()
	EntityHit(self)
end

function ENT:StartTouch(ent)
	--[[if not self.Done and not self.HitEntity and not self.Touched[ent] and (ent.IsCreeperNest or ent:IsValidLivingZombie()) then
		if self.HitOneTime then
			self.HitEntity = ent
		else
			self.Touched[ent] = true
		end

		if self:GetOwner() ~= ent then
			self:ProcessHitEntity(ent)
		end
	end]]
end

function ENT:Think()
	if self.PhysicsData then
		self:ProcessHitWall()
	end
end

function ENT:ProcessHitWall()
	self:Remove()
end

function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end
	if not util.HitFence(self, data, phys) then
		self.Done = true
		phys:EnableMotion(false)
		self.PhysicsData = data
	end
	self:NextThink(CurTime())
end

function ENT:ProcessHitEntity( ent )
	self:Remove()
end

function ENT:Touch(ent)
end

function ENT:EndTouch(ent)
end