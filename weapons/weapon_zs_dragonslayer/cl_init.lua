include("shared.lua")

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.VElements = {
		["handle"] = { type = "Model", model = "models/props_docks/dock02_pole02a_256.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.0190000534058, 1.0060000419617, 3.0190000534058), angle = Angle(-5.3039999008179, -9.0570001602173, -3.1819999217987), size = Vector(0.10100000351667, 0.10100000351667, 0.071999996900558), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_canal/coastmap_sheet", skin = 0, bodygroup = {} },
	["handle+"] = { type = "Model", model = "models/hunter/tubes/circle2x2c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.19200000166893, -0.10000000149012, -7.4800000190735), angle = Angle(89.261001586914, 88.696998596191, -1.5), size = Vector(0.17499999701977, 0.15000000596046, 1.1849999427795), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal6", skin = 0, bodygroup = {} },
	["handle++"] = { type = "Model", model = "models/hunter/tubes/circle2x2c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.19200000166893, -0.10000000149012, -7.5359997749329), angle = Angle(89.261001586914, 88.696998596191, -1.6109999418259), size = Vector(0.15099999308586, 0.11900000274181, 1.2309999465942), color = Color(0, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
	["handle+++"] = { type = "Model", model = "models/hunter/tubes/circle2x2c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.19200000166893, -0.10000000149012, -7.5359997749329), angle = Angle(89.261001586914, 88.696998596191, -1.6109999418259), size = Vector(0.13500000536442, 0.10499999672174, 1.2999999523163), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal6", skin = 0, bodygroup = {} },
	["handle++++"] = { type = "Model", model = "models/hunter/plates/plate1x4x2trap1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(0.046999998390675, -1.414999961853, -7.5060000419617), angle = Angle(90.56600189209, -92.830001831055, 180), size = Vector(0.32199999690056, 0.25, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
	["handle+++++"] = { type = "Model", model = "models/hunter/triangles/05x05mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.045000001788139, 0.69999998807907, -69.800003051758), angle = Angle(90.603996276855, -92.697998046875, 0), size = Vector(0.10000000149012, 0.08500000089407, 1.0099999904633), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
	["handle++++++"] = { type = "Model", model = "models/hunter/plates/plate1x4x2trap1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(0, -1.1050000190735, -9.0570001602173), angle = Angle(90.583999633789, -92.842002868652, 180), size = Vector(0.3129999935627, 0.34999999403954, 0.76999998092651), color = Color(200, 200, 200, 255), surpresslightning = false, material = "metal2a", skin = 0, bodygroup = {} },
	["handle+++++++"] = { type = "Model", model = "models/hunter/triangles/05x05mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.10000000149012, 0.69999998807907, -70.800003051758), angle = Angle(90.603996276855, -92.697998046875, 0), size = Vector(0.20000000298023, 0.11800000071526, 0.79000002145767), color = Color(200, 200, 200, 255), surpresslightning = false, material = "metal2a", skin = 0, bodygroup = {} },
	["кольцо"] = { type = "Model", model = "models/props_interiors/pot01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(0, 2.0130000114441, -10.027000427246), angle = Angle(0, 180, -90), size = Vector(0.21999999880791, 0.21999999880791, 0.21999999880791), color = Color(255, 255, 255, 255), surpresslightning = false, material = "metal6", skin = 0, bodygroup = {} },
	["цепь"] = { type = "Model", model = "models/props_vehicles/tire001b_truck.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.097999997437, 3.0190000534058, -9.0570001602173), angle = Angle(19.434000015259, 76.981002807617, 131.32099914551), size = Vector(0.059999998658895, 0.059999998658895, 0.059999998658895), color = Color(150, 150, 150, 255), surpresslightning = false, material = "metal2a", skin = 0, bodygroup = {} }
	}

SWEP.WElements = {
		["handle"] = { type = "Model", model = "models/props_docks/dock02_pole02a_256.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.1849999427795, 1.4509999752045, -0.2660000026226), angle = Angle(-5.3039999008179, 23.35000038147, -3.1819999217987), size = Vector(0.10100000351667, 0.10100000351667, 0.071999996900558), color = Color(100, 100, 100, 255), surpresslightning = false, material = "models/props_canal/coastmap_sheet", skin = 0, bodygroup = {} },
	["handle+"] = { type = "Model", model = "models/hunter/tubes/circle2x2c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.19200000166893, -0.10000000149012, -7.4800000190735), angle = Angle(89.261001586914, 88.696998596191, -1.5), size = Vector(0.19099999964237, 0.15000000596046, 1.1950000524521), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
	["handle++"] = { type = "Model", model = "models/hunter/tubes/circle2x2c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.19200000166893, -0.10000000149012, -7.5359997749329), angle = Angle(89.261001586914, 88.696998596191, -1.6109999418259), size = Vector(0.15099999308586, 0.11900000274181, 1.2309999465942), color = Color(0, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
	["handle+++"] = { type = "Model", model = "models/hunter/tubes/circle2x2c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.19200000166893, -0.10000000149012, -7.5359997749329), angle = Angle(89.261001586914, 88.696998596191, -1.6109999418259), size = Vector(0.12999999523163, 0.10000000149012, 1.2400000095367), color = Color(200, 200, 200, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
	["handle++++"] = { type = "Model", model = "models/hunter/plates/plate1x4x2trap1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(0.046999998390675, -1.414999961853, -7.5060000419617), angle = Angle(90.56600189209, -92.830001831055, 180), size = Vector(0.32199999690056, 0.25, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
	["handle+++++"] = { type = "Model", model = "models/hunter/triangles/05x05mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.045000001788139, 0.69999998807907, -69.800003051758), angle = Angle(90.603996276855, -92.697998046875, 0), size = Vector(0.10000000149012, 0.08500000089407, 1.0099999904633), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/road", skin = 0, bodygroup = {} },
	["handle++++++"] = { type = "Model", model = "models/hunter/plates/plate1x4x2trap1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(0, -1.1050000190735, -9.0570001602173), angle = Angle(90.583999633789, -92.842002868652, 180), size = Vector(0.3129999935627, 0.34999999403954, 0.76999998092651), color = Color(200, 200, 200, 255), surpresslightning = false, material = "metal2a", skin = 0, bodygroup = {} },
	["handle+++++++"] = { type = "Model", model = "models/hunter/triangles/05x05mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.10000000149012, 0.69999998807907, -70.800003051758), angle = Angle(90.603996276855, -92.697998046875, 0), size = Vector(0.20000000298023, 0.11800000071526, 0.79000002145767), color = Color(200, 200, 200, 255), surpresslightning = false, material = "metal2a", skin = 0, bodygroup = {} },
	["кольцо"] = { type = "Model", model = "models/props_interiors/pot01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(0, 2.5380001068115, -10.027000427246), angle = Angle(0, 180, -90), size = Vector(0.21999999880791, 0.21999999880791, 0.21999999880791), color = Color(180, 180, 180, 255), surpresslightning = false, material = "phoenix_storms/concrete3", skin = 0, bodygroup = {} },
	["помель"] = { type = "Model", model = "models/props_c17/gravestone_cross001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.0020000000949949, 0.050000000745058, 5.5419998168945), angle = Angle(-180, 3.0329999923706, -0.72600001096725), size = Vector(0.046999998390675, 0.046999998390675, 0.046999998390675), color = Color(100, 100, 100, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
	["цепь"] = { type = "Model", model = "models/props_vehicles/tire001b_truck.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-0.097999997437, 3.5, -9.0570001602173), angle = Angle(19.434000015259, 76.981002807617, 131.32099914551), size = Vector(0.070000000298023, 0.070000000298023, 0.070000000298023), color = Color(150, 150, 150, 255), surpresslightning = false, material = "metal2a", skin = 0, bodygroup = {} }
	}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 2.433, 0), angle = Angle(0, 0, 0) }
}