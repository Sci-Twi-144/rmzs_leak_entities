include("shared.lua")

DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 55
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.IronsightsMultiplier = 0.25
SWEP.HUD3DBone = "v_weapon.scout_Parent"
SWEP.HUD3DPos = Vector(-1.25, -2.75, -6)
SWEP.HUD3DAng = Angle(0, 0, 0)
SWEP.HUD3DScale = 0.017

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.VElements = {
	["body2"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(-2.431, 0, 7.743), angle = Angle(-180, 90, 0), size = Vector(0.541, 0.736, 1.307), color = Color(85, 120, 195, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(-1.833, 0, 11.97), angle = Angle(90, 0, 0), size = Vector(0.717, 0.061, 0.061), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["body3"] = { type = "Model", model = "models/props_trainstation/train001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(-2.57, 0, -5.768), angle = Angle(0, 90, 90), size = Vector(0.009, 0.016, 0.012), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["scope"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0, -5.212, -11.976), angle = Angle(0, 90, 180), size = Vector(0.368, 0.616, 0.603), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["body4"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(-5.567, 0, -7.106), angle = Angle(-90, 0, 0), size = Vector(0.009, 0.014, 0.01), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["body"] = { type = "Model", model = "models/props_c17/gravestone003a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(-2.309, 0, 0.996), angle = Angle(-90, 0, 0), size = Vector(3.167, 0.043, 0.061), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["body5"] = { type = "Model", model = "models/props_combine/breenconsole.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(-3.738, 0, 5.004), angle = Angle(0, -90, -90), size = Vector(0.096, 0.284, 0.081), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["stuff"] = { type = "Model", model = "models/props_c17/FurnitureDrawer001a_Chunk05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0.041, 0, -5.003), angle = Angle(90, 0, 0), size = Vector(0.05, 0.035, 0.05), color = Color(255, 255, 195, 255), surpresslightning = false, material = "models/props_combine/masterinterface_alert", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["body2"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-2.922, 0, 15.505), angle = Angle(-180, 90, 0), size = Vector(0.582, 0.805, 1.307), color = Color(85, 120, 195, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["body3"] = { type = "Model", model = "models/props_trainstation/train001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-2.491, 0, -2.517), angle = Angle(0, 90, 90), size = Vector(0.009, 0.016, 0.012), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["barrel"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-2.411, 0, 16.427), angle = Angle(90, 0, 0), size = Vector(0.99, 0.061, 0.061), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["scope"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.253, 0.721, -7.623), angle = Angle(-100, 0, 0), size = Vector(0.433, 0.616, 0.755), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["body4"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-6.316, 0, -2.192), angle = Angle(-90, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["body"] = { type = "Model", model = "models/props_c17/gravestone003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-2.75, 0, 8.814), angle = Angle(-90, 0, 0), size = Vector(3.167, 0.043, 0.065), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["body5"] = { type = "Model", model = "models/props_combine/breenconsole.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-3.738, 0, 12.616), angle = Angle(0, -90, -90), size = Vector(0.096, 0.419, 0.093), color = Color(85, 120, 195, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
	["stuff"] = { type = "Model", model = "models/props_c17/FurnitureDrawer001a_Chunk05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0.046, 0, -6.447), angle = Angle(90, 0, 0), size = Vector(0.05, 0.035, 0.061), color = Color(255, 255, 195, 255), surpresslightning = false, material = "models/props_combine/masterinterface_alert", skin = 0, bodygroup = {} }
}

function SWEP:DefineFireMode3D()
	if self:GetFireMode() == 0 then
		return "SUPP"
	elseif self:GetFireMode() == 1 then
		return "ATCK"
	end
end

function SWEP:DefineFireMode2D()
	if self:GetFireMode() == 0 then
		return "Support Mode"
	elseif self:GetFireMode() == 1 then
		return "Attack Mode"
	end
end

function SWEP:DrawHUD()
	self:RenderBuffProgressBar()
	self:Draw2DHUD()
	if self:GetReloadStart() then
		local max = (self:GetReloadFinish() - CurTime())
		local val = self:GetReloadFinish()
		if self.ReloadTime then
			GAMEMODE:DrawCircleEx(x, y, 17, COLOR_DARKRED, self:GetReloadFinish(), self.ReloadTime)
			local timeleft = self:GetReloadFinish() - CurTime() 
			if timeleft > 0 then
				draw.SimpleText(math.Round(timeleft, 2), "ZSHUDFontTiny", x + 90, y - 90, COLOR_GRAY, TEXT_ALIGN_LEFT)
			end
		end
	end

	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:GetViewModelPosition(pos, ang)
	if GAMEMODE.DisableScopes then return end

	if self:IsScoped() then
		return pos + ang:Up() * 256, ang
	end

	return BaseClass.GetViewModelPosition(self, pos, ang)
end

function SWEP:DrawHUDBackground()
	if GAMEMODE.DisableScopes then return end

	if self:IsScoped() then
		self:DrawFuturisticScope()
	end
end

function SWEP:Draw2DHUD()
	BaseClass.Draw2DHUD(self)

	local owner = self:GetOwner()
	if owner:IsSkillActive(SKILL_DISABLEDTARGETING) then return end

	local no_target = translate.Get("no_target")

	local player1 = self:GetSeekedPlayer()
	local screenscale = BetterScreenScale()
	surface.SetFont("ZSHUDFont")
	local text = player1:IsValidLivingHuman() and player1:Name() or no_target
	local _, nTEXH = surface.GetTextSize(text)

	local ehithp = self:GetDTInt(17) or 0
	local ehitmaxhp = self:GetDTInt(16) or 0

	local colormul = ehithp / ehitmaxhp

	local curbloodent = self:GetDTInt(18) or 0
	local maxbloodent = self:GetDTInt(19) or 0

	local regen = self:GetDTInt(20) or 0

	local red = COLOR_RED
	local green = COLOR_LIMEGREEN

	local dyncolor = Color((green.r * colormul) + (red.r * (1 - colormul)), (green.g * colormul) + (red.g * (1 - colormul)), (green.b * colormul) + (red.b * (1 - colormul)), 255)

	draw.SimpleTextBlurry(text, "ZSHUDFont", ScrW() - 218 * screenscale, ScrH() - nTEXH * 1, text ~= no_target and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)

	if ehithp and ehitmaxhp and text ~= no_target then
		draw.SimpleTextBlurry(ehithp.. " / " ..ehitmaxhp.." hp" .. (tobool(regen > 0) and (" + " .. tostring(regen) ) or ""), "ZS3D2DFontSmaller", ScrW() - 218 * screenscale, ScrH() - nTEXH * 4, dyncolor, TEXT_ALIGN_CENTER)
	end

	if curbloodent and maxbloodent and text ~= no_target then
		draw.SimpleTextBlurry(curbloodent.. " / " ..maxbloodent.." blood", "ZS3D2DFontSmaller", ScrW() - 218 * screenscale, ScrH() - nTEXH * 5, COLOR_SOFTRED, TEXT_ALIGN_CENTER)
	end
end

function SWEP:Draw3DHUD(vm, pos, ang)
	BaseClass.Draw3DHUD(self, vm, pos, ang)

	local owner = self:GetOwner()
	if owner:IsSkillActive(SKILL_DISABLEDTARGETING) then return end

	local no_target = translate.Get("no_target")

	local wid, hei = 180, 220
	local x, y = wid * 1.25, hei * -2.25

	local player1 = self:GetSeekedPlayer()
	surface.SetFont("ZS3D2DFontSmall")
	local text = player1:IsValidLivingHuman() and player1:Name() or no_target

	local ehithp = self:GetDTInt(17) or 0
	local ehitmaxhp = self:GetDTInt(16) or 0

	cam.Start3D2D(pos, ang, self.HUD3DScale / 3)
		draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x, y, text ~= no_target and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)

		if ehithp and ehitmaxhp and text ~= no_target then
			draw.SimpleTextBlurry(ehithp.. " / " ..ehitmaxhp.." hp", "ZS3D2DFontSmall", x, y /1.2, text ~= no_target and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end
