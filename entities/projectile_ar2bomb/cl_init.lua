include("shared.lua")

local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local matGlow3 = Material("effects/ar2_altfire1")
local matWhite = Material("models/debug/debugwhite")
local vector_origin = vector_origin

function ENT:Draw()
	local owner = self:GetOwner()
	if GAMEMODE.NoDrawHumanProjectilesInFPS_H and not (owner == MySelf) and not owner:ShouldDrawLocalPlayer() then return end

	local pos = self:GetPos()

	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow3)
		render.DrawSprite(pos, 25, 25, Color(255, 255, 255, 255))
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)
		local particle
		for i=0, 1 do
			particle = emitter:Add(matGlow2, pos)
			particle:SetVelocity(VectorRand() * 5)
			particle:SetDieTime(0.1)
			particle:SetStartAlpha(alt and 65 or 125)
			particle:SetEndAlpha(0)
			particle:SetStartSize(5)
			particle:SetEndSize(0)
			particle:SetRollDelta(math.Rand(-10, 10))
			particle:SetColor(255, alt and 180 or 100, 100)
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end

function ENT:OnRemove()
	local pos = self:GetPos()

	sound.Play("weapons/physcannon/energy_bounce1.wav", pos, 75, math.random(124, 135))
end

function ENT:Initialize()
end

function ENT:Think()
end
