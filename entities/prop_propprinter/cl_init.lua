include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	if GAMEMODE.UseCustomCollisionGroups then
		self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_DEPLOYABLE, ZS_COLLISIONGROUP_ALL, true)
	end

    --[[
	ent = ClientsideModel("models/combine_apc_destroyed_gib06.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(-28, -68, -50))
        ent:SetLocalAngles(angle_zero + Angle(90, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(1, 1, 1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase = ent
    end

	ent = ClientsideModel("models/props_combine/combine_interface002.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(36, 0, -20))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.5, 0.5, 0.6))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase2 = ent
    end

	ent = ClientsideModel("models/props_combine/combine_mortar01b.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, 12))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.92, 0.92, 0.1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase4 = ent
    end


	ent = ClientsideModel("models/hunter/blocks/cube1x1x1.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(18, 0, -9))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))
		ent:SetMaterial("models/props_combine/combine_generator01")

        matrix = Matrix()
        matrix:Scale(Vector(0.25, 0.85, 0.5))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase5 = ent
    end

	ent = ClientsideModel("models/props_combine/combine_intwallunit.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(-19.5, -19.5, -5))
        ent:SetLocalAngles(angle_zero + Angle(0, 225, 90))
	
        matrix = Matrix()
        matrix:Scale(Vector(0.95, 0.5, 0.5))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase3 = ent
    end

	ent = ClientsideModel("models/props_combine/combine_teleportplatform.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, -22))
        ent:SetLocalAngles(angle_zero + Angle(0, 180, 0))
	
        matrix = Matrix()
        matrix:Scale(Vector(0.8, 0.8, 0.26))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase6 = ent
    end

	ent = ClientsideModel("models/props_combine/combine_generator01.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(-26, 20, -6))
        ent:SetLocalAngles(angle_zero + Angle(0, 60, 0))
	
        matrix = Matrix()
        matrix:Scale(Vector(0.25, 0.25, 0.15))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase7 = ent
    end

	ent = ClientsideModel("models/xqm/cylinderx1large.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, -9))
        ent:SetLocalAngles(angle_zero + Angle(90, 0, 0))
		ent:SetMaterial("models/props_combine/combine_generator01")

        matrix = Matrix()
        matrix:Scale(Vector(0.4, 0.95, 0.95))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase8 = ent
    end

	ent = ClientsideModel("models/props_combine/combine_intmonitor001.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(25, 0, 20))
        ent:SetLocalAngles(angle_zero + Angle(270, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.4, 0.95, 0.95))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase9 = ent
    end

	ent = ClientsideModel("models/props_combine/combinethumper002.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 38, -25))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.25, 0.3, 0.15))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase12 = ent
    end

	ent = ClientsideModel("models/props_combine/combinethumper002.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, -38, -25))
        ent:SetLocalAngles(angle_zero + Angle(0, 180, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.25, 0.3, 0.15))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase13 = ent
    end

	ent = ClientsideModel("models/props_combine/combinethumper002.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(-38, 0, -25))
        ent:SetLocalAngles(angle_zero + Angle(0, 90, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.25, 0.3, 0.15))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase14 = ent
    end
    ]]

    --[[
        ent:SetMaterial("phoenix_storms/torpedo")
        ent:SetColor(Color(100, 100, 100))

         models/props_combine/combine_light002a.mdl
        models/props_combine/combinecamera001.mdl
    ]]
    ent = ClientsideModel("models/props_combine/combine_mine01.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, -20))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(1, 1, 1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base1 = ent
    end

    ent = ClientsideModel("models/combine_helicopter/helicopter_bomb01.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, -5))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))
	
        matrix = Matrix()
        matrix:Scale(Vector(0.1, 0.1, 0.1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base11 = ent
    end

    ent = ClientsideModel("models/props_combine/combinethumper002.mdl")
    if ent:IsValid() then
        ent:SetParent(self.v2Base11)
        ent:SetLocalPos(vector_origin + Vector(-1, 2, -14))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.1, 0.1, 0.075))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base2 = ent
    end

    ent = ClientsideModel("models/props_combine/combine_light002a.mdl")
    if ent:IsValid() then
        ent:SetParent(self.v2Base2)
        ent:SetLocalPos(vector_origin + Vector(1, -2, 18))
        ent:SetLocalAngles(angle_zero + Angle(90, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.25, 0.35, 0.5))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base3 = ent
    end

    ent = ClientsideModel("models/props_combine/combine_light002a.mdl")
    if ent:IsValid() then
        ent:SetParent(self.v2Base2)
        ent:SetLocalPos(vector_origin + Vector(1, -2, 18))
        ent:SetLocalAngles(angle_zero + Angle(90, 240, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.25, 0.35, 0.5))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base4 = ent
    end

    ent = ClientsideModel("models/props_combine/combine_light002a.mdl")
    if ent:IsValid() then
        ent:SetParent(self.v2Base2)
        ent:SetLocalPos(vector_origin + Vector(1, -2, 18))
        ent:SetLocalAngles(angle_zero + Angle(90, 120, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.25, 0.35, 0.5))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base5 = ent
    end

    --[[
    ent = ClientsideModel("models/props_combine/combine_interface002.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(36, 0, -20))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))

        matrix = Matrix()
        matrix:Scale(Vector(0.5, 0.5, 0.6))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base6 = ent
    end]]

    ent = ClientsideModel("models/props_combine/combine_teleportplatform.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, -20.5))
        ent:SetLocalAngles(angle_zero + Angle(0, 180, 0))
	
        matrix = Matrix()
        matrix:Scale(Vector(0.5, 0.5, 0.1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base7 = ent
    end

    ent = ClientsideModel("models/props_combine/combine_teleportplatform.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, -20.45))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))
	
        matrix = Matrix()
        matrix:Scale(Vector(0.5, 0.5, 0.1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base8 = ent
    end

    ent = ClientsideModel("models/props_combine/combine_intwallunit.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, -20))
        ent:SetLocalAngles(angle_zero + Angle(270, 0, 0))
	
        matrix = Matrix()
        matrix:Scale(Vector(1, 1, 1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base9 = ent
    end

    ent = ClientsideModel("models/props_combine/combinebutton.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(2, 1, -10))
        ent:SetLocalAngles(angle_zero + Angle(270, 0, 0))
	
        matrix = Matrix()
        matrix:Scale(Vector(1, 1, 1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.v2Base10 = ent
    end
end

function ENT:OnRemove()
    local proptbl = {self.v2Base2, self.v2Base1, self.v2Base3, self.v2Base4, self.v2Base5, self.v2Base7, self.v2Base8, self.v2Base9, self.v2Base10, self.v2Base11}
    for _, element in pairs(proptbl) do if element and element:IsValid() then element:Remove() end end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

function ENT:DrawHealthBar(percentage)
    local y = -250
    local maxbarwidth = 560
    local barheight = 30
    local barwidth = maxbarwidth * percentage
    local startx = maxbarwidth * -0.5

    surface.SetDrawColor(0, 0, 0, 220)
    surface.DrawRect(startx, y, maxbarwidth, barheight)
    surface.SetDrawColor((1 - percentage) * 255, percentage * 255, 0, 220)
    surface.DrawRect(startx + 4, y + 4, barwidth - 8, barheight - 8)
    surface.DrawOutlinedRect(startx, y, maxbarwidth, barheight)
end

function ENT:Draw()
    render.SetBlend(0) -- v2
	self:DrawModel()
    render.SetBlend(1) -- v2

	--render.DrawBox(self:GetPos(), self:GetAngles(), Vector(-392, -392, -0.29), Vector(392, 392, 120), Color( 148, 24, 24) )
	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN or ShouldVisibleDraw(self:GetPos()) then return end

	local owner = self:GetObjectOwner()

    // v1
	--local vOffset = Vector(40, 0, 8)
	--local aOffset = Angle(0, 90, 45)

    local vOffset = Vector(0, -28, -12)
	local aOffset = Angle(0, 0, 45)
	local ang = self:LocalToWorldAngles(aOffset)


	local w, h = 600, 420

	cam.Start3D2D(self:LocalToWorld(vOffset), ang, 0.05)

		draw.RoundedBox(64, w * -0.5, h * -0.5, w, h, color_black_alpha120)

		draw.SimpleText(translate.Get("prop_printer"), "ZS3D2DFont2", 0, -150, COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if IsValid(self:GetObjectLinkUp()) then
			draw.SimpleText("Соеденен с арсеналом", "ZS3D2DFont2Small", 0, -100, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if self:GetBuilding() then
			draw.SimpleText("Currently Building!", "ZS3D2DFont2", 0, 45, COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			local txt = self:GetBuilder() and " by ("..self:GetBuilder():ClippedName()..")" or ""
			draw.SimpleText(translate.Get(self:GetPropName())..txt, "ZS3D2DFont2Small", 0, 115, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1))

		if owner:IsValid() and owner:IsPlayer() then
			draw.SimpleText("("..owner:ClippedName()..")", "ZS3D2DFont2Small", 0, 150, owner == MySelf and COLOR_LBLUE or COLOR_GRAY, TEXT_ALIGN_CENTER)
		end

	cam.End3D2D()
end

local colFlash = Color(0, 240, 240)
local vOffset = Vector(15, 10.1, 20)
local vOffset2 = Vector(15, -10.2, 20)
local aOffset = Angle(0, -180, 90)
local aOffset2 = Angle(180, -180, -90)
function ENT:RenderInfo(pos, ang, owner)
	local w, h = 575, 650

end

local matWireframe = Material("models/wireframe")
local function DrawWireframe(self)
	local owner = self.Builder
	if not IsValid(owner) or not owner:GetBuilding() then 
		self.RenderOverride = nil
		return
	end

	local mn, mx = self:GetRenderBounds()
	local Down = -self:GetUp()
	local Up = -Down
	local Bottom = self:GetPos() + mn
	local Top = self:GetPos() + mx

	local Fraction = (owner:GetBuildingTimer() - CurTime()) / owner:GetTime()
	Fraction = math.Clamp( Fraction / 1, 0, 1 )

	local Lerped = LerpVector( Fraction, Top, Bottom )

	local normal = Up
	local distance = normal:Dot( Lerped )
	local bEnabled = render.EnableClipping( true )
		render.PushCustomClipPlane( normal, distance )
		render.SuppressEngineLighting(true)
		render.SetBlend(0.4)
		render.ModelMaterialOverride(matWireframe)
		self:DrawModel()
		render.SetBlend(1)
		render.ModelMaterialOverride()
		render.SuppressEngineLighting(false)
		render.PopCustomClipPlane()
		
		normal = Down
		distance = normal:Dot( Lerped )
		
		render.PushCustomClipPlane( normal, distance )
		self:DrawModel()
		render.PopCustomClipPlane()
	render.EnableClipping(bEnabled)
end

function ENT:DrawTranslucent()
	if (self:WorldSpaceCenter() - EyePos()):Dot(EyeVector()) < 0 then return end
	if not IsValid(MySelf) then return end
	
	if self:GetBuilding() then
		local prop = self:GetProp()
		if IsValid(prop) and not prop.RenderOverride then
			prop.Builder = self
			prop.RenderOverride = DrawWireframe
		end

        local proptbl = {self.v2Base2, self.v2Base3, self.v2Base4, self.v2Base5, self.v2Base11}
        if proptbl[1]:IsValid() and proptbl[2]:IsValid() and proptbl[3]:IsValid() and proptbl[4]:IsValid() and proptbl[5]:IsValid() then
            proptbl[5]:SetLocalAngles(angle_zero + Angle(0,  CurTime() * 250, 0))
            proptbl[5]:SetPos(self:GetPos() + Vector(0, 0, -5))
            proptbl[1]:SetParent(proptbl[5])
            proptbl[2]:SetParent(proptbl[1])
            proptbl[3]:SetParent(proptbl[1])
            proptbl[4]:SetParent(proptbl[1])
        end
	end
	
	local owner = self:GetObjectOwner()
	self:RenderInfo(self:LocalToWorld(vOffset), self:LocalToWorldAngles(aOffset), owner)
	self:RenderInfo(self:LocalToWorld(vOffset2), self:LocalToWorldAngles(aOffset2), owner)
end