AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_mehrunes")) -- "'Mehrunes' Кинжал
SWEP.Description = (translate.Get("desc_mehrunes")) -- Кинжал, способный одним ударом в спину, убить нежить

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
    SWEP.ShowViewModel = false
    SWEP.ShowWorldModel = false

    SWEP.VElements = {
        ["клинок"] = { type = "Model", model = "models/hunter/geometric/pent1x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(0, 0, 7.203), angle = Angle(180, 90, 90), size = Vector(0.037, 0.027, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
        ["клинок++"] = { type = "Model", model = "models/hunter/plates/plate05x05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(0, 0, 8.774), angle = Angle(180, 90, 90), size = Vector(0.104, 0.104, 0.094), color = Color(255, 255, 255, 255), surpresslightning = true, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
        ["гард+"] = { type = "Model", model = "models/hunter/tubes/circle4x4c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(0, 0, 6.472), angle = Angle(90, 0, 0), size = Vector(0.009, 0.039, 0.293), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/construct/concrete_barrier00", skin = 0, bodygroup = {} },
        ["клинок+"] = { type = "Model", model = "models/hunter/plates/plate05x05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(0, 0, 8.774), angle = Angle(180, 90, 90), size = Vector(0.075, 0.059, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
        ["кончик"] = { type = "Model", model = "models/hunter/triangles/025x025mirrored.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(0, 0, 19.649), angle = Angle(-90, 180, -180), size = Vector(0.128, 0.039, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
        ["клинок2+"] = { type = "Model", model = "models/hunter/plates/plate1x4x2trap.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(-0.15, 0, 9.227), angle = Angle(-90, 0, 0), size = Vector(0.057, 0.071, 0.094), color = Color(255, 255, 255, 255), surpresslightning = true, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
        ["кончик+"] = { type = "Model", model = "models/hunter/triangles/025x025mirrored.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(-0.008, 0, 20.045), angle = Angle(-90, 180, -180), size = Vector(0.138, 0.046, 0.094), color = Color(255, 255, 255, 255), surpresslightning = true, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
        ["клинок2"] = { type = "Model", model = "models/hunter/plates/plate1x4x2trap.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(-0.231, 0, 9.454), angle = Angle(-90, 0, 0), size = Vector(0.054, 0.054, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
        ["гард"] = { type = "Model", model = "models/hunter/misc/platehole1x1c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(0, 0.009, 8.871), angle = Angle(90, 0, 0), size = Vector(0.101, 0.16, 0.296), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/construct/concrete_barrier00", skin = 0, bodygroup = {} },
        ["рукоятка"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0, 0, -2.136), angle = Angle(0, 0, 1.258), size = Vector(0.052, 0.052, 0.122), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props/CS_militia/roofbeams01", skin = 0, bodygroup = {} },
        ["клинок+++"] = { type = "Model", model = "models/hunter/geometric/pent1x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(0, 0, 7.203), angle = Angle(180, 90, 90), size = Vector(0.041, 0.041, 0.094), color = Color(255, 255, 255, 255), surpresslightning = true, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
        ["жемчуг"] = { type = "Model", model = "models/props_combine/breenglobe.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "рукоятка", pos = Vector(0, 0.162, -0.403), angle = Angle(180, 0, 0), size = Vector(0.165, 0.165, 0.165), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/construct/concrete_barrier00", skin = 0, bodygroup = {} }
    }

    SWEP.WElements = {
        ["клинок"] = { type = "Model", model = "models/hunter/geometric/pent1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(0, 0, 7.203), angle = Angle(180, 90, 90), size = Vector(0.037, 0.027, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
        ["клинок++"] = { type = "Model", model = "models/hunter/plates/plate05x05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(0, 0, 8.774), angle = Angle(180, 90, 90), size = Vector(0.104, 0.104, 0.094), color = Color(255, 255, 255, 255), surpresslightning = true, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
        ["гард+"] = { type = "Model", model = "models/hunter/tubes/circle4x4c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(0, 0, 6.472), angle = Angle(90, 0, 0), size = Vector(0.009, 0.039, 0.293), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/construct/concrete_barrier00", skin = 0, bodygroup = {} },
        ["клинок+"] = { type = "Model", model = "models/hunter/plates/plate05x05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(0, 0, 8.774), angle = Angle(180, 90, 90), size = Vector(0.075, 0.059, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
        ["кончик"] = { type = "Model", model = "models/hunter/triangles/025x025mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(0, 0, 19.649), angle = Angle(-90, 180, -180), size = Vector(0.128, 0.039, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
        ["клинок2+"] = { type = "Model", model = "models/hunter/plates/plate1x4x2trap.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(-0.15, 0, 9.227), angle = Angle(-90, 0, 0), size = Vector(0.057, 0.071, 0.094), color = Color(255, 255, 255, 255), surpresslightning = true, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
        ["клинок+++"] = { type = "Model", model = "models/hunter/geometric/pent1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(0, 0, 7.203), angle = Angle(180, 90, 90), size = Vector(0.041, 0.041, 0.094), color = Color(255, 255, 255, 255), surpresslightning = true, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
        ["рукоятка"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.079, 0.444, 3.015), angle = Angle(173.518, 82.167, 6.455), size = Vector(0.052, 0.052, 0.122), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props/CS_militia/roofbeams01", skin = 0, bodygroup = {} },
        ["гард"] = { type = "Model", model = "models/hunter/misc/platehole1x1c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(0, 0.009, 8.871), angle = Angle(90, 0, 0), size = Vector(0.101, 0.16, 0.296), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/construct/concrete_barrier00", skin = 0, bodygroup = {} },
        ["клинок2"] = { type = "Model", model = "models/hunter/plates/plate1x4x2trap.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(-0.231, 0, 9.454), angle = Angle(-90, 0, 0), size = Vector(0.054, 0.054, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
        ["кончик+"] = { type = "Model", model = "models/hunter/triangles/025x025mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(-0.008, 0, 20.05), angle = Angle(-90, 180, -180), size = Vector(0.138, 0.046, 0.094), color = Color(255, 255, 255, 255), surpresslightning = true, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
        ["жемчуг"] = { type = "Model", model = "models/props_combine/breenglobe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "рукоятка", pos = Vector(0, 0.001, -0.401), angle = Angle(180, 0, 0), size = Vector(0.159, 0.159, 0.159), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/construct/concrete_barrier00", skin = 0, bodygroup = {} }
    }


    SWEP.ViewModelBoneMods = {
        ["v_weapon.Knife_Handle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.424), angle = Angle(0, 0, 0) }
    }

end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "knife"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 92
SWEP.MeleeDamageSave = SWEP.MeleeDamage
SWEP.MeleeRange = 63
SWEP.MeleeSize = 0.875

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.Primary.Delay = 0.45
SWEP.SaveDelay = SWEP.Primary.Delay

SWEP.HitDecal = "Manhackcut"

SWEP.Tier = 5
SWEP.MaxStock = 2

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitAnim = ACT_VM_MISSCENTER
SWEP.MissAnim = ACT_VM_PRIMARYATTACK

SWEP.NoHitSoundFlesh = true

SWEP.BlockRotation = Angle(0, -10, -30)
SWEP.BlockOffset = Vector(4, 6, 2)

SWEP.CanBlocking = false
SWEP.BlockStability = 0.15
SWEP.BlockReduction = 7
SWEP.StaminaConsumption = 7

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
	self.MeleeDamage = self.MeleeDamageSave * 1.5
	self.HitAnim = ACT_VM_SECONDARYATTACK
	self.Primary.Delay = self.SaveDelay * 2
	self.StaminaConsumption = self.SaveStaminaConsumption * 1.5
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	SECOND(self)
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	MAIN(self)
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:PlaySwingSound()
	self:EmitSound( "weapons/knife/knife_slash" .. math.random( 2 ) .. ".wav", 72, math.Rand( 85, 95 ) )
end

function SWEP:PlayHitSound()
	self:EmitSound( "weapons/knife/knife_hitwall1.wav", 72, math.Rand( 75, 85 ) )
end

function SWEP:PlayHitFleshSound()
	self:EmitSound( "physics/flesh/flesh_squishy_impact_hard" .. math.random( 4 ) .. ".wav" )
	self:EmitSound( "physics/body/body_medium_break" .. math.random( 2, 4 ) .. ".wav" )
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:GetBossTier() <= 2 and math.abs(hitent:GetForward():Angle().yaw - self:GetOwner():GetForward():Angle().yaw) <= 90 then
		hitent:TakeSpecialDamage(math.min(hitent:Health(), 1000), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
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
