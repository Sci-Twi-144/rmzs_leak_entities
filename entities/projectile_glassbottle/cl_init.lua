include("shared.lua")

local matGlow = Material("sprites/light_glow02_add")

function ENT:Draw()
	local owner = self:GetOwner()
	if GAMEMODE.NoDrawHumanProjectilesInFPS_H and not (owner == MySelf) and not owner:ShouldDrawLocalPlayer() then return end
	self:DrawModel()
end

function ENT:OnRemove()
	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 15 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 175)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1.2)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(255, 255, 255)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end