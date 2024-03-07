include("shared.lua")

function SWEP:DrawAds()
	GAMEMODE:DrawCircleEx(x, y, 17, COLOR_DARKRED, self:GetNextPrimaryFire(), self:GetMaxCooldown())
end