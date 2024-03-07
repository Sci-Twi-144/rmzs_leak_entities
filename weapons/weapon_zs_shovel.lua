AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_shovel"))
SWEP.Description = (translate.Get("desc_shovel"))

if CLIENT then
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "tag_weapon", rel = "", pos = Vector(1.6, 0, 5), angle = Angle(180, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.363, -15), angle = Angle(-3, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	local metal, field = Material("models/weapons/rmzs/scythe/scythe_metal"), Material("models/weapons/rmzs/scythe/scythe_field")

	function SWEP:PreDrawViewModel(vm)
		self.BaseClass.PreDrawViewModel(self, vm)
		metal:SetFloat("$emissiveblendenabled", 0)
		field:SetFloat("$emissiveblendenabled", 0)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/rmzs/scythe/c_grotesque.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 85
SWEP.MeleeRange = 80
SWEP.MeleeSize = 2
SWEP.MeleeKnockBack = 120

SWEP.Primary.Delay = 1

SWEP.Tier = 2

SWEP.WalkSpeed = SPEED_SLOW

SWEP.SwingTime = 0.65
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 0, 15)
SWEP.BlockOffset = Vector(-5, 0, -2)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.2
SWEP.BlockReduction = 9
SWEP.StaminaConsumption = 10

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.AllowQualityWeapons = true

SWEP.SwingRotation = Angle(-3.0, -15.0, -50)
SWEP.HeavyNoOffsetSwing = true

--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09, 1)
--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_IMPACT_DELAY, -0.06, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_lamp")), (translate.Get("desc_lamp")), "weapon_zs_lamp")
GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_pushbroom")), (translate.Get("desc_pushbroom")), "weapon_zs_pushbroom")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	if SERVER then
		self:SendWeaponAnim(self:IsHeavy() and ACT_VM_PRIMARYATTACK or ACT_VM_PRIMARYATTACK_2)
	end
	self:GetOwner():GetViewModel():SetPlaybackRate(self.SwingTime * (1 + (1 - (otbl.MeleeSwingDelayMul or 1))) * 0.96)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, self.SwingTime * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5)
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/shovel/shovel_hit-0"..math.random(4)..".ogg", 75, 80)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end


function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and Revive[hitent] and Revive[hitent]:IsValid() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
	end
end
