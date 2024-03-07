function EFFECT:Init(data)
	local pos = data:GetOrigin() + Vector(0, 0, 2)

	self.Start = pos
	self.StartTime = CurTime()

	self.Alpha = 255
	self.Life = 0

	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		local axis = AngleRand()
		emitter:SetNearClip(32, 48)
		
	for i=1, 180 do
		axis.roll = axis.roll + 2
		offset = axis:Up()

		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(offset * math.Rand(100, 120))
		particle:SetColor(30, 30, 255)
		particle:SetAirResistance(300)
		particle:SetDieTime(math.Rand(1.25, 2.5))
		particle:SetStartAlpha(245)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(math.Rand(12, 15))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-10, 10))
		--particle:SetCollide(true)
	end

	for i=1, 20 do
		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(VectorRand() * 8)
		particle:SetColor(60, 60, 255)
		particle:SetDieTime(2)
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(255)
		particle:SetStartSize(24)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
	end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end

function EFFECT:Think()
	self.Life = self.Life + FrameTime() * 4
	self.Alpha = 255 * (1 - self.Life)
	return self.Life < 1
end

local glowmat = Material("sprites/glow04_noz")

function EFFECT:Render()
	if ShouldDrawGlobalParticles(self.Start) then
		render.SetMaterial(glowmat)
		render.DrawSprite(self.Start, 400, 400, Color(30, 30, 255, self.Alpha))
	end
end
