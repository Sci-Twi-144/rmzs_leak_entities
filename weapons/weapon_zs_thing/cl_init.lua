include("shared.lua")

local matSkin = Material("models/flesh")
local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
	render.SetColorModulation(0.64, 0.37, 0.39)
end

function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(1, 1, 1)
end