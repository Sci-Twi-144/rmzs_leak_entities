include("shared.lua")

SWEP.ViewModelFOV = 70
SWEP.DrawCrosshair = false

function SWEP:DrawWorldModel()
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

function SWEP:DrawHUD()
	self:DrawAds()

	GAMEMODE:DrawCircleEx(x, y, 17, COLOR_DARKRED, self:GetTime(), self:GetAbstractNumber())
	GAMEMODE:DrawCircleEx(x, y, 22, COLOR_GREEN, self:GetCooldown(), self:GetMaxCooldown())

	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawAds()
end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end
