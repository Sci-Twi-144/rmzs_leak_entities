SWEP.PrintName = (translate.Get("wep_crossbow"))
SWEP.Description = (translate.Get("desc_crossbow"))

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.SoundFireVolume = 0.61
SWEP.SoundFireLevel = 75
SWEP.SoundPitchMin = 93
SWEP.SoundPitchMax = 108

SWEP.Primary.Sound = ")weapons/crossbow/fire1.wav"
SWEP.Primary.Delay = 2.0
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 80

SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.DefaultClip = 15

SWEP.Primary.ProjExplosionTaper = 0.85

SWEP.SecondaryDelay = 0.25

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 5
--SWEP.MaxStock = 2
SWEP.IsAoe = false

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.NextZoom = 0

SWEP.ReloadSpeed = 0.85 -- Since it works with it now.

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_PROJECTILE_VELOCITY, 100)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_avelyn")

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/crossbow/bolt_load"..math.random(2)..".wav", 65, 100, 0.9, CHAN_WEAPON + 21)
		self:EmitSound("weapons/crossbow/reload1.wav", 65, 100, 0.9, CHAN_WEAPON + 22)
	end
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

util.PrecacheSound("weapons/crossbow/bolt_load1.wav")
util.PrecacheSound("weapons/crossbow/bolt_load2.wav")
