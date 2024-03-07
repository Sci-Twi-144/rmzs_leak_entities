AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Intervention' Sniper Rifle"
SWEP.Description = "Находясь в воздухе, вы наносите на 25% больше урона."
SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

 	SWEP.HUD3DBone = "v_weapon.awm_parent"
	SWEP.HUD3DPos = Vector(-2, -5.2, -2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

 	SWEP.VElements = {
		["B"] = { type = "Model", model = "models/mechanics/solid_steel/type_c_3_6.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(22.837, 0.02, -1.869), angle = Angle(135, 90, 90), size = Vector(0.17, 0.17, 0.708), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["mb"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(48.837, 0, 6.749), angle = Angle(180, 90, 90), size = Vector(0.18, 0.18, 0.314), color = Color(70, 70, 70, 255), surpresslightning = false, material = "phoenix_storms/gear_top", skin = 0, bodygroup = {} },
		["s+"] = { type = "Model", model = "models/hunter/misc/roundthing2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-8.259, 0, 5.783), angle = Angle(180, 90, -90), size = Vector(0.054, 0.035, 0.05), color = Color(50, 50, 50, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["h+++"] = { type = "Model", model = "models/Mechanics/gears2/pinion_40t3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(4.953, -0.049, 8.138), angle = Angle(180, 180, 90), size = Vector(0.078, 0.025, 0.026), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["b1+"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(35.995, 0, 6.73), angle = Angle(-90, 0, 0), size = Vector(0.135, 0.135, 0.551), color = Color(70, 70, 70, 255), surpresslightning = false, material = "phoenix_storms/gear_top", skin = 0, bodygroup = {} },
		["sc"] = { type = "Model", model = "models/xqm/Rails/funnel.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(5.063, -0.08, 9.873), angle = Angle(-90, 0, 0), size = Vector(0.028, 0.028, 0.21), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["h+"] = { type = "Model", model = "models/Mechanics/gears2/pinion_20t2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(14.095, -0.579, 3.681), angle = Angle(0, 180, 90), size = Vector(0.078, 0.129, 0.081), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["s"] = { type = "Model", model = "models/props_combine/cell_01_supportsb.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 7.014), angle = Angle(87.564, 0, 0), size = Vector(0.009, 0.019, 0.018), color = Color(50, 5, 50, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["r"] = { type = "Model", model = "models/mechanics/roboticslarge/a1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(6.107, 0, 6.631), angle = Angle(0, 0, 0), size = Vector(0.259, 0.081, 0.129), color = Color(50, 50, 50, 255), surpresslightning = false, material = "phoenix_storms/gear_top", skin = 0, bodygroup = {} },
		["eject"] = { type = "Model", model = "models/props_c17/gravestone001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(5.686, -0.76, 7.521), angle = Angle(180, 90, 90), size = Vector(0.052, 0.014, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["sc+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(6.443, -0.097, 8.652), angle = Angle(0.94, 0, 0), size = Vector(0.039, 0.014, 0.059), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/weapons/w_pist_usp.mdl", bone = "v_weapon.awm_parent", rel = "", pos = Vector(0, 2.282, 0.579), angle = Angle(-90, -90, 180), size = Vector(1, 1, 1), color = Color(50, 50, 50, 255), surpresslightning = false, material = "phoenix_storms/gear_top", skin = 0, bodygroup = {} },
		["b1"] = { type = "Model", model = "models/props_docks/dock01_pole01a_128.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(21.903, 0, 6.78), angle = Angle(-90, 0, 0), size = Vector(0.159, 0.159, 0.159), color = Color(50, 50, 50, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["g"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(1.123, 0, 9.798), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_models/snip_awp/v_awp_scope", skin = 0, bodygroup = {} },
		["sc+"] = { type = "Model", model = "models/xqm/Rails/funnel.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(7.646, -0.062, 9.793), angle = Angle(90, 0, 0), size = Vector(0.019, 0.019, 0.123), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["blt"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.awm_bolt_action", rel = "", pos = Vector(0, -0.062, -5.547), angle = Angle(0, 0, 0), size = Vector(0.059, 0.059, 0.187), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["*"] = { type = "Model", model = "models/props_junk/metalgascan.mdl", bone = "v_weapon.awm_clip", rel = "", pos = Vector(0, 1.129, -1.38), angle = Angle(180, 180, -90), size = Vector(0.119, 0.25, 0.206), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/car_tire", skin = 0, bodygroup = {} },
		["h++"] = { type = "Model", model = "models/hunter/misc/stair1x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(11.946, -0.713, 4.729), angle = Angle(-90, -90, 90), size = Vector(0.054, 0.016, 0.025), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["h"] = { type = "Model", model = "models/phxtended/tri2x1x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(16.257, 0, 5.565), angle = Angle(-179.058, 180, 90), size = Vector(0.054, 0.024, 0.019), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["sc++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(8.34, -0.097, 9.81), angle = Angle(90, 0, 0), size = Vector(0.05, 0.05, 0.098), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["blt+"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.awm_bolt_action", rel = "", pos = Vector(-1.823, 0.949, 2.579), angle = Angle(90, 128.574, 0), size = Vector(0.382, 0.382, 0.382), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} }
	}

  	SWEP.WElements = {
		["B"] = { type = "Model", model = "models/mechanics/solid_steel/type_c_3_6.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(22.837, 0.02, -1.869), angle = Angle(135, 90, 90), size = Vector(0.17, 0.17, 0.708), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["mb"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(48.837, 0, 6.749), angle = Angle(180, 90, 90), size = Vector(0.18, 0.18, 0.314), color = Color(70, 70, 70, 255), surpresslightning = false, material = "phoenix_storms/gear_top", skin = 0, bodygroup = {} },
		["s+"] = { type = "Model", model = "models/hunter/misc/roundthing2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-8.259, 0, 5.783), angle = Angle(180, 90, -90), size = Vector(0.054, 0.035, 0.05), color = Color(50, 50, 50, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["h+++"] = { type = "Model", model = "models/Mechanics/gears2/pinion_40t3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.953, -0.049, 8.138), angle = Angle(180, 180, 90), size = Vector(0.078, 0.025, 0.026), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["b1+"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(35.995, 0, 6.73), angle = Angle(-90, 0, 0), size = Vector(0.135, 0.135, 0.551), color = Color(70, 70, 70, 255), surpresslightning = false, material = "phoenix_storms/gear_top", skin = 0, bodygroup = {} },
		["sc"] = { type = "Model", model = "models/xqm/Rails/funnel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(5.063, -0.08, 9.873), angle = Angle(-90, 0, 0), size = Vector(0.028, 0.028, 0.21), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["h+"] = { type = "Model", model = "models/Mechanics/gears2/pinion_20t2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(14.095, 0.029, 3.681), angle = Angle(0, 180, 90), size = Vector(0.078, 0.129, 0.081), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["s"] = { type = "Model", model = "models/props_combine/cell_01_supportsb.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 7.014), angle = Angle(87.564, 0, 0), size = Vector(0.009, 0.019, 0.018), color = Color(50, 5, 50, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["r"] = { type = "Model", model = "models/mechanics/roboticslarge/a1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(6.107, 0, 6.631), angle = Angle(0, 0, 0), size = Vector(0.259, 0.081, 0.129), color = Color(50, 50, 50, 255), surpresslightning = false, material = "phoenix_storms/gear_top", skin = 0, bodygroup = {} },
		["eject"] = { type = "Model", model = "models/props_c17/gravestone001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(5.454, -0.76, 7.521), angle = Angle(180, 90, 90), size = Vector(0.052, 0.014, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["sc+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(6.443, -0.097, 8.652), angle = Angle(0.94, 0, 0), size = Vector(0.039, 0.014, 0.059), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/weapons/w_pist_usp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.089, 0.563, 2.997), angle = Angle(-170.004, 180, 0), size = Vector(1, 1, 1), color = Color(50, 50, 50, 255), surpresslightning = false, material = "phoenix_storms/gear_top", skin = 0, bodygroup = {} },
		["b1"] = { type = "Model", model = "models/props_docks/dock01_pole01a_128.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(21.903, 0, 6.78), angle = Angle(-90, 0, 0), size = Vector(0.159, 0.159, 0.159), color = Color(50, 50, 50, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["g+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(16.594, 0, 9.798), angle = Angle(0, 0, 0), size = Vector(0.048, 0.048, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_models/snip_awp/v_awp_scope", skin = 0, bodygroup = {} },
		["g"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(1.123, 0, 9.798), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_models/snip_awp/v_awp_scope", skin = 0, bodygroup = {} },
		["sc+"] = { type = "Model", model = "models/xqm/Rails/funnel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(7.646, -0.062, 9.793), angle = Angle(90, 0, 0), size = Vector(0.019, 0.019, 0.123), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["blt"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(7.421, 0, 7.12), angle = Angle(90, 0, 0), size = Vector(0.059, 0.059, 0.187), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["*"] = { type = "Model", model = "models/props_junk/metalgascan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(7.892, 0.025, 2.437), angle = Angle(180, 90, 0), size = Vector(0.119, 0.25, 0.206), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/car_tire", skin = 0, bodygroup = {} },
		["h++"] = { type = "Model", model = "models/hunter/misc/stair1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(11.946, 0.018, 4.729), angle = Angle(-90, -90, 90), size = Vector(0.054, 0.016, 0.025), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["h"] = { type = "Model", model = "models/phxtended/tri2x1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(16.257, 0.522, 5.565), angle = Angle(-179.058, 180, 90), size = Vector(0.054, 0.024, 0.019), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["blt+"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-0.755, -2.307, 6.085), angle = Angle(0, 0, -32.639), size = Vector(0.382, 0.382, 0.382), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
		["sc++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(8.34, -0.097, 9.81), angle = Angle(90, 0, 0), size = Vector(0.05, 0.05, 0.098), color = Color(50, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["v_weapon.awm_clip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -1.403), angle = Angle(0, 0, 0) },
		["v_weapon.awm_parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(3.657, 2.171, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.IronSightsPos = Vector(2.654, -10.523, 0)
	SWEP.IronSightsAng = Vector(0, 0, 0)
end

sound.Add(
{
	name = "Weapon_Inrvc.Single",
	channel = CHAN_AUTO,
	volume = 0.8,
	soundlevel = 80,
	pitchstart = 60,
	pitchend = 70,
	sound = {"weapons/glock/glock18-1.wav"}
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_Inrvc.Single")
SWEP.Primary.Damage = 122
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 14

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ReloadDelay = 2.5

SWEP.ConeMax = 5.75
SWEP.ConeMin = 0

SWEP.Pierces = 2

SWEP.ProjExplosionTaper = 0.6
SWEP.DamageTaper = SWEP.ProjExplosionTaper

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 4

SWEP.ResistanceBypass = 0.4

-- SWEP.ReloadActivity = ACT_VM_PRIMARYATTACK

SWEP.Primary.DefaultDamage = SWEP.Primary.Damage -- Вернуть урон в исходное
SWEP.Primary.BonusDamage = SWEP.Primary.Damage * 1.25

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -1, 1)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
	self:EmitSound("npc/sniper/sniper1.wav", 100, 100, 1, CHAN_AUTO + 20)
	self:EmitSound("weapons/sg552/sg552-1.wav", 80, 75, 0.75, CHAN_WEAPON + 20)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
		local owner = self:GetOwner()
		if not owner:IsOnGround() then
			self.Primary.Damage = self.Primary.BonusDamage
		else
			self.Primary.Damage = self.Primary.DefaultDamage
		end
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:FireAnimationEvent(pos,ang,event)
	-- print(event, options)
	return (event==20)
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end
