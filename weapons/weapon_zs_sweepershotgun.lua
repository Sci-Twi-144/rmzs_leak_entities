AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_baseshotgun")

SWEP.PrintName = (translate.Get("wep_sweepershotgun"))
SWEP.Description = (translate.Get("desc_sweepershotgun"))

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-1.3, -4, -3.2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, Color(121, 121, 121), self:GetResource(), self.AbilityMax, "BURST FIRE")
		--self:DrawAbilityBar2D(x, y, hei, wid, Color(0, 128, 192), self:GetResource(), 900, "PULSE ARC")
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, Color(121, 121, 121), self:GetResource(), self.AbilityMax, "BURST FIRE")
		--self:DrawAbilityBar3D(x, y, hei, wid, Color(0, 128, 192), self:GetResource(), 900, "PULSE ARC")
	end

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

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.UseHands = true

SWEP.ReloadDelay = 0.5

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/m3/m3-1.wav"
SWEP.Primary.Damage = 14.25
SWEP.DamageSave = SWEP.Primary.Damage * (GAMEMODE.ZombieEscape and 4 or 1)
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.8

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 5
SWEP.ConeMin = 3.75

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.FireAnimSpeed = 1.2
SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 4

SWEP.HasAbility = true
SWEP.AbilityMax = 600
SWEP.ResourceCap = SWEP.AbilityMax
SWEP.SpecificCond = false 

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

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1) 


function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.ResistanceBypass = 1
		self.Primary.NumShots = 9
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.ClassicSpread = false
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave * 6.35
		self.ResistanceBypass = 0.6
		self.Primary.NumShots = 1
		self.ConeMax = self.ConeMaxSave * 0.35
		self.ConeMin = self.ConeMinSave * 0.20
		self.ClassicSpread = true
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_xm1014")), (translate.Get("desc_xm1014")), function(wept)
	wept.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
	wept.WorldModel = "models/weapons/w_shot_xm1014.mdl"

	wept.Primary.Damage = wept.Primary.Damage * 0.883
	wept.Primary.Sound = ")weapons/xm1014/xm1014-1.wav"
	wept.Primary.Delay = 0.38
	wept.Primary.ClipSize = 6
	wept.Primary.Automatic = true

	wept.CantSwitchFireModes = true
	wept.HasAbility = false
	wept.InnateEffect = true
	wept.InnateBounty = true
	wept.BountyDamage = 0.35

	wept.ConeMax = 6 * 1.25
	wept.ConeMin = 3.75 * 1.25
	
	wept.ReloadSpeed = 0.86

	if CLIENT then
		wept.HUD3DBone = "v_weapon.xm1014_Bolt"
		wept.HUD3DPos = Vector(-1, 0, 0)
		wept.HUD3DAng = Angle(0, 0, 0)
		wept.HUD3DScale = 0.02
	end
end)
branch.Colors = {Color(136, 136, 136), Color(70, 70, 70), Color(39, 39, 39)}
branch.Killicon = "weapon_zs_xm1014"

function SWEP:SecondaryAttack()
	if self:GetTumbler() then
		if not self:CanPrimaryAttack() then return end

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitFireSound()
	
		self:SetNextShot(CurTime())
		self:SetShotsLeft(self:Clip1())
	
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:Think()
	BaseClass.Think(self)

	if not self.HasAbility then return end

	if self:GetResource() >= self.AbilityMax then
		self:SetTumbler(true)
	end

	self:ProcessBurstFire(nil, nil, true)
end