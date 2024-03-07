EFFECT.LifeTime = 0.3

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal() * -1

	pos = pos + normal

	self.Pos = pos
	self.Normal = normal
	self.DieTime = CurTime() + self.LifeTime

	sound.Play("ambient/fire/gascan_ignite1.wav", pos, 75, math.Rand(250, 255))
	self.CirclePoints = 16
	self.CircleBase = {}
	self.Rander = VectorRand()
	
	local ang = self.Rander:GetNormalized():Angle()
	local up = ang:Up()
	
	for i = 0, (self.CirclePoints - 1) do		
		table.insert(self.CircleBase, i + 1, ang:Forward())
		ang:RotateAroundAxis(up, 360/self.CirclePoints)		
	end

	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		for i=1, math.random(70, 80) do
			local heading = VectorRand()
			heading:Normalize()

			local particle = emitter:Add("sprites/glow04_noz", pos + heading * 8)
			particle:SetVelocity(500 * heading * math.random())
			particle:SetDieTime(math.Rand(0.5, 0.55))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(math.Rand(3, 4))
			particle:SetEndSize(0)
			particle:SetColor(110, 110, 110)
			particle:SetRoll(math.Rand(-10, 10))
			--particle:SetRollDelta(math.Rand(-10, 10))
			particle:SetAirResistance(250)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)

		local dlight = DynamicLight(0)
		if dlight then
			dlight.Pos = pos
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.Brightness = 8
			dlight.Size = 300
			dlight.Decay = 1000
			dlight.DieTime = CurTime() + 1
		end
	end
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matGlow = Material("sprites/glow04_noz")
local matBeam = Material("trails/physbeam", "smooth")
local beammat = Material("trails/laser", "smooth")
local beam1mat = Material("trails/electric", "smooth")
local glowmat = Material("sprites/light_glow02_add")
local colGlow = Color(215, 215, 215)
function EFFECT:Render()
	local delta = (self.DieTime - CurTime()) / self.LifeTime
	local adelta = 1 - delta
	local ctbl = self.CircleBase
	local pos = self.Pos
	render.SetMaterial(beam1mat)
	render.StartBeam(self.CirclePoints)
	for i = 1, (self.CirclePoints + 1) do
		local ind = i > self.CirclePoints and 2 or i
		render.AddBeam(pos + (ctbl[ind] * 100 + VectorRand() * 20 * delta) * adelta, 20, 32, Color(255,255,255, 255 * delta))
	end
	render.EndBeam()
	
	for a = 1, 3 do
		self:DrawLightning(VectorRand(), math.random(50,150), math.random(3,6), adelta, delta)
	end
	
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 200 * adelta, 200 * adelta, Color(120,150,255, 255* delta))
end

function EFFECT:DrawLightning(vector, range, divide, adelta, delta)
	local length = range/divide
	render.SetMaterial(beammat)
	render.StartBeam(divide)
	for i = 1, divide do
		render.AddBeam(self.Pos + vector * length * i + VectorRand() * 10, 20 * (divide - i)/divide, 1, Color(120,150,255, 255* delta))
	end
	render.EndBeam()
end