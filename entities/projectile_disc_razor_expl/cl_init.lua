include("shared.lua")

local matWhite = Material("models/debug/debugwhite")
local matGlow = Material("sprites/light_glow02_add")

function ENT:Draw()

	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(1, 0.2, 0.1)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)

	if self:GetVelocity():LengthSqr() > 100 then
		self:SetAngles(self:GetVelocity():Angle())

		render.SetMaterial(matGlow)

		local glowcol = Color(240, 25, 10)

		render.DrawSprite(self:GetPos(), 15, 3, glowcol)
		render.DrawSprite(self:GetPos(), 3, 15, glowcol)
	end
end

function ENT:Initialize()
end

function ENT:Think()
end
