ENT.Type = "anim"

ENT.ExplosionDelay = 0.7

ENT.NoPropDamageDuringWave0 = true
ENT.IsProjectileZS = true

ENT.IgnoreBullets = true

function ENT:SetExplodeTime(time)
	self:SetDTFloat(0, time)
end

function ENT:GetExplodeTime()
	return self:GetDTFloat(0)
end

function ENT:SetARMTime(time)
	self:SetDTFloat(2, time)
end

function ENT:GetARMTime()
	return self:GetDTFloat(2)
end