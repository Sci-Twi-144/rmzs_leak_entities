AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = (translate.Get("wep_boomstick"))
SWEP.Description = (translate.Get("desc_boomstick"))
SWEP.AbilityText = "KNOCKBACK"
SWEP.AbilityColor = Color(106, 10, 15)
SWEP.AbilityMax = 1350

if CLIENT then
	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.95, 0, -8)
	SWEP.HUD3DScale = 0.025

	SWEP.ViewModelFlip = false
	
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, true, 9, 1/9)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, true, 9, 1/9)
	end

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "KNOCK"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "KNOCK"
		end
	end	
end

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadDelay = 0.5

SWEP.Primary.Sound = "weapons/shotgun/shotgun_dbl_fire.wav"
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 1

SWEP.Recoil = 7.5

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.DefaultClip = 28

SWEP.Secondary.Sound = "weapons/shotgun/shotgun_dbl_fire7.wav"

SWEP.ConeMax = 11.5
SWEP.ConeMin = 10

SWEP.Tier = 5

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.FireAnimSpeed = 0.4
SWEP.MeleeKnockBack = 80
SWEP.Knockback = SWEP.MeleeKnockBack
SWEP.HasAbility = false
SWEP.MainAttack = true

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = true
SWEP.PushFunction = false

SWEP.EnableKnock = false

SWEP.PumpActivity = ACT_SHOTGUN_PUMP
SWEP.PumpSound = Sound("Weapon_Shotgun.Special1")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.05, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_KNOCK, 5, 1)

function SWEP:GetCone()
	return self.BaseClass.GetCone(self) * (self.MainAttack and 1 or 0.5)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self:GetOwner()
	self.MainAttack = true
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitSound(self.Primary.Sound)

	local clip = self:Clip1()

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self:GetCone())

	self:TakePrimaryAmmo(clip)
	owner:ViewPunch(clip * 0.5 * self.Recoil * 5 * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	owner:SetGroundEntity(NULL)
	if self:GetTumbler() and self.EnableKnock then
		owner:SetVelocity(-self.Knockback * clip * owner:GetAimVector())
		self:SetResource(math.max(self:GetResource() - 150, 0))
	end
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	self.MainAttack = false
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 0.7)
	self:EmitSound(self.Secondary.Sound)

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())

	self:TakePrimaryAmmo(1)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity 
	if SERVER and wep:IsValid() then
	    if wep:GetTumbler() and wep:GetResource() <= 0 then
		    wep:SetTumbler(false) 
	    elseif wep:GetResource() >= 150 then -- 1/9 of the ablity bar
		    wep:SetTumbler(true)
	    end
		if ent:IsValidLivingZombie() and not wep.EnableKnock then
			wep:SetResource(math.min(wep:GetResource() + (wep.EnableKnock and dmginfo:GetDamage() / 2 or dmginfo:GetDamage()) * (attacker.AbilityCharge or 1), wep.AbilityMax))
		end
	end
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.EnableKnock = false
	elseif self:GetFireMode() == 1 then
		self.EnableKnock = true
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1) 
end

function SWEP:Deploy()
	if player.GetCount() >= 26 and not self.HasAbility then
		self.HasAbility = true
		self.CantSwitchFireModes = false
		self.PushFunction = true
		self:SetResource(0)
		self:SetTumbler(false)
	end
	
    self.BaseClass.Deploy(self)
	return true
end