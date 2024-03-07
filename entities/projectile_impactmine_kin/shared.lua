ENT.Base = "projectile_impactmine"
ENT.IsProjectileZS = true

function ENT:GetStartPos()
	return self:GetPos() + self:GetUp() * 5
end
