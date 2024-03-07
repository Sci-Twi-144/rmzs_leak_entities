AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base_akimbo")

if CLIENT then
	SWEP.ViewModelFOV = 52

	SWEP.HUD3DBone = "v_weapon.Deagle_Slide"
	SWEP.HUD3DPos = Vector(-2.5, 0, 1)
	SWEP.HUD3DAng = Angle(0, -5, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.HUD3DBone2 = "v_weapon.Deagle_Slide"
	SWEP.HUD3DPos2 = Vector(-2.5, 0, 1)
	SWEP.HUD3DAng2 = Angle(0, 185, 0)

	SWEP.VElementsR = {
		["destra++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.004, -0.604, -3.516), angle = Angle(0, 0, 0), size = Vector(0.054, 0.054, 0.054), color = Color(191, 139, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {} },
		["destra+++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_01", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.018, -0.673, -3.346), size = { x = 1.84, y = 1.84 }, color = Color(0, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["destra+++"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -2.162, -1.688), angle = Angle(-90.811, 90, 0), size = Vector(0.039, 0.004, 0.019), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["1_right"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.5, 0.75, 0.5), angle = Angle(0, 180, 180), size = Vector(0.008, 0.008, 0.008), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["destra+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -0.648, -2.722), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 0.1), color = Color(255, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/bluemetal", skin = 0, bodygroup = {} },
		["destra+++++++++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0.202, -0.934, 0.949), angle = Angle(0, -164.299, 0), size = Vector(0.029, 0.029, 0.039), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["arma"] = { type = "Model", model = "models/weapons/w_pist_p228.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.341, 4.723, 0.446), angle = Angle(90, 0, -91.383), size = Vector(1, 1, 0.8), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -0.648, -2.975), angle = Angle(0, 0, 0), size = Vector(1.289, 1.289, 0.001), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 1} },
		["destra+++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.004, -0.604, -3.681), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.019), color = Color(203, 191, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -0.648, 8.727), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 0.029), color = Color(191, 130, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {[0] = 1} },
		["destra++++++++++++++"] = { type = "Model", model = "models/props_combine/combine_mine01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.415, -0.19, 17.486), angle = Angle(0, 0, 180), size = Vector(0.15, 0.15, 0.15), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra++++++++++"] = { type = "Model", model = "models/xqm/Rails/funnel.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.004, -0.604, 14.862), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.029), color = Color(255, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/bluemetal", skin = 0, bodygroup = {} },
		["destra++++++++++++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0.202, -0.934, 1.661), angle = Angle(0, -164.299, 0), size = Vector(0.029, 0.029, 0.039), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.004, -0.604, -3.516), angle = Angle(0, 0, 0), size = Vector(0.064, 0.064, 0.009), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra+++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.019, -0.604, 9.364), angle = Angle(0, 0, 0), size = Vector(0.079, 0.079, 0.029), color = Color(255, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/bluemetal", skin = 0, bodygroup = {} },
		["destra+++++++++++++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0.202, -0.934, 2.381), angle = Angle(0, -164.299, 0), size = Vector(0.029, 0.029, 0.039), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} }
	}

	SWEP.VElementsL = {
		["sinistra+++++++++++++"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-1.708, -1.885, 5.531), angle = Angle(0, 90, -65.677), size = Vector(0.039, 0.239, 0.032), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++++++++++"] = { type = "Model", model = "models/mechanics/articulating/arm2x20d2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.065, -3.08, 5.25), angle = Angle(0, 0, -8.528), size = Vector(0.009, 0.009, 0.009), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++++++++++++++++++++"] = { type = "Model", model = "models/props_pipes/pipe02_lcurve01_long.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.369, -3.596, 4.664), angle = Angle(-169.842, -90, 98.758), size = Vector(0.029, 0.029, 0.029), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++++++"] = { type = "Model", model = "models/hunter/misc/roundthing2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -2.783, 3.663), angle = Angle(0, 180, 93.805), size = Vector(0.039, 0.059, 0.004), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+++"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -2.662, -1.77), angle = Angle(-90.811, 90, 0), size = Vector(0.039, 0.004, 0.019), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["sinistra+++++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.027, -3.445), angle = Angle(0, 0, -8.528), size = Vector(0.029, 0.029, 0.009), color = Color(203, 191, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["sinistra+++++++"] = { type = "Model", model = "models/mechanics/wheels/wheel_smooth_48.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0.086, -2.174, 4.669), angle = Angle(0, 0, 78.443), size = Vector(0.09, 0.09, 0.09), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_01", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.03, -1.091, -3.211), size = { x = 1.84, y = 1.84 }, color = Color(0, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["sinistra++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.124, -2.975), angle = Angle(0, 0, -8.528), size = Vector(1.289, 1.289, 0.001), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["sinistra++++++++++++++++"] = { type = "Model", model = "models/xqm/afterburner1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.129, -1.946, 7.337), angle = Angle(1.031, 9.673, 165.345), size = Vector(0.129, 0.129, 0.129), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["arma+"] = { type = "Model", model = "models/weapons/w_pist_p228.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.027, 4.218, 0.021), angle = Angle(86.37, 0, -95.528), size = Vector(1, 1, 0.8), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["sinistra+++++++++++++++"] = { type = "Model", model = "models/mechanics/solid_steel/box_beam_4.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.04, -3.985, 4.684), angle = Angle(0, 0, -124.5), size = Vector(0.019, 0.039, 0.019), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["1_left"] = { type = "Model", model = "", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.5, -1.25, 0.25), angle = Angle(-5, 0, 182.5), size = Vector(0.008, 0.008, 0.008), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["sinistra"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.027, -3.445), angle = Angle(0, 0, -8.528), size = Vector(0.064, 0.064, 0.009), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["sinistra++++++++++++"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-2.04, -1.747, 3.923), angle = Angle(0, 90, -152.019), size = Vector(0.039, 0.14, 0.032), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.17, -2.313), angle = Angle(0, 0, -8.528), size = Vector(1.399, 1.399, 0.019), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+++++++++++++++++"] = { type = "Model", model = "models/hunter/tubes/circle4x4.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0.127, -2.625, 4.685), angle = Angle(0, 0, 78.443), size = Vector(0.023, 0.023, 0.023), color = Color(191, 130, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {} },
		["sinistra+++++++++++++++++++++"] = { type = "Model", model = "models/XQM/triangle1x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.051, -3.195, 3.684), angle = Angle(0, -90, -90), size = Vector(0.029, 0.029, 0.07), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+++++"] = { type = "Model", model = "models/hunter/tubes/circle4x4.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0.308, -1.545, 4.342), angle = Angle(0, 0, 78.443), size = Vector(0.026, 0.026, 0.3), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/stripes", skin = 0, bodygroup = {} },
		["sinistra++++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.027, -3.445), angle = Angle(0, 0, -8.528), size = Vector(0.057, 0.057, 0.007), color = Color(191, 139, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {} },
		["sinistra+++++++++++"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-1.55, -1.583, 2.028), angle = Angle(0, 90, -152.019), size = Vector(0.039, 0.14, 0.032), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+++++++++++++++++++"] = { type = "Model", model = "models/props_pipes/pipe02_lcurve01_long.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0.368, -3.596, 4.664), angle = Angle(169.841, 90, 98.758), size = Vector(0.029, 0.029, 0.029), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++"] = { type = "Model", model = "models/hunter/misc/roundthing2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, 0.87, 4.671), angle = Angle(0, 0, -98.528), size = Vector(0.039, 0.039, 0.039), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["sinistra+++++++++++++"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-1.708, -1.885, 5.531), angle = Angle(0, 90, -65.677), size = Vector(0.039, 0.239, 0.032), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++++++++++"] = { type = "Model", model = "models/mechanics/articulating/arm2x20d2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.065, -3.08, 5.25), angle = Angle(0, 0, -8.528), size = Vector(0.009, 0.009, 0.009), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++++++++++++++++++++"] = { type = "Model", model = "models/props_pipes/pipe02_lcurve01_long.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.369, -3.596, 4.664), angle = Angle(-169.842, -90, 98.758), size = Vector(0.029, 0.029, 0.029), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++++++"] = { type = "Model", model = "models/hunter/misc/roundthing2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -2.783, 3.663), angle = Angle(0, 180, 93.805), size = Vector(0.039, 0.059, 0.004), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+++"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -2.662, -1.77), angle = Angle(-90.811, 90, 0), size = Vector(0.039, 0.004, 0.019), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["sinistra+++++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.027, -3.445), angle = Angle(0, 0, -8.528), size = Vector(0.029, 0.029, 0.009), color = Color(203, 191, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["sinistra+++++++"] = { type = "Model", model = "models/mechanics/wheels/wheel_smooth_48.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0.086, -2.174, 4.669), angle = Angle(0, 0, 78.443), size = Vector(0.09, 0.09, 0.09), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_01", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.03, -1.091, -3.211), size = { x = 1.84, y = 1.84 }, color = Color(0, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["sinistra++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.124, -2.975), angle = Angle(0, 0, -8.528), size = Vector(1.289, 1.289, 0.001), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["sinistra++++++++++++++++"] = { type = "Model", model = "models/xqm/afterburner1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.129, -1.946, 7.337), angle = Angle(1.031, 9.673, 165.345), size = Vector(0.129, 0.129, 0.129), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["arma+"] = { type = "Model", model = "models/weapons/w_pist_p228.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, 4.218, 0.1), angle = Angle(90, 0, -90), size = Vector(0.8, 1, 0.8), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["sinistra+++++++++++++++"] = { type = "Model", model = "models/mechanics/solid_steel/box_beam_4.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.04, -3.985, 4.684), angle = Angle(0, 0, -124.5), size = Vector(0.019, 0.039, 0.019), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.027, -3.445), angle = Angle(0, 0, -8.528), size = Vector(0.064, 0.064, 0.009), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["sinistra++++++++++++"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-2.04, -1.747, 3.923), angle = Angle(0, 90, -152.019), size = Vector(0.039, 0.14, 0.032), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.17, -2.313), angle = Angle(0, 0, -8.528), size = Vector(1.399, 1.399, 0.019), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+++++++++++++++++"] = { type = "Model", model = "models/hunter/tubes/circle4x4.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0.127, -2.625, 4.685), angle = Angle(0, 0, 78.443), size = Vector(0.023, 0.023, 0.023), color = Color(191, 130, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {} },
		["sinistra+++++++++++++++++++++"] = { type = "Model", model = "models/XQM/triangle1x1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-0.051, -3.195, 3.684), angle = Angle(0, -90, -90), size = Vector(0.029, 0.029, 0.07), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+++++"] = { type = "Model", model = "models/hunter/tubes/circle4x4.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0.308, -1.545, 4.342), angle = Angle(0, 0, 78.443), size = Vector(0.026, 0.026, 0.3), color = Color(165, 165, 165, 255), surpresslightning = false, material = "phoenix_storms/stripes", skin = 0, bodygroup = {} },
		["sinistra++++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, -1.027, -3.445), angle = Angle(0, 0, -8.528), size = Vector(0.057, 0.057, 0.007), color = Color(191, 139, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {} },
		["sinistra+++++++++++"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(-1.55, -1.583, 2.028), angle = Angle(0, 90, -152.019), size = Vector(0.039, 0.14, 0.032), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra+++++++++++++++++++"] = { type = "Model", model = "models/props_pipes/pipe02_lcurve01_long.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0.368, -3.596, 4.664), angle = Angle(169.841, 90, 98.758), size = Vector(0.029, 0.029, 0.029), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		["sinistra++"] = { type = "Model", model = "models/hunter/misc/roundthing2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_left", pos = Vector(0, 0.87, 4.671), angle = Angle(0, 0, -98.528), size = Vector(0.039, 0.039, 0.039), color = Color(0, 99, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },

		["1_left"] = { type = "Model", model = "", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3, 0.75, 2), angle = Angle(0, 90, 90), size = Vector(0.008, 0.008, 0.008), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

		["1_right"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -3.1), angle = Angle(180, 90, 90), size = Vector(0.008, 0.008, 0.008), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

		["destra+++++++++++++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0.202, -0.934, 2.381), angle = Angle(0, -164.299, 0), size = Vector(0.029, 0.029, 0.039), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra+++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_01", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.018, -0.673, -3.346), size = { x = 1.84, y = 1.84 }, color = Color(0, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["destra+++"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -2.162, -1.688), angle = Angle(-90.811, 90, 0), size = Vector(0.039, 0.004, 0.019), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.004, -0.604, -3.516), angle = Angle(0, 0, 0), size = Vector(0.054, 0.054, 0.054), color = Color(191, 139, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {} },
		["destra+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -0.648, -2.722), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 0.1), color = Color(255, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/bluemetal", skin = 0, bodygroup = {} },
		["destra+++++++++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0.202, -0.934, 0.949), angle = Angle(0, -164.299, 0), size = Vector(0.029, 0.029, 0.039), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["arma"] = { type = "Model", model = "models/weapons/w_pist_p228.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.341, 4.723, 0.446), angle = Angle(90, 0, -91.383), size = Vector(1, 1, 0.6), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -0.648, -2.975), angle = Angle(0, 0, 0), size = Vector(1.289, 1.289, 0.001), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 1} },
		["destra+++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.004, -0.604, -3.681), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.019), color = Color(203, 191, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -0.648, 8.1), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 0.029), color = Color(191, 130, 255, 255), surpresslightning = false, material = "models/props_combine/masterinterface01c", skin = 0, bodygroup = {[0] = 1} },
		["destra++++++++++++++"] = { type = "Model", model = "models/props_combine/combine_mine01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0, -0.19, 12), angle = Angle(0, 0, 180), size = Vector(0.15, 0.15, 0.15), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra++++++++++"] = { type = "Model", model = "models/xqm/Rails/funnel.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.004, -0.604, 11), angle = Angle(0, 0, 0), size = Vector(0.029, 0.029, 0.029), color = Color(255, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/bluemetal", skin = 0, bodygroup = {} },
		["destra++++++++++++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(0.202, -0.934, 1.661), angle = Angle(0, -164.299, 0), size = Vector(0.029, 0.029, 0.039), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.004, -0.604, -3.516), angle = Angle(0, 0, 0), size = Vector(0.064, 0.064, 0.009), color = Color(165, 165, 165, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["destra+++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1_right", pos = Vector(-0.019, -0.604, 8.7), angle = Angle(0, 0, 0), size = Vector(0.079, 0.079, 0.029), color = Color(255, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/bluemetal", skin = 0, bodygroup = {} }
	}

	SWEP.SwapGunAmmo = true

	function SWEP:DrawHUD()
		BaseClass.DrawHUD(self)

		if self:Clip2() == 0 then
			self.VElementsR["destra+++++++++++++++"].color = Color(255,0,0,255)
		else
			self.VElementsR["destra+++++++++++++++"].color = Color(0,255,0,255)
		end

		if self:Clip1() == 0 then
			self.VElementsL["sinistra++++++++++++++"].color = Color(255,0,0,255)
		else
			self.VElementsL["sinistra++++++++++++++"].color = Color(0,255,0,255)
		end
	end
