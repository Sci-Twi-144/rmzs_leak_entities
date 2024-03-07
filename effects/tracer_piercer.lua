EFFECT.DieTime = 0

function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.EndPos = data:GetOrigin()
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )

	self.Dir = self.EndPos - self.StartPos
	
	self.DieTime = CurTime() + 0.2
	self.StartTime = CurTime()
	
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:Think( )
	return CurTime() < self.DieTime
end


local matBeam = Material("trails/physbeam")


function EFFECT:Render()
	
	local fDelta = self.DieTime - CurTime()
	fDelta = math.Clamp(fDelta, 0, 1)
	
	render.SetMaterial(matBeam)
	render.DrawBeam(self.StartPos, self.EndPos , fDelta * 30, 1, 0, Color(255, 255, 255, 255))

end
