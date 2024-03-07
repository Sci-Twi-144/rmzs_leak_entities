include("shared.lua")

SWEP.ViewModelFOV = 75

SWEP.ForceHideWeapon = false

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

	local screenscale = BetterScreenScale()

	surface.SetFont("ZSHUDFont")
	local nails = self:GetPrimaryAmmoCount()
	local text = translate.Format("nails_x", nails)
	local text2 = (self:GetFireMode() == 0) and "Normal" or "Force"
	local text_nails = (translate.Get("idesc_hammer_nail_special"))
	local text_prop = (translate.Get("idesc_hammer_prop_special"))
	local nTEXW, nTEXH = surface.GetTextSize(text)
	local aTEXW = surface.GetTextSize(text_prop)
	local adj = self.IsBranch and 0.5 or 0

	if self.IsBranch then
		local ammo = math.min(math.max(0, self:GetOwner():GetAmmoCount("pulse")), 999)
		local atext = translate.Format("hammerammo_x", ammo)
		draw.SimpleTextBlurry(atext, "ZSHUDFontSmall", ScrW() - aTEXW * 0.3 - 32 * screenscale, ScrH() - nTEXH * 2.1, ammo > 2 and COLOR_CYAN or COLOR_RED, TEXT_ALIGN_CENTER)
	end

	draw.SimpleTextBlurry(text, "ZSHUDFont", ScrW() - aTEXW * 0.3 - 32 * screenscale, ScrH() - nTEXH * 1.5, nails > 0 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)

	if GetConVar("zs_newbiemode"):GetInt() == 1 then
		draw.SimpleTextBlurry(text_prop, "ZSHUDFontSmall", ScrW() - aTEXW * 0.3 - 32 * screenscale, ScrH() - nTEXH * (2.2 + adj), nails > 0 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)
		draw.SimpleTextBlurry(text_nails, "ZSHUDFontSmall", ScrW() - aTEXW * 0.3 - 32 * screenscale, ScrH() - nTEXH * (3 + adj), nails > 0 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)
	end

	if MySelf:IsSkillActive(SKILL_HAMMEREDTTM) then
		draw.SimpleTextBlurry(text2, "ZSHUDFontSmall", ScrW() - aTEXW * 0.3 - 32 * screenscale, ScrH() - nTEXH * 0.7, (self:GetFireMode() == 0) and (nails > 0 and COLOR_LIMEGREEN or COLOR_YELLOW) or (nails > 0 and COLOR_LIMEGREEN or COLOR_YELLOW), TEXT_ALIGN_CENTER)
	end

	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end 