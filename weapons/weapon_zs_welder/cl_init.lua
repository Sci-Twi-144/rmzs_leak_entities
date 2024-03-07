include("shared.lua")

SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false

SWEP.VElements = {
	--["base"] =  { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1, 1.5, -5), angle = Angle(110, 0, 0), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/concrete0", skin = 0, bodygroup = {} },
	["4"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.4, 2.2, -4), angle = Angle(175, 10, 15), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--	["5"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12, 1.25, -1), angle = Angle(-90, 0, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--	["6"] = { type = "Model", model = "models/props_combine/plazafallingmonitor.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 2, -0.5), angle = Angle(-17.251, 153.126, -8.652), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["9"] = { type = "Model", model = "models/props_combine/suit_charger001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -3.8), angle = Angle(0, -90, -90), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 3, -1.5), angle = Angle(90, 90, 90), size = Vector(0.045, 0.02, 0.045), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8a"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, -1, -0.5), angle = Angle(-90, 90, 90), size = Vector(0.045, 0.02, 0.045), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["10"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 0.5, -3), angle = Angle(0, 90, -90), size = Vector(0.061, 0.041, 0.081), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["11"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 2.5, 1), angle = Angle(0, -90, 90), size = Vector(0.061, 0.041, 0.061), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["0"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16, 1.25, -3), angle = Angle(90, 90, 0), size = Vector(0.404, 0.454, 0.404), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["4"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.4, 2.2, -4), angle = Angle(175, 10, 15), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--	["5"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12, 1.25, -1), angle = Angle(-90, 0, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["9"] = { type = "Model", model = "models/props_combine/suit_charger001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -3.8), angle = Angle(0, -90, -90), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 3, -1.5), angle = Angle(90, 90, 90), size = Vector(0.045, 0.02, 0.045), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8a"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, -0.3, -0.5), angle = Angle(-90, 90, 90), size = Vector(0.045, 0.02, 0.045), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["10"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 0.5, -3), angle = Angle(0, 90, -90), size = Vector(0.061, 0.041, 0.081), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["11"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 2.5, 1), angle = Angle(0, -90, 90), size = Vector(0.061, 0.041, 0.061), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["0"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16, 1.25, -3), angle = Angle(90, 90, 0), size = Vector(0.404, 0.454, 0.404), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.HUD3DBone = "ValveBiped.Bip01_R_Hand"
SWEP.HUD3DPos = Vector(1, 1.5, -5)
SWEP.HUD3DAng = Angle(0, 90, -110)
SWEP.HUD3DScale = 0.007

local colBG = Color(16, 16, 16, 90)
local colRed = Color(220, 0, 0, 230)
local colWhite = Color(220, 220, 220, 230)
function SWEP:Draw3DHUD(vm, pos, ang)
	local wid, hei = 180, 200
	local x, y = wid * -0.6, hei * -0.5
	local spare = self:GetPrimaryAmmoCountNoClip()

	cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		draw.RoundedBox(32, x-270, y-60, wid+512, hei+256, Color(16, 16, 16, 250))
		
		local text = "Uknown"
		local color = Color(255,0,0)

		local owner = self:GetOwner()
		local tr = owner:CompensatedMeleeTrace(self.RepairRange, 1, nil, nil, false, true)
		local ent = tr.Entity

		if tr.Hit and ent and ent:IsValid() and tr.HitPos:Distance(tr.StartPos) <= self.RepairRange then
			if ent:IsNailed() then
				local mul = ent:GetBarricadeHealth() / ent:GetMaxBarricadeHealth()
				local tCol = Color(255 - 255 * mul,255 * mul,0)
				local reps = math.Round(ent:GetBarricadeRepairs())

				draw.SimpleTextBlurry("Prop:", "ZS3D2DFont", x + wid * 0.4, y + hei * 0, COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextBlurry(tostring(math.Round(ent:GetBarricadeHealth())) .. "/" .. tostring(math.Round(ent:GetMaxBarricadeHealth()))
				, "ZS3D2DFontBig", x + wid * 0.4, y + hei * 0 + 130, tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextBlurry(tostring(reps), "ZS3D2DFontBig", x + wid * 0.4, y + hei * 0 + 260, reps == 0 and Color(255,0,0) or COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then
				draw.SimpleTextBlurry("Error!", "ZS3D2DFontBig", x + wid * 0.4, y + hei * 0.5, math.sin(CurTime() * 6) > 0 and Color(255,0,0) or Color(229,240,24), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif ent.GetObjectHealth and ent.GetMaxObjectHealth then
				local mul = ent:GetObjectHealth() / ent:GetMaxObjectHealth()
				local tCol = Color(255 - 255 * mul,255 * mul,0)
				draw.SimpleTextBlurry("Deployable:", "ZS3D2DFont", x + wid * 0.4, y + hei * 0, tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextBlurry(tostring(math.Round(ent:GetObjectHealth())) .. "/" .. tostring(math.Round(ent:GetMaxObjectHealth()))
				, "ZS3D2DFontBig", x + wid * 0.4, y + hei * 0 + 130, tCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if ent:GetClass() == "prop_aegisboard" then
					if math.sin(CurTime() * 6) > 0 then
						draw.SimpleTextBlurry("Incompatible", "ZS3D2DFont", x + wid * 0.4, y + hei * 0 + 260, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			else
				draw.SimpleTextBlurry("Unknown", "ZS3D2DFontBig", x + wid * 0.4, y + hei * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		else
			draw.SimpleTextBlurry("Unknown", "ZS3D2DFontBig", x + wid * 0.4, y + hei * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		draw.SimpleText(spare, spare >= 100 and "ZS3D2DFont" or "ZS3D2DFont", x + wid * -1, y + hei * 1.8, spare == 0 and colRed or COLOR_YELLOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleTextBlurry("Ammo", "ZS3D2DFont", x + wid * 0.5, y + hei * 1.8, COLOR_YELLOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function SWEP:Draw2DHUD()
	local screenscale = BetterScreenScale()

	local wid, hei = 180 * screenscale, 64 * screenscale
	local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
	local spare = self:GetPrimaryAmmoCountNoClip()

	draw.RoundedBox(16, x, y, wid, hei, colBG)

	draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local ghostlerp = 0
function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)

	if self:GetOwner():GetBarricadeGhosting() then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 4)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 5)
	end

	if ghostlerp > 0 then
		pos = pos + 3.5 * ghostlerp * ang:Up()
		ang:RotateAroundAxis(ang:Right(), -30 * ghostlerp)
	end

	return pos, ang
end

function SWEP:DrawHUD()
	self:DrawCrosshairDot()

	if GAMEMODE:ShouldDraw2DWeaponHUD() then
		self:Draw2DHUD()
	end
end