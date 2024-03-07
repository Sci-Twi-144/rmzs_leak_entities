AddCSLuaFile()

SWEP.PrintName = "'Executioner' Axe"
SWEP.Description = (translate.Get("desc_executioner"))

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/rmzs/weapons/poleaxe/c_poleaxe.mdl"
SWEP.WorldModel = "models/rmzs/weapons/poleaxe/w_poleaxe.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 130
SWEP.MeleeRange = 78
SWEP.MeleeSize = 3
SWEP.MeleeKnockBack = 225

SWEP.HitAnim = ACT_VM_MISSCENTER
SWEP.Primary.Delay = 1.35

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.SwingTime = 0.7

--SWEP.SwingRotation = Angle(-3.0, 7.0, -25)
--SWEP.SwingOffset = Vector(10, -7, 0)
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 0, 5)
SWEP.BlockOffset = Vector(-1, 0, -2)

SWEP.CanBlocking = true
SWEP.BlockReduction = 13
SWEP.BlockStability = 0.5
SWEP.StaminaConsumption = 10

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.Tier = 3

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.13)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:SendWeaponAnim(self:IsHeavy() and ACT_VM_HITRIGHT or ACT_VM_HITLEFT)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.SwingTime * (1 + (1 - (otbl.MeleeSwingDelayMul or 1))) * 1.1)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, self.SwingTime * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5) -- we dont want over 2x attack penalty, right?
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf_club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Alive() and hitent:Health() <= hitent:GetMaxHealthEx() * 0.1 and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		if SERVER then
			hitent:SetWasHitInHead()
		end
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
		hitent:EmitSound("npc/roller/blade_out.wav", 80, 75)
	end
end