end

SWEP.Base = "weapon_zs_base_akimbo"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.PrintName = "'Porther' Zap Guns"
SWEP.Description = ""
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.ViewModel_L = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 80
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.4

SWEP.Secondary.Damage = 60
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Delay = 0.4

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"

SWEP.Secondary.ClipSize = 8
SWEP.Secondary.DefaultClip = 8
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "pulse"

SWEP.RequiredClip = 1

SWEP.ConeMax = 2
SWEP.ConeMin = 1

SWEP.ConeMax_S = 2
SWEP.ConeMin_S = 1

SWEP.FireAnimSpeed = 1.5

SWEP.Tier = 6

SWEP.ReloadSpeed = 0.75

SWEP.FireAnimIndexMin = 1
SWEP.FireAnimIndexMax = 1
SWEP.ReloadAnimIndex = 4
SWEP.DeployAnimIndex = 5

SWEP.FireAnimIndexMin_S = 1
SWEP.FireAnimIndexMax_S = 1
SWEP.ReloadAnimIndex_S = 4
SWEP.DeployAnimIndex_S = 5

SWEP.TracerName = "tracer_zapgun_right"
SWEP.TracerName_S = "tracer_zapgun_left"

SWEP.SoundFireVolume = 1
SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.SoundFireVolume_S = 1
SWEP.SoundPitchMin_S = 100
SWEP.SoundPitchMax_S = 110

SWEP.ReloadSound = "weapons_zapguns/zapgun_reload.ogg"
SWEP.Primary.Sound = "weapons_zapguns/zapgun_shot.ogg"
SWEP.Secondary.Sound = "weapons_zapguns/zapgun_shot.ogg"

local math_random = math.random
function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, self.SoundFireLevel, math_random(self.SoundPitchMin, self.SoundPitchMax), self.SoundFireVolume, CHAN_WEAPON)
end

function SWEP:EmitFireSound_S()
	self:EmitSound(self.Secondary.Sound, self.SoundFireLevel_S, math_random(self.SoundPitchMin_S, self.SoundPitchMax_S), self.SoundFireVolume_S, CHAN_WEAPON)
end

-- Not worth for networking from serverside just for muzzle.
function SWEP:ShootBullets(dmg, numbul, cone, isleft)
	local owner = self:GetOwner()
	--self:SendWeaponAnimation()
	owner:DoAttackEvent()
	if self.Recoil > 0 then
		local r = math.Rand(0.8, 1)
		owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
	end

	if self.PointsMultiplier then
		POINTSMULTIPLIER = self.PointsMultiplier
	end

	owner:LagCompensation(true)
		owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, self.Pierces, self.DamageTaper, dmg, nil, self.Primary.KnockbackScale, isleft and self.TracerName_S or self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self, self, isleft and (GAMEMODE.OverTheShoulder and 2 or 1) or 1)
	owner:LagCompensation(false)

	if self.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end
end

local LeftUpdateDMG
local RightUpdateDMG

function SWEP:PrimaryAttack()
	if not self:CanAttackCheck(false) then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

	self:EmitFireSound_S()

	self:TakeAmmo(false)

	LeftUpdateDMG = self.Primary.Damage

	self:ShootBullets(self.Primary.Damage, self.Secondary.NumShots, self:GetCone_S(), true)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin_S, self.FireAnimIndexMax_S), 1, self.FireAnimSpeed)
end

-- RIGHT SHOOTING
function SWEP:SecondaryAttack()
	if not self:CanAttackCheck(true) then return end

	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay())

	self:EmitFireSound()

	self:TakeAmmo(true)

	RightUpdateDMG = self.Secondary.Damage

	self:ShootBullets(self.Secondary.Damage, self.Primary.NumShots, self:GetCone(), false)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin, self.FireAnimIndexMax), 0, self.FireAnimSpeed)
end

local util_Effect = util.Effect
local timer_Simple = timer.Simple
function SWEP.BulletCallback(attacker, tr, dmginfo)
	dmginfo:SetDamageType(DMG_DISSOLVE)

	if tr.HitWorld then
		util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end

	if SERVER then
		local ent = tr.Entity
		local damage = dmginfo:GetDamage()

		if damage == LeftUpdateDMG then
			--timer_Simple(0, function()
				--if IsValid(ent) and ent:Alive() then
					local effectdata = EffectData()
						effectdata:SetOrigin(tr.HitPos)
						effectdata:SetStart(ent:GetPos())
						effectdata:SetEntity(ent)
					util_Effect("tracer_zapper", effectdata)
				--end
			--end)
		elseif damage == RightUpdateDMG then
			local radius = 20 ^ 2
			local basedmg = RightUpdateDMG * 0.55

			for _, hitpl in pairs(util.BlastAlloc(attacker:GetActiveWeapon(), attacker, tr.HitPos, radius)) do
				if hitpl:IsValidLivingZombie() and gamemode.Call("PlayerShouldTakeDamage", hitpl, attacker) then
					local nearest = hitpl:NearestPoint(tr.HitPos)
					local datdmg = ((radius - nearest:DistToSqr(tr.HitPos)) / radius) * basedmg

					if datdmg > 0 and datdmg <= basedmg then
						hitpl:TakeSpecialDamage(datdmg, DMG_DISSOLVE, attacker, attacker:GetActiveWeapon(), nearest)

						basedmg = basedmg * 0.9
					end
				end
			end
		end
	end

	if attacker:GetActiveWeapon().LegDamage then
		local ent = tr.Entity
		if ent:IsValidZombie() then
			ent:AddLegDamageExt(8.5, attacker, attacker:GetActiveWeapon(), SLOWTYPE_PULSE) --increase resonance chance
		end
	end

	return {impact = false}
end