--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Hit(vHitPos, vHitNormal, eHitEntity, vOldVelocity)
	if self:GetHitTime() ~= 0 then return end
	self:SetHitTime(CurTime())

	self.Done = true
	self:Fire("kill", "", 0)

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	local alt = self:GetDTBool(0)
	if eHitEntity:IsValid() then
		if eHitEntity:IsPlayer() and eHitEntity:Team() ~= TEAM_UNDEAD then
			local calc_duration = (self.BuffDuration or 10) * (owner.BuffDurationMD or 1)
			local duration = (alt and 2 or 1) * calc_duration
			--print(duration)
			local opts = {Applier = owner, Damage = 0.25 * (owner.BuffEffectivenessMD or 1)}
			eHitEntity:ApplyHumanBuff(alt and "medrifledefboost" or "strengthdartboost", duration, opts)

			local txt = alt and "Defence Shot Gun" or "Strength Shot Gun"

			local gun = self:ProjectileDamageSource()
			if gun and HitSeekedTarget(gun, eHitEntity) then
				gun:SetActivePatient(eHitEntity, duration, alt and PATIENT_COLOR_BLUE or PATIENT_COLOR_RED)
			end

			net.Start("zs_buffby")
				net.WriteEntity(owner)
				net.WriteString(txt)
			net.Send(eHitEntity)

			net.Start("zs_buffwith")
				net.WriteEntity(eHitEntity)
				net.WriteString(txt)
			net.Send(owner)

			--eHitEntity:GiveStatus("healdartboost", (self.BuffDuration or 10)/2)
			eHitEntity:ApplyHumanBuff("healdartboost", (self.BuffDuration or 10)/2, {Applier = owner})
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
	util.Effect(alt and "hit_healdart2" or "hit_strengthdart", effectdata)
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if self.Targeting and not (self:GetSeeked() == ent) then return end

	if ent:IsValidLivingHuman() then
		if (owner:IsSkillActive(SKILL_SMART_DELIVERY)
		and (self.Targeting)
		or (not ent:GetStatus(self.Branch and "medrifledefboost" or "strengthdartboost")))
		or (not owner:IsSkillActive(SKILL_SMART_DELIVERY)) then
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