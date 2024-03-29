include("shared.lua")

SWEP.HUD3DBone = "v_weapon.ump45_Release"
SWEP.HUD3DPos = Vector(-1.6, -4, 5)
SWEP.HUD3DAng = Angle(0, 0, 0)
SWEP.HUD3DScale = 0.02

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModelFOV = 52
SWEP.ViewModelFlip = false

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.VElements = {
	["bio+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, 0, 12), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.019), color = Color(69, 62, 36, 255), surpresslightning = false, material = "models/weapons/w_shotgun/w_shotgun", skin = 0, bodygroup = {} },
	["bio+++++++++++++"] = { type = "Model", model = "models/props_pipes/pipecluster32d_003a.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0.3, 2, 7), angle = Angle(0, 0, 90), size = Vector(0.019, 0.05, 0.019), color = Color(64, 79, 97, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} },
	["bio"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(0.2, -5.6, -14), angle = Angle(0, 180, 0), size = Vector(0.05, 0.05, 0.059), color = Color(39, 44, 52, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bio+"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, 0, 3), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(39, 44, 52, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bio++"] = { type = "Model", model = "models/props_phx/construct/metal_wire_angle360x2.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, 0, 4), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.079), color = Color(39, 44, 52, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bio++++++++++++++"] = { type = "Model", model = "models/props_c17/gravestone004a.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, -0.5, 19.221), angle = Angle(0, 0, 0), size = Vector(0.1, 0.09, 0.1), color = Color(39, 46, 54, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} },
	["bio++++++++++"] = { type = "Model", model = "models/props_lab/generatortube.mdl", bone = "v_weapon.ump45_Clip", rel = "bio+++++++++", pos = Vector(0.1, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.05), color = Color(150, 230, 110, 255), surpresslightning = true, material = "models/props_c17/metalladder002", skin = 0, bodygroup = {} },
	["bio++++++++++++"] = { type = "Model", model = "models/props_wasteland/light_spotlight01_base.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0.3, -4, 14), angle = Angle(0, 0, 0), size = Vector(0.349, 0.25, 0.23), color = Color(42, 46, 54, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} },
	["bio++++++"] = { type = "Model", model = "models/props_lab/generatortube.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, 0, 4), angle = Angle(0, 0, 0), size = Vector(0.079, 0.079, 0.079), color = Color(150, 230, 110, 255), surpresslightning = true, material = "models/props_c17/metalladder002", skin = 0, bodygroup = {} },
	["bio+++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.ump45_Clip", rel = "bio+++++++++", pos = Vector(0.1, 0, 4), angle = Angle(0, 0, 0), size = Vector(0.029, 0.039, 0.009), color = Color(15, 15, 15, 255), surpresslightning = false, material = "models/props_c17/metalladder002", skin = 0, bodygroup = {} },
	["bio+++++"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, -0.5, 15), angle = Angle(0, 0, -90), size = Vector(0.4, 0.5, 0.56), color = Color(47, 49, 49, 255), surpresslightning = false, material = "models/props_lab/teleportgate_sheet", skin = 0, bodygroup = {} },
	["bio+++++++"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, 0.6, 12), angle = Angle(178.83, 90, 0), size = Vector(0.059, 0.079, 0.119), color = Color(84, 89, 125, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bio++++"] = { type = "Model", model = "models/props_c17/furnitureboiler001a.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, 0.6, 16), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(70, 75, 90, 255), surpresslightning = false, material = "models/weapons/w_shotgun/w_shotgun", skin = 0, bodygroup = {} },
	["bio++++++++"] = { type = "Model", model = "models/props_pipes/valve002.mdl", bone = "v_weapon.ump45_Parent", rel = "bio", pos = Vector(0, -4.5, 6.5), angle = Angle(60, 90, 0), size = Vector(0.17, 0.17, 0.079), color = Color(34, 44, 55, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} },
	["bio+++++++++"] = { type = "Model", model = "models/props_phx/construct/metal_wire_angle360x2.mdl", bone = "v_weapon.ump45_Clip", rel = "", pos = Vector(0.1, 3, -2), angle = Angle(0, 0, 90), size = Vector(0.025, 0.025, 0.039), color = Color(34, 44, 55, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["bio+++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, 0, 12), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.019), color = Color(69, 62, 36, 255), surpresslightning = false, material = "models/weapons/w_shotgun/w_shotgun", skin = 0, bodygroup = {} },
	["bio+++++++++++++"] = { type = "Model", model = "models/props_pipes/pipecluster32d_003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0.3, 2, 7), angle = Angle(0, 0, 90), size = Vector(0.019, 0.05, 0.019), color = Color(64, 79, 97, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} },
	["bio"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18, 2.599, -6), angle = Angle(0, -97.014, 85.324), size = Vector(0.05, 0.05, 0.059), color = Color(39, 44, 52, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bio+"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, 0, 3), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(39, 44, 52, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bio++++++++++++"] = { type = "Model", model = "models/props_wasteland/light_spotlight01_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0.3, -4, 14), angle = Angle(0, 0, 0), size = Vector(0.349, 0.25, 0.23), color = Color(42, 46, 54, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} },
	["bio++++++++++"] = { type = "Model", model = "models/props_lab/generatortube.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio++++++++", pos = Vector(1.799, 0, -2.1), angle = Angle(30, 0, 0), size = Vector(0.05, 0.05, 0.039), color = Color(150, 180, 0, 255), surpresslightning = true, material = "models/props_c17/metalladder002", skin = 0, bodygroup = {} },
	["bio++++"] = { type = "Model", model = "models/props_c17/furnitureboiler001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, 0.6, 16), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(70, 75, 90, 255), surpresslightning = false, material = "models/weapons/w_shotgun/w_shotgun", skin = 0, bodygroup = {} },
	["bio++"] = { type = "Model", model = "models/props_phx/construct/metal_wire_angle360x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, 0, 4), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.079), color = Color(39, 44, 52, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bio++++++"] = { type = "Model", model = "models/props_lab/generatortube.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, 0, 4), angle = Angle(0, 0, 0), size = Vector(0.079, 0.079, 0.079), color = Color(150, 180, 0, 255), surpresslightning = true, material = "models/props_c17/metalladder002", skin = 0, bodygroup = {} },
	["bio+++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio++++++++", pos = Vector(0.1, 0, 4), angle = Angle(0, 0, 0), size = Vector(0.029, 0.039, 0.009), color = Color(15, 15, 15, 255), surpresslightning = false, material = "models/props_c17/metalladder002", skin = 0, bodygroup = {} },
	["bio+++++"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, -0.5, 15), angle = Angle(0, 0, -90), size = Vector(0.4, 0.5, 0.56), color = Color(47, 49, 49, 255), surpresslightning = false, material = "models/props_lab/teleportgate_sheet", skin = 0, bodygroup = {} },
	["bio+++++++"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, 0.6, 12), angle = Angle(178.83, 90, 0), size = Vector(0.059, 0.079, 0.119), color = Color(84, 89, 125, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["bio++++++++++++++"] = { type = "Model", model = "models/props_c17/gravestone004a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, -0.5, 19.221), angle = Angle(0, 0, 0), size = Vector(0.1, 0.09, 0.1), color = Color(39, 46, 54, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} },
	["bio++++++++"] = { type = "Model", model = "models/props_pipes/valve002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, -4.5, 6.5), angle = Angle(60, 90, 0), size = Vector(0.17, 0.17, 0.079), color = Color(34, 44, 55, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} },
	["bio+++++++++"] = { type = "Model", model = "models/props_phx/construct/metal_wire_angle360x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "bio", pos = Vector(0, -7.301, 7), angle = Angle(0, 0, 90), size = Vector(0.025, 0.025, 0.039), color = Color(34, 44, 55, 255), surpresslightning = false, material = "models/props_c17/substation_transformer01a", skin = 0, bodygroup = {} }
}

--[[
SWEP.AbilityText = "CORROSION"
SWEP.AbilityColor = Color(68, 224, 89)
function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
	self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
end

function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
	self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
end
]]