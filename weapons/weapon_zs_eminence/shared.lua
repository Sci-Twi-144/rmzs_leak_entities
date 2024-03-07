SWEP.PrintName = (translate.Get("wep_eminence"))
SWEP.Description = (translate.Get("desc_eminence"))

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = 3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.Delay = 0.8
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Damage = 26.5
SWEP.Primary.NumShots = 1

SWEP.ConeMax = 3
SWEP.ConeMin = 2

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4

SWEP.ReloadSpeed = 0.4

SWEP.ResistanceBypass = 0.4

SWEP.Primary.ClipMultiplier = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/grenade_launcher1.wav", 75, math.random(67, 74), 0.4)
	self:EmitSound("npc/attack_helicopter/aheli_mine_drop1.wav", 75, 65, 0.8, CHAN_AUTO + 20)
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/ar2/ar2_reload_rotate.wav", 70, 55)
		self:EmitSound("items/battery_pickup.wav", 70, 77, 0.85, CHAN_AUTO)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/ar2/ar2_reload_push.wav", pos, 70, math.Rand(130, 140))
	end
end

function SWEP:SetAltUsage(usage)
	self:SetDTBool(8, usage)
end

function SWEP:GetAltUsage()
	return self:GetDTBool(8)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()

	local altuse = self:GetAltUsage()
	if not altuse then
		self:TakeAmmo()
	end
	self:SetAltUsage(not altuse)

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end