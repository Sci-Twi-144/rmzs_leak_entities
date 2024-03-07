include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
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
function ENT:Draw()
	if MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN and not ShouldVisibleDraw(self:GetPos()) then
		local percentage = math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1)
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 270)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Forward(), 270)
		local vPos = self:GetPos()
		local vOffset = self:GetForward() * self:OBBMaxs().x
		local name
		local owner = self:GetObjectOwner()
		if owner:IsValidHuman() then
			name = owner:Name()
		end

		--self:DrawModel()

		ang:RotateAroundAxis(ang:Right(), 180)

		cam.Start3D2D(vPos - vOffset, ang, 0.05)
			self:Draw3DHealthBar(percentage, name)
		cam.End3D2D()
	--else
	--	self:DrawModel()
	end
	
	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride(matGlow)

	render.SetColorModulation(0.1, 0.7, 0.9)
	render.SetBlend(0.01 + math.max(0, math.cos(CurTime())) ^ 4 * 0.05)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)

	if render.SupportsPixelShaders_2_0() then
		render.UpdateRefractTexture()

		matRefract:SetFloat("$refractamount", 0.001)

		render.SetBlend(1)

		render.ModelMaterialOverride(matRefract)
		self:DrawModel()
	else
		render.SetBlend(1)
	end

	render.ModelMaterialOverride(0)
	render.SuppressEngineLighting(false)
end