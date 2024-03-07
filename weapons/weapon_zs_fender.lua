AddCSLuaFile()

SWEP.PrintName = "Fender"

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_phx/misc/fender.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.5, 0.5, -5), angle = Angle(-90, -25, 75), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_phx/misc/fender.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, -2.5, -4), angle = Angle(-90, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_phx/misc/fender.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 55
SWEP.MeleeRange = 75
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 0
SWEP.Primary.Delay = 0.45
SWEP.StaminaConsumption = 2

SWEP.WalkSpeed = SPEED_SLOW

SWEP.SwingTime = 0
SWEP.SwingRotation = Angle(0, -20, -40)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee"

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.AllowQualityWeapons = true

SWEP.Weight = 2
SWEP.Tier = 3

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.ChargeSound = CreateSound(self, ")ambient/music/country_rock_am_radio_loop.wav")
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	if self:GetDTInt(8) < 10 then
		self:EmitSound("weapons/guitar/guitar_hit_world_0"..math.random(5)..".wav", 100 / (self:GetDTInt(8) / 2))
	end
end

function SWEP:PlayHitFleshSound()
	if self:GetDTInt(8) < 10 then
		self:EmitSound("weapons/guitar/melee_guitar_0"..math.random(14)..".wav")
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if self:GetDTInt(8) > 10 then
		self.ChargeSound:PlayEx(1, 100)
	else
		self.ChargeSound:Stop()
	end
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	
	self:SetNextPrimaryFire(CurTime() + math.max(0.2, E_GetTable(self).Primary.Delay - (self:GetDTInt(8) / 30)) * armdelay)
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() then
		local combo = self:GetDTInt(8)
		local owner = self:GetOwner()

		self:SetDTInt(8, combo + 1)
		print(self:GetDTInt(8))
	end
end

function SWEP:PostOnMeleeMiss(tr)
	self:SetDTInt(8, 0)
end