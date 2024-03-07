AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if SERVER then
		local enty = self

		hook.Add("SpecialPlayerDamage", tostring(enty), function(ent, dmginfo)
			if not IsValid(self) then return end
			
			local attacker = dmginfo:GetAttacker()
			if attacker ~= enty:GetOwner() then return end
		
			if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
				local dmg = dmginfo:GetDamage()
				dmginfo:SetDamage(dmg * (enty:GetDamage() or 0.75))
			end
		end)

		self:SetDTInt(1, 0)
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	hook.Remove("SpecialPlayerDamage", tostring(self))
end

function ENT:SetDamage(damage)
	self:SetDTFloat(5, math.Clamp(damage, 0.75, 1))
end

function ENT:GetDamage()
	if self:GetDTFloat(5) > 1 then -- ebic
		return self:GetDTFloat(5)
	end
end