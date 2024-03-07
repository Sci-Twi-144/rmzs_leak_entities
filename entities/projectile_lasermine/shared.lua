ENT.Base = "projectile_impactmine"
ENT.IsProjectileZS = true

function ENT:GetStartPos()
	return self:GetPos() + self:GetUp() * 5
end

function ENT:SetSelfTime(time)
	self:SetDTInt(3, time)
end

function ENT:GetSelfTime()
	return self:GetDTInt(3)
end