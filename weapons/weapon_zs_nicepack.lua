AddCSLuaFile()

SWEP.Base = "weapon_zs_boardpack"

SWEP.PrintName = (translate.Get("wep_nicepack"))
SWEP.Description = (translate.Get("desc_nicepack"))

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 15


function SWEP:Initialize()
	self.JunkModels = {
		Model("models/props_debris/wood_board04a.mdl"),
		Model("models/props_debris/wood_board06a.mdl"),
		Model("models/props_debris/wood_board02a.mdl"),
		Model("models/props_debris/wood_board01a.mdl"),
		Model("models/props_debris/wood_board07a.mdl")
	}

	self.BaseClass.Initialize(self)
end