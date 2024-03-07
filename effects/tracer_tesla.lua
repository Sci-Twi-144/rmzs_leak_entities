EFFECT.Mat = Material( "effects/tool_tracer" )

function EFFECT:Init(data)
	self.EndPos = data:GetStart()
	self.StartPos = data:GetOrigin()
	if not self.StartPos or not self.EndPos then return end

	self.Alpha = 255
	self.Life = 0
	
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)	
	self.Refract = 0
	self.positions = {}
end

function EFFECT:Think()
	self.Life = self.Life + FrameTime() * 4
	self.Alpha = 255 * ( 1 - self.Life )

	return ( self.Life < 1 )
end

function EFFECT:Render()

	if ( self.Alpha < 1 ) then return end

	render.SetMaterial( self.Mat )
	local texcoord = math.Rand( 0, 1 )

	local norm = (self.StartPos - self.EndPos) * self.Life

	self.Length = norm:Length()

	for i = 1, 3 do

		render.DrawBeam( self.StartPos - norm,
			self.EndPos,
			8,
			texcoord,
			texcoord + self.Length / 128,
			Color( 255, 64, 0) 
		)
	end

	render.DrawBeam( self.StartPos,
		self.EndPos,
		8,
		texcoord,
		texcoord + ((self.StartPos - self.EndPos ):Length() / 128),
		Color(255, 64, 0, 128 * (1 - self.Life)) 
	)
end