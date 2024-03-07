SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/Combine_turrets/Floor_turret.mdl"

SWEP.PrintName = (translate.Get("wep_gunturret"))
SWEP.Description = (translate.Get("desc_gunturret"))

SWEP.Base = "weapon_zs_base"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.Deployable = true

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "thumper"
SWEP.Primary.Delay = 2
SWEP.Primary.Damage = 8.6

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.MaxStock = 5

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOWEST

SWEP.TurretType = 1
SWEP.SearchDistance = 768
SWEP.GhostStatus = "ghost_gunturretm"
SWEP.DeployClass = "prop_gunturret"
SWEP.Channel = "turret"

SWEP.TurretAmmoType = "smg1"
SWEP.TurretAmmoStartAmount = 250
SWEP.TurretSpread = 2

SWEP.NoDeploySpeedChange = true
SWEP.AllowQualityWeapons = false

--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TURRET_SPREAD, -0.4)

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
	GAMEMODE:DoChangeDeploySpeed(self)
	self:HideViewAndWorldModel()

	self.ResupplyAmmoType = self.TurretAmmoType
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

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if SERVER then
		local count = self:GetPrimaryAmmoCount()
		if count ~= self:GetReplicatedAmmo() then
			self:SetReplicatedAmmo(count)
			self:GetOwner():ResetSpeed()
		end
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:Holster()
	return true
end

util.PrecacheModel("models/Combine_turrets/Floor_turret.mdl")
