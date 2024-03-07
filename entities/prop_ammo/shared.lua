ENT.Type = "anim"
ENT.Base = "prop_baseoutlined"

ENT.NoNails = true

function ENT:HumanHoldable(pl)
	return pl:KeyDown(GAMEMODE.UtilityKey)
end

function ENT:SetAmmoType(ammotype)
	self:SetModel(GAMEMODE.AmmoModels[string.lower(ammotype)] or "models/Items/BoxMRounds.mdl")
	self.m_AmmoType = ammotype

	self:SetDTString(0, ammotype)

	return true
end

function ENT:GetAmmoType()
	return self:GetDTString(0) or "pistol"
end