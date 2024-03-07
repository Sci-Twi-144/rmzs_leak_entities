include("shared.lua")

DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60

SWEP.HUD3DBone = "ValveBiped.square"
SWEP.HUD3DPos = Vector(1.1, 0.25, -2)
SWEP.HUD3DScale = 0.015

	SWEP.VElements = {
		["m+"] = { type = "Model", model = "models/props_junk/metal_paintcan001a.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 0, -2.597), angle = Angle(0, 0, 180), size = Vector(0.23, 0.23, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/GutterMetal01a", skin = 0, bodygroup = {} },
		["m"] = { type = "Model", model = "models/props_combine/combine_mine01.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 0, 9.869), angle = Angle(0, 0, 180), size = Vector(0.1, 0.1, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["m+"] = { type = "Model", model = "models/props_junk/metal_paintcan001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.557, 2.25, -3.636), angle = Angle(90, 0, 0), size = Vector(0.23, 0.23, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/GutterMetal01a", skin = 0, bodygroup = {} },
		["m"] = { type = "Model", model = "models/props_combine/combine_mine01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.026, 2.25, -3.6), angle = Angle(0, -90, 90), size = Vector(0.119, 0.119, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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