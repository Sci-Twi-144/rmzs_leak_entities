include("shared.lua")
local metal, field = Material("models/weapons/rmzs/scythe/scythe_metal"), Material("models/weapons/rmzs/scythe/scythe_field")
function SWEP:PreDrawViewModel(vm)
	self.BaseClass.BaseClass.PreDrawViewModel(self, vm)
	metal:SetFloat("$emissiveblendenabled", 0)
	field:SetFloat("$emissiveblendenabled", 0)
end

function SWEP:DrawWorldModel()
	self.BaseClass.BaseClass.DrawWorldModel(self)
end

function SWEP:DrawAds()
	self:DrawGenericAbilityBar(self:GetResource(), self.ResCap, nil, "Knockdown", false, true)
end