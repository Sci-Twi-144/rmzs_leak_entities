AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_sledgehammer"))
SWEP.Description = (translate.Get("desc_sledgehammer"))
 
if CLIENT then
	SWEP.ViewModelFOV = 55

	function SWEP:DrawAds()
	end

	function SWEP:DrawConditions()
		local fulltime = self.Primary.Delay * self:GetOwner():GetMeleeSpeedMul()
		
		GAMEMODE:DrawCircleEx(x, y, 17, self:IsHeavy() and COLOR_YELLOW or COLOR_DARKRED, self:GetNextPrimaryFire() , fulltime)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/rmzs/c_sledgehammer_redone.mdl"
SWEP.WorldModel = "models/weapons/rmzs/w_sledgehammer_redone.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 105
SWEP.MeleeRange = 64
SWEP.MeleeSize = 1.75
SWEP.MeleeKnockBack = 270

SWEP.Primary.Delay = 1.4

SWEP.SwingTime = 0.33
SWEP.SwingRotation = Angle(-3.0, 7.0, -25)
SWEP.SwingOffset = Vector(10, -7, 0)
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 0, 5)
SWEP.BlockOffset = Vector(-1, 0, -2)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.2
SWEP.BlockReduction = 9
SWEP.StaminaConsumption = 12

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.Tier = 2
SWEP.DisableHeavy = true

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.AllowQualityWeapons = true

SWEP.MeleeHeadShotMulti = 1.8

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_IMPACT_DELAY, -0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 2)

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_masher")), (translate.Get("desc_masher")), "weapon_zs_megamasher")
branch.Killicon = "weapon_zs_megamasher"

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
local acttbl = {
	ACT_VM_HITLEFT
	--ACT_VM_SWINGHARD
}

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	--if not owner:KeyDown(IN_ATTACK) then
		self:SendWeaponAnim(acttbl[math.random(#acttbl)])
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	--end

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5) -- we dont want over 2x attack penalty, right?
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
end

function SWEP:OnHeavyCharge()
	self:SendWeaponAnim(ACT_VM_HITLEFT)
	self.IdleAnimation = CurTime() + self:SequenceDuration() 
end

function SWEP:OnHeavy()
	self:SendWeaponAnim(ACT_VM_HITLEFT)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(86, 90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90))
end

