ENT.Type = "anim"

ENT.Damage = 25

ENT.DefaultAmmo = 0 --250
ENT.MaxAmmo = 1000
ENT.AmmoType = "pulse"
ENT.CoolDown = 5

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.CanPackUp = true

ENT.IsBarricadeObject = false
ENT.AlwaysGhostable = true
ENT.EntityDeployable = true
ENT.ForceDamageFloaters = true

ENT.IgnoreBullets = true
ENT.IgnoreMeleeTeam = TEAM_HUMAN

function ENT:GetObjectHealth()
	return self:GetDTFloat(0)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(1, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:GetNextZap()
	return self:GetDTFloat(2)
end

function ENT:SetNextZap(time)
	self:SetDTFloat(2, time)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(1)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
end

function ENT:SetAmmo(ammo)
	self:SetDTInt(0, ammo)
end

function ENT:GetAmmo()
	return self:GetDTInt(0)
end

function ENT:CanBePackedBy(pl)
	local owner = self:GetObjectOwner()
	return not IsValid(owner) or owner == pl or owner:Team() == TEAM_UNDEAD or gamemode.Call("PlayerIsAdmin", pl)
end
