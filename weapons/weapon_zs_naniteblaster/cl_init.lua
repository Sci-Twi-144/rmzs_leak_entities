include("shared.lua")

DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60

SWEP.HUD3DBone = "ValveBiped.square"
SWEP.HUD3DPos = Vector(1.1, 0.25, -2)
SWEP.HUD3DScale = 0.015

SWEP.VElements = {
		["m+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 0, -7.792), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 3.351), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["m"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 2, 0), angle = Angle(0, -90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["m++"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 0, -7.792), angle = Angle(0, 90, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["m+++"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(2, 0, 2.596), angle = Angle(0, 90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(0, 34, 55, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["m+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 2, -3.636), angle = Angle(-95, 0, 0), size = Vector(0.5, 0.5, 2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["m"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.947, 2, -2.201), angle = Angle(85, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["m++"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.519, 2, -3.636), angle = Angle(-90, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["m+++"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.831, 4, -3.636), angle = Angle(-95, 0, 0), size = Vector(0.6, 0.6, 0.6), color = Color(0, 34, 55, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
	}

function SWEP:DefineFireMode3D()
	if self:GetFireMode() == 0 then
		return "STOCK"
	else
		return "AOE"
	end
end

function SWEP:DefineFireMode2D()
	if self:GetFireMode() == 0 then
		return "STOCK"
	else
		return "AOE"
	end
end	