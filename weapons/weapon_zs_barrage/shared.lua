SWEP.PrintName = (translate.Get("wep_barrage"))
SWEP.Description = (translate.Get("desc_barrage"))

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.Delay = 0.9 -- 0.7
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Damage = 26
SWEP.Primary.NumShots = 3

SWEP.ConeMax = 8
SWEP.ConeMin = 7.5
SWEP.ReloadSpeed = 0.8

SWEP.Primary.ProjExplosionRadius = 82
SWEP.Primary.ProjExplosionTaper = 0.92

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4
--SWEP.MaxStock = 3
SWEP.IsAoe = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05)
--GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_eminence")), (translate.Get("desc_eminence")), "weapon_zs_eminence") -- just fuck it, idc to fix

function SWEP:EmitFireSound()
	self:EmitSound("weapons/grenade_launcher1.wav", 70, math.random(118, 124), 0.3)
	self:EmitSound("npc/attack_helicopter/aheli_mine_drop1.wav", 70, 100, 0.7, CHAN_AUTO + 20)
end
