ENT.Type = "anim"

ENT.Radius = 75
ENT.IsProjectileZS = true

ENT.IgnoreBullets = true
ENT.IgnoreMelee = true
ENT.IgnoreTraces = true

function ENT:SetGasEmit(emit)
	self:SetDTBool(0, emit)
end

function ENT:GetGasEmit()
	return self:GetDTBool(0)
end
