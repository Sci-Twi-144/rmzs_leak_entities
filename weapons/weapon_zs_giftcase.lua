AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Gift Case"
	SWEP.Description = "Open to find a random present!"
	
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
	SWEP.Slot = 5
	SWEP.SlotPos = 0
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["case"] = { type = "Model", model = "models/katharsmodels/present/type-2/small/present.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.7, 2.7, -1.5), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["case"] = { type = "Model", model = "models/katharsmodels/present/type-2/small/present.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2.7, -1), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basethrown"

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/katharsmodels/present/type-2/small/present.mdl"
SWEP.UseHands = true

SWEP.HoldType = "slam"

SWEP.WalkSpeed = SPEED_FAST

SWEP.AmmoIfHas = true
SWEP.NoDismantle = true
SWEP.Undroppable = true
SWEP.NoTransfer = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "gift"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 1

SWEP.WalkSpeed = SPEED_FAST

SWEP.AutoSwitchFrom = false
SWEP.Weight = 2 -- This is the second crappiest weapon you could hope for, besides food

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
	GAMEMODE:DoChangeDeploySpeed(self)

	if CLIENT then
		self:Anim_Initialize()
	end
end

function SWEP:ShootBullets()
	local owner = self:GetOwner()
	self:SendWeaponAnim(ACT_VM_DRAW)
	owner:DoAttackEvent()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:ShootBullets()
	self:TakePrimaryAmmo(1)
	self.NextDeploy = CurTime() + 1

	if SERVER then
		GiveNonBullshitReward(self:GetOwner())
	end
end

function SWEP:SecondaryAttack()
end