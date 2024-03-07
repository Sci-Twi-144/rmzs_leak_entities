AddCSLuaFile()

SWEP.Base = "weapon_zs_base_akimbo"


if CLIENT then
    SWEP.ViewModelFOV = 33

    SWEP.VMPos = Vector(1.5, 9, -1.75)
    SWEP.VMAng = Vector(2, 1, -6)

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1, -1, 0.5)
	SWEP.HUD3DAng = Angle(0, 180, 75)
	SWEP.HUD3DScale = 0.0125

	SWEP.HUD3DBone2 = "weapon"
	SWEP.HUD3DPos2 =  Vector(1.2, 1, 0.5)
	SWEP.HUD3DAng2 = Angle(180, 180, -125)
	SWEP.HUD3DScale = 0.0125

    SWEP.VElements = {}
	SWEP.WElements = {
        ["fixleft"] = { type = "Model", model = "models/weapons/w_smg_mac10.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1, 2.5, -1), angle = Angle(0, 0, 180), size = Vector(0.001, 0.001, 0.001), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["wep_left"] = { type = "Model", model = "models/weapons/w_ins2_pist_ots33.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "fixleft", pos = Vector(1.5, 1.5, -2.3), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_right"] = { type = "Model", model = "models/weapons/w_ins2_pist_ots33.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 1.1, -1.3), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
        ["L Clavicle"] = { scale = Vector(0, 0, 0), pos = Vector(-10, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(0, 0, 0), pos = Vector(-10, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(-0.0, -0.05, 0.2), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0.25, 0, 0), angle = Angle(0, 0, 0) }
	}
	--[[
    function SWEP:GetDisplayAmmo(clip, spare, maxclip)
		local minus = self:GetAltUsage() and 0 or 1
		return math.max(0, (clip * 2) - minus), spare * 2, maxclip * 2
	end

    function SWEP:GetDisplayAmmo2(clip, spare, maxclip)
		local minus = self:GetAltUsage2() and 0 or 1
		return math.max(0, (clip * 2) - minus), spare * 2, maxclip * 2
	end
	]]
end

SWEP.PrintName = (translate.Get("wep_ot33akimbo"))
SWEP.Description = (translate.Get("desc_ot33akimbo"))
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_ins2_pist_ots33.mdl"
SWEP.ViewModel_L = "models/weapons/c_ins2_pist_ots33.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.SoundFireVolume = 1
SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/ots33/fire1.wav"
SWEP.Primary.Damage = 47
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.066

SWEP.SoundFireVolume_S = 1
SWEP.SoundPitchMin_S = 100
SWEP.SoundPitchMax_S = 110

SWEP.Secondary.Sound = ")weapons/ots33/fire1.wav"
SWEP.Secondary.Damage = 47
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Delay = 0.066

--SWEP.Primary.ClipMultiplier = 12/18 * 2 
SWEP.Primary.ClipSize = 27
SWEP.Primary.DefaultClip = 27
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.BulletType = SWEP.Primary.Ammo

SWEP.Secondary.ClipSize = 27
SWEP.Secondary.DefaultClip = 27
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "pistol"

SWEP.RequiredClip = 1
SWEP.Auto = true
SWEP.CantSwitchFireModes = true

SWEP.ConeMax = 8.5
SWEP.ConeMin = 6.5

SWEP.ConeMax_S = 8.5
SWEP.ConeMin_S = 6.5

SWEP.FireAnimSpeed = 1.0

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.FireAnimIndexMin = 6
SWEP.FireAnimIndexMax = 6
SWEP.ReloadAnimIndex = 9
SWEP.DeployAnimIndex = 4

SWEP.FireAnimIndexMin_S = 6
SWEP.FireAnimIndexMax_S = 6
SWEP.ReloadAnimIndex_S = 9
SWEP.DeployAnimIndex_S = 4

--GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_ot33")), (translate.Get("desc_ot33")), "weapon_zs_ot33")

local function CreateMuzzleFlashEffect(self, left)
	if GAMEMODE.OverTheShoulder then return end -- no need effect in thirdperson!

	local data = EffectData()
		data:SetFlags(0)
		data:SetEntity(self:GetOwner():GetViewModel(left and 1 or 0))
		data:SetAttachment(1)
		data:SetScale(1)
	util.Effect("CS_MuzzleFlash", data)
end
--[[
function SWEP:PrimaryFire()
	if not self:CanAttackCheck(false) then return end

	if self:GetFireMode() == 1 then
		self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(true) * 0.5)
	end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

	self:EmitFireSound()

	local altuse = self:GetAltUsage()
	if not altuse then
		self:TakeAmmo(false)
	end
    self:SetAltUsage(not altuse)

	if CLIENT and self.ShouldMuzzleR then
		CreateMuzzleFlashEffect(self, false)
	end
	
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin, self.FireAnimIndexMax), 0, self.FireAnimSpeed)
end

function SWEP:SecondaryFire()
	if not self:CanAttackCheck(true)  then return end

	if self:GetFireMode() == 1 then
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 0.5)
	end
	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(true))

	self:EmitFireSound_S()

	local altuse = self:GetAltUsage2()
	if not altuse then
		self:TakeAmmo(true)
	end
    self:SetAltUsage2(not altuse)

	if CLIENT and self.ShouldMuzzleL then
		CreateMuzzleFlashEffect(self, true)
	end
	
	self:ShootBullets_Left(self.Secondary.Damage, self.Secondary.NumShots, self:GetCone_S())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin_S, self.FireAnimIndexMax_S), 1, self.FireAnimSpeed)
end

function SWEP:SetAltUsage(usage)
	self:SetDTBool(8, usage)
end

function SWEP:GetAltUsage()
	return self:GetDTBool(8)
end

function SWEP:SetAltUsage2(usage)
	self:SetDTBool(9, usage)
end

function SWEP:GetAltUsage2()
	return self:GetDTBool(9)
end
]]