include("shared.lua")

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false

SWEP.HUD3DBone = "Screen_Frame"
SWEP.HUD3DPos = Vector(1.7, -0.2, 0.8)
SWEP.HUD3DAng = Angle(0, 180, 70)
SWEP.HUD3DScale = 0.015

SWEP.ViewModelBoneMods = {
	["base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {}

SWEP.WElements = {}
	
function SWEP:PostDrawViewModel(vm)
	local time = UnPredictedCurTime()
	local reloaddelta = ((self:GetReloadFinish() - time) > (time - self:GetReloadStart()) and 55 or -7) * FrameTime()

	--local reloadpos = self.VElements.gep_gunf.pos
	--reloadpos.x = math.Clamp(reloadpos.x + reloaddelta, 8.5, 23)

	self.BaseClass.PostDrawViewModel(self, vm)
end

function SWEP:SecondaryAttack()
end

function SWEP:Draw2DHUD()
end

local colBG = Color(16, 16, 16, 90)
local colReady = Color(0, 255, 0, 255)
local colUnmanaged = Color(255, 255, 255, 255)
local colManaged = Color(0, 0, 255, 255)

local colBG = Color(16, 16, 16, 90)
local colRed = Color(220, 0, 0, 230)
local colYellow = Color(220, 220, 0, 230)
local colWhite = Color(220, 220, 220, 230)
local colAmmo = Color(255, 255, 255, 230)
local function GetAmmoColor(clip, maxclip)
	if clip == 0 then
		colAmmo.r = 255 colAmmo.g = 0 colAmmo.b = 0
	else
		local sat = clip / maxclip
		colAmmo.r = 255
		colAmmo.g = sat ^ 0.3 * 255
		colAmmo.b = sat * 255
	end
end

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(1)
	end

	local clip = self:Clip1()
	local maxclip = self.Primary.ClipSize
	local spare = self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
	local dclip, dspare, dmaxclip = self:GetDisplayAmmo(clip, spare, maxclip)
	local owner = self:GetOwner()

	local pos, ang = self:GetHUD3DPos(vm)
	if pos then
		local wid, hei = 180, 64
		local x, y = wid * -0.6, hei * -0.5
		
		cam.Start3D2D(pos, ang, self.HUD3DScale / 2)

			draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
			
			if clip == 1 then
				draw.SimpleTextBlurry("READY", "ZS3D2DFontSmall", 0,0, colReady, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleTextBlurry("NOT READY", "ZS3D2DFontSmall", 0,0, COLOR_YELLOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			draw.SimpleTextBlurry(self:GetDTBool(8) and "MANAGED" or "UNMANAGED", "ZS3D2DFontSmall", 0,36, self:GetDTBool(8) and COLOR_CYAN or colUnmanaged, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			local displayspare = dmaxclip > 0 and self.Primary.DefaultClip ~= 99999
			if displayspare then
				draw.SimpleTextBlurry(dspare, dspare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFontSmall", x + wid * 0.8, y + hei * 3.4, dspare == 0 and colRed or dspare <= dmaxclip and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			GetAmmoColor(dclip, dmaxclip)
			draw.SimpleTextBlurry("/", "ZS3D2DFontSmall", x + wid * 0.45, y + hei * 3.4, colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleTextBlurry(dclip, "ZS3D2DFontSmall", x + wid * 0.3, y + hei * 3.4, colAmmo, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			local val, max = math.max(self:GetBonusTime() - CurTime(), 0), (self.BonusTime * 1/(owner.ProjectileSpeedMul or 1))
			local active = self:GetBonusTime() >= CurTime()
			local col = COLOR_YELLOW
			local linemul = 2.4
			wid = wid * 1.7

			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(x - wid * 0.18, y + hei * linemul, wid, 40)

			surface.SetDrawColor(col)
			surface.DrawOutlinedRect(x - wid * 0.18, y + hei * linemul, wid, 40)

			surface.DrawRect(x - wid * 0.18, y + (hei * linemul) + 3, (wid - 6) * math.Clamp(val / max, 0, 1), 40 - 6)

			local coltext = self:GetTumbler() and Color(255,255,255, math.abs(math.sin(CurTime() * 3)) *255) or color_white
			draw.SimpleText("Bonus:"..(active and self:GetBonus() or 0), "ZS3D2DFontSmall", x + wid * 0.3, y + hei * 2.7, coltext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

local colHUD = Color(50, 255, 50, 90)
local texGradDown = surface.GetTextureID("VGUI/gradient_down")
function SWEP:DrawHUD()
	local proj = self:GetDTEntity(0)

	if GetConVar("crosshair"):GetInt() == 1 then
		self:DrawCrosshairDot()
	end

	if not IsValid(proj) or not self:GetDTBool(8) then return end

	local ctime = proj:GetCreationTime()

	local wid, hei = 275, 24
	local x, y = 260, 90
	local w, h = ScrW(), ScrH()
	local span = proj.LifeSpan + proj.LifeSpan * (1/(self:GetOwner().ProjectileSpeedMul or 1) - 1) * 0.6

	local timeleft = ctime + span - CurTime()
	if 0 < timeleft then

		surface.SetDrawColor(5, 5, 5, 90)
		surface.DrawRect(0,0,w,h*0.05)
		surface.DrawRect(0,h*0.92,w,h*0.08)
		surface.DrawRect(x, y, wid, hei)

		surface.SetDrawColor(50, 255, 50, 90)
		surface.SetTexture(texGradDown)
		surface.DrawTexturedRect(x-1, y+2, math.min(1, timeleft / math.max(span)) * wid -3, hei -4)

		surface.SetDrawColor(50, 255, 50, 90)

		surface.DrawRect(0,h*0.07,w,2)
		surface.DrawRect(0,h*0.87,w,2)

		surface.DrawRect(w*0.10,h*0.07,2,h*0.80)
		surface.DrawRect(w*0.12,h*0.07,2,h*0.80)

		surface.DrawRect(w*0.90,h*0.07,2,h*0.80)
		surface.DrawRect(w*0.88,h*0.07,2,h*0.80)

		surface.DrawRect(w*0.22,h*0.89,w*0.56,2)
		surface.DrawOutlinedRect(w*0.25, h*0.89, w*0.5, h*0.02)

		surface.DrawCircle( w*0.5, h*0.5, 30, 50, 255, 50, 50 )
		surface.DrawRect(w*0.15,h*0.5,w*0.30,2)
		surface.DrawRect(w*0.55,h*0.5,w*0.30,2)
		surface.DrawRect(w*0.5,h*0.15,2,h*0.30)
		surface.DrawRect(w*0.5,h*0.55,2,h*0.25)

		surface.DrawOutlinedRect(x, y, wid, hei)

		draw.SimpleTextBlurry("E to detonate", "ZSHUDFontSmall", x,y+hei+16, colHUD, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

end
