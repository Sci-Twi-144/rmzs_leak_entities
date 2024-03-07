AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_hurricane"))
SWEP.Description = (translate.Get("desc_hurricane"))

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.AbilityText = "Pulse Damage"
SWEP.AbilityColor = Color(96, 65, 250)
SWEP.AbilityMax = 100
SWEP.AbilityMul = 3.5

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54

	SWEP.HUD3DBone = "Bolt"
	SWEP.HUD3DPos = Vector(0, 0.2, -1)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.ViewModelBoneMods = {
		["ValveBiped.square"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(0, -0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -24, 0) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "4.84"
		elseif self:GetFireMode() == 1 then
			return "76.3"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "4.84 GHz"
		elseif self:GetFireMode() == 1 then
			return "76.3 GHz"
		end
	end

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:DrawWorldModel()
		self:SetBodygroup(self:FindBodygroupByName("studio"), 1)
		self:SetBodygroup(self:FindBodygroupByName("combi_world"), 1)
		self.BaseClass.DrawWorldModel(self)
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/rmzs/weapons/mp5k/c_mp5k.mdl"
SWEP.WorldModel = "models/rmzs/weapons/mp5k/w_mp5k.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = Sound("Weapon_Hurricane.Single")

SWEP.Primary.Damage = 17.5
SWEP.DamageSave = SWEP.Primary.Damage * (GAMEMODE.ZombieEscape and 4 or 1)
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09

SWEP.Primary.ClipSize = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 1.19

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 4.3
SWEP.ConeMin = 2.5

SWEP.HasAbility = true
SWEP.SpecificCond = true

SWEP.WalkSpeed = SPEED_FAST
SWEP.PointsMultiplier = 1.1
SWEP.TracerName = "AR2Tracer"

SWEP.IronSightsPos = Vector(-4.176, 4, 1.5)
SWEP.IronSightsAng = Vector(0.368, -0.197, 0)

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 1.5
SWEP.LegDamage = 1.5
SWEP.InnateLegDamage = true

SWEP.Tier = 2

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5375, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.3125, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 2, 1)

local texture = Material("models/rmzs/weapons/mp5k/assimilated_parts_cables")

function SWEP:Initialize()
	if CLIENT then
		texture:SetFloat("$emissiveblendstrength", 0)
	end
	self.BaseClass.Initialize(self)
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
	local vm = self:GetOwner():GetViewModel()
	vm:SetBodygroup(vm:FindBodygroupByName("studio"), 1)
	vm:SetBodygroup(vm:FindBodygroupByName("combine_atch"), 1)
	local wm = self:GetOwner()

	return true
end

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_IDLE or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:GetCone()
	return self.BaseClass.GetCone(self) * ((self:GetFireMode() == 0) and 1 or 0.5)
end

function SWEP:GetFireDelay()
	return self.BaseClass.GetFireDelay(self) - (tobool(self:GetFireMode() == 1) and (self:GetResource() * 0.001) or 0)
end

local function Based(self)
	self.Primary.Damage = self.DamageSave
	self.ResistanceBypass = 0.6

	self.Pierces = 1
	self.Recoil = 0
end

local function Overcharged(self)
	self.Primary.Damage = self.DamageSave * (1 + self:GetResource() / 75)
	self.ResistanceBypass = 0.8
	self.ClassicSpread = true
	self.Recoil = 0.25
	self:SetResource(math.max(self:GetResource() - self.AbilityMax / self:GetMaxClip1(), 0))
end

function SWEP:FinishReload()
	if self:GetFireMode() == 1 then
		self:EmitSound("weapons/rmzs/fusion_breaker/fusion_startup.ogg", 75, math.Rand(86, 90))
	end
	self.BaseClass.FinishReload(self)
end

function SWEP:CallWeaponFunction()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

function SWEP:PrimaryAttack()
	if self:GetFireMode() == 0 then
		Based(self)
	elseif (self:GetFireMode() == 1) then
		if (self:GetResource() > 0) then
			Overcharged(self)
		else
			return 
		end
	end
	if CLIENT then
		texture:SetFloat("$emissiveblendstrength", (self:GetResource() / 100))
	end

	self.BaseClass.PrimaryAttack(self)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	if (wep:GetFireMode() == 0) and tr.Entity:IsValidLivingZombie() and tobool(tr.Entity:GetLegDamage()) then
		wep:SetResource(math.min(wep:GetResource() + (((tr.Entity:GetLegDamage() * 1.2) * (attacker.AbilityCharge or 1)) or 0) * wep.AbilityMul, wep.AbilityMax))
	end
	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end
end

sound.Add(
{
	name = "Weapon_Hurricane.Single",
	channel = CHAN_WEAPON,
	volume = 0.7,
	soundlevel = 100,
	pitch = {70,80},
	sound = {"weapons/ar2/fire1.wav"}
})

sound.Add({
	name = "Weapon_SMG2.NPC_Fire",
	channel = CHAN_USER_BASE+10,
	volume = 0.75,
	level = 140,
	pitch = {142, 148},
	sound = ")weapons/hmg/hmg_fire_player_01.wav"
})

sound.Add({
	name = "Weapon_SMG2.Bolt_Grab",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapons/hmg/handling/hmg_bolt_grab_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = "weapons//handling/.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapons/akm/handling/akm_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Lock",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapons/hmg/handling/hmg_bolt_lock_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_bolt_release_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_mag_in_01.wav"
})