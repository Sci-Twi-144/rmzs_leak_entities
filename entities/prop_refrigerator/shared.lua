ENT.Type = "anim"

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.CanPackUp = true

ENT.IgnoreBullets = true
ENT.IgnoreMeleeTeam = TEAM_HUMAN

ENT.IsBarricadeObject = true
ENT.AlwaysGhostable = true
ENT.EntityDeployable = true

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true
		self:FakePropBreak()
	end
end

function ENT:GetObjectHealth()
	return self:GetDTFloat(0)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(1, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(0, ent)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(0)
end

function ENT:ClearObjectOwner()
	self:SetObjectOwner(NULL)
end