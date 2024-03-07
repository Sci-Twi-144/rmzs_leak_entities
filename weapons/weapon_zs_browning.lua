AddCSLuaFile()

SWEP.Base = "weapon_zs_base"
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "M1919 Browning"
SWEP.Description = "..."

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.VMPos = Vector(-2, -5, 0)
	SWEP.VMAng = Vector(0, 0, 0)

	SWEP.HUD3DBone = "v_weapon.m249"
	SWEP.HUD3DPos = Vector(1.6, -1.4, 5)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.VElements = {
		["3+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -0.812, -7.864), angle = Angle(0, 0, 0), size = Vector(0.165, 0.093, 0.128), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.115, 4.342), angle = Angle(0, 0, -90), size = Vector(0.063, 0.054, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -0.806, 3.924), angle = Angle(0, 0, 0), size = Vector(0.165, 0.093, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.028, 23.006), angle = Angle(0, 0, 0), size = Vector(0.035, 0.035, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["apertura"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.receiver", rel = "", pos = Vector(-0.257, 0, 0.185), angle = Angle(90, 0, 0), size = Vector(0.09, 0.166, 0.09), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["apertura+++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.receiver", rel = "1", pos = Vector(-0.013, -0.698, -3.517), angle = Angle(0, 90, 0), size = Vector(0.079, 0.166, 0.601), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["apertura+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.receiver", rel = "apertura", pos = Vector(-0.45, 0, 6.636), angle = Angle(0, 0, 0), size = Vector(0.019, 0.166, 0.601), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -1.63, -7.658), angle = Angle(0, -90, 90), size = Vector(0.064, 0.064, 0.064), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -1.469, -8.207), angle = Angle(0, -90, 90), size = Vector(0.019, 0.075, 0.165), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+++++++++"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -2.017, -7.985), angle = Angle(0, 0, 0), size = Vector(0.074, 0.024, 0.024), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -0.681, 4.021), angle = Angle(0, 0, 0), size = Vector(0.115, 0.115, 0.115), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x4.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.028, 4.25), angle = Angle(0, 0, 0), size = Vector(0.032, 0.032, 0.1), color = Color(88, 88, 88, 255), surpresslightning = false, material = "phoenix_storms/mat/mat_phx_carbonfiber", skin = 0, bodygroup = {} },
		["3++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 4.342), angle = Angle(0, 0, -90), size = Vector(0.18, 0.27, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["arma"] = { type = "Model", model = "models/weapons/w_pist_p228.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 7.961, -10.252), angle = Angle(90, -90, 0), size = Vector(0.925, 1.08, 0.938), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["apertura++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "v_weapon.receiver", rel = "apertura", pos = Vector(-0.313, 0, 1.748), angle = Angle(0, 0, 0), size = Vector(0.039, 0.172, 0.245), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3++++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "v_weapon.receiver", rel = "apertura", pos = Vector(-0.487, -0.366, 6.943), angle = Angle(0, 90, -90), size = Vector(0.18, 0.27, 0.004), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(0, -1.361, 5.657), angle = Angle(0, 0, 0), size = Vector(0.008, 0.008, 0.008), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 1.014, -2.237), angle = Angle(0, 0, 0), size = Vector(0.165, 0.217, 1.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.028, 3.075), angle = Angle(0, 0, 0), size = Vector(0.02, 0.02, 0.233), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/black_brushes", skin = 0, bodygroup = {} },
		["3++++++++++"] = { type = "Model", model = "models/props_phx/construct/metal_wire1x2b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -2.438, -7.985), angle = Angle(0, 0, 0), size = Vector(0.013, 0.019, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+"] = { type = "Model", model = "models/props_phx/misc/potato_launcher_chamber.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.028, 27.555), angle = Angle(0, 0, 0), size = Vector(0.115, 0.115, 0.145), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },

		["munizione01"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet10", rel = "", pos = Vector(0.059, 1.034, -0.049), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione02"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet9", rel = "", pos = Vector(-0.018, 1.034, 0.034), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione03"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet8", rel = "", pos = Vector(-0.018, 1.034, 0.03), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione04"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet7", rel = "", pos = Vector(-0.018, 1.034, 0.03), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione05"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet6", rel = "", pos = Vector(-0.018, 1.034, 0.052), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione06"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet5", rel = "", pos = Vector(-0.018, 1.034, 0.03), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione07"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet4", rel = "", pos = Vector(-0.018, 1.034, 0.03), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione08"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet3", rel = "", pos = Vector(-0.033, 1.034, 0.029), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione09"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet2", rel = "", pos = Vector(-0.049, 1.034, 0), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione010"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(-0.018, 1.034, -0.047), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione011"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(-0.018, 1.034, 2.295), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione012"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(-0.018, 1.034, 1.812), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione013"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(-0.018, 1.034, 1.327), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione014"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(-0.018, 1.034, 0.916), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["munizione015"] = { type = "Model", model = "models/shells/shell_556.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(-0.018, 1.034, 0.432), angle = Angle(0, 90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["3+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.812, -7.864), angle = Angle(0, 0, 0), size = Vector(0.165, 0.093, 0.128), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.681, 3.5), angle = Angle(0, 0, 0), size = Vector(0.115, 0.115, 0.115), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.509, -1.456), angle = Angle(0, 0, 0), size = Vector(0.032, 0.032, 0.1), color = Color(88, 88, 88, 255), surpresslightning = false, material = "phoenix_storms/mat/mat_phx_carbonfiber", skin = 0, bodygroup = {} },
		["3+++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.2, 3.698), angle = Angle(0, 0, -90), size = Vector(0.063, 0.054, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 3.684), angle = Angle(0, 0, -90), size = Vector(0.18, 0.27, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+++++++++"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -2.017, -7.985), angle = Angle(0, 0, 0), size = Vector(0.074, 0.024, 0.024), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -1.469, -8.207), angle = Angle(0, -90, 90), size = Vector(0.019, 0.075, 0.165), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["arma"] = { type = "Model", model = "models/weapons/w_pist_p228.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 5.883, -11.742), angle = Angle(90, -90, 0), size = Vector(0.6, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["3++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.806, 3.924), angle = Angle(0, 0, 0), size = Vector(0.165, 0.093, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.509, 16.981), angle = Angle(0, 0, 0), size = Vector(0.035, 0.035, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.23, 1.799, -5.584), angle = Angle(0, -95, -99.037), size = Vector(0.008, 0.008, 0.008), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["apertura++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "apertura", pos = Vector(-0.313, 0, 1.748), angle = Angle(0, 0, 0), size = Vector(0.039, 0.172, 0.245), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["apertura"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.648, 3.065), angle = Angle(0, -90, -180), size = Vector(0.09, 0.166, 0.09), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3++++++++"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -1.63, -7.658), angle = Angle(0, -90, 90), size = Vector(0.064, 0.064, 0.064), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3++++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "apertura", pos = Vector(0, -0.594, 6.943), angle = Angle(0, 90, -90), size = Vector(0.18, 0.27, 0.008), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["apertura+"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "apertura", pos = Vector(0, 0, 6.636), angle = Angle(0, 0, 0), size = Vector(0.09, 0.166, 0.601), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 1.014, -2.237), angle = Angle(0, 0, 0), size = Vector(0.165, 0.217, 1.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.509, -4.723), angle = Angle(0, 0, 0), size = Vector(0.02, 0.02, 0.233), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/black_brushes", skin = 0, bodygroup = {} },
		["3++++++++++"] = { type = "Model", model = "models/props_phx/construct/metal_wire1x2b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -2.438, -7.985), angle = Angle(0, 0, 0), size = Vector(0.013, 0.019, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+"] = { type = "Model", model = "models/props_phx/misc/potato_launcher_chamber.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.509, 20.379), angle = Angle(0, 0, 0), size = Vector(0.115, 0.115, 0.145), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(2.009, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0.46, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.IsReloadingAnim = false
	SWEP.IsEmptyAmmo = false

	function SWEP:CustomClipEdit(clip, invisible)
		if self.VElements["munizione0" .. clip] then
			self.VElements["munizione0" .. clip].color = Color(255, 255, 255, invisible and 0 or 255)
		end
	end

	function SWEP:ShootBullets(dmg, numbul, cone)
		BaseClass.ShootBullets(self, dmg, numbul, cone)

		self:CustomClipEdit(self:Clip1() - 1, true)
	end

	function SWEP:DrawHUD()
		BaseClass.DrawHUD(self)

		if self.IsReloadingAnim then
			if self:GetReloadAmmoDropDown() <= CurTime() then
				for i = 1, 15 do
					self:CustomClipEdit(i, false)
				end

				self.ViewModelBoneMods["ValveBiped.Bip01_L_Clavicle"].pos = Vector(0, 0, 0)
				self.ViewModelBoneMods["ValveBiped.Bip01_L_Hand"].pos = Vector(0, 0, 0)

				self.IsReloadingAnim = false
				self.IsEmptyAmmo = false
			end
		end

		if not self.IsEmptyAmmo and self:GetReloadAmmoDelay() <= CurTime() then
			for i=1, 20 do
				self:CustomClipEdit(i, false)
			end

			self.ViewModelBoneMods["ValveBiped.Bip01_L_Clavicle"].pos = Vector(2.009, 0, 0)
			self.ViewModelBoneMods["ValveBiped.Bip01_L_Hand"].pos = Vector(0.46, 0, 0)

			self.IsEmptyAmmo = true
		end

		if self:Clip1() >= 0 and self:GetReloadAmmoAfterReload() <= CurTime() then
			for i = 1, 15 do
				self:CustomClipEdit(i + self:Clip1(), true)
			end
		end
	end

	local ghostlerp = 0
	function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)
		local bIron = self:GetIronsights() and not GAMEMODE.NoIronsights

		if bIron ~= self.bLastIron then
			self.bLastIron = bIron
			self.fIronTime = CurTime()

			if bIron then
				self.SwayScale = 0.3
				self.BobScale = 0.1
			else
				self.SwayScale = 2.0
				self.BobScale = 1.5
			end
		end

		local Mul = math.Clamp((CurTime() - (self.fIronTime or 0)) * 4, 0, 1)
		if not bIron then Mul = 1 - Mul end

		if Mul > 0 then
			local Offset = self.IronSightsPos
			if self.IronSightsAng then
				ang = Angle(ang.p, ang.y, ang.r)
				ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
				ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
				ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
			end

			pos = pos + Offset.x * Mul * ang:Right() + Offset.y * Mul * ang:Forward() + Offset.z * Mul * ang:Up()
		end

		if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
			ghostlerp = math.min(1, ghostlerp + FrameTime() * 3)
		elseif ghostlerp > 0 then
			ghostlerp = math.max(0, ghostlerp - FrameTime() * 4)
		end

		if ghostlerp > 0 then
			--pos = pos + 3.5 * ghostlerp * ang:Up()
			ang:RotateAroundAxis(ang:Right(), -7 * ghostlerp)
		end

		if self.VMAng and self.VMPos then
			ang:RotateAroundAxis(ang:Right(), self.VMAng.x) 
			ang:RotateAroundAxis(ang:Up(), self.VMAng.y)
			ang:RotateAroundAxis(ang:Forward(), self.VMAng.z)

			pos:Add(ang:Right() * (self.VMPos.x))
			pos:Add(ang:Forward() * (self.VMPos.y))
			pos:Add(ang:Up() * (self.VMPos.z))
		end

		return pos, ang
	end

	local colBG = Color(16, 16, 16, 90)
	local colRed = Color(220, 0, 0, 230)
	local colYellow = Color(220, 220, 0, 230)
	local colWhite = Color(220, 220, 220, 230)
	local colAmmo = Color(255, 255, 255, 230)
	local function GetAmmoColor(clip, maxclip)
		if clip == 0 then
			colAmmo.r = 255 colAmmo.g = 0 colAmmo.b = 0
		else
			local sat = clip / maxclip
			colAmmo.r = 255
			colAmmo.g = sat ^ 0.3 * 255
			colAmmo.b = sat * 255
		end
	end

	function SWEP:Draw3DHUD(vm, pos, ang)
		local wid, hei = 220, 220
		local x, y = wid * -0.6, hei * -0.6
		local clip = self:Clip1()
		local owner = self:GetOwner()
		local spare = owner:GetAmmoCount(self:GetPrimaryAmmoType())
		local maxclip = self.Primary.ClipSize

		cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
			surface.SetDrawColor(16, 16, 16, 255)
			surface.DrawRect(x, y + hei * 1, wid, 30)
			surface.SetDrawColor(1 * self:GetOverheat() * 255, 255 / self:GetOverheat() / 8, 0, 255)
			surface.DrawRect(x, y + hei * 1, wid * self:GetOverheat() - 8, 30)
			draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)

			local displayspare = maxclip > 0 and self.Primary.DefaultClip ~= 99999
			if displayspare then
				draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.75, spare == 0 and colRed or spare <= maxclip and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			GetAmmoColor(clip, maxclip)
			draw.SimpleTextBlurry(clip, clip >= 100 and "ZS3D2DFont" or "ZS3D2DFontBig", x + wid * 0.5, y + hei * (displayspare and 0.3 or 0.5), colAmmo, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

	function SWEP:Draw2DHUD()
		local screenscale = BetterScreenScale()

		local wid, hei = 180 * screenscale, 64 * screenscale
		local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
		local clip = self:Clip1()
		local owner = self:GetOwner()
		local spare = owner:GetAmmoCount(self:GetPrimaryAmmoType())
		local maxclip = self.Primary.ClipSize

		surface.SetDrawColor(16, 16, 16, 255)
		surface.DrawRect(x, y + hei * 1, wid, 30)
		surface.SetDrawColor(1 * self:GetOverheat() * 255, 255 / self:GetOverheat() / 8, 0, 255)
		surface.DrawRect(x, y + hei * 1, wid * self:GetOverheat() - 8, 30)

		draw.RoundedBox(16, x, y, wid, hei, colBG)

		local displayspare = maxclip > 0 and self.Primary.DefaultClip ~= 99999
		if displayspare then
			draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFontSmall" or "ZSHUDFont", x + wid * 0.75, y + hei * 0.5, spare == 0 and colRed or spare <= maxclip and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		GetAmmoColor(clip, maxclip)
		draw.SimpleTextBlurry(clip, clip >= 100 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * (displayspare and 0.25 or 0.5), y + hei * 0.5, colAmmo, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

-- Fix prediction for switch wep.
function SWEP:SetReloadAmmoDelay(s)
	self:SetDTFloat(8, s)
end

function SWEP:GetReloadAmmoDelay()
	return self:GetDTFloat(8)
end

function SWEP:SetReloadAmmoDropDown(s)
	self:SetDTFloat(9, s)
end

function SWEP:GetReloadAmmoDropDown()
	return self:GetDTFloat(9)
end

function SWEP:SetReloadAmmoAfterReload(s)
	self:SetDTFloat(10, s)
end

function SWEP:GetReloadAmmoAfterReload()
	return self:GetDTFloat(10)
end

function SWEP:SetOverheat(s)
	self:SetDTFloat(11, s)
end

function SWEP:GetOverheat()
	return self:GetDTFloat(11)
end

function SWEP:SetMode(s)
	self:SetDTFloat(12, s)
end

function SWEP:GetMode()
	return self:GetDTFloat(12)
end

function SWEP:Deploy()
	BaseClass.Deploy(self)

	-- Reset them
	self:SetReloadAmmoDropDown(0)
	self:SetReloadAmmoDelay(0)
	self:SetReloadAmmoAfterReload(0)

	return true
end

function SWEP:SendReloadAnimation()
	BaseClass.SendReloadAnimation(self)

	if CLIENT then
		self.IsReloadingAnim = true
	end

	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	self:SetReloadAmmoDropDown(CurTime() + self:SequenceDuration() * (0.2 / reloadspeed))
	self:SetReloadAmmoDelay(CurTime() + self:SequenceDuration() * (0.83 / reloadspeed))
	self:SetReloadAmmoAfterReload(CurTime() + self:SequenceDuration() * (1.1 / reloadspeed))
end

SWEP.ShowWorldModel = false
SWEP.ShowViewModel = false

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/waw_m1919/fire.wav")
SWEP.Primary.Damage = 24.5 --196/6.6--29.33 -- this gun is too op...
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.08

SWEP.Primary.ClipSize = 125
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.Recoil = 0

SWEP.ConeMax = 6
SWEP.ConeMin = 2.4

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.IronSightsPos = Vector(-4.06, -2.619, 2.069)
SWEP.IronSightsAng = Vector(0, 0, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 140, math.random(115, 125), 1.0, CHAN_WEAPON)
end

function SWEP:ShootBullets(dmg, numbul, cone)
	BaseClass.ShootBullets(self, dmg, numbul, cone)

	if self:GetMode() ~= 1 then
		self:SetOverheat(self:GetOverheat() + 0.01)
		self:SetMode(1)
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)

	local owner = self:GetOwner()
	if self:GetReloadFinish() >= 1 and self:GetOverheat() >= 0.05 then
		self:SetOverheat(self:GetOverheat() - FrameTime() * 0.12)
	end

	if owner:IsHolding() or owner:GetBarricadeGhosting() or self:GetReloadFinish() >= 1 then
		self:SetNextPrimaryFire(CurTime() + 0.75)
		self:SetMode(0)
		return
	end

	if owner:KeyReleased(IN_ATTACK) and self:GetReloadFinish() == 0 then
		self:SetMode(0)
	end

	if self:GetOverheat() >= 1 then
		self:SetOverheat(self:GetOverheat() and 1 or 0)
		self:SetMode(0)
	end

	self.Primary.Delay = 0.1 - (self:GetOverheat() / 18)

	if IsValid(owner) then
		if self:GetMode() == 1 and self:Clip1() >= 1 then
			self:SetOverheat(self:GetOverheat() + FrameTime() * (0.095 - (self:GetOverheat() / 60)))
		else
			if self:GetOverheat() <= 0.05 then return end
			self:SetOverheat(self:GetOverheat() - FrameTime() * 0.03 / self:GetOverheat())
		end
	end
end