ENT.Type = "anim"
ENT.Base = "status__base"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
--ENT.IgnoreMelee = true
ENT.IgnoreMeleeTeam = TEAM_UNDEAD
ENT.IsShadeShield = true

function ENT:SetState(state)
	self:SetDTInt(0, state)
end

function ENT:GetState()
	return self:GetDTInt(0)
end

function ENT:SetStateEndTime(time)
	self:SetDTFloat(0, time)
end

function ENT:GetStateEndTime()
	return self:GetDTFloat(0)
end

function ENT:SetDirection(m)
	self:SetDTInt(1, m)
end

function ENT:GetDirection()
	return self:GetDTInt(1)
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(1, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		if SERVER then
			local effectdata = EffectData()
				effectdata:SetOrigin(self:WorldSpaceCenter())
				effectdata:SetNormal(self:GetUp())
			util.Effect("explosion_shadeshield", effectdata, true, true)

			util.ScreenShake(self:GetPos(), 15, 5, 1.5, 800)
			self:EmitSound("ambient/levels/labs/electric_explosion2.wav", 85, 100)
		end
	end
end

function ENT:GetObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(2, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(2)
end

function ENT:HitByWrench(wep, owner, tr)
	return true
end