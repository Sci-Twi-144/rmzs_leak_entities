AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_battlehammer"))
SWEP.Description = (translate.Get("desc_battlehammer"))
SWEP.AbilityMax = 650

if CLIENT then
	SWEP.ViewModelFOV = 60

	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource() , self.AbilityMax, col, "Skull Crusher", false)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/rmzs/c_battlehammer.mdl"
SWEP.WorldModel = "models/weapons/rmzs/w_battlehammer.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.SPMultiplier = 4

SWEP.MeleeDamage = 150
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 76
SWEP.MeleeSize = 1.85
SWEP.MeleeKnockBack = 170

SWEP.Primary.Delay = 1.5

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingTime = 0.5
SWEP.SwingHoldType = "melee2"

SWEP.SwingTimeSP = 2.6

SWEP.BlockRotation = Angle(0, 0, 25)
SWEP.BlockOffset = Vector(-5, 0, -2)

SWEP.CanBlocking = true
SWEP.BlockReduction = 16
SWEP.BlockStability = 0.25
SWEP.StaminaConsumption = 10

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_SECONDARYATTACK

SWEP.Tier = 4

SWEP.HasAbility = true
SWEP.ResourceMul = 0.75

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_fusionhammer")), (translate.Get("desc_fusionhammer")), "weapon_zs_fusionhammer")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:SendWeaponAnim(self:GetTumbler() and ACT_VM_RELEASE or ACT_VM_HITCENTER)
	self:GetOwner():GetViewModel():SetPlaybackRate(self:GetTumbler() and 1 or (self.SwingTime * (1 + (1 - (otbl.MeleeSwingDelayMul or 1))) * 2))
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = self:GetTumbler() and stbl.SwingTimeSP or stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5)
	local condition = not self:GetTumbler() and clamped or 1
	self:SetSwingEnd(CurTime() + time * condition)
end

function SWEP:CanReload()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetResource() < 650 then return false end
	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:Reload()
	if not self:CanReload() then return end
	self:ProcessSpecialAttack()
end

function SWEP:ProcessSpecialAttack()
	if self:GetResource() >= 650 then
		self:StopWind()
		self:SetTumbler(true)
		self:StartWinding()
		self:SetNextAttack()
		self:SetResource(0)
	end
end

function SWEP:AfterSwing()
	if self:GetTumbler() then
		self:SetTumbler(false)
	end
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(86, 90))
	self:EmitSound("weapons/crowbar/crowbar_impact"..math.random(2)..".wav", 75, math.random(160, 196), 0.7, CHAN_WEAPON + 20)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90))
	self:EmitSound("weapons/crowbar/crowbar_impact"..math.random(2)..".wav", 75, math.random(160, 196), 0.7, CHAN_WEAPON + 20)
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and hitent:IsHeadcrab() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
	end
end