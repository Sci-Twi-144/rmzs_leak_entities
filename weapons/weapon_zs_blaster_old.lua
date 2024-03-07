AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = (translate.Get("wep_blaster"))
SWEP.Description = (translate.Get("desc_blaster"))

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 65

	SWEP.HUD3DPos = Vector(3, -0.5, -1.2)
	SWEP.HUD3DAng = Angle(90, 0, -30)
	SWEP.HUD3DScale = 0.016
	SWEP.HUD3DBone = "Weapon_Controller"


	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "SLUG"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "SLUG"
		end
	end	
end

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_blaster/c_blaster.mdl"
SWEP.WorldModel = "models/weapons/w_supershorty.mdl"
SWEP.UseHands = true

SWEP.ReloadDelay = 0.5

SWEP.Primary.Sound = Sound("Weapon_Shotgun.NPC_Single")
SWEP.Primary.Damage = 7.925
SWEP.DamageSave = SWEP.Primary.Damage
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.8

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 5.625
SWEP.ConeMin = 4.875

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.PumpSound = Sound("Weapon_M3.Pump")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.SpreadPattern = {
    {0, 0},
    {-5, 0},
    {-4, 3},
    {0, 5},
    {4, 3},
    {5, 0},
    {4, -3},
    {0, -5},
    {-4, -3},
}

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_blareduct")
-- GAMEMODE:AddNewRemantleBranch(SWEP, 2, nil, nil, "weapon_zs_cinderrod")

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.Primary.NumShots = 9
		self.ResistanceBypass = nil
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.ClassicSpread = false
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave * 6.35
		self.Primary.NumShots = 1
		self.ResistanceBypass = 0.6
		self.ConeMin = self.ConeMinSave * 0.20
		self.ConeMax = self.ConeMaxSave * 0.35
		self.ClassicSpread = true
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

	timer.Simple(0.15, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

			if CLIENT and self:GetOwner() == MySelf then
				self:EmitSound("weapons/m3/m3_pump.wav", 65, 100, 0.4, CHAN_AUTO)
			end
		end
	end)
end
