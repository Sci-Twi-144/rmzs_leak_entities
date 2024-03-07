include("shared.lua")

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

function SWEP:DrawHUD()
	self:DrawAds()

	GAMEMODE:DrawCircleEx(x, y, 17, COLOR_DARKRED, self:GetEatEndTime(), self:GetFoodEatTime())

	if GetConVar("crosshair"):GetInt() ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawAds()
end

--[[function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)
	local eattime = self:GetEatEndTime()
	if eattime == 0 then return end

	local delta = math.Clamp((CurTime() - self:GetEatStartTime()) / self:GetFoodEatTime(), 0, 1)
	if delta > 0 then
		local lerp = math.sin(6 * math.pi * delta)
		lerp = math.abs(lerp)

		local Offset = self.EatViewOffset

		if self.EatViewAngles then
			ang = Angle(ang.p, ang.y, ang.r)
			ang:RotateAroundAxis(ang:Right(), self.EatViewAngles.x * lerp)
			ang:RotateAroundAxis(ang:Up(), self.EatViewAngles.y * lerp)
			ang:RotateAroundAxis(ang:Forward(), self.EatViewAngles.z * lerp)
		end

		pos = pos + Offset.x * lerp * ang:Right() + Offset.y * lerp * ang:Forward() + Offset.z * lerp * ang:Up()
	end

	return pos, ang
end]]
