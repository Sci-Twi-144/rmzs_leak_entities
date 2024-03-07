include("shared.lua")

local matGlow = Material("sprites/glow04_noz")
local matTrail = Material("trails/electric")
local colTrail = Color(70, 255, 255)

ENT.EffectWall = 1
function ENT:Draw()
	self.EffectWall = self.EffectWall + FrameTime() * 1

	render.SetColorModulation(0, 0, 1)
	render.ModelMaterialOverride(matRefract)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)

	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 1 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.4)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(20 / self.EffectWall)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(110, 210, 255)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	render.SetMaterial(matTrail)
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i+1] then
			colTrail.a = 255 - 255 * (i/#self.TrailPositions)

			render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 3, 1, 0, colTrail)
		end
	end
end

function ENT:Initialize()
	self:SetModelScale(0.3, 0)
	self:DrawShadow(false)
end

function ENT:Initialize()
	self.Trailing = CurTime() + 0.25
	self.TrailPositions = {}
end

function ENT:Think()
	table.insert(self.TrailPositions, 1, self:GetPos())
	if self.TrailPositions[24] then
		table.remove(self.TrailPositions, 24)
	end

	local dist = 0
	local mypos = self:GetPos()
	for i=1, #self.TrailPositions do
		if self.TrailPositions[i]:DistToSqr(mypos) > dist then
			self:SetRenderBoundsWS(self.TrailPositions[i], mypos, Vector(24, 24, 24))
			dist = self.TrailPositions[i]:DistToSqr(mypos)
		end
	end
end
