SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = (translate.Get("wep_grenadelauncher"))
SWEP.Description = (translate.Get("desc_grenadelauncher"))
SWEP.SlotPos = 5

SWEP.ViewModel = "models/weapons/c_grenadelauncher.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadDelay = 0.65

SWEP.SoundFireVolume = 0.61

SWEP.Primary.Sound = ")weapons/ar2/ar2_altfire.wav"

SWEP.Primary.Damage = 90
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1

SWEP.Recoil = 7.5

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.DefaultClip = 28

SWEP.ConeMin = 0
SWEP.ConeMax = 0

SWEP.Tier = 3
--SWEP.MaxStock = 2
SWEP.IsAoe = true

SWEP.Primary.ProjExplosionRadius = 50
SWEP.Primary.ProjExplosionTaper = 0.825

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.FireAnimSpeed = 1
SWEP.Knockback = 80

SWEP.ReloadActivity = ACT_VM_RELOAD
SWEP.PumpActivity = ACT_SHOTGUN_RELOAD_FINISH
SWEP.ReloadStartActivity = ACT_SHOTGUN_RELOAD_START

SWEP.PumpSound = Sound("Weapon_Shotgun.Special1")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.Mogus = 1

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)

function SWEP:StopReloading()
	self:SetDTFloat(15, 0)
	self:SetDTBool(9, false)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 0.75)

	-- do the pump stuff if we need to
	if self:Clip1() > 0 then
		if self.PumpSound then
			self:EmitSound(self.PumpSound)
		end
		if self.PumpActivity then
			self:SendWeaponAnim(self.PumpActivity)
			self:ProcessReloadAnim()
			timer.Simple(0.2, function()
				if IsValid(self) then
					self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
					--self:EmitSound(self.PumpSound)
					self:GetOwner():GetViewModel():SetPlaybackRate(1 * self:GetReloadDelay())
				end
			end)
		end
	end
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

	timer.Simple(0.1, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
			self:EmitSound(self.PumpSound)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
		end
	end)
end

local mogus = 1
function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Mogus = 1
	elseif self:GetFireMode() == 1 then
		self.Mogus = 0
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:SetSwitchDelay(0.1)
end