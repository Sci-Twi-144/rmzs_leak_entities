include("shared.lua")

local matTrail = Material("trails/physbeam")
local colTrail = Color(0, 255, 255)
local matGlow = Material("sprites/light_glow02_add")
local vector_origin = vector_origin
local matWhite = Material("models/debug/debugwhite")

function ENT:Draw()
	local owner = self:GetOwner()
	render.SetBlend(0.4)
	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(0, 1, 1)
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)
	render.SetBlend(1)

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			colTrail.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 2500, 1, 0, colTrail)
		end
	end
end


function ENT:Initialize()
	self.Trailing = CurTime() + 0.25
	self.TrailPositions = {}
end

function ENT:Think()
	if self:GetVelocity() == vector_origin and self.Trailing < CurTime() then
		function self:Draw() self.Entity:DrawModel() end
		function self:Think() end
	else
		table.insert(self.TrailPositions, 1, self:GetPos())
		if self.TrailPositions[24] then
			table.remove(self.TrailPositions, 24)
		end

		local dist = 0
		local mypos = self:GetPos()
		for i=1, #self.TrailPositions do
			if self.TrailPositions[i]:DistToSqr(mypos) > dist then
				self:SetRenderBoundsWS(self.TrailPositions[i], mypos, Vector(16, 16, 16))
				dist = self.TrailPositions[i]:DistToSqr(mypos)
			end
		end
	end
end
