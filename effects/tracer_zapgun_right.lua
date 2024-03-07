EFFECT.LifeTime = 0.3

function EFFECT:GetDelta()
	return math.Clamp(self.DieTime - CurTime(), 0, self.LifeTime) / self.LifeTime
end

function EFFECT:Init(data)
	self.StartPos = self:GetTracerShootPos(data:GetStart(), data:GetEntity(), data:GetAttachment())
	self.EndPos = data:GetOrigin()

	self.HitNormal = data:GetNormal() * -1

	local normal = (self.EndPos - self.StartPos)
	normal:Normalize()
	self.Normal = (self.EndPos - self.StartPos):GetNormalized()
	self.QuadPos = self.EndPos + self.HitNormal

	self.Color = Color(255,50,50)
	self.LifeTime = 0.45
	self.DieTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local Mat_Impact = Material("effects/combinemuzzle2")
local matBeam2 = Material("trails/physbeam")
local Mat_TracePart = Material("effects/select_ring")
local matElectric = Material("trails/electric")

function EFFECT:Render()
	local norm = (self.StartPos - self.EndPos) * self.LifeTime
	self.Length = norm:Length()

	render.SetMaterial(matElectric)
	local texcoord = math.Rand( 0, 1 )
	render.DrawBeam(self.StartPos, self.EndPos + (VectorRand() * 36), 25, texcoord, texcoord + self.Length / 128, Color( 255, 0, 0, self.Alpha ))

	local delta = self:GetDelta()
	if delta <= 0 then return end
	self.Color.a = delta * 255

	local startpos = self.StartPos
	local endpos = self.QuadPos

	local size = delta * 55
	render.SetMaterial(matBeam2)
	render.DrawBeam(startpos, endpos, size * 0.5, 1, 0, self.Color)
	render.DrawBeam(startpos, endpos, size, 1, 0, self.Color)
	render.DrawBeam(startpos, endpos, size * 0.15, 0.25, 0, Color(255,200,200,255))

	local distancevector = (startpos - endpos)
	local dir = distancevector:Angle()
	local dfwd = dir:Forward()
	local dup = dir:Up()
	local drgt = dir:Right()
	local nlen = distancevector:Length()

	for i = 0, nlen * (1 - delta), 32 do
		local set = i - CurTime() * 7
		local spinbeamsize = (1 - delta) * 15

		local basebeampos = startpos - dfwd * i
		local spinbeampos = basebeampos + dup * math.sin(set) * spinbeamsize + drgt * math.cos(set) * spinbeamsize
		local spinbeampos2 = basebeampos - dup * math.sin(set) * spinbeamsize - drgt * math.cos(set) * spinbeamsize

		render.SetMaterial(Mat_Impact)
		render.DrawSprite(self.EndPos, 26, 26, Color(255,50,0))
		render.SetMaterial(Mat_TracePart)

		if not self.DoOnce then
			local emitter = ParticleEmitter(self.StartPos)
			for e = 1, 2 do
				local particle = emitter:Add(Mat_TracePart, self.StartPos)
				particle:SetVelocity(self.Normal:GetNormalized() * 2 * (e * 12))
				particle:SetAirResistance(8)
				particle:SetColor(255,50,0)
				particle:SetEndSize(8)
				particle:SetDieTime(0.2)
				particle:SetStartSize(5)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(1)
			end
			emitter:Finish()
			emitter = nil
			collectgarbage("step", 64)

			self.DoOnce = true
		end

		prevspinpos = spinbeampos
		prevspinpos2 = spinbeampos2
	end
end