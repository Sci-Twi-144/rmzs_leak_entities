include("shared.lua")

local render_SetBlend = render.SetBlend
local render_SetColorModulation = render.SetColorModulation

function SWEP:PreDrawViewModel(vm)
	render_SetBlend(0.55)
	render_SetColorModulation(0.1, 0.1, 0.1)
end

function SWEP:PostDrawViewModel(vm)
	render_SetBlend(1)
	render_SetColorModulation(1, 1, 1)
end
