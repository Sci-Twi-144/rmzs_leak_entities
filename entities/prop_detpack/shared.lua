ENT.Type = "anim"

ENT.CanPackUp = true
ENT.PackUpTime = 2

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.NoPropDamageDuringWave0 = true

ENT.ExplosionDelay = 1.5

ENT.IsProjectileZS = true -- add filter to ignore them!

ENT.IgnoreBullets = true
ENT.IgnoreMeleeTeam = TEAM_HUMAN

ENT.ForceDamageFloaters = true

function ENT:GetExplodeTime()
	return self:GetDTFloat(0)
end

function ENT:SetObjectOwner(owner)
	self:SetOwner(owner)
end

function ENT:GetObjectOwner()
	return self:GetOwner()
end

function ENT:SetARMTime(time)
	self:SetDTFloat(2, time)
end

function ENT:GetARMTime()
	return self:GetDTFloat(2)
end