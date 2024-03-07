EFFECT.LifeTime = 0.3

function EFFECT:Init(data)
	self.StartPos = self:GetTracerShootPos(data:GetStart(), data:GetEntity(), data:GetAttachment())
	self.EndPos = data:GetOrigin()
	self.HitNormal = data:GetNormal() * -1
	self.Color = Color(150,155,255)
	self.LifeTime = 0.2
	self.DieTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matBeam2 = Material("trails/electric")
function EFFECT:Render()
	local norm = (self.StartPos - self.EndPos) * self.LifeTime
	self.Length = norm:Length()

	render.SetMaterial(matBeam2)
	local texcoord = math.Rand( 0, 1 )
	render.DrawBeam(self.StartPos, self.EndPos + (VectorRand() * 6), 12, texcoord, texcoord + self.Length / 128, Color( 255, 255, 255, self.Alpha ))
end
