include("shared.lua")

local matTrail = Material("trails/physbeam")
local colTrail = Color(140, 190, 250)
local matGlow = Material("sprites/light_glow02_add")
local matWhite = Material("models/debug/debugwhite")
local vector_origin = vector_origin

function ENT:Draw()
	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(0.5, 0.7, 1)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)

	if self:GetVelocity():LengthSqr() > 100 then
		self:SetAngles(self:GetVelocity():Angle())

		render.SetMaterial(matGlow)
		render.DrawSprite(self:GetPos(), 11, 11, Color(140, 190, 250))
	end

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			colTrail.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 3, 1, 0, colTrail)
		end
	end
end

function ENT:Initialize()
	self.Trailing = CurTime() + 0.15
	self.TrailPositions = {}
end

function ENT:Think()
	table.insert(self.TrailPositions, 1, self:GetPos())
	if self.TrailPositions[1] then
		table.remove(self.TrailPositions, 12)
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
