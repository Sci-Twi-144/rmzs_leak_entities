SWEP.PrintName = "Nanite Blaster"
SWEP.Description = "Стреляет снарядом, который чинит пропы"
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"
DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = ""

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Ammo = "pulse"
SWEP.RequiredClip = 5

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.ReloadSpeed = 0.85

SWEP.BuffDuration = 10

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

-- SWEP.SetUpFireModes = 1
-- SWEP.CantSwitchFireModes = false
-- SWEP.PushFunction = true

SWEP.Mogus = 1

SWEP.Primary.ProjExplosionRadius = 32

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 1)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 100, 150, 0.65, CHAN_WEAPON + 21)
end

function SWEP:GetFireDelay()
	local owner = self:GetOwner()
	return (self.Primary.Delay * (owner.MedgunFireDelayMul or 1)) / (owner:GetStatus("frost") and 0.7 or 1)
end

function SWEP:GetReloadSpeedMultiplier()
	local owner = self:GetOwner()
	return BaseClass.GetReloadSpeedMultiplier(self) * (owner.MedgunReloadSpeedMul or 1) -- Convention is now BaseClass instead of self.BaseClass
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	return self:GetNextSecondaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
end

function SWEP:SetSeekedPlayer(ent)
	self:SetDTEntity(6, ent)
end

function SWEP:GetSeekedPlayer()
	return self:GetDTEntity(6)
end

-- function SWEP:CheckFireMode()
	-- if self:GetFireMode() == 0 then
		-- self.Mogus = 1
	-- elseif self:GetFireMode() == 1 then
		-- self.Mogus = 0
	-- end
-- end

-- function SWEP:CallWeaponFunction()
	-- self:CheckFireMode()
	-- self:SetSwitchDelay(0.1)
-- end