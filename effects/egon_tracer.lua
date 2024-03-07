function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()

	self.Life = 0

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.Scale = data:GetScale() or 1
    self.Delay = 0.2 * self.Scale

    self.Branch = self.WeaponEnt.Branch or nil
    self.Color1 = self.Branch == 1 and Color(130, 0, 255, 200) or self.Branch == 2 and Color( 0, 150, 0) or Color( 255, 255, 255, 200 )
    self.Color2 = self.Branch == 1 and Color(175, 150, 255, 200) or self.Branch == 2 and Color(0, 255, 0) or Color(60, 160, 255, 200)
end

function EFFECT:Think( )
	self.Life = self.Life + FrameTime() * 9 -- Effect should dissipate before the next one.
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )

	return (self.Life < 1)
end

local Beamz = Material("effects/gluon_glow_trail"--[[,"effects/gluon_beam_z"]] ) --gluon_beam_noz
local Beamtwo = Material("effects/gloun_beam")
local BeamY = Material("effects/gluon_beam_noz")
local BeamS = Material("effects/gluon_glow_z")
local glowmat = Material("sprites/light_glow02_add") --"sprites/light_glow02_add" gluon_glow_z
function EFFECT:Render()
	if not IsValid(self.WeaponEnt) then return end

	if self.WeaponEnt:GetOwner()==MySelf then
		--self.EndPos = util.TraceLine({ start = MySelf:GetShootPos(), endpos = MySelf:GetShootPos() + gui.ScreenToVector( ScrW()/2, ScrH()/2 ) * 9999, mask = MASK_SOLID --[[filter = self]]}).HitPos
	end
	
    local sinq = 3
    render.SetMaterial( Beamtwo )
    Rotator = Rotator or 0
    Rotator = Rotator - 2
    local Times = 50 --12
    render.OverrideDepthEnable(true,false)
    local dir= (self.EndPos - self.StartPos):GetNormal()
	local cycleendpos=util.TraceLine({start=self.StartPos,endpos=self.StartPos+dir*704,mask=MASK_SOLID --[[filter = self]]}).HitPos
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (cycleendpos - self.StartPos):GetNormal()
    self.Inc = (cycleendpos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)
    RAng:RotateAroundAxis(RAng:Up(),Rotator)
	
    for i = 0, Times do
        // get point
        RAng:RotateAroundAxis(RAng:Up(),360/(Times/sinq))
        local point = ( self.StartPos + self.Dir * ( i * self.Inc ) ) + RAng:Forward() * (math.sin((i/Times)*math.pi))*7
        render.AddBeam(
            point,
            5,
            CurTime() + ( 1 / Times ) * i,
            self.Color1
        )
    end
    
    render.EndBeam()
    
    --second beam >_<
    render.SetMaterial( BeamY )
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (cycleendpos - self.StartPos):GetNormal()
    self.Inc = (cycleendpos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)
    RAng:RotateAroundAxis(RAng:Up(),Rotator*-1)
    
    for i = 0, Times do
        // get point
        RAng:RotateAroundAxis(RAng:Up(),360/(Times/sinq))
        local point = ( self.StartPos + self.Dir * ( i * self.Inc ) ) + RAng:Forward() * (math.sin((i/Times)*math.pi))*4
        render.AddBeam(
            point,
            5,
            CurTime() + ( 1 / Times ) * i,
            self.Color1
        )
    end
    
    render.EndBeam()
	
    -- third one X_x
    render.SetMaterial( Beamz )
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (self.EndPos - self.StartPos):GetNormal()
    self.Inc = (self.EndPos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)
    for i = 0, Times do
        // get point
        local point = ( self.StartPos+ self.Dir * ( i * self.Inc ) ) --+ VectorRand()*math.random(1,10)
        render.AddBeam(
            point,
            5,
            CurTime() + ( 1 / Times ) * i,
            self.Color1
        )
    end
    
    render.EndBeam()

	--- 4
	render.SetMaterial( BeamS )
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (self.EndPos - self.StartPos):GetNormal()
    self.Inc = (self.EndPos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)

    for i = 0, Times do
        // get point
        local point = ( self.StartPos + self.Dir * ( i * self.Inc ) ) --+ VectorRand()*math.random(1,10)
        render.AddBeam(
            point,
            10,
            CurTime() + ( 1 / Times ) * i,
            self.Color2
        )
    end

    render.EndBeam()
    
    render.OverrideDepthEnable(false,false)
	
	local alpha = (1 - self.Life)
    local colorsprite = self.Color2
    colorsprite.a = colorsprite.a * alpha
	render.SetMaterial(glowmat)
	render.DrawSprite(self.StartPos, 35, 35, colorsprite)
	render.DrawSprite(self.EndPos, 35, 35, colorsprite)
end
