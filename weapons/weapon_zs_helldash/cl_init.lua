include("shared.lua")

SWEP.HUD3DBone = "v_weapon.ump45_Release"
SWEP.HUD3DPos = Vector(-3.2, -4.4, 2)
SWEP.HUD3DAng = Angle(0, 0, 0)
SWEP.HUD3DScale = 0.02

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.VElements = {
	["bochka"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "v_weapon.ump45_Clip", rel = "", pos = Vector(0, 4.038, -1.5), angle = Angle(4.528, -4.528, -79.245), size = Vector(0.12, 0.12, 0.12), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bochka+"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "v_weapon.ump45_Clip", rel = "", pos = Vector(-0.3, 9.163, -2.513), angle = Angle(4.528, -4.528, -79.245), size = Vector(0.12, 0.12, 0.12), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bochka+++"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "v_weapon.ump45_Clip", rel = "", pos = Vector(-0.4, 11.169, -3.025), angle = Angle(4.528, -4.528, -79.245), size = Vector(0.12, 0.12, 0.12), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["box"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(-0.2, -2.013, -6.038), angle = Angle(-6.792, 0, -81.509), size = Vector(0.23, 0.23, 0.23), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(0.5, -7.044, -14.088), angle = Angle(0, 11.321, 0), size = Vector(0.22, 0.22, 0.22), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} },
	["element_name+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(0.5, -7.044, -4.2), angle = Angle(0, 11.321, 0), size = Vector(0.22, 0.22, 0.22), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} },
	["element_name++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(0.2, -6.038, 9.057), angle = Angle(0, 2.264, 22.642), size = Vector(0.15, 0.15, 0.15), color = Color(65, 65, 65, 65), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} },
	["element_name+++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(0.2, -8.05, 4.025), angle = Angle(0, 2.264, 22.642), size = Vector(0.15, 0.15, 0.15), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} },
	["element_name++++"] = { type = "Model", model = "models/props_wasteland/prison_lamp001c.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(0.5, -7.044, -11.069), angle = Angle(0, 29.434, 0), size = Vector(0.4, 0.4, 0.9), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["bochka"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.868, 0.964, -3.246), angle = Angle(25.74, -158.845, -5.486), size = Vector(0.12, 0.12, 0.12), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bochka+"] = { type = "Model", model = "models/props_c17/oildrum001_explosive.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.279, 0.296, 0.324), angle = Angle(25.74, -158.845, -5.486), size = Vector(0.12, 0.12, 0.12), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.46, 0.876, -6.522), angle = Angle(80.661, 10.712, -12.886), size = Vector(0.22, 0.22, 0.22), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} },
	["element_name+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.199, 0.949, -2.618), angle = Angle(61.513, 69.682, -66.208), size = Vector(0.13, 0.13, 0.13), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} },
	["element_name++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.148, 0.462, -5.101), angle = Angle(61.513, 69.682, -66.208), size = Vector(0.22, 0.22, 0.22), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} },
	["element_name+++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.6, 1.016, -1.942), angle = Angle(61.513, 69.682, -66.208), size = Vector(0.13, 0.13, 0.13), color = Color(65, 65, 65, 255), surpresslightning = false, material = "models/props_c17/furniturefabric002a", skin = 0, bodygroup = {} }
}
