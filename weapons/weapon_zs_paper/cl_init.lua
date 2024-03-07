include("shared.lua")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70

SWEP.ViewModelBoneMods = {
	["ValveBiped.cube1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.cube2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.cube"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
	["paper_wtf"] = { type = "Model", model = "models/props/cs_office/paper_towels.mdl", bone = "ValveBiped.cube3", rel = "", pos = Vector(-2.013, 1.006, 1.006), angle = Angle(0, -67.925, -99.623), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
 
SWEP.WElements = {
	["paper_wtf"] = { type = "Model", model = "models/props/cs_office/paper_towels.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.038, 0, -2.013), angle = Angle(86.038, 138.11301, -99.623), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}