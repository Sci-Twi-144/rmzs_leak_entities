--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.HitOneTime = false
ENT.PostKillTime = 0
ENT.HitCounts = 0
ENT.MaxHitCounts = 50

ENT.LengthTraceUp = 0
ENT.LengthTraceRight = 0
ENT.LengthTraceForward = -150

ENT.Targeting = nil

function ENT:Initialize()
	self.Touched = {}
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.3, 0)
	self:SetupGenericProjectile(false)
	self:SetTrigger(true)
	
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONFLAGS_HUMANPROJ)

	self:Fire("kill", "", 0.25)
end

function ENT:Think()
	if self.PhysicsData then
		self:ProcessHitWall()
	end
end

function ENT:Hit(ent)

end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end

	if not util.HitFence(self, data, phys) then
		self.PhysicsData = data
		self.Done = true
	end

	self:NextThink(CurTime())
end

function ENT:ProcessHitWall()
	self:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 160, 190)
	self:Remove()
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end
--print(ent)
	if ent:IsValid() and ent.IsSigil then 
		ent:TakeSpecialDamage(1200, DMG_GENERIC, owner, self:ProjectileDamageSource())
		self:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 160)
		self:Remove()
elseif ent:IsValidLivingZombie() then
		self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 66), self:GetPos(), owner)
		--ent:TakeSpecialDamage(self.ProjDamage or 66, DMG_GENERIC, owner, self:ProjectileDamageSource())
		self:EmitSound("weapons/crossbow/hitbod"..math.random(2)..".wav", 75, 160)
		self:Remove()
	end
end

function ENT:StartTouch(ent)
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
		and not stbl.Touched[ent] then
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

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:TraceHits()
	EntityHit(self)
end

function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end
end

function ENT:Touch(ent)
end

function ENT:EndTouch(ent)
end