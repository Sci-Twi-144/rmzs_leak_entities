include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.DamageEffect = 5.0
ENT.Shattering=false

local matrix=Matrix()
matrix:SetScale( Vector(1,15,1))
	
function ENT:Initialize()
	self.Seed = math.Rand(0, 10)
	self:EnableMatrix( "RenderMultiply", matrix )
	self:DrawShadow(false)
end

local material = {}
material["$refractamount"] = 0.01
material["$colortint"] = "[0.1 1.3 1.9]"
material["$SilhouetteColor"] = "[2.1 3.5 5.0]"
material["$BlurAmount"] = 0.001
material["$SilhouetteThickness"] = 0.5
material["$normalmap"] = "effects/combineshield/comshieldwall"
local matRefract = CreateMaterial("forcefieldxd","Aftershock_dx9", material)
local matGlow = Material("models/shiny")
function ENT:DrawTranslucent()
	if self:GetLastDamaged() + self.DamageEffect>CurTime() then
		self.Shattering=true
		local rand=math.Rand(0.95,1.05)
		matrix:SetScale(Vector(rand,15,rand))
		self:EnableMatrix( "RenderMultiply", matrix )
	elseif self.Shattering then
		self.Shattering=false
		matrix:SetScale(Vector(1,15,1))
		self:EnableMatrix( "RenderMultiply", matrix )		
	end
	
	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride(matGlow)

	render.SetColorModulation(0.1, 0.7, 0.9)
	render.SetBlend(0.01 + math.max(0, math.cos(CurTime())) ^ 4 * 0.01)
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

	render.ModelMaterialOverride(0)
	render.SuppressEngineLighting(false)
end