include("shared.lua")

local matGlow = Material("sprites/glow04_noz")

function ENT:Draw()
	render.SetColorModulation(1, 0.608, 0)
	--self:DrawModel()
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
		particle:SetStartSize(6)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(255, 210, 110)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function ENT:Initialize()
	self:SetModelScale(0.3, 0)
	self:DrawShadow(false)
end
