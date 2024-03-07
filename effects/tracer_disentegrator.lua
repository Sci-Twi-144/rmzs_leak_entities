EFFECT.DieTime = 0

function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.EndPos = data:GetOrigin()
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )

	self.Dir = self.EndPos - self.StartPos
	self.LifeTime = 0.2
	self.DieTime = CurTime() + self.LifeTime
	self.StartTime = CurTime()
	self.Distance = self.StartPos:DistToSqr(self.EndPos) ^ 0.5
	self.ZigZagLength = 50
	self.ZigZagCount = self.Distance/self.ZigZagLength
	self.ZigZagPoints = {}
	self.Vectorup = self.Dir:Angle():Up()
	local function Dir()
		local ang = self.Dir:Angle()
		local forward = ang:Forward()
		ang:RotateAroundAxis(forward, math.random(360))
		return ang:Up()
	end
	for i = 0, self.ZigZagCount do
		table.insert(self.ZigZagPoints, #self.ZigZagPoints + 1, {self.StartPos + self.Dir:GetNormalized() * self.ZigZagLength * i, Dir()})
	end
	
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:Think( )
	return CurTime() < self.DieTime
end

local matBeam = Material("trails/physbeam", "smooth")
local beammat = Material("trails/laser", "smooth")
local beam1mat = Material("trails/electric", "smooth")
local glowmat = Material("sprites/light_glow02_add")

function EFFECT:Render()
	local tbl = self.ZigZagPoints
	local fDelta = (self.DieTime - CurTime())/self.LifeTime
	fDelta = math.Clamp(fDelta, 0, 1)
	
	local function Offset()
		return math.random() * (1 - fDelta) * 20
	end
	
	render.SetMaterial(beam1mat)
	render.StartBeam(self.ZigZagCount)
		for i=1, self.ZigZagCount do
			render.AddBeam(tbl[i][1] + tbl[i][2] * (i == 1 and 0 or Offset()), 20, 32, Color(255,255,255, 255 * fDelta))
		end
	render.EndBeam()
	
	render.SetMaterial(matBeam)
	render.DrawBeam(self.StartPos, self.EndPos , fDelta * 3, 1, 0, Color(255, 255, 255, 255))
end
