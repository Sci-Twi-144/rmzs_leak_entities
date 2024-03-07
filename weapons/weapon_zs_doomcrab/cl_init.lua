include("shared.lua")

SWEP.PrintName = "Doom Crab"
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
	GAMEMODE:DrawCircleEx(x, y, 17, COLOR_DARKRED, self:GetTime(), self:GetAbstractNumber())
	GAMEMODE:DrawCircleEx(x, y, 22, COLOR_GREEN, self:GetCooldown(), self:GetMaxCooldown())

	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end