AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_lamp"))
SWEP.Description = (translate.Get("desc_lamp"))

if CLIENT then
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_interiors/Furniture_Lamp01a.mdl", bone = "tag_weapon", rel = "", pos = Vector(0, 0, 5), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_interiors/Furniture_Lamp01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 1.5, -15), angle = Angle(180, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	local metal, field = Material("models/weapons/rmzs/scythe/scythe_metal"), Material("models/weapons/rmzs/scythe/scythe_field")

	function SWEP:PreDrawViewModel(vm)
		self.BaseClass.PreDrawViewModel(self, vm)
		metal:SetFloat("$emissiveblendenabled", 0)
		field:SetFloat("$emissiveblendenabled", 0)
	end

	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource() , self.AbilityMax, col, "Light On", false, true)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/rmzs/scythe/c_grotesque.mdl"
SWEP.WorldModel = "models/props_interiors/Furniture_Lamp01a.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 72
SWEP.MeleeRange = 80
SWEP.MeleeSize = 2
SWEP.MeleeKnockBack = 120

SWEP.Primary.Delay = 1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 2

SWEP.BlockRotation = Angle(0, 0, 15)
SWEP.BlockOffset = Vector(-5, 0, -2)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.2
SWEP.BlockReduction = 9
SWEP.StaminaConsumption = 8

SWEP.SwingTime = 0.65
SWEP.SwingHoldType = "melee"

SWEP.AbilityMax = 500
SWEP.HasAbility = true
SWEP.ResourceMul = 1

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.AllowQualityWeapons = true

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 80, math.Rand(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_solid_impact_hard"..math.random(4, 5)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
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

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if self:GetResource() >= self.AbilityMax then
		self:SetTumbler(true)
		self:SetResource(self.AbilityMax)
	end
	if hitent:IsValidLivingZombie() and (hitent:GetBossTier() < 1) then
		if self:GetTumbler() then
			self:SetTumbler(false)
			self:SetResource(0)
			if SERVER then
				hitent:ScreenFade(SCREENFADE.IN, COLOR_WHITE, 0.8, 0.2)
				hitent:SetDSP(36)
				hitent:EmitSound("weapons/flashbang/flashbang_explode2.wav")
			end
		end
	end
end

