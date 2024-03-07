ENT.Type = "anim"

ENT.IsZMPolip = true
ENT.ZombieConstruction = true
ENT.OrbsOut = false

function ENT:SetNestMaxHealth(health)
	self:SetDTInt(10, health)
end

function ENT:GetNestMaxHealth()
	return self:GetDTInt(10)
end

function ENT:SetNestCurHealth(health)
	self:SetDTInt(11, health)
end

function ENT:GetNestCurHealth()
	return self:GetDTInt(11)
end

function ENT:GetShield()
	return self:GetDTBool(12)
end

function ENT:SetShield(bool)
	self:SetDTBool(12, bool)
end