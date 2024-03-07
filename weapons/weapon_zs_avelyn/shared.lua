SWEP.PrintName = (translate.Get("wep_avelyn"))
SWEP.Description = (translate.Get("desc_avelyn"))

SWEP.Base = "weapon_zs_baseproj"
DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = "weapons/crossbow/fire1.wav"
SWEP.Primary.ClipSize = 3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Damage = 105
SWEP.Primary.BurstShots = 3

SWEP.ConeMax = 2.25
SWEP.ConeMin = 2

SWEP.InnateBounty = true
SWEP.BountyDamage = 0.2

SWEP.Recoil = 1

SWEP.ReloadSpeed = 0.5

SWEP.WalkSpeed = SPEED_SLOW

SWEP.ResistanceBypass = 0.6

SWEP.Tier = 5

--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.04, 1)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()

	self:SetNextShot(CurTime())
	self:SetShotsLeft(self.Primary.BurstShots)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
	BaseClass.Think(self)

	self:ProcessBurstFire()
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/crossbow/reload1.wav", 70, 110)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/galil/galil_boltpull.wav", 70, 110)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/crossbow/fire1.wav", 70, 120, 0.7)
	self:EmitSound("weapons/crossbow/bolt_skewer1.wav", 70, 193, 0.7, CHAN_AUTO)
end
