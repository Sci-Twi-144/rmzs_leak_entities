SWEP.PrintName = (translate.Get("wep_inquisitor"))
SWEP.Description = (translate.Get("desc_inquisitor"))

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = "weapons/crossbow/fire1.wav"
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Delay = 1.25
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Damage = 83

SWEP.ConeMax = 0.5
SWEP.ConeMin = 0

SWEP.Recoil = 5

SWEP.ReloadSpeed = 0.6

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 2

SWEP.Pierces = 3

SWEP.ReloadActivity = ACT_VM_DRAW

SWEP.Primary.ProjVelocity = 1600
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.06)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_absolver")), (translate.Get("desc_absolver")), function(wept)
	wept.Pierces = -1
	wept.Primary.Damage = wept.Primary.Damage * 1.2
	wept.Primary.ProjVelocity = 2100
	wept.Primary.Projectile = "projectile_arrow_cha"
	wept.ReloadSpeed = wept.ReloadSpeed * 0.85
end)

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/crossbow/reload1.wav", 70, 130, 1, CHAN_WEAPON + 22)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/galil/galil_boltpull.wav", 70, 150)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/crossbow/fire1.wav", 70, 180, 0.7, CHAN_WEAPON + 20)
	self:EmitSound("weapons/crossbow/bolt_skewer1.wav", 70, 243, 0.7, CHAN_WEAPON + 21)
end
