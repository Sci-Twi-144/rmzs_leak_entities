--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_healdart"

ENT.Heal = 10
ENT.PointsMultiplier = 1.25
ENT.Gravity = false

ENT.Branch = nil
ENT.AttackMode = nil

function ENT:Initialize()
	self.Touched = {}
	self.IsOnceEnts = {}
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.3, 0)
	self:SetupGenericProjectile(false)
	self:SetTrigger(true)
	
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONFLAGS_HUMANPROJ)

	self:Fire("kill", "", 30)
	
	if self:GetDTInt(15) == 1 then
		self.Branch = true
	end

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

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 then return end

	self:SetHitTime(CurTime())

	self:Fire("kill", "", 0)

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	local alt = self:GetDTInt(15) == 1
	local alt2 = self:GetDTInt(15) == 2
	if eHitEntity:IsValid() then
		if eHitEntity:IsPlayer() then
			if eHitEntity:Team() == TEAM_UNDEAD then
				if self.PointsMultiplier then
					POINTSMULTIPLIER = self.PointsMultiplier
				end
				self:DealProjectileTraceDamageNew(eHitEntity, self.ProjDamage or 60, self:GetPos(), owner)
				if self.PointsMultiplier then
					POINTSMULTIPLIER = nil
				end
				
				local status = (alt or alt2) and "zombiestrdebuff" or "zombiedartdebuff"
				local sdamage = (alt or alt2) and (1 + (0.25 * (owner.BuffEffectivenessMD or 1))) or (1 - (0.25 * (owner.BuffEffectivenessMD or 1)))
				eHitEntity:ApplyZombieDebuff(status, (self.BuffDuration or 10) * owner.BuffDurationMD, {Applier = owner, Damage = sdamage}, true, (alt or alt2) and 35 or 37)
			elseif eHitEntity:Team() == TEAM_HUMAN then
				local ehithp, ehitmaxhp = eHitEntity:Health(), eHitEntity:GetMaxHealth()

				if not (owner:IsSkillActive(SKILL_RECLAIMSOL) and ehithp >= ehitmaxhp) then

					local heal = self.Heal
					local calc_duration = (self.BuffDuration or 10) * (owner.BuffDurationMD or 1)
					local duration = ((alt or alt2) and 2 or 1) * (calc_duration * (owner.BuffDuration or 1))
					local regen, regular = math.ceil(self.Heal/2), math.floor(self.Heal/2)

					if alt2 then
						eHitEntity:ApplyHumanBuff("ammoback", duration, {Applier = owner})
						
						if gamemode.Call("PlayerCanBeHealed", eHitEntity) then
							eHitEntity:AddHealthRegeneration(regen, owner, 1, true)
							if rawget(PLAYER_LastHitTime, eHitEntity) < CurTime() then
								owner:HealPlayer(eHitEntity, regular)
							end
						end
					else
						local opts = {Applier = owner, Damage = alt and (0.3 * owner.BuffEffectivenessMD) or (0.2 * owner.BuffEffectivenessMD)}
						eHitEntity:ApplyHumanBuff(alt and "strengthdartboost" or "medrifledefboost", duration, opts)
						
						if gamemode.Call("PlayerCanBeHealed", eHitEntity) then
							eHitEntity:AddHealthRegeneration(regen, owner, 1, true)
							if rawget(PLAYER_LastHitTime, eHitEntity) < CurTime() then
								owner:HealPlayer(eHitEntity, regular)
							end
						end
					end

					local gun = self:ProjectileDamageSource()
						if gun and HitSeekedTarget(gun, eHitEntity) then
							gun:SetActivePatient(eHitEntity, duration, (alt2 and PATIENT_COLOR_GREEN) or (alt and PATIENT_COLOR_RED) or PATIENT_COLOR_BLUE)
						end

					local txt = (alt and "Strength Rifle") or (alt2 and "Ammo Rifle") or "Medical Rifle"

					net.Start("zs_buffby")
						net.WriteEntity(owner)
						net.WriteString(txt)
					net.Send(eHitEntity)

					net.Start("zs_buffwith")
						net.WriteEntity(eHitEntity)
						net.WriteString(txt)
					net.Send(owner)
					
				else
					self:DoRefund(owner)
				end
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
		if eHitEntity:IsValid() then
			effectdata:SetEntity(eHitEntity)
		else
			effectdata:SetEntity(NULL)
		end
	util.Effect(alt and "hit_strengthdart" or "hit_healdart2", effectdata)
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if self.Targeting and not (self:GetSeeked() == ent) then return end

	if not self.AttackMode then
		if ent:IsValidLivingHuman() or ent:IsValidLivingZombie() then
			if (owner:IsSkillActive(SKILL_SMART_DELIVERY) -- TODO
			and self.Targeting
			or (ent:Health() < ent:GetMaxHealth())
			or (not ent:GetStatus(self.Branch and "strengthdartboost" or "medrifledefboost")))
			or (not owner:IsSkillActive(SKILL_SMART_DELIVERY)) then
				self:Hit(nil, nil, ent, nil)
			end
		end
	else
		if ent:IsValidLivingZombie() then
			self:Hit(nil, nil, ent, nil)
		end
	end
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