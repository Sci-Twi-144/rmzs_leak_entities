include("shared.lua")

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 57

SWEP.HUD3DBone = "Base"
SWEP.HUD3DPos = Vector(5, -1, -8)
SWEP.HUD3DAng = Angle(180, 0, 0)
SWEP.HUD3DScale = 0.04

SWEP.VElements = {
	["egon_base+++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "Base", rel = "egon_base", pos = Vector(1, 3, 4), angle = Angle(140, -90, 0), size = Vector(0.017, 0.017, 0.129), color = Color(196, 234, 244, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["egon_base++++++"] = { type = "Model", model = "models/props_phx/misc/iron_beam2.mdl", bone = "Base", rel = "egon_base", pos = Vector(1.5, -4, -2), angle = Angle(-17.532, 90, 0), size = Vector(0.119, 0.119, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunstick/v_stunstick_diffuse", skin = 0, bodygroup = {} },
	["egon_base+"] = { type = "Model", model = "models/props_phx/construct/metal_wire_angle360x2.mdl", bone = "Base", rel = "egon_base", pos = Vector(10, 0.2, 0), angle = Angle(90, 0, 0), size = Vector(0.07, 0.07, 0.17), color = Color(89, 100, 99, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["egon_base++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "Base", rel = "egon_base", pos = Vector(1, 3, 4), angle = Angle(140, -90, 0), size = Vector(0.018, 0.018, 0.1), color = Color(9, 115, 0, 255), surpresslightning = false, material = "phoenix_storms/camera", skin = 1, bodygroup = {} },
	["egon_base+++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "Base", rel = "egon_base", pos = Vector(7, 0, -3.1), angle = Angle(180, 90, 0), size = Vector(0.039, 0.079, 0.054), color = Color(142, 142, 142, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["egon_base+++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "Base", rel = "egon_base", pos = Vector(1, 3, 4), angle = Angle(140, -90, 0), size = Vector(0.025, 0.025, 0.059), color = Color(188, 196, 213, 255), surpresslightning = false, material = "phoenix_storms/metal_plate", skin = 0, bodygroup = {} },
	["egon_base+++++"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "Base", rel = "egon_base", pos = Vector(-6.909, 0.2, 0), angle = Angle(90, 0, 0), size = Vector(0.07, 0.07, 0.2), color = Color(145, 152, 173, 255), surpresslightning = false, material = "phoenix_storms/cube", skin = 0, bodygroup = {} },
	["egon_base"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "Base", rel = "", pos = Vector(0.699, 1, -7.792), angle = Angle(90, -90, 0), size = Vector(0.2, 0.1, 0.1), color = Color(87, 95, 110, 255), surpresslightning = false, material = "phoenix_storms/indenttiles_1-2", skin = 0, bodygroup = {} },
	["egon_base++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "Base", rel = "egon_base", pos = Vector(7, 0, 2), angle = Angle(0, 90, 0), size = Vector(0.039, 0.079, 0.05), color = Color(142, 142, 142, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["whity2"] = { type = "Sprite", sprite = "sprites/glow04", bone = "Base", rel = "egon_base+", pos = Vector(0, 0, 0), size = { x = 15, y = 15 }, color = Color(255, 255, 255, 0), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true}
}

SWEP.WElements = {
	["egon_base+++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "egon_base", pos = Vector(1, 3, 4), angle = Angle(140, -90, 0), size = Vector(0.017, 0.017, 0.129), color = Color(196, 234, 244, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["egon_base++++++"] = { type = "Model", model = "models/props_phx/misc/iron_beam2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "egon_base", pos = Vector(1.5, -4, -2), angle = Angle(-17.532, 90, 0), size = Vector(0.119, 0.119, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunstick/v_stunstick_diffuse", skin = 0, bodygroup = {} },
	["egon_base+"] = { type = "Model", model = "models/props_phx/construct/metal_wire_angle360x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "egon_base", pos = Vector(10, 0.2, 0), angle = Angle(90, 0, 0), size = Vector(0.07, 0.07, 0.17), color = Color(89, 100, 99, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["egon_base++++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "egon_base", pos = Vector(1, 3, 4), angle = Angle(140, -90, 0), size = Vector(0.018, 0.018, 0.1), color = Color(9, 115, 0, 255), surpresslightning = false, material = "phoenix_storms/camera", skin = 1, bodygroup = {} },
	["egon_base+++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "egon_base", pos = Vector(7, 0, -3.1), angle = Angle(180, 90, 0), size = Vector(0.039, 0.079, 0.054), color = Color(142, 142, 142, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} },
	["egon_base"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9, 2, -5.6), angle = Angle(0, 0, -160), size = Vector(0.2, 0.1, 0.1), color = Color(87, 95, 110, 255), surpresslightning = false, material = "phoenix_storms/indenttiles_1-2", skin = 0, bodygroup = {} },
	["egon_base+++++"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "egon_base", pos = Vector(-6.909, 0.2, 0), angle = Angle(90, 0, 0), size = Vector(0.07, 0.07, 0.2), color = Color(145, 152, 173, 255), surpresslightning = false, material = "phoenix_storms/cube", skin = 0, bodygroup = {} },
	["egon_base+++++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "egon_base", pos = Vector(1, 3, 4), angle = Angle(140, -90, 0), size = Vector(0.025, 0.025, 0.059), color = Color(188, 196, 213, 255), surpresslightning = false, material = "phoenix_storms/metal_plate", skin = 0, bodygroup = {} },
	["egon_base++"] = { type = "Model", model = "models/props_c17/factorymachine01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "egon_base", pos = Vector(7, 0, 2), angle = Angle(0, 90, 0), size = Vector(0.039, 0.079, 0.05), color = Color(142, 142, 142, 255), surpresslightning = false, material = "phoenix_storms/future_vents", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -3), angle = Angle(0, 0, 0) },
	["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 3), angle = Angle(0, 0, 0) }
}

function SWEP:DrawHUD()
	self:DrawWeaponCrosshair()

	self:DrawHealBar()
end

local matGlow = Material("sprites/glow04_noz")
local texDownEdge = surface.GetTextureID("gui/gradient_down")
local colHealth = Color(0, 0, 0, 0)
local hlastperc = 1
local texGradDown = surface.GetTextureID("VGUI/gradient_down")
local colHealth = Color(0, 0, 0, 240)
local noheal = Material("zombiesurvival/sickness.png")
-----
function SWEP:DrawHealBar()
	local screenscale = BetterScreenScale()
	local wid, hei = 240 * screenscale, 18 * screenscale

	local size = 56
	local half_size = size / 2

	local mx = ScrW() / 2 - ( wid /2 )
	local my = ScrH() / 1920 * 1100
	
	local ent = self:GetDTEntity(10)
	
	if IsValid(ent) then
		local healed = self.Heal * (MySelf.MedicHealMul or 1)
		local health = ent:Health() + healed
		local maxhealth = ent:GetMaxHealth()
		local name = ent:GetName()

		local healthperc = math.Clamp(health / maxhealth , 0, 1)
		local healthremain = math.floor(healthperc * 100)
		
		hlastperc = Lerp(FrameTime() * (healthperc < healthremain and 8 or 1.1), hlastperc, healthperc)
		subwidth = hlastperc * wid
		
		colHealth.a = math.Clamp(colHealth.a + (hlastperc >= (healthperc - FrameTime()/8) and -1.8 or 4.6) * FrameTime(),0,0.9)

		colHealth.r = (1 - healthperc) * 180
		colHealth.g = healthperc * 180
		colHealth.b = 0

		surface.SetDrawColor(0, 0, 0, 230 * colHealth.a)
		surface.DrawRect(mx, my, wid, hei)
		
		surface.SetDrawColor(colHealth.r * 0.8, colHealth.g * 0.8, colHealth.b, 220 * colHealth.a)
		surface.SetTexture(texGradDown)
		surface.DrawTexturedRect(mx + 2, my + 1, subwidth - 4, hei - 2)
		surface.SetDrawColor(colHealth.r * 0.8, colHealth.g * 0.8, colHealth.b, 30 * colHealth.a)
		surface.DrawRect(mx + 2, my + 1, subwidth - 4, hei - 2)

		surface.SetMaterial(matGlow)
		surface.SetDrawColor(255, 255, 255, 255 * colHealth.a)
		surface.DrawTexturedRect(mx + 2 + subwidth - 6, my + 1 - hei/2, 3, hei * 2)

		draw.SimpleTextBlurry("Target Health", "ZSHUDFontTiny", mx + wid * 0.5, my + 9, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleTextBlurry("You are healing", "ZSHUDFontTiny", mx + wid * 0.5, my + 56, Color(0, 255, 255, 230 * colHealth.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleTextBlurry(name, "ZSHUDFontSmaller", mx + wid * 0.5, my + 84, Color(0, 255, 255, 230 * colHealth.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		if ent:GetStatus("sickness") or (ent:GetPhantomHealth() >= 1) then
			surface.SetMaterial(noheal)
			surface.SetDrawColor(Color(255, 50, 50, 255))
			surface.DrawTexturedRect(mx - (1/2 * size), my, size, size)
		end
		
		if 0 < healthremain then
			draw.SimpleText(healthremain.." %", "ZSHUDFontTiny", mx + wid, my, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)
		end
	end
end

local colBG = Color(16, 16, 16, 90)
local colBlue = Color(50, 50, 220, 230)
local colWhite = Color(220, 220, 220, 230)

local function DrawUberBar(self, x, y)
	local mul = self:GetResource() / self.AbilityMax
	surface.SetDrawColor(0, 0, 0, 180)
	surface.DrawRect(x + 128, y - 48, 48, 128)
	if mul < 0.15 then
		surface.SetDrawColor(255, 0, 0, 255)
	else
		surface.SetDrawColor(255 * (1 - mul), 255, 110 * mul, 220)
	end
	surface.DrawRect(x + 133, y + 75, 38, 0 - 118 * mul)


	if self:GetFullUber() or self:GetUber() then
		local sin = math.abs(math.sin(CurTime() * 2))
		local colortext = Color(100, 255 * sin, 255 * sin, 255)
		if self:GetFullUber() then
			draw.SimpleTextBlurry("F", "ZS3D2DFontSmaller", x + 152, y - 30, colortext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleTextBlurry("U", "ZS3D2DFontSmaller", x + 152, y - 0, colortext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleTextBlurry("L", "ZS3D2DFontSmaller", x + 152, y + 30, colortext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleTextBlurry("L", "ZS3D2DFontSmaller", x + 152, y + 60, colortext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleTextBlurry("U", "ZS3D2DFontSmaller", x + 152, y - 30, colortext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleTextBlurry("B", "ZS3D2DFontSmaller", x + 152, y - 0, colortext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleTextBlurry("E", "ZS3D2DFontSmaller", x + 152, y + 30, colortext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleTextBlurry("R", "ZS3D2DFontSmaller", x + 152, y + 60, colortext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local sin2 = math.abs(math.cos(CurTime() * 0.5)) / 2
		local colorspr = Color(102, 255, 237, 100 * sin2)
		self.VElements["whity2"].color = colorspr
		
		self.VElements["egon_base"].color = Color(255, 255, 255, 255)
		self.VElements["egon_base"].material = "models/props_combine/masterinterface01c"
	elseif (self.VElements["egon_base"].material ~= "phoenix_storms/indenttiles_1-2") then
		self.VElements["whity2"].color = Color(255, 255, 255, 0)
		self.VElements["egon_base"].color = Color(87, 95, 110, 255)
		self.VElements["egon_base"].material = "phoenix_storms/indenttiles_1-2"
	end
end

function SWEP:Draw2DHUD()
	local screenscale = BetterScreenScale()

	local wid, hei = 180 * screenscale, 64 * screenscale
	local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
	local spare = self.HealMULsave

	draw.RoundedBox(16, x, y, wid, hei, colBG)
	draw.SimpleTextBlurry(spare, "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 1 and colWhite or colBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:Draw3DHUD(vm, pos, ang)
	local wid, hei = 128, 72
	local x, y = wid * -0.6, hei * -0.5
	local spare = self.HealMULsave

	cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		DrawUberBar(self, x, y)
		draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
		draw.SimpleTextBlurry(spare, "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 1 and colWhite or colBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
