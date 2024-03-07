function EFFECT:Init(data)
	self.Host = data:GetEntity()
	self.LifeTime = data:GetMagnitude()
	self.DieTime = CurTime() + self.LifeTime
	self.Color = data:GetColor()
	self.NextEmit = 0
	self.ClrTable = {
		[1] = {255, 255, 30},
		[2] = {130, 130, 130},
		[3] = {255, 145, 25},
		[4] = {33, 128, 255},
		[5] = {33, 255, 33}
	}
	self.DesiredColor = self.ClrTable[self.Color]
end

function EFFECT:Think()
	if !self.Host:Alive() then
		return false
	end
	return CurTime() < self.DieTime
end

local matBeam2 = Material( "trails/laser" )
local distor = Material("effects/hunterphysblast")

function EFFECT:Render()	
	local pos = self.Host:WorldSpaceCenter()
	if not self.Host:IsValid() or self.Host == MySelf and not self.Host:ShouldDrawLocalPlayer() then return end
	if ShouldDrawGlobalParticles(pos) then
		
		if CurTime() < self.NextEmit then return end
		self.NextEmit = CurTime() + 0.25
		
		pos.z = pos.z + 24
		local clr = Color(255,100,100)
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(16, 24)
		for i = 1, 6 do
			particle = emitter:Add("sprites/light_glow02_add", pos + VectorRand() * 12)
			particle:SetDieTime(math.Rand(1.1, 1.2))
			particle:SetStartAlpha(230)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2)
			particle:SetEndSize(0)
			particle:SetGravity(Vector(0, 0, -155))
			particle:SetAirResistance(300)
			particle:SetStartLength(1)
			particle:SetEndLength(35)
			particle:SetColor(self.DesiredColor[1], self.DesiredColor[2], self.DesiredColor[3])
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
