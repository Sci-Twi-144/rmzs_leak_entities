SWEP.PrintName = (translate.Get("wep_charon"))
SWEP.Description = (translate.Get("desc_charon"))

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
SWEP.Primary.Delay = 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 95.75

SWEP.Primary.ClipSize = 8
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.DefaultClip = 40

SWEP.WalkSpeed = SPEED_SLOW
SWEP.Tier = 3

SWEP.ReloadDelay = 2.8
SWEP.Recoil = 2

SWEP.ConeMax = 3.5
SWEP.ConeMin = 3.25

SWEP.NextZoom = 0

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.03)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_styx")), (translate.Get("desc_styx")), function(wept)
	wept.Primary.ClipSize = math.floor(wept.Primary.ClipSize * 2)
	wept.Primary.Delay = wept.Primary.Delay * 0.47
	wept.Primary.Damage = wept.Primary.Damage * 0.56
	wept.Primary.Projectile = "projectile_arrow_cha"
	wept.Primary.Automatic = true

	wept.ConeMax = wept.ConeMax * 1.4
	wept.ConeMin = wept.ConeMin * 1.4
	wept.ReloadSpeed = wept.ReloadSpeed * 0.7
end)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SetShootTime(CurTime())
end

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/crossbow/bolt_load"..math.random(2)..".wav", 50, 100, 1, CHAN_AUTO)
		self:EmitSound("weapons/crossbow/reload1.wav")
	end
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_FIDGET)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
	timer.Simple(self.Primary.Delay/3.5, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_IDLE)
			self:GetOwner():GetViewModel():SetPlaybackRate(6)
		end
	end)
end

function SWEP:SendReloadAnimation()
end

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	self:SetReloadFinish(CurTime() + self.ReloadDelay / reloadspeed)

	self.ReloadTime = self.ReloadDelay / reloadspeed 
end


function SWEP:SetShootTime(time)
	self:SetDTFloat(8, time)
end

function SWEP:GetShootTime()
	return self:GetDTFloat(8)
end

util.PrecacheSound("weapons/crossbow/bolt_load1.wav")
util.PrecacheSound("weapons/crossbow/bolt_load2.wav")
util.PrecacheSound("weapons/sniper/sniper_zoomin.wav")
util.PrecacheSound("weapons/sniper/sniper_zoomout.wav")
