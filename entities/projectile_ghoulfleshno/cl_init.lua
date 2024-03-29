include("shared.lua")

ENT.NextEmit = 0

function ENT:Initialize()
	self:SetColor(Color(200, 135, 165, 255))
	self:SetMaterial("models/seagull/seagull")
end

function ENT:Draw()
	self:DrawModel()

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.025

	local pos = self:GetPos()

	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		local particle = emitter:Add("particles/smokey", pos)
		particle:SetDieTime(math.Rand(0.4, 0.5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(3, 5))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 255))
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetVelocity((self:GetVelocity():GetNormalized() * -1 + VectorRand():GetNormalized()):GetNormalized() * math.Rand(16, 48))
		particle:SetColor(200, 135, 165)

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
