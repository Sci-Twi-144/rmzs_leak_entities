if CLIENT then
	SWEP.Name = "Zombie Material"

	SWEP.Slot = -1
	SWEP.SlotPos = -1

	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.DrawWeaponInfoBox = false
end

SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.AnimPrefix = "none"
SWEP.HoldType = "normal"
SWEP.Spawnable = true

SWEP.DrawCrosshair = false
SWEP.Undroppable = true

SWEP.Primary.Sound = ""
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = SPEED_NORMAL

if SERVER then
	function SWEP:Initialize()
		if not GAMEMODE.ZombieEscape then
			self:Remove()
		end
	end

	function SWEP:OnDrop()
		self:Remove()
	end

	function SWEP:Deploy()
		self:GetOwner():SelectWeapon("weapon_zs_superzombie")
	end
else
	function SWEP:Deploy()
		return true
	end

	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	end

	function SWEP:DrawWorldModel()
	end

	function SWEP:DrawWorldModelTranslucent()
	end

	function SWEP:GetViewModelPosition(pos, ang)
		return pos, ang
	end

	function SWEP:TranslateFOV(fov)
		return fov
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:SecondaryAttack()
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SetWeaponHoldType()
end

function SWEP:Reload()
end
