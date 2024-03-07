include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.NextEmit = 0

local matGlow2 = Material("sprites/glow04_noz")
local vector_origin = vector_origin

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "ambient/energy/electric_loop.wav")
end

function ENT:Think()
	if not self:GetGasEmit() then return end
	
	self.AmbientSound:PlayEx(0.80, 250 + CurTime() % 1)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
	local pos = self:GetPos()
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 20 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 45)
		particle:SetDieTime(math.random(5))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(0, 255, 255)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 5)
end

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	if not self:GetGasEmit() then return end

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 1 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 45)
		particle:SetDieTime(0.15)
		particle:SetStartAlpha(75)
		particle:SetEndAlpha(0)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(0, 150, 150)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow2)
		render.DrawSprite(pos, 15, 15, Color(0, 150, 150))
	end
end
