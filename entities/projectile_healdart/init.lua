--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Heal = 5.1
ENT.Gravity = true

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
	self:SetupGenericProjectile(self.Gravity)
	self:SetTrigger(true)
	
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONFLAGS_HUMANPROJ)

	self:Fire("kill", "", 30)

	if self:GetSeeked():IsValidLivingHuman() and self:GetOwner():IsValidLivingHuman() then
		local owner = self:GetOwner()
		local seeked = self:GetSeeked()
		
		self.Targeting = true

		local meforward = self:GetForward()
		local angtoseek = (self:GetPos() - seeked:GetPos()):GetNormalized()
		local dot = meforward:Dot(angtoseek)

		if dot > -0.35 or owner:GetPos():DistToSqr(seeked:GetPos()) > 700000 then
			self:SetSeeked(NULL)
			self.Targeting = false
		else
			self:EmitSound("buttons/blip1.wav", 65, 150)
		end
	end
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.HitEntity, self.PhysicsData.OurOldVelocity)
	end

	if self:GetSeeked():IsValidLivingHuman() then
		local target = self:GetSeeked()

		local targetpos = target:LocalToWorld(target:OBBCenter())
		local direction = (targetpos - self:GetPos()):GetNormal()

		self:SetAngles(direction:Angle())

		local phys = self:GetPhysicsObject()
		phys:SetVelocityInstantaneous(direction * 2000)
	end

	self:NextThink(CurTime())
end

function ENT:DoRefund(owner)
	if self.Refunded or not owner:IsSkillActive(SKILL_RECLAIMSOL) then return end

	self.Refunded = true
	owner:GiveAmmo(3, "Battery")
end

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 then return end

	self:SetHitTime(CurTime())

	self:Fire("kill", "", 0)
	
	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if IsValid(eHitEntity) then
		if eHitEntity:IsPlayer() and eHitEntity:Team() ~= TEAM_UNDEAD then
			local ehithp, ehitmaxhp = eHitEntity:Health(), eHitEntity:GetMaxHealth()

			if not (owner:IsSkillActive(SKILL_RECLAIMSOL) and ehithp >= ehitmaxhp) then
				local duration = (self.BuffDuration or 10) * (owner.BuffDurationMD or 1)
				--eHitEntity:GiveStatus("healdartboost", duration)
				eHitEntity:ApplyHumanBuff("healdartboost", duration, {Applier = owner})
				
				local regen, regular = math.ceil(self.Heal/2), math.floor(self.Heal/2)
				
				if gamemode.Call("PlayerCanBeHealed", eHitEntity) then
					if rawget(PLAYER_LastHitTime, eHitEntity) < CurTime() then
						owner:HealPlayer(eHitEntity, regular)
					end
					eHitEntity:AddHealthRegeneration(regen, owner, 1, true)
				end
				
				local gun = self:ProjectileDamageSource()
				if gun and gun.IsMedicalDevice and HitSeekedTarget(gun, eHitEntity) then
					gun:SetActivePatient(eHitEntity, duration, PATIENT_COLOR_GREEN)
				end
			else
				self:DoRefund(owner)
			end
		else
			self:DoRefund(owner)
		end
	else
		self:DoRefund(owner)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal((Vector(0, 0, -1) * -1))
		if IsValid(eHitEntity) then
			effectdata:SetEntity(eHitEntity)
		else
			effectdata:SetEntity(NULL)
		end
	util.Effect("hit_healdart", effectdata)
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end

	local ent = data.HitEntity
	if ent and self:GetSeeked() and self:GetSeeked():IsValidLivingHuman() and ent ~= self:GetSeeked() then
		return false
	end

	if not util.HitFence(self, data, phys) then
		self.PhysicsData = data
		self.Done = true
	end

	self:NextThink(CurTime())
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if self.Targeting and not (self:GetSeeked() == ent) then return end

	if ent:IsValidLivingHuman() then 
		if (owner:IsSkillActive(SKILL_SMART_DELIVERY) and (self.Targeting) or (ent:Health() < ent:GetMaxHealth())) or (not owner:IsSkillActive(SKILL_SMART_DELIVERY)) then -- TODO
			self:Hit(nil, nil, ent, nil)
		end
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

function HitSeekedTarget(gun, target)
	if not gun or not gun.GetSeekedPlayer then
		return false
	end

	local seekedTarget = gun:GetSeekedPlayer()
	if seekedTarget ~= target then
		return false
	end

	return true
end