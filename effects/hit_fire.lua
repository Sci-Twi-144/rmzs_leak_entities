function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal()
	
	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(28, 32)
		local grav = Vector(0, 0, -200)
		for i=1, math.random(4, 7) do
			local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), pos)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(16, 64))
			particle:SetDieTime(math.Rand(1.1, 1.5))
			particle:SetStartAlpha(150)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(2, 3))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetCollide(true)
			--particle:SetGravity(grav)
			--particle:SetCollideCallback(CollideCallback)
			particle:SetColor(255, 220, 140)
			particle:SetLighting(false)
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	
	sound.Play("ambient/fire/gascan_ignite1.wav", pos, 80, math.Rand(165, 170))
end