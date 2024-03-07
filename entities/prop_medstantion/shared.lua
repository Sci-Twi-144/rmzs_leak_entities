ENT.Type = "anim"

ENT.SWEP = "weapon_zs_medstantion"

ENT.Healing = nil
ENT.Cooldown = 4
ENT.HealRadius = 16384

ENT.DefaultAmmo = 0
ENT.MaxAmmo = 300
ENT.AmmoType = "Battery"

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.IgnoreBullets = true
ENT.IgnoreMeleeTeam = TEAM_HUMAN

ENT.CanPackUp = true

ENT.IsBarricadeObject = true
ENT.AlwaysGhostable = true
ENT.EntityDeployable = true

util.PrecacheModel("models/props_lab/reciever_cart.mdl")

function ENT:GetObjectHealth()
	return self:GetDTFloat(0)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(1, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(1)
end

function ENT:GetAmmo()
	return self:GetDTInt(0)
end

function ENT:CanBePackedBy(pl)
	local owner = self:GetObjectOwner()
	return not IsValid(owner) or owner == pl or owner:Team() == TEAM_UNDEAD or gamemode.Call("PlayerIsAdmin", pl)
end
