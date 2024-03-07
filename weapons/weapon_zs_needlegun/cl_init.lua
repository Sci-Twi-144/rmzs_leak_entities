include("shared.lua")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70

SWEP.HUD3DBone = "W_Main"
SWEP.HUD3DPos = Vector(1.6, -0.2, 1)
SWEP.HUD3DAng = Angle(180, 0, 0)
SWEP.HUD3DScale = 0.015

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.IronsightsMultiplier = 0.25

function SWEP:GetViewModelPosition(pos, ang)
	if GAMEMODE.DisableScopes then return end

	if self:IsScoped() then
		return pos + ang:Up() * 256, ang
	end

	return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

function SWEP:DrawHUDBackground()
	if GAMEMODE.DisableScopes then return end

	if self:IsScoped() then
		self:DrawRegularScope()
	end
end