AddCSLuaFile()

SWEP.Base = "weapon_zs_base_akimbo"

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(2, -1, 1)
	SWEP.HUD3DAng = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.01

	SWEP.HUD3DBone2 = "tag_weapon"
	SWEP.HUD3DPos2 = Vector(2, 1, 1)
	SWEP.HUD3DAng2 = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.01

	SWEP.VElementsR = {}
	SWEP.VElementsL = {}

	SWEP.WElements = {
        ["fixleft"] = { type = "Model", model = "models/weapons/w_vector_a1.mdll", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.001, 0.001, 0.001), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["UZIWM2"] = { type = "Model", model = "models/weapons/w_vector_a1.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "fixleft", pos = Vector(10, 1.4, 1.5), angle = Angle(0, 0, 0), size = Vector(0.99, 1.014, 0.99), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["UZIWM1"] = { type = "Model", model = "models/weapons/w_vector_a1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, -0.3, -1.5), angle = Angle(0, 0, 180), size = Vector(0.99, 1.014, 0.99), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }

	SWEP.IronSightsPos = Vector(-2, -1, 1)

	SWEP.VMPos = Vector(0.5, -0.2, -0.3)
	SWEP.VMAng = Vector(1, 0, -2)
end

--SWEP.PrintName = "'Two Shadows' Akimbo Vectors"
--SWEP.Description = "Akimbo"
SWEP.PrintName = (translate.Get("wep_akimbo_vectors"))
SWEP.Description = (translate.Get("desc_akimbo_vectors"))
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_vector_a1.mdl"
SWEP.ViewModel_L = "models/weapons/c_vector_a1.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = false

SWEP.SoundFireVolume = 1
SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.SoundFireVolume_S = 1
SWEP.SoundPitchMin_S = 95
SWEP.SoundPitchMax_S = 100

SWEP.Primary.Sound = ")weapons/zs_vector/Fire.wav"
SWEP.Primary.Damage = 23.08
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06

SWEP.Secondary.Sound = ")weapons/zs_vector/Fire.wav"
SWEP.Secondary.Damage = 23.08
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Delay = 0.06

SWEP.Primary.ClipSize = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.DefaultClip = 250

SWEP.Secondary.ClipSize = 25
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "smg1"
SWEP.Secondary.DefaultClip = 250

SWEP.RequiredClip = 1
SWEP.Auto = true
SWEP.CantSwitchFireModes = true

SWEP.ConeMax = 3.85 * 1.3
SWEP.ConeMin = 1.85 * 1.3

SWEP.ConeMax_S = 3.85 * 1.3
SWEP.ConeMin_S = 1.85 * 1.3

SWEP.FireAnimSpeed = 1

SWEP.Tier = 5

SWEP.FireAnimIndexMin = 1
SWEP.FireAnimIndexMax = 2
SWEP.ReloadAnimIndex = 7
SWEP.DeployAnimIndex = 3

SWEP.FireAnimIndexMin_S = 1
SWEP.FireAnimIndexMax_S = 2
SWEP.ReloadAnimIndex_S = 0
SWEP.DeployAnimIndex_S = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.15)

function SWEP:PrimaryFire()
	if not self:CanAttackCheck(false) then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()
	self:TakeAmmo(false)

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin, self.FireAnimIndexMax), 0, self.FireAnimSpeed)
end

function SWEP:SecondaryFire()
	if not self:CanAttackCheck(true)  then return end

	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(true))
	self:EmitFireSound_S()
	self:TakeAmmo(true)
	
	self:ShootBullets_Left(self.Secondary.Damage, self.Secondary.NumShots, self:GetCone_S())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin_S, self.FireAnimIndexMax_S), 1, self.FireAnimSpeed)
end

sound.Add({
	name = 			"Vector.fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/Fire.wav"
})

sound.Add({
	name = 			"Vector.lift",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/lift.wav"	
})

sound.Add({
	name = 			"Vector.clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/clipout.wav"	
})

sound.Add({
	name = 			"Vector.clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/clipin.wav"	
})

sound.Add({
	name = 			"Vector.chamber",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/chamber.wav"	
})

sound.Add({
	name = 			"Vector.draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/draw.wav"	
})