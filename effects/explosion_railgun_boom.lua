function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	local normal = effectdata:GetNormal()

	local particle

	local emitter = ParticleEmitter(pos)
	local emitter2 = ParticleEmitter(pos, true)
	emitter:SetNearClip(24, 32)

	for i=1, 100 do
		particle = emitter:Add("effects/splash2", pos)
		particle:SetDieTime(0.3)
		particle:SetColor(50, 150, 255)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(140)
		particle:SetEndSize(140)
		particle:SetStartLength(60)
		particle:SetEndLength(60)
		particle:SetVelocity(VectorRand():GetNormal() * 220)
	end
	local ringstart = pos + normal * -3


	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
