function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	self.Pos = pos
	local normal = effectdata:GetNormal()

	self.Alpha = 255
	self.Life = 0

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	for i=1, 4 do
		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(math.Rand(0.2, 1))
		particle:SetColor(255,245,245)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(10)
		particle:SetEndSize(30)
		particle:SetVelocity((normal + VectorRand()):GetNormal() * 245)
		particle:SetCollide(true)
		particle:SetBounce(0.75)
		particle:SetAirResistance(700)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	self.Life = self.Life + FrameTime() * 1
	self.Alpha = 255 * (1 - self.Life)
	return (self.Life < 1)
end

local glowmat = Material("sprites/glow04_noz")
function EFFECT:Render()
	local pos = self.Pos

	render.SetMaterial(glowmat)
	render.DrawSprite(pos, 35, 35, Color(255, 255, 255, self.Alpha))
end
