SWEP.PrintName = (translate.Get("wep_flashbomb"))
SWEP.Description = (translate.Get("desc_flashbomb"))

SWEP.Base = "weapon_zs_basethrown"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"

SWEP.Primary.Ammo = "flashbomb"
SWEP.Primary.Sound = "weapons/pinpull.wav"

SWEP.PrimaryActivity = ACT_VM_THROW
SWEP.PrimaryAnimationThrow = true

SWEP.MaxStock = 9

function SWEP:Precache()
	util.PrecacheSound("weapons/pinpull.wav")
end