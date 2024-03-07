--[[SECURE]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:DoShit()
	local owner = self:GetOwner()
	local tr = owner:CompensatedMeleeTrace(self.RepairRange, 1, nil, nil, false, true)
	if (self.NextHurt or 0) <= CurTime() and tr.Entity:IsPlayer() and tr.Entity:Team() == TEAM_UNDEAD then
		self.NextHurt = CurTime() + 0.4
		tr.Entity:TakeSpecialDamage(15, DMG_CLUB, owner, self, tr.HitPos)
		tr.Entity:AddLegDamageExt(4.5, owner, self, SLOWTYPE_PULSE)
		self:ShouldTakeAmmo(1)
	end

	self:EmitSound("weapons/physcannon/superphys_small_zap"..math.random(4)..".wav", 100, math.random(110, 115))
end

function SWEP:DoShitAgain()
	local owner = self:GetOwner()
	local  tr = owner:CompensatedMeleeTrace(self.RepairRange, 1, nil, nil, false, true)
	local ent = tr.Entity
	if tr.Hit and tr.Entity:IsValid() and tr.Entity:IsNailed() and tr.HitPos:Distance(tr.StartPos) <= self.RepairRange and (self.LastRepair or 0) + self.Primary.Delay < CurTime() then
		self.LastRepair = CurTime()

		if ent.HitByHammer and ent:HitByHammer(self, owner, tr) then
			return
		end

		if owner:IsSkillActive(SKILL_BARRICADEEXPERT) then
			ent.ReinforceEnd = CurTime() + 5
			ent.ReinforceApplier = owner
		end
		
		local healstrength = self.HealStrength * GAMEMODE.NailHealthPerRepair * (owner.RepairRateMul or 1)
		local oldhealth = ent:GetBarricadeHealth()
		if oldhealth <= 0 or oldhealth >= ent:GetMaxBarricadeHealth() or ent:GetBarricadeRepairs() <= 0.01 then return end

		ent:SetBarricadeHealth(math.min(ent:GetMaxBarricadeHealth(), ent:GetBarricadeHealth() + math.min(ent:GetBarricadeRepairs(), healstrength)))
		local healed = ent:GetBarricadeHealth() - oldhealth
		ent:SetBarricadeRepairs(math.max(ent:GetBarricadeRepairs() - healed, 0))
		self:PlayRepairSound(ent)
		self:ShouldTakeAmmo(1)
		gamemode.Call("PlayerRepairedObject", owner, ent, healed, self)

		return true
	elseif tr.Hit and tr.Entity:IsValid() and tr.HitPos:Distance(tr.StartPos) <= self.RepairRange and (self.LastRepair or 0) + self.Primary.Delay < CurTime() then
		self.LastRepair = CurTime()
		if ent.HitByWrench and ent:HitByWrench(self, owner, tr) then
			return
		end

		if ent.GetObjectHealth then
			local oldhealth = ent:GetObjectHealth()
			if oldhealth <= 0 or oldhealth >= ent:GetMaxObjectHealth() or ent.m_LastDamaged and CurTime() < ent.m_LastDamaged + 4 then return end

			local healstrength = (self.HealStrength * GAMEMODE.NailHealthPerRepair) * ((owner.RepairRateMul or 1) * (ent.WrenchRepairMultiplier or 1))

			ent:SetObjectHealth(math.min(ent:GetMaxObjectHealth(), ent:GetObjectHealth() + healstrength))
			local healed = ent:GetObjectHealth() - oldhealth
			self:PlayRepairSound(ent)
			self:ShouldTakeAmmo(1)
			gamemode.Call("PlayerRepairedObject", owner, ent, healed, self)

			return true
		end
	end
end
