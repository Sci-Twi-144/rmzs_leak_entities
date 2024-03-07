include("shared.lua")
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local vector_origin = vector_origin

function ENT:Draw()
	local pos = self:GetPos()
	local color = self:GetColor()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 2 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 25)
		particle:SetDieTime(0.1)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(3)
		particle:SetEndSize(20)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(color.r, color.g, color.b)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, 20, 20, self:GetColor())
		render.SetMaterial(matGlow2)
		render.DrawSprite(pos, 25, 25, Color(color.r + 20, color.g + 20, color.b + 20))
		render.DrawSprite(pos, 25, 25, Color(210, 210, 210, 255))
	end

	render.SuppressEngineLighting(true)
	render.SetBlend(0.2)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.ModelMaterialOverride(nil)
end

function ENT:OnRemove()
	local pos = self:GetPos()
	local color = self:GetColor()

	sound.Play("weapons/physcannon/energy_bounce1.wav", pos, 75, math.random(75, 80))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 19 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 25)
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(3, 4))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(color.r, color.g, color.b)
	end
	for i=0,5 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(35, 40))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(color.r + 20, color.g + 20, color.b + 20)
	end
	for i=1, 45 do
		particle = emitter:Add("effects/splash2", pos)
		particle:SetDieTime(0.6)
		particle:SetColor(color.r, color.g, color.b)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(5)
		particle:SetEndSize(0)
		particle:SetStartLength(1)
		particle:SetEndLength(5)
		particle:SetVelocity(VectorRand():GetNormal() * 50)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end