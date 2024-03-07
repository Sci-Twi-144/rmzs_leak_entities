AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_mp40"))
SWEP.Description = (translate.Get("desc_mp40"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.VMPos = Vector(-3, -5, 3.4)
	SWEP.VMAng = Vector(0, 0, 0)

	SWEP.HUD3DBone = "v_weapon.ump45_Release"
	SWEP.HUD3DPos = Vector(-2, -2, 3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.VElements = {
		["4"] = { type = "Model", model = "models/XQM/Rails/gumball_1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.629, -0.008), angle = Angle(0, 0, 0), size = Vector(0.071, 0.071, 0.071), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.824, 10.064), angle = Angle(0, -90, 0), size = Vector(0.216, 0.143, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 8.89), angle = Angle(0, 0, 0), size = Vector(0.781, 0.781, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["1+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "v_weapon.ump45_Release", rel = "1", pos = Vector(0, 0, 17.44), angle = Angle(0, 0, 0), size = Vector(0.497, 0.497, 0.023), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["4+"] = { type = "Model", model = "models/XQM/Rails/gumball_1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 13.553), angle = Angle(0, 0, 0), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 10.045), angle = Angle(0, 90, 0), size = Vector(0.017, 0.017, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["7+++"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 1.195, 6.974), angle = Angle(0, 0, 0), size = Vector(0.187, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino2+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.488, 19.451), angle = Angle(180, 0, -90), size = Vector(0.037, 0.037, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 8.845), angle = Angle(90, 0, 0), size = Vector(0.018, 0.155, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["7"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.69, 0), angle = Angle(0, 0, 0), size = Vector(0.187, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/weapons/w_pist_fiveseven.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 5.663, 1.684), angle = Angle(90, -90, 0), size = Vector(0.949, 0.949, 0.949), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0.019, 0.899, -0.622), angle = Angle(0, -180, 90), size = Vector(0.018, 0.018, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino+"] = { type = "Model", model = "models/hunter/triangles/05x05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0.275, -0.7, 6.168), angle = Angle(90, 0, 0), size = Vector(0.061, 0.048, 0.063), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino2"] = { type = "Model", model = "models/hunter/tubes/tube2x2xtb.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -0.784, 19.503), angle = Angle(180, 0, -90), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["7+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0.879, 0.734, -0.095), angle = Angle(0, 0, 3.506), size = Vector(0.202, 0.202, 0.063), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["caricatore"] = { type = "Model", model = "models/Items/BoxSRounds.mdl", bone = "v_weapon.ump45_Clip", rel = "", pos = Vector(-0.301, 3.635, -1.4), angle = Angle(-0.529, -180, 180), size = Vector(0.172, 0.432, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 0.319), angle = Angle(0, -17.792, 0), size = Vector(0.037, 0.037, 0.089), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0.068, 0, 0.319), angle = Angle(0, 103.025, 0), size = Vector(0.035, 0.035, 0.089), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["7++"] = { type = "Model", model = "models/props_phx/construct/metal_wire1x2b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 1.534, 6.228), angle = Angle(0, 0, 74.788), size = Vector(0.046, 0.039, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["6"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2c.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.888, 3.7), angle = Angle(5, 90, 0), size = Vector(0.032, 0.032, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["5++"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0.019, 0.834, -0.331), angle = Angle(-180, 180, -88.972), size = Vector(0.019, 0.025, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino+++"] = { type = "Model", model = "models/hunter/triangles/05x05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.446, 15.923), angle = Angle(-90, 0, 180), size = Vector(0.246, 0.024, 0.239), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["5+"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0.019, 1.312, 0.5), angle = Angle(0, -180, 160.82), size = Vector(0.018, 0.018, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(-0, -4.8, 2.2), angle = Angle(180, 0, 0), size = Vector(0.409, 0.409, 0.196), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0.836, 3.944), angle = Angle(0, -90, 0), size = Vector(0.143, 0.143, 0.372), color = Color(97, 59, 33, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["bolt"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-0.227, 0.111, 6.328), angle = Angle(-90, 30, 0), size = Vector(0.179, 0.179, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2d.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0.089, -0.026, 0.319), angle = Angle(0, -170, 0), size = Vector(0.035, 0.035, 0.089), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino++"] = { type = "Model", model = "models/hunter/triangles/05x05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(-0.276, -0.7, 6.168), angle = Angle(90, 0, 0), size = Vector(0.061, 0.048, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, -0.701, 6.492), angle = Angle(0, 0, 0), size = Vector(0.061, 0.037, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "1", pos = Vector(0, 0, 11.222), angle = Angle(0, 0, 0), size = Vector(0.017, 0.017, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["4"] = { type = "Model", model = "models/XQM/Rails/gumball_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.629, -0.008), angle = Angle(0, 0, 0), size = Vector(0.071, 0.071, 0.071), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3+"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.824, 10.064), angle = Angle(0, -90, 0), size = Vector(0.216, 0.114, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.019, 0.899, -0.622), angle = Angle(0, -180, 90), size = Vector(0.018, 0.018, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["1+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 17.44), angle = Angle(0, 0, 0), size = Vector(0.497, 0.497, 0.023), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["4+"] = { type = "Model", model = "models/XQM/Rails/gumball_1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 13.553), angle = Angle(0, 0, 0), size = Vector(0.054, 0.054, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+++"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 10.045), angle = Angle(0, 90, 0), size = Vector(0.017, 0.017, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["7+++"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 1.195, 6.974), angle = Angle(0, 0, 0), size = Vector(0.187, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino2+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.488, 19.451), angle = Angle(180, 0, -90), size = Vector(0.037, 0.037, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 8.89), angle = Angle(0, 0, 0), size = Vector(0.781, 0.781, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["7"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.69, 0), angle = Angle(0, 0, 0), size = Vector(0.187, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/weapons/w_pist_fiveseven.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 5.663, 1.684), angle = Angle(90, -90, 0), size = Vector(0.949, 0.949, 0.949), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino++"] = { type = "Model", model = "models/hunter/triangles/05x05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-0.276, -0.7, 6.168), angle = Angle(90, 0, 0), size = Vector(0.061, 0.048, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino+"] = { type = "Model", model = "models/hunter/triangles/05x05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.275, -0.7, 6.168), angle = Angle(90, 0, 0), size = Vector(0.061, 0.048, 0.063), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino2"] = { type = "Model", model = "models/hunter/tubes/tube2x2xtb.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.784, 19.503), angle = Angle(180, 0, -90), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["7+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.879, 0.734, -0.095), angle = Angle(0, 0, 3.506), size = Vector(0.202, 0.202, 0.063), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["caricatore"] = { type = "Model", model = "models/Items/BoxSRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.026, 4.918, 9.486), angle = Angle(0, 0, 0), size = Vector(0.163, 0.349, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 0.319), angle = Angle(0, -17.792, 0), size = Vector(0.037, 0.037, 0.089), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 8.845), angle = Angle(90, 0, 0), size = Vector(0.018, 0.155, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["7++"] = { type = "Model", model = "models/props_phx/construct/metal_wire1x2b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 1.534, 6.228), angle = Angle(0, 0, 74.788), size = Vector(0.046, 0.039, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["6"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.888, 3.7), angle = Angle(5, 90, 0), size = Vector(0.032, 0.032, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["5++"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.019, 0.834, -0.331), angle = Angle(-180, 180, -88.972), size = Vector(0.019, 0.025, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["bolt"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-0.227, 0.111, 6.328), angle = Angle(-90, 30, 0), size = Vector(0.179, 0.179, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["5+"] = { type = "Model", model = "models/hunter/tubes/tubebend2x2x90outer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.019, 1.312, 0.5), angle = Angle(0, -180, 160.82), size = Vector(0.018, 0.018, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.068, 0, 0.319), angle = Angle(0, 103.025, 0), size = Vector(0.035, 0.035, 0.089), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.836, 3.944), angle = Angle(0, -90, 0), size = Vector(0.143, 0.143, 0.372), color = Color(97, 59, 33, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
		["mirino+++"] = { type = "Model", model = "models/hunter/triangles/05x05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0.446, 15.923), angle = Angle(-90, 0, 180), size = Vector(0.246, 0.024, 0.239), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2++++++++"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0.089, -0.026, 0.319), angle = Angle(0, -170, 0), size = Vector(0.035, 0.035, 0.089), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.955, 0.777, -3.787), angle = Angle(2.494, -89.441, -95.196), size = Vector(0.409, 0.409, 0.196), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["mirino"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, -0.701, 6.492), angle = Angle(0, 0, 0), size = Vector(0.061, 0.037, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
		["2+"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(0, 0, 11.222), angle = Angle(0, 0, 0), size = Vector(0.017, 0.017, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} }
	}

	local Ang = Angle(-5.557, 10, -1.111)
	local LAng = Angle(5, 5, -5)

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = LAng },

		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Ang },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Ang },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Ang },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Ang }
	}

end

SWEP.ShowWorldModel = false
SWEP.ShowViewModel = false

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 115

SWEP.Primary.Sound = ")weapons/ump45/ump45-1.wav"
SWEP.Primary.Damage = 17.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 32
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 5.73
SWEP.ConeMin = 3.6

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ReloadSpeed = 1.1

SWEP.Tier = 4

SWEP.IronSightsPos = Vector(-5.3, -3, 1.4)
SWEP.IronSightsAng = Vector(-1, 0.2, 2.55)

function SWEP:OnZombieKilled()
	local killer = self:GetOwner()

	if killer:IsValid() then
		local reaperstatus = killer:GiveStatus("reaper", 7)
		if reaperstatus and reaperstatus:IsValid() then
			reaperstatus:SetStacks(math.min(reaperstatus:GetStacks() + 1, 5))
			killer:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetStacks() * 30, 0.45)
		end
	end
end

function SWEP.BulletCallback(attacker, tr)
	local hitent = tr.Entity
	if hitent:IsValidLivingZombie() and hitent:Health() <= hitent:GetMaxHealthEx() * 0.04 and gamemode.Call("PlayerShouldTakeDamage", hitent, attacker) then
		if SERVER then
			hitent:SetWasHitInHead()
		end
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, attacker, attacker:GetActiveWeapon(), tr.HitPos)
		hitent:EmitSound("npc/roller/blade_out.wav", 80, 125)
	end
end

if not CLIENT then return end

function SWEP:Draw3DHUD(vm, pos, ang)
	self.BaseClass.Draw3DHUD(self, vm, pos, ang)

	local wid, hei = 180, 200
	local x, y = wid * -0.6, hei * -0.5

	cam.Start3D2D(pos, ang, self.HUD3DScale)
		local owner = self:GetOwner()
		local ownerstatus = owner:GetStatus("reaper")
		if ownerstatus then
			local text = ""
			for i = 0, ownerstatus:GetDTInt(1)-1 do
				text = text .. "+"
			end
			draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x + wid/2, y + hei * 0.15, Color(60, 30, 175, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end
