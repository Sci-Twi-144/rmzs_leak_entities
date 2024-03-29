include("shared.lua")

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60

SWEP.HUD3DBone = "Python"
SWEP.HUD3DPos = Vector(0.85, -0.3, -2.5)
SWEP.HUD3DScale = 0.015

SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Angle(0, 0, 0)
local uBarrelOrigin = SWEP.VMPos
local lBarrelOrigin = Vector(0, 0, 0)
local BarAngle = Angle(0, 0, 0)
function SWEP:Think()
	if (self.IsShooting >= CurTime()) and self:GetIronsights() then
		self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(3, -0, 0) )
		self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -35, 0) )
	else
		self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
		self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
	end
	self.BaseClass.Think(self)
end

SWEP.VElements = {
	["spinner"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "Cylinder", rel = "", pos = Vector(0, 0, 0.243), angle = Angle(-180, 0, 0), size = Vector(0.078, 0.078, 0.041), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel11"] = { type = "Model", model = "models/items/boxflares.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel10", pos = Vector(0.888, 0, 0.159), angle = Angle(10, 0, 0), size = Vector(0.101, 0.273, 0.642), color = Color(153, 124, 139, 255), surpresslightning = false, material = "models/props_junk/shoe001a", skin = 0, bodygroup = {} },
	["chamber"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel7-2"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel7", pos = Vector(0.238, -3.609, 0), angle = Angle(0, 0, -180), size = Vector(0.018, 0.018, 0.018), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["uragan"] = { type = "Model", model = "models/items/357ammo.mdl", bone = "Python", rel = "", pos = Vector(0, 1.615, 0), angle = Angle(90, 0, -90), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel7-3"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel7-2", pos = Vector(-0.638, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.018, 0.018, 0.018), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["ironsight"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel6", pos = Vector(0, -0.24, 1.692), angle = Angle(0, 0, 180), size = Vector(0.019, 0.035, 0.05), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel8"] = { type = "Model", model = "models/items/boxflares.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(0, 0, -0.88), angle = Angle(0, 0, 0), size = Vector(0.36, 0.245, 0.248), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel7"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(3.233, 0, -0.304), angle = Angle(-90, 90, 0), size = Vector(0.039, 0.039, 0.019), color = Color(25, 25, 25, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel13"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(0.233, 0, 0.305), angle = Angle(0, -90, 15.102), size = Vector(0.286, 0.305, 0.125), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel6"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel5", pos = Vector(0, 0.8, -0.329), angle = Angle(0, 0, 16.666), size = Vector(0.071, 0.063, 0.128), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["tube2"] = { type = "Model", model = "models/items/battery.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(3.279, 0, 2.448), angle = Angle(90, 0, 0), size = Vector(0.5, 0.273, 0.485), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel5"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(6.534, 0, 2.262), angle = Angle(0, 89.678, -17.173), size = Vector(0.071, 0.071, 0.071), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel3"] = { type = "Model", model = "models/maxofs2d/hover_plate.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(2.701, 0, 2.114), angle = Angle(86.527, 180, 0), size = Vector(0.188, 0.075, 0.467), color = Color(87, 68, 72, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel2"] = { type = "Model", model = "models/maxofs2d/hover_plate.mdl", bone = "Python", rel = "uragan", pos = Vector(-0.849, 0, 2.04), angle = Angle(80, 0, 0), size = Vector(0.188, 0.075, 0.467), color = Color(87, 68, 72, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tube"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(5.422, 0, 0.794), angle = Angle(0, 90, 0), size = Vector(0.07, 0.261, 0.15), color = Color(60, 60, 60, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel1"] = { type = "Model", model = "models/maxofs2d/light_tubular.mdl", bone = "Python", rel = "uragan", pos = Vector(-0.55, 0, 1.748), angle = Angle(0, 90, -90), size = Vector(0.68, 0.68, 0.18), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel9"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(-2.118, 0, -0.964), angle = Angle(11.454, 0, 0), size = Vector(0.356, 0.059, 0.174), color = Color(75, 75, 75, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel10"] = { type = "Model", model = "models/items/boxflares.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(-3.944, 0, -3.618), angle = Angle(-19.883, 0, 0), size = Vector(0.101, 0.273, 0.642), color = Color(153, 106, 135, 255), surpresslightning = false, material = "models/props_junk/shoe001a", skin = 0, bodygroup = {} },
	["barrel12"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(1.279, 0, -0.239), angle = Angle(0, 90, 59.189), size = Vector(0.305, 0.111, 0.111), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel4"] = { type = "Model", model = "models/items/boxflares.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(-1.734, 0, 1.445), angle = Angle(0, 90, -70), size = Vector(0.029, 0.092, 0.15), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["tube3"] = { type = "Model", model = "models/props_junk/flare.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "uragan", pos = Vector(5.171, 0, 0.892), angle = Angle(90, -90, -90), size = Vector(0.564, 0.564, 0.428), color = Color(60, 60, 60, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["spinner2"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "Cylinder", rel = "spinner", pos = Vector(0, 0, 1.572), angle = Angle(-180, 0, 0), size = Vector(0.335, 0.335, 0.317), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["spinner"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(1.45, 0, 1.529), angle = Angle(-90, 0, 0), size = Vector(0.078, 0.078, 0.041), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel4"] = { type = "Model", model = "models/items/boxflares.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(-1.734, 0, 1.445), angle = Angle(0, 90, -70), size = Vector(0.029, 0.092, 0.15), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["uragan"] = { type = "Model", model = "models/items/357ammo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.559, 1.355, -2.738), angle = Angle(0, 0, 180), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel8"] = { type = "Model", model = "models/items/boxflares.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(0, 0, -0.88), angle = Angle(0, 0, 0), size = Vector(0.36, 0.245, 0.248), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel7"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(3.233, 0, -0.304), angle = Angle(-90, 90, 0), size = Vector(0.039, 0.039, 0.019), color = Color(25, 25, 25, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel13"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(-0.648, 0, 0.398), angle = Angle(0, -90, 15.102), size = Vector(0.286, 0.305, 0.125), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["tube2"] = { type = "Model", model = "models/items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(3.279, 0, 2.448), angle = Angle(90, 0, 0), size = Vector(0.5, 0.273, 0.485), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel5"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(6.534, 0, 2.18), angle = Angle(0, 89.678, -17.173), size = Vector(0.071, 0.071, 0.071), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel3"] = { type = "Model", model = "models/maxofs2d/hover_plate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(2.701, 0, 2.114), angle = Angle(86.527, 180, 0), size = Vector(0.188, 0.075, 0.467), color = Color(87, 68, 72, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel2"] = { type = "Model", model = "models/maxofs2d/hover_plate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(-0.849, 0, 2.04), angle = Angle(80, 0, 0), size = Vector(0.188, 0.075, 0.467), color = Color(87, 68, 72, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["spinner2"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "spinner", pos = Vector(0, 0, 1.572), angle = Angle(-180, 0, 0), size = Vector(0.335, 0.335, 0.317), color = Color(50, 50, 50, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel1"] = { type = "Model", model = "models/maxofs2d/light_tubular.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(-0.55, 0, 1.748), angle = Angle(0, 90, -90), size = Vector(0.68, 0.68, 0.18), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel9"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(-2.118, 0, -0.964), angle = Angle(11.454, 0, 0), size = Vector(0.356, 0.059, 0.174), color = Color(75, 75, 75, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel12"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(0.486, 0, -0.239), angle = Angle(0, 90, 59.189), size = Vector(0.305, 0.111, 0.111), color = Color(100, 100, 100, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["tube"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(5.422, 0, 0.794), angle = Angle(0, 90, 0), size = Vector(0.07, 0.261, 0.15), color = Color(60, 60, 60, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} },
	["barrel10"] = { type = "Model", model = "models/items/boxflares.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(-3.944, 0, -3.618), angle = Angle(-19.883, 0, 0), size = Vector(0.101, 0.273, 0.642), color = Color(183, 106, 135, 255), surpresslightning = false, material = "models/props_junk/shoe001a", skin = 0, bodygroup = {} },
	["tube3"] = { type = "Model", model = "models/props_junk/flare.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "uragan", pos = Vector(5.171, 0, 0.892), angle = Angle(90, -90, -90), size = Vector(0.564, 0.564, 0.428), color = Color(60, 60, 60, 255), surpresslightning = false, material = "maxofs2d/models/hover_plate", skin = 0, bodygroup = {} }
}
