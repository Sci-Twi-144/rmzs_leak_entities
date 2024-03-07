include("shared.lua")

function ENT:Initialize()
	self.Seed = math.Rand(0, 10)

	self:DrawShadow(false)
end

function ENT:OnRemove()
end

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local vector_origin = vector_origin

function ENT:Draw()
	local pos = self:GetPos()
	local color = self:GetColor()

	render.SuppressEngineLighting(true)
	render.SetBlend(0.25)
	self:DrawModel()
	render.SetBlend(1)
	render.SuppressEngineLighting(false)
	render.ModelMaterialOverride(nil)
end

function ENT:OnRemove()
	local pos = self:GetPos()
	local color = self:GetColor()

	sound.Play("ambient/fire/ignite.wav", pos, 100, 100)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 19 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 255)
		particle:SetDieTime(0.65)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(3, 4))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(color.r, color.g, color.b)
	end
	for i=0,5 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 255)
		particle:SetDieTime(0.75)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(35, 40))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(color.r, color.g, color.b)
	end
	for i=1, 45 do
		particle = emitter:Add("effects/splash2", pos)
		particle:SetDieTime(0.8)
		particle:SetColor(color.r, color.g, color.b)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(5)
		particle:SetEndSize(0)
		particle:SetStartLength(1)
		particle:SetEndLength(5)
		particle:SetVelocity(VectorRand():GetNormal() * 255)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end