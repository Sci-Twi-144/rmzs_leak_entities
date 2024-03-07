EFFECT.DieTime = 0

function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.EndPos = data:GetOrigin()
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )

	self.Length = self.StartPos:DistToSqr(self.EndPos) ^ 0.5
	self.Dir = self.EndPos - self.StartPos
	
	self.Speed = 6000
	self.DieTime = CurTime() + self.Length/self.Speed
	self.StartTime = CurTime()
	
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:Think( )
	return CurTime() < self.DieTime
end

local matBeam = Material("trails/laser")
local impact = Material("effects/combinemuzzle2")

function EFFECT:Render()
	local waves = self.Length / self.Speed
	
	local timebasedcoordinate = (self.DieTime - CurTime())/waves
	local lengthmul = (timebasedcoordinate <= 0.1) and 0 or (timebasedcoordinate >= 0.9) and 0 or (0.01 / waves)

	if self.Length > 40 then
		render.SetMaterial(matBeam)
		render.DrawBeam(self.EndPos - self.Dir * timebasedcoordinate, self.EndPos - self.Dir * (timebasedcoordinate + lengthmul), 2, 1, 0, Color(255, 255, 255, 255))
		render.DrawBeam(self.EndPos - self.Dir * timebasedcoordinate, self.EndPos - self.Dir * (timebasedcoordinate + lengthmul), 8, 1, 0, Color(250, 160, 60, 255))
	end
	
end
