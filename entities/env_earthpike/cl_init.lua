include("shared.lua")

ENT.NextEmit = 0
ENT.DoEmit = false

function ENT:Initialize()
	self.DieTime = CurTime() + 0.75
	self.Rotation = math.Rand(0, 360)
	self:SetColor(Color(130, 25, 0, 255))
	self:SetMaterial("models/shadertest/shader2")
	
	self:EmitSound("ambient/explosions/explode_4.wav", 70, math.random(160, 180))
	self:EmitSound("ambient/explosions/explode_4.wav", 70, math.random(160, 180))
end

function ENT:Think()
	if self.DoEmit then
		self.DoEmit = false

		self:EmitSound("ambient/machines/thumper_dust.wav", 70, 170)
	end
end

function ENT:Draw()
	local time = CurTime()
	local pos = self:GetPos()

	if time < self.NextEmit then return end
	self.NextEmit = time + 0.45
	self.DoEmit = true
	
	if ShouldDrawGlobalParticles(pos) then
		local particle
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(40, 48)

		local ang = Angle(0,0,0)
		local up = Vector(0,0,1)
		for i=1, 120 do
			ang:RotateAroundAxis(up, 3)
			local fwd = ang:Forward()

			local particle = emitter:Add("particle/snow", pos + Vector(0, 0, 16) + fwd * 8)
			particle:SetVelocity(fwd * 64)
			particle:SetAirResistance(-64)
			particle:SetDieTime(1.7)
			particle:SetLifeTime(0.8)
			particle:SetColor(255, 100, 50)
			particle:SetStartAlpha(60)
			particle:SetEndAlpha(0)
			particle:SetStartSize(10)
			particle:SetEndSize(10)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-2, 2))

			particle = emitter:Add("particle/snow", pos)
			particle:SetVelocity(fwd * 72 + Vector(0,0,32))
			particle:SetAirResistance(-128)
			particle:SetDieTime(0.8)
			particle:SetLifeTime(1)
			particle:SetColor(255, 100, 50)
			particle:SetStartAlpha(60)
			particle:SetEndAlpha(0)
			particle:SetStartSize(12)
			particle:SetEndSize(12)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-2, 2))
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
