include("shared.lua")
SWEP.ViewModelFOV = 60
SWEP.DrawCrosshair = false

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:PreDrawViewModel(vm)
	self:GetOwner():CallZombieFunction0("PrePlayerDraw")
end

function SWEP:PostDrawViewModel(vm)
	self:GetOwner():CallZombieFunction0("PostPlayerDraw")
end

function SWEP:DrawAds()
	self:DrawGenericAbilityBar(self:GetResource(), self.ResCap, col, "Chemical Buff", false, true, false)
end