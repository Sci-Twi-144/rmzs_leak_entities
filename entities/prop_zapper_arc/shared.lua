ENT.Base = "prop_zapper"

ENT.Damage = 55
ENT.MaxAmmo = 230

ENT.IgnoreMeleeTeam = TEAM_HUMAN
ENT.ForceDamageFloaters = true

ENT.HeatBuild = 0.1

function ENT:GetHeatLevel()
	return math.Clamp(self:GetDTFloat(6), 0.0, 1.0)	
end

function ENT:GetHeatState()
	return self:GetDTInt(6)
end