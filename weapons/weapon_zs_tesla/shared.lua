SWEP.PrintName = (translate.Get("wep_tesla"))
SWEP.Description = (translate.Get("desc_tesla"))

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = Model("models/rmzs_customs/tesla_coil.mdl")

SWEP.Base = "weapon_zs_base"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.Deployable = true

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "tesla"
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"

SWEP.MaxStock = 5
SWEP.Tier = 5

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOWEST

SWEP.NoDeploySpeedChange = true
SWEP.AllowQualityWeapons = true

SWEP.LegDamage = 20
SWEP.LegDamageMul = 2.353

SWEP.Primary.Damage = 85
SWEP.CoolDown = 3
SWEP.MaxDistance = 150

SWEP.GhostStatus = "ghost_tesla"
SWEP.DeployClass = "prop_tesla"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_COOLDOWN, -0.25, 1)

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
	self:SetDeploySpeed(10)
	self:HideViewAndWorldModel()
end

function SWEP:SetReplicatedAmmo(count)
	self:SetDTInt(7, count)
end

function SWEP:GetReplicatedAmmo()
	return self:GetDTInt(7)
end

function SWEP:GetWalkSpeed()
	if self:GetPrimaryAmmoCount() > 0 then
		return self.FullWalkSpeed
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:Holster()
	return true
end
