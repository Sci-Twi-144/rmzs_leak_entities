AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_finka"))
SWEP.Description = (translate.Get("desc_finka"))

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 75

	SWEP.ShowWorldModel = false

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/rmzs/weapons/finka_nkvd.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-10, 5, -15), angle = Angle(0, 0, 200), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "knife"
SWEP.ViewModel = "models/rmzs/weapons/finka_nkvd.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 27 * 1.65
SWEP.MeleeDamageSave = SWEP.MeleeDamage
SWEP.MeleeRange = 60
SWEP.MeleeSize = 0.875

SWEP.HeadshotMulti = 3

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.Primary.Delay = 0.65
SWEP.SaveDelay = SWEP.Primary.Delay

SWEP.HitDecal = "Manhackcut"

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitAnim = ACT_VM_PRIMARYATTACK
SWEP.MissAnim = ACT_VM_PRIMARYATTACK

SWEP.NoHitSoundFlesh = true

SWEP.CanBlocking = false

SWEP.StaminaConsumption = 10
SWEP.SaveStaminaConsumption = SWEP.StaminaConsumption

SWEP.Tier = 3

SWEP.AllowQualityWeapons = true

SWEP.PArsenalModel = "models/rmzs/weapons/finka_nkvd.mdl"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, 0.1, 3)

local function MAIN(self)
	self.MeleeDamage = self.MeleeDamageSave
	self.HitAnim = ACT_VM_PRIMARYATTACK
	self.Primary.Delay = self.SaveDelay
end

local function SECOND(self)
	self.MeleeDamage = self.MeleeDamageSave * 2
	self.HitAnim = ACT_VM_SECONDARYATTACK
	self.Primary.Delay = self.SaveDelay * 1.5
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	SECOND(self)
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	MAIN(self)
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(4)..".wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and not self.m_BackStabbing and math.abs(hitent:GetForward():Angle().yaw - self:GetOwner():GetForward():Angle().yaw) <= 90 then
		self.m_BackStabbing = true
		self.MeleeDamage = self.MeleeDamage * 2
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if self.m_BackStabbing then
		self.m_BackStabbing = false

		self.MeleeDamage = self.MeleeDamageSave
	end
end

function SWEP:OnZombieKilled(pl, totaldamage, dmginfo)
	local killer = self:GetOwner()
	killer:ApplyHumanBuff("healdartboost", 3, {Applier = killer})
end

if SERVER then
	function SWEP:InitializeHoldType()
		self.ActivityTranslate = {}
		self.ActivityTranslate[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_KNIFE
		self.ActivityTranslate[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_KNIFE
		self.ActivityTranslate[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_KNIFE
		self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_CROUCH_PHYSGUN
		self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_KNIFE
		self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
		self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_KNIFE
		self.ActivityTranslate[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_KNIFE
		self.ActivityTranslate[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_KNIFE
	end
end
