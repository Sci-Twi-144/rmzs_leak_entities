--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Heal = 5.1

ENT.HitOneTime = false
ENT.PostKillTime = 0
ENT.HitCounts = 0
ENT.MaxHitCounts = 3

ENT.LengthTraceUp = 0
ENT.LengthTraceRight = 0
ENT.LengthTraceForward = -150

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

	self:Fire("kill", "", 0.7)
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity, self.PhysicsData.OurOldVelocity)
		self:ProcessHitWall()
	end

	self:NextThink(CurTime())
end

function ENT:DoRefund(owner)
	if self.Refunded or not owner:IsSkillActive(SKILL_RECLAIMSOL) then return end

	self.Refunded = true
	owner:GiveAmmo(3, "Battery")
end

function ENT:Hit(eHitEntity)
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if IsValid(eHitEntity) then
		if eHitEntity:GetPoisonDamage() > 0 then
			owner:HealPlayer(eHitEntity, self.Heal, nil, nil, true)
		end

		if eHitEntity.LastCleansing <= CurTime() then 
			eHitEntity:ApplyHumanBuff("cleanser", 30, {Applier = owner, Stacks = 1})
			owner:ProcessStatusFloater(5, eHitEntity)
		end
	end
	
	if self.HitCounts > self.MaxHitCounts then self:Remove() end

	--[[
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal((Vector(0, 0, -1) * -1))
		if IsValid(eHitEntity) then
			effectdata:SetEntity(eHitEntity)
		else
			effectdata:SetEntity(NULL)
		end
	util.Effect("hit_healdart", effectdata)
	]]
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end

	if not util.HitFence(self, data, phys) then
		self.PhysicsData = data
		self.Done = true
	end
	self:EmitSound("ambient/machines/steam_release_2.wav", 70, 175)
	self:NextThink(CurTime())
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end
	if ent:IsValidLivingHuman() then
		self:Hit(ent)
	end
end

function ENT:ProcessHitWall()
	self:Remove()
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