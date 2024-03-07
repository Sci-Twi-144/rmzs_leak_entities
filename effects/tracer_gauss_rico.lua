EFFECT.Life = 0

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.Position = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Dir = self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)

	self.Life = CurTime() + 0.1

	--sound.Play("weapons/fx/rics/ric"..math.random(5)..".wav", self.StartPos, 73, math.random(100, 110))
end

function EFFECT:Think( )
	return CurTime() < self.Life
end

local Beam = Material("effects/tau_beam")
local BeamTwo = Material("trails/electric")
function EFFECT:Render()
    local Times = 100 --12
    render.SetMaterial( Beam )
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (self.EndPos - self.StartPos):GetNormal()
    self.Inc = (self.EndPos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)

    for i = 0, Times do
        // get point
        local point = ( self.StartPos + self.Dir * ( i * self.Inc ) )
        render.AddBeam(
            point,
            10,
            CurTime() + ( 1 / Times ) * i,
            Color(255,132,0,255)
        )
    end
    render.EndBeam()
	local texcoord = math.Rand(0, 1)
	local norm = (self.StartPos - self.EndPos) * self.Life
	local nlen = norm:Length()

	local alpha = (1 - self.Life)
	render.SetMaterial(BeamTwo)
	for i = 1, 3 do
		render.DrawBeam(self.StartPos + (VectorRand() * 3), self.EndPos + (VectorRand() * 3), 6, texcoord, texcoord + nlen / 128, Color(255, 160, 50, 170 * alpha))
	end
end