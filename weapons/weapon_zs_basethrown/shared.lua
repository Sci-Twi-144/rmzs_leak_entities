SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.UseHands = true

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "grenade"
SWEP.Primary.Delay = 1.25
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Sound = Sound("WeaponFrag.Throw")

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"

SWEP.WalkSpeed = SPEED_FAST

SWEP.AllowQualityWeapons = false
SWEP.PrimaryActivity = ACT_VM_PRIMARYATTACK
SWEP.SecondaryActivity = ACT_VM_SECONDARYATTACK
SWEP.PrimaryAnimationThrow = false


function SWEP:Initialize()
	self:SetWeaponHoldType("grenade")
	GAMEMODE:DoChangeDeploySpeed(self)

	if CLIENT then
		self:Anim_Initialize()
	end
end

function SWEP:Precache()
	util.PrecacheSound("WeaponFrag.Throw")
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack(secondary)
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo(1)
	self:ShootBullets(secondary)
	self.NextDeploy = CurTime() + 1
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack(true)
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Deploy()
	GAMEMODE:WeaponDeployed(self:GetOwner(), self)

	return true
end

function SWEP:Holster()
	self.NextDeploy = nil

	if self:GetPrimaryAmmoCount() <= 0 and SERVER then
		self:GetOwner():StripWeapon(self:GetClass())
	end

	return true
end

function SWEP:Think()

	local throwtime = self.PrimaryAnimationThrow and self:SequenceDuration(self:SelectWeightedSequence(self.PrimaryActivity)) or self:SequenceDuration(self:SelectWeightedSequence(self.SecondaryActivity))
	local desiredtime = self:GetNextPrimaryFire() - self.Primary.Delay + throwtime
	
	if self.NextDeploy and self.NextDeploy <= CurTime() then
		self.NextDeploy = nil

		if 0 < self:GetPrimaryAmmoCount() then
			self:SendWeaponAnim(ACT_VM_DRAW)
		end
	elseif SERVER and self:GetPrimaryAmmoCount() <= 0 and CurTime() > desiredtime then
		self:GetOwner():StripWeapon(self:GetClass())
	end
end