include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self.Seed = math.Rand(0, 10)

	self:DrawShadow(false)

	self.AmbientSound = CreateSound(self, "ambient/machines/combine_shield_loop3.wav")
	self.AmbientSound:PlayEx(0.3, 150)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

local materialp = {}
materialp["$refractamount"] = 0.01
materialp["$colortint"] = "[1.0 1.3 1.9]"
materialp["$SilhouetteColor"] = "[2.1 3.5 5.0]"
materialp["$BlurAmount"] = 0.001
materialp["$SilhouetteThickness"] = 0.5
materialp["$normalmap"] = "effects/combineshield/comshieldwall"
local matRefract = CreateMaterial("forcefieldxd","Aftershock_dx9", materialp)
local matGlow = Material("models/shiny")
function ENT:DrawTranslucent()
	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride(matGlow)

	render.SetColorModulation(0.906, 0.6, 1)
	render.SetBlend(0.007)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)

	if render.SupportsPixelShaders_2_0() then
		render.UpdateRefractTexture()

		matRefract:SetFloat("$refractamount", 0.005)

		render.SetBlend(1)

		render.ModelMaterialOverride(matRefract)
		self:DrawModel()
	else
		render.SetBlend(1)
	end

	render.SetColorModulation(1, 1, 1)

	render.ModelMaterialOverride(0)
	render.SuppressEngineLighting(false)
end

