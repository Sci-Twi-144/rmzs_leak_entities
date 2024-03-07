include('shared.lua')

function ENT:Initialize()	
	self.Color = Color( 255, 255, 255, 0 )
end

local Laser = Material( "cable/redlaser" )
function ENT:Draw()
	self:DrawModel()

	local classprop = {
		"prop_*",
		"func_*"
	}

	local Vector1 = self:GetPos() + self:GetRight() * -1.5 + self:GetForward() * 2.8 + Vector(0,0,12)
	local Vector2 = self:GetPos():GetNormalized() + self:GetUp() * -10 + self:GetRight() * -50 + self:GetForward() * 40 + Vector(0,0,12)
 	local tr = util.QuickTrace(Vector1, Vector2, function( ent ) 
		if ( ent:GetClass() == classprop ) then 
			return true 
		end 
	end)

	render.SetMaterial( Laser )
	render.DrawBeam( Vector1, tr.HitPos, 1, 1, 1, self.Color) 

	local Vector3 = self:GetPos() + self:GetRight() * -1.5 + self:GetForward() * -2.8 + Vector(0,0,12)
	local Vector4 = self:GetPos():GetNormalized() + self:GetUp() * -10 + self:GetRight() * -50 + self:GetForward() * -40 + Vector(0,0,12)
	local tr1 = util.QuickTrace(Vector3, Vector4, function( ent ) 
		if ( ent:GetClass() == classprop ) then 
			return true 
		end 
	end)

	render.SetMaterial( Laser )
	render.DrawBeam( Vector3, tr1.HitPos, 1, 1, 1, self.Color)
end