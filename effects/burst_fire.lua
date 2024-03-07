function EFFECT:Init(effectdata)
	local pos = effectdata:GetOrigin()
	local normal = effectdata:GetNormal()
	self.EffectType = effectdata:GetScale()
	
	local clrtbl = {
		[0] = Color(255, 220, 140),
		[1] = Color(140, 220, 255),
		[2] = Color(140, 150, 255)
	}
	local col = clrtbl[self.EffectType]
	print(clrtbl[self.EffectType], self.EffectType)
	sound.Play("ambient/fire/gascan_ignite1.wav", pos, 80, math.Rand(165, 170))
	
	local function rollangl() return math.Rand(-45,45) end
	
	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(28, 32)
		local grav = Vector(0, 0, -200)
		for i=1, math.random(15, 25) do
			local rndangle = Angle(rollangl(), rollangl(), rollangl())
			local rotated =  (normal:Angle() + rndangle):Forward()
			local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), pos)
			particle:SetVelocity((normal + rotated):GetNormalized() * math.Rand(100, 250))
			particle:SetDieTime(math.Rand(1.1, 1.5))
			particle:SetStartAlpha(150)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(5, 6))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetCollide(true)
			--particle:SetGravity(grav)
			--particle:SetCollideCallback(CollideCallback)
			--particle:SetColor(255, 220, 140)
			particle:SetColor(col.r, col.g, col.b)
			particle:SetLighting(false)
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

