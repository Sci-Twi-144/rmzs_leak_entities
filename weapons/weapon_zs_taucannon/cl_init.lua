include("shared.lua")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
	
SWEP.HUD3DBone = "V_TauCannon_Ref"
SWEP.HUD3DPos = Vector(2, 8, 5.5)
SWEP.HUD3DAng = Angle(180, -10, -110)
SWEP.HUD3DScale = 0.025

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.VElements = {}

SWEP.ViewModelBoneMods = {
	["CylinderTurn"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}
	
local colBG = Color(16, 16, 16, 90)
local colWhite = Color(220, 220, 220, 230)
local colRed = Color(255, 0, 0, 230)
function SWEP:DoSpin()
	self.SpinAng = self.SpinAng or 0
	self.SpinSpeed = self.SpinSpeed or 10
		
	if self.SpinAng > 7200 then
		self.SpinAng = -7200
	end
	
	self.SpinAng = self.SpinAng - self.SpinSpeed

	if self.SpinSpeed > 0 then
		self.SpinSpeed = self.SpinSpeed * 0.99
	elseif self.SpinSpeed < 0 then
		self.SpinSpeed = 0
	end
	self.ViewModelBoneMods["CylinderTurn"].angle = Angle(self.SpinAng, 0, 0)
end

function SWEP:Draw2DHUD()
	local wid, hei = 230 * BetterScreenScale(), 60 * BetterScreenScale()
	local x, y = ScrW() - wid - BetterScreenScale() * 128, ScrH() - hei - BetterScreenScale() * 90
	local spare = self:GetPrimaryAmmoCountNoClip()


	local longdiv = self:GetChargePower()
	local textheight = 30
	local texty = y + hei * 1
	local textlongwid = math.max(wid * longdiv - 8, 0)

	surface.SetDrawColor(16, 16, 16, 255)
	surface.DrawRect(x, y + hei * 1, wid, 30)
	surface.SetDrawColor(1 * self:GetChargePower() * 255, 255 / self:GetChargePower() / 8, 0, 255)
	surface.DrawRect(x, y + hei * 1, wid * self:GetChargePower(), 30)
		if self:GetChargePower() >= 0.01 then
			if (self:GetHolding() and self:GetCharging()) or (not self:GetHeatState() == 0 and self:GetNextPrimaryFire()>CurTime()-0.1) then
				draw.SimpleText("CHARGING", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if self:GetHolding() and self:GetCharging() and self:GetChargePower()>0.5 then
					draw.SimpleText("C", "zsdeathnoticecs", x + wid -24, texty + hei * 0.475, Color(math.abs(math.sin(CurTime()*8))*255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			elseif self:GetHeatState() == 0 then
				draw.SimpleText("OVERHEAT", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, COLOR_YELLOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				if self:GetHeatState() == 1 then
					draw.SimpleText("HEAT", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, COLOR_YELLOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				if self:GetHeatState() == 2 then
					draw.SimpleText("VENTING", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		else
			draw.SimpleText("READY", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

	local timeleft = self:GetNextReload() - CurTime() 
	if timeleft > 0 then
		draw.SimpleText(math.Round(timeleft, 2), "ZSHUDFontSmall", x + wid/2,  texty + hei * 0.7, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.RoundedBox(0, x, y, wid, hei, colBG)
	draw.SimpleTextBlurry(spare, spare >= 100 and "ZS3D2DFontSmall" or "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:Draw3DHUD(vm, pos, ang)
	local wid, hei = 220, 60
	local x, y = wid * -0.6, hei * -0.6
	local spare = self:GetPrimaryAmmoCountNoClip()

	local longdiv = self:GetChargePower()
	local textheight = 30
	local texty = y + hei * 1
	local textlongwid = math.max(wid * longdiv - 8, 0)

	cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		surface.SetDrawColor(16, 16, 16, 255)
		surface.DrawRect(x, y + hei * 1, wid, 30)
		surface.SetDrawColor(1 * self:GetChargePower() * 255, 255 / self:GetChargePower() / 8, 0, 255)
		surface.DrawRect(x, y + hei * 1, wid * self:GetChargePower(), 30)
		
		if self:GetChargePower() >= 0.01 then
			if (self:GetHolding() and self:GetCharging()) or (not self:GetHeatState() == 0 and self:GetNextPrimaryFire()>CurTime()-0.1) then
				draw.SimpleText("CHARGING", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if self:GetHolding() and self:GetCharging() and self:GetChargePower()>0.5 then
					draw.SimpleText("C", "zsdeathnoticecs", x + wid -24, texty + hei * 0.475, Color(math.abs(math.sin(CurTime()*8))*255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			elseif self:GetHeatState() == 0 then
				draw.SimpleText("OVERHEAT", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, COLOR_YELLOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				if self:GetHeatState() == 1 then
					draw.SimpleText("HEAT", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, COLOR_YELLOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				if self:GetHeatState() == 2 then
					draw.SimpleText("VENTING", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		else
			draw.SimpleText("READY", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local timeleft = self:GetNextReload() - CurTime() 
		if timeleft > 0 then
			draw.SimpleText(math.Round(timeleft, 2), "ZSHUDFontSmall", x + wid/2,  texty + hei * 0.7, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		draw.RoundedBoxEx(0, x, y, wid, hei, colBG, true, false, true, false)
		draw.SimpleText(spare, spare >= 100 and "ZS3D2DFont" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function SWEP:DrawHUD()
	self:DrawWeaponCrosshair()

	if GAMEMODE:ShouldDraw2DWeaponHUD() then
		self:Draw2DHUD()
	end
end