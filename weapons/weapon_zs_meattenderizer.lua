AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_meattenderizer"))
SWEP.Description = (translate.Get("desc_meattenderizer"))

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["spikes2"] = { type = "Model", model = "models/props_phx/mechanics/slider1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "sledgetop", pos = Vector(-0.051, -5.915, -0.113), angle = Angle(0, 0, -90), size = Vector(0.076, 1.013, 0.356), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["spikes2+"] = { type = "Model", model = "models/props_phx/mechanics/slider1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "sledgetop", pos = Vector(-0.047, 5.934, 0.104), angle = Angle(0, 0, 90), size = Vector(0.076, 1.013, 0.356), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["sledgetop"] = { type = "Model", model = "models/props_junk/cardboard_box001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "sledge", pos = Vector(0, 0, 33), angle = Angle(0, 90, -5.652), size = Vector(0.196, 0.326, 0.284), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["spikes"] = { type = "Model", model = "models/props_phx/mechanics/slider1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "sledgetop", pos = Vector(-0.087, -5.854, 0), angle = Angle(-90, 90, 0), size = Vector(0.059, 0.95, 0.374), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["spikes+"] = { type = "Model", model = "models/props_phx/mechanics/slider1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "sledgetop", pos = Vector(-0.04, 5.888, 0), angle = Angle(90, 90, 0), size = Vector(0.059, 0.95, 0.374), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["sledge"] = { type = "Model", model = "models/weapons/w_sledgehammer.mdl", bone = "tag_weapon", rel = "", pos = Vector(0, 0, -8), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["top"] = { type = "Model", model = "models/props_junk/cardboard_box001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "sledge", pos = Vector(0, 0, 26.433), angle = Angle(90, 90, 0), size = Vector(0.196, 0.305, 0.284), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["spikes1++"] = { type = "Model", model = "models/props_phx/mechanics/slider1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "sledge", pos = Vector(-5.422, -0.069, 26.549), angle = Angle(0, -90, 90), size = Vector(0.059, 0.95, 0.374), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["spikes1+++"] = { type = "Model", model = "models/props_phx/mechanics/slider1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "sledge", pos = Vector(5.407, -0.069, 26.538), angle = Angle(0, 90, 90), size = Vector(0.059, 0.95, 0.374), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["spikes1"] = { type = "Model", model = "models/props_phx/mechanics/slider1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "sledge", pos = Vector(-5.487, 0, 26.361), angle = Angle(90, -90, 90), size = Vector(0.076, 1.011, 0.356), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["spikes1+"] = { type = "Model", model = "models/props_phx/mechanics/slider1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "sledge", pos = Vector(5.535, 0.126, 26.361), angle = Angle(90, 90, 90), size = Vector(0.076, 1.011, 0.356), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/metalladder001", skin = 0, bodygroup = {} },
		["sledge"] = { type = "Model", model = "models/weapons/w_sledgehammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.203, 1.284, 4.852), angle = Angle(180, 0, 0), size = Vector(0.759, 0.759, 0.759), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	
	local texture = Material( "models/rmzs/weapons/fusion_breaker/fusion_breaker_head.vmt" )

	function SWEP:PreDrawViewModel(vm)
		self.BaseClass.PreDrawViewModel(self, vm)
		texture:SetFloat("$emissiveblendenabled", 0)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

--SWEP.ViewModel = "models/weapons/v_sledgehammer/c_sledgehammer.mdl"
SWEP.ViewModel = "models/rmzs/weapons/fusion_breaker/c_fusion_breaker.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 145
SWEP.MeleeRange = 65
SWEP.MeleeSize = 3.55
SWEP.MeleeKnockBack = 240

SWEP.Primary.Delay = 1.15

SWEP.Tier = 3

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingTime = 0.65
SWEP.SwingHoldType = "melee"

SWEP.CanBlocking = true
SWEP.BlockStability = 0.45
SWEP.BlockReduction = 13
SWEP.StaminaConsumption = 12

SWEP.BlockRotation = Angle(0, 0, 15)
SWEP.BlockOffset = Vector(-5, 0, -2)

SWEP.AllowQualityWeapons = true
SWEP.Culinary = true

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_IMPACT_DELAY, -0.12)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(25, 35))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(70, 74))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_impact_hard"..math.random(2, 3)..".wav", 75, math.Rand(80, 84))
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:SendWeaponAnim(self:IsHeavy() and ACT_VM_HITRIGHT or ACT_VM_HITLEFT)
	self:GetOwner():GetViewModel():SetPlaybackRate(1 + (1 - self.SwingTime) * (1 + (1 - (otbl.MeleeSwingDelayMul or 1))))
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, self.SwingTime * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5)
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
end