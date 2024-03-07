function EFFECT:Init( data )
	local pos = data:GetStart()

	self.StartPos = pos
	self.EndPos = data:GetOrigin()

	self.Alpha = 255
	
	self.Dir = self.EndPos - self.StartPos
	self.LifeTime = 5
	self.DieTime = CurTime() + self.LifeTime
	self.StartTime = CurTime()
	self.Distance = self.StartPos:DistToSqr(self.EndPos) ^ 0.5
	self.ZigZagLength = 100
	self.ZigZagCount = self.Distance/self.ZigZagLength
	self.ZigZagLengthTrue = self.Distance/math.floor(self.ZigZagCount)
	self.ZigZagPoints = {}
	self.Vectorup = self.Dir:Angle():Up()
	self.Rerolls = 20
	self.NextReroll = CurTime() + self.LifeTime / self.Rerolls
	
	local function Dir()
		local ang = self.Dir:Angle()
		local forward = ang:Forward()
		ang:RotateAroundAxis(forward, math.random(360))
		return ang:Up()
	end
	if math.floor(self.ZigZagCount) > 1 then
		for i = 1, math.ceil(self.ZigZagCount) do
			table.insert(self.ZigZagPoints, #self.ZigZagPoints + 1, {self.StartPos + self.Dir:GetNormalized() * self.ZigZagLengthTrue * (i-1), Dir()})
		end
	else
		self.ZigZagPoints[1] = {self.StartPos, Dir()}
		self.ZigZagPoints[2] = {self.EndPos, Dir()}
	end

	if ShouldDrawGlobalParticles(pos) then	
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		for i=1, 9 do
			local particle = emitter:Add("effects/blueflare1", pos)
			particle:SetDieTime(0.8)
			particle:SetColor(150,190,255)
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(4)
			particle:SetEndSize(0)
			particle:SetVelocity(VectorRand():GetNormal() * 60)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:RerollPoints( )
	self.ZigZagPoints = {}
	local function Dir()
		local ang = self.Dir:Angle()
		local forward = ang:Forward()
		ang:RotateAroundAxis(forward, math.random(360))
		return ang:Up()
	end
	if math.floor(self.ZigZagCount) > 1 then
		for i = 1, math.ceil(self.ZigZagCount) do
			table.insert(self.ZigZagPoints, #self.ZigZagPoints + 1, {self.StartPos + self.Dir:GetNormalized() * self.ZigZagLengthTrue * (i-1), Dir()})
		end
	else
		self.ZigZagPoints[1] = {self.StartPos, Dir()}
		self.ZigZagPoints[2] = {self.EndPos, Dir()}
	end
end

function EFFECT:Think( )
	if self.NextReroll <= CurTime() then
		self:RerollPoints()
		self.NextReroll = CurTime() + self.LifeTime / self.Rerolls
	end
	return ( self.DieTime > CurTime() )
end

local beam1mat = Material("trails/electric", "smooth")
local glowmat = Material("sprites/light_glow02_add")

function EFFECT:Render()
	local tbl = self.ZigZagPoints
	local fDelta = (self.DieTime - CurTime())/self.LifeTime
	fDelta = math.Clamp(fDelta, 0, 1)
	local count = math.ceil(self.ZigZagCount)
	local pi = math.pi
	
	local function Offset()
		return math.random() * (1 - fDelta) * 20
	end
	
	local noise = (5 + 10 * (1 - fDelta))
	
	render.SetMaterial(beam1mat)
	render.StartBeam(count)
		for i=1, count do
			local sinmod = math.sin(i/count * pi)
			render.AddBeam(tbl[i][1] + tbl[i][2] * noise, 40 * sinmod, 1, Color(100,255,100, 50 + 205 * fDelta))
		end
	render.EndBeam()

	render.SetMaterial(glowmat)
	render.DrawSprite(tbl[1][1] + tbl[1][2] * noise, 130, 130, Color(150, 215, 255, 255 * fDelta))
	render.DrawSprite(tbl[#tbl][1] + tbl[#tbl][2] * noise, 50, 50, Color(170, 215, 255, 255 * fDelta))
end
