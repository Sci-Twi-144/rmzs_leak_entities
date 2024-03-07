include("shared.lua")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.ShowWorldModel = false

SWEP.IronSightsPos = Vector(-6.35, 5, 1.7)

SWEP.VMPos = Vector(0, -3, -1)
SWEP.VMAng = Vector(2, 1, -6)

SWEP.VElements = {}
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-10, 0, 0), angle = Angle(0, 0, 0) }
}

local ghostlerp = 0
function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 0.15)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 1)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -35 * ghostlerp)
	end

	if self.VMAng and self.VMPos then
		ang:RotateAroundAxis(ang:Right(), self.VMAng.x) 
		ang:RotateAroundAxis(ang:Up(), self.VMAng.y)
		ang:RotateAroundAxis(ang:Forward(), self.VMAng.z)

		pos:Add(ang:Right() * (self.VMPos.x))
		pos:Add(ang:Forward() * (self.VMPos.y))
		pos:Add(ang:Up() * (self.VMPos.z))
	end

	return pos, ang
end

SWEP.HUD3DBone = "v_weapon.mac10_bolt"
SWEP.HUD3DPos = Vector(-1.45, 1.25, 0)
SWEP.HUD3DAng = Angle(0, 0, 0)
SWEP.HUD3DScale = 0.015

SWEP.HUD3DBone2 = "v_weapon.mac10_bolt"
SWEP.HUD3DPos2 = Vector(-1.75, -1.25, 0)
SWEP.HUD3DAng2 = Angle(0, 180, 0)

function SWEP:GetHUD3DPos2(vm)
	local bone = vm:LookupBone(self.HUD3DBone2)
	if not bone then return end

	local m = vm:GetBoneMatrix(bone)
	if not m then return end

	local pos, ang = m:GetTranslation(), m:GetAngles()

	if self.ViewModelFlip1 then
		ang.r = -ang.r
	end

	local offset = self.HUD3DPos2
	local aoffset = self.HUD3DAng2

	pos = pos + ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z

	if aoffset.yaw ~= 0 then ang:RotateAroundAxis(ang:Up(), aoffset.yaw) end
	if aoffset.pitch ~= 0 then ang:RotateAroundAxis(ang:Right(), aoffset.pitch) end
	if aoffset.roll ~= 0 then ang:RotateAroundAxis(ang:Forward(), aoffset.roll) end

	return pos, ang
end

SWEP.SwapGunAmmo = false

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(1)
	end

	-- Both must have it!
	if self.HUD3DPos and self.HUD3DPos2 and GAMEMODE:ShouldDraw3DWeaponHUD() then
		local vm1 = self:GetOwner():GetViewModel(0)
		local vm2 = self:GetOwner():GetViewModel(1)

	
		if IsValid(vm1) then
			local pos, ang = self:GetHUD3DPos(vm1)
			if pos then
				self:Draw3DHUD(vm1, pos, ang, self.SwapGunAmmo and self:Clip2() or self:Clip1())
			end
		end
		
		if IsValid(vm2) then
			local pos2, ang2 = self:GetHUD3DPos2(vm2)
			if pos2 then
				self:Draw3DHUD(vm2, pos2, ang2, self.SwapGunAmmo and self:Clip1() or self:Clip2())
			end
		end
	end
end

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

function SWEP:Draw3DHUD(vm, pos, ang, clip)
	local wid, hei = 180, 200
	local x, y = wid * -0.6, hei * -0.5
	local adjust_size = self.CantSwitchFireModes and y or y * 1.18
	local spare = self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
	local maxclip = self.Primary.ClipSize

	local dclip, dspare, dmaxclip = self:GetDisplayAmmo(clip, spare, maxclip)

	cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)

		local displayspare = dmaxclip > 0 and self.Primary.DefaultClip ~= 99999
		if displayspare then
			draw.SimpleTextBlurry(dspare, dspare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.75, dspare == 0 and colRed or dspare <= dmaxclip and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if not self.CantSwitchFireModes then
			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(x, y + hei * 0.49, wid, 32)
			draw.SimpleTextBlurry(self:DefineFireMode3D() or "", "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		adjust_size = (not self.CantSwitchFireModes and 0.24) or 0.3
		GetAmmoColor(dclip, dmaxclip)
		draw.SimpleTextBlurry(dclip, dclip >= 100 and "ZS3D2DFont" or "ZS3D2DFontBig", x + wid * 0.5, y + hei * (displayspare and adjust_size or 0.5), colAmmo, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function SWEP:Draw2DHUD()
	local screenscale = BetterScreenScale()

	local wid, hei = 280 * screenscale, 64 * screenscale
	local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
	local clip = self.SwapGunAmmo and self:Clip2() or self:Clip1()
	local clip2 = self.SwapGunAmmo and self:Clip1() or self:Clip2()
	local spare = self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
	local maxclip = self.Primary.ClipSize

	local dclip, dspare, dmaxclip = self:GetDisplayAmmo(clip, spare, maxclip)

	draw.RoundedBox(16, x, y, wid, hei, colBG)
	if not self.CantSwitchFireModes then
	--	surface.DrawRect( x + wid * 0.25, y + hei * -0.36, wid * 0.5, 24)
		draw.SimpleTextBlurry(self:DefineFireMode2D() or "", "ZSHUDFontSmall", x + wid * 0.5, y + hei * 1.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local displayspare = dmaxclip > 0 and self.Primary.DefaultClip ~= 99999
	if displayspare then
		draw.SimpleTextBlurry(dspare, dspare >= 1000 and "ZSHUDFontSmall" or "ZSHUDFont", x + wid * 0.75, y + hei * 0.5, dspare == 0 and colRed or dspare <= dmaxclip and colYellow or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	GetAmmoColor(dclip, dmaxclip)
	draw.SimpleTextBlurry(dclip, dclip >= 100 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * (displayspare and 0.45 or 0.8), y + hei * 0.5, colAmmo, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local dclip_s, _, dmaxclip_s = self:GetDisplayAmmo2(clip2, spare, maxclip)
	GetAmmoColor(dclip_s, dmaxclip_s)

	draw.SimpleTextBlurry(dclip_s, dclip_s >= 100 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * (displayspare and 0.15 or 0.4), y + hei * 0.5, colAmmo, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:GetDisplayAmmo2(clip, spare, maxclip)
	if self.RequiredClip ~= 1 then
		clip = math.floor(clip / self.RequiredClip)
		spare = math.floor(spare / self.RequiredClip)
		maxclip = math.ceil(maxclip / self.RequiredClip)
	end

	if self.AmmoUse then
		clip = math.floor(clip / self.AmmoUse)
		spare = math.floor(spare / self.AmmoUse)
		maxclip = math.ceil(maxclip / self.AmmoUse)
	end

	return clip, spare, maxclip
end

function SWEP:ViewModelDrawn()
	self:Anim_ViewModelDrawn()
	self:Anim_ViewModelDrawn(true)
end

function SWEP:DefineFireMode3D()
	if self:GetFireMode() == 0 then
		return "SEMI"
	elseif self:GetFireMode() == 1 then
		return "AUTO"
	end
end

function SWEP:DefineFireMode2D()
	if self:GetFireMode() == 0 then
		return "Semi-Auto"
	elseif self:GetFireMode() == 1 then
		return "Automatic"
	end
end