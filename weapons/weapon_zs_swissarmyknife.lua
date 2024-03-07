AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_swissarmyknife"))
SWEP.Description = (translate.Get("desc_swissarmyknife"))

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else 
			return "BLOCK"
		end
	end	
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:CheckFireMode()
	local stbl = E_GetTable(self)

	if self:GetFireMode() == 0 then

		self:SetBlocking(false) -- in case if someone changed a fire mode while blocking
		stbl.CanBlocking = false

		stbl.SecondaryAttack = stbl.SecondaryAttackSave
	else

		stbl.CanBlocking = true

		stbl.SecondaryAttack = nil

	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
end

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true 

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "knife"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 21
SWEP.MeleeDamageSave = SWEP.MeleeDamage
SWEP.MeleeRange = 60
SWEP.MeleeSize = 0.875

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.Primary.Delay = 0.4
SWEP.SaveDelay = SWEP.Primary.Delay

SWEP.HitDecal = "Manhackcut"

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitAnim = ACT_VM_PRIMARYATTACK
SWEP.MissAnim = ACT_VM_PRIMARYATTACK

SWEP.NoHitSoundFlesh = true

SWEP.BlockRotation = Angle(0, -10, -30)
SWEP.BlockOffset = Vector(4, 6, 2)

SWEP.CanBlocking = false
SWEP.BlockStability = 0.1
SWEP.BlockReduction = 4
SWEP.StaminaConsumption = 5

SWEP.SaveStaminaConsumption = SWEP.StaminaConsumption

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3)

local function MAIN(self)
	self.MeleeDamage = self.MeleeDamageSave
	self.HitAnim = ACT_VM_PRIMARYATTACK
	self.Primary.Delay = self.SaveDelay
	self.StaminaConsumption = self.SaveStaminaConsumption
end

local function SECOND(self)
	self.MeleeDamage = self.MeleeDamageSave * 3.25
	self.HitAnim = ACT_VM_SECONDARYATTACK
	self.Primary.Delay = self.SaveDelay * 2.5
	self.StaminaConsumption = self.SaveStaminaConsumption * 2
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	SECOND(self)
	self.BaseClass.PrimaryAttack(self)
end

SWEP.SecondaryAttackSave = SWEP.SecondaryAttack

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
		self.MeleeDamage = self.MeleeDamage * 3
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if self.m_BackStabbing then
		self.m_BackStabbing = false

		self.MeleeDamage = self.MeleeDamageSave
	end
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

function SWEP:GetAuraRange()
	return GAMEMODE.Hideandseek and 0 or 2048
end
