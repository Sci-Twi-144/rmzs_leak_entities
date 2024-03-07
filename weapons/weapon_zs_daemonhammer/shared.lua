SWEP.PrintName = (translate.Get("wep_earthshaker"))
SWEP.Description = (translate.Get("desc_earthshaker"))

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/rmzs/weapons/fusion_breaker/c_fusion_breaker.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 180
SWEP.MeleeRange = 86
SWEP.MeleeSize = 4.5
SWEP.MeleeKnockBack = 500

SWEP.MeleeDamageSecondaryMul = 1.2273
SWEP.MeleeKnockBackSecondaryMul = 1.25

SWEP.Primary.Delay = 1.5
SWEP.Secondary.Delay = SWEP.Primary.Delay * 2

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.SwingTime = 0.63
SWEP.SwingHoldType = "melee"

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.SwingTimeSecondary = 0.85

SWEP.Tier = 5
SWEP.MaxStock = 2

SWEP.BlockRotation = Angle(0, 0, 5)
SWEP.BlockOffset = Vector(-1, 0, -2)

SWEP.BlockReduction = 19
SWEP.BlockStability = 0.5
SWEP.StaminaConsumption = 15
SWEP.CanBlocking = true

SWEP.AllowQualityWeapons = true

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.14)

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "nox/scatterfrost.ogg")
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextSecondaryFire() <= CurTime() and not self:IsSwinging()
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging(secondary)
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:SendWeaponAnim(secondary and ACT_VM_HITRIGHT or ACT_VM_HITLEFT)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.SwingTime * (1 + (1 - (otbl.MeleeSwingDelayMul or 1))) * 1.15)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, (secondary and self.SwingTimeSecondary or self.SwingTime) * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5)
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
	if secondary then self:SetCharge(CurTime()) end
end

function SWEP:SetNextAttack(secondary)
	if self:IsBlocking() then return end
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() + (secondary and self.Primary.Delay + 0.23 or self.Primary.Delay) * armdelay)
	self:SetNextSecondaryFire(CurTime() + (secondary and self.Secondary.Delay or self.Primary.Delay) * armdelay)
end

function SWEP:Think()
	self.BaseClass.Think(self)
	local owner = self:GetOwner()

	local swinging = self:IsSwinging()
	local charging = self:IsCharging()

	if charging then
		self.ChargeSound:PlayEx(1, math.min(255, 35 + (CurTime() - self:GetCharge()) * 220))
	else
		self.ChargeSound:Stop()
	end

	if not swinging and charging then
		self:SetCharge(0)
	end

end

function SWEP:BeforeSwing(damagemultiplier)
	return damagemultiplier * 1.1
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(25, 35))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(70, 74))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_impact_hard"..math.random(2, 3)..".wav", 75, math.Rand(80, 84))
end

function SWEP:Reload()
	if not self:CanPrimaryAttack() or not self:CanSecondaryAttack() or self:IsBlocking() then return end
	self:SetNextAttack(true)
	self:StartSwinging(true)
end

function SWEP:IsCharging()
	return self:GetCharge() > 0
end

function SWEP:SetCharge(charge)
	self:SetDTFloat(14, charge)
end

function SWEP:GetCharge()
	return self:GetDTFloat(14)
end
