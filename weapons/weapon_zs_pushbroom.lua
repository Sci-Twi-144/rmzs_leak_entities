AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_pushbroom"))
SWEP.Description = (translate.Get("desc_pushbroom"))

if CLIENT then
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_c17/pushbroom.mdl", bone = "tag_weapon", rel = "", pos = Vector(1.3, -0.35, 7), angle = Angle(110, 80, 130), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_c17/pushbroom.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, 5), angle = Angle(247, 90, 283), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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

SWEP.MeleeDamage = 76
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
SWEP.StaminaConsumption = 8

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.AllowQualityWeapons = true
SWEP.PArsenalModel = "models/props_c17/pushbroom.mdl"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_IMPACT_DELAY, -0.05)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 80, math.Rand(60, 65))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/wood/wood_plank_impact_hard"..math.random(4)..".wav", 75, math.random(75, 80))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/wood/wood_plank_impact_hard"..math.random(4)..".wav", 75, math.random(75, 80))
end


local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:SendWeaponAnim(self:IsHeavy() and ACT_VM_PRIMARYATTACK or ACT_VM_PRIMARYATTACK_2)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.SwingTime * (1 + (1 - (otbl.MeleeSwingDelayMul or 1))) * 1.14)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, self.SwingTime * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5)
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
end