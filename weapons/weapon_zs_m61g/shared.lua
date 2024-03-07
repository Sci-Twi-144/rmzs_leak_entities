SWEP.PrintName = (translate.Get("wep_m61g")) -- Lemon Grenade
SWEP.Description = (translate.Get("desc_m61g")) -- При взрыве, наносит кровотечение

SWEP.Base = "weapon_zs_basethrown"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Primary.Ammo = "GrenadeHL1"
SWEP.Primary.Sound = "weapons/pinpull.wav"

SWEP.PrimaryActivity = ACT_VM_THROW
SWEP.PrimaryAnimationThrow = true

SWEP.MaxStock = 9

function SWEP:Precache()
	util.PrecacheSound("weapons/pinpull.wav")
end