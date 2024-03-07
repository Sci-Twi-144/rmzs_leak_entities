AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_jackhammer"))
SWEP.Description = (translate.Get("desc_jackhammer"))

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "W_Main"
	SWEP.HUD3DPos = Vector(1.6, -2.2, -1)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015

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

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(0, 0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -12, 0) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/rmzs/weapons/jackhammer/c_jackhammer.mdl"
SWEP.WorldModel = "models/rmzs/weapons/jackhammer/w_jackhammer.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Jack.Fire")
SWEP.Primary.Damage = 13.5
SWEP.DamageSave = SWEP.Primary.Damage * (GAMEMODE.ZombieEscape and 4 or 1)
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 7
SWEP.ConeMin = 4

SWEP.IronSightsPos = Vector(-2, 2, 1)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.StandartIronsightsAnim = false

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.ReloadSpeed = 0.68

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

--SWEP.MaxStock = 3

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

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -1.125)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.81)

--GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_gladiator")

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.ResistanceBypass = 1
		self.Primary.NumShots = 9
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.ClassicSpread = false
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave * 6.6
		self.ResistanceBypass = 0.6
		self.Primary.NumShots = 1
		self.ConeMax = self.ConeMaxSave * 0.35
		self.ConeMin = self.ConeMinSave * 0.20
		self.ClassicSpread = true
	end
end

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.2)
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 75, math.random(147, 153), 0.7)
	self:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, math.random(132, 138), 0.6, CHAN_WEAPON + 20)
end

sound.Add({
	name = 			"Jack.Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			")weapons/jackhammer/fire_jack.wav"
})

sound.Add({
	name = 			"Jack.Pumpout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/jackhammer/jack_pumpout.wav"
})

sound.Add({
	name = 			"Jack.Pumpin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/jackhammer/jack_pumpin.wav"
})

sound.Add({
	name = 			"Jack.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/jackhammer/jack_clipout.wav"
})

sound.Add({
	name = 			"Jack.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/jackhammer/jack_clipin.wav"
})
