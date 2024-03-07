include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	if GAMEMODE.UseCustomCollisionGroups then
		self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_DEPLOYABLE, ZS_COLLISIONGROUP_ALL, true)
	end

  
    local materialp = {}
    materialp["$refractamount"] = 0.01
    materialp["$colortint"] = "[1.0 1.3 1.9]"
    materialp["$SilhouetteColor"] = "[2.1 3.5 5.0]"
    materialp["$BlurAmount"] = 0.001
    materialp["$SilhouetteThickness"] = 0.5
    materialp["$normalmap"] = "effects/combineshield/comshieldwall"
    local matRefract = CreateMaterial("m4texture","Aftershock_dx9", materialp)

    local mat2 = Material("models/debug/debugwhite")


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

	ent = ClientsideModel("models/weapons/wunderwaffe/w_wunderwaffe.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, 35))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))
        ent:SetMaterial("m4texture")
        ent:SetRenderFX(kRenderFxDistort)

        matrix = Matrix()
        matrix:Scale(Vector(1, 1, 1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent.RenderOverride = function(self)
			render.SuppressEngineLighting(true)
            render.ModelMaterialOverride(mat2)
            render.SetBlend(0.6)
            render.SetColorModulation(0.4, 0.4, 1)
			self:DrawModel()
            render.SetBlend(1)
            render.SetColorModulation(1, 1, 1)
			render.SuppressEngineLighting(false)
            render.ModelMaterialOverride(nil)
		end

        ent:Spawn()
        self.SelfBase15 = ent
    end
end

function ENT:OnRemove()
    local proptbl = {self.SelfBase, self.SelfBase1, self.SelfBase2, self.SelfBase3, self.SelfBase4, self.SelfBase5, self.SelfBase6, self.SelfBase7, self.SelfBase8, self.SelfBase9, self.SelfBase10, self.SelfBase11, self.SelfBase12, self.SelfBase13, self.SelfBase14, self.SelfBase15}
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
	self:DrawModel()

	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN or ShouldVisibleDraw(self:GetPos()) then return end

	local vOffset = Vector(40, 0, 8)
	local aOffset = Angle(0, 90, 45)
	local ang = self:LocalToWorldAngles(aOffset)


	local w, h = 600, 420

	cam.Start3D2D(self:LocalToWorld(vOffset), ang, 0.05)

		draw.RoundedBox(64, w * -0.5, h * -0.4, w, h, color_black_alpha120)

        local text = "Выберите предмет"

        if false then
            text = math.random()
            text = string.sub( text, 3, string.len( text ) )
        end

		draw.SimpleText("Консоль вызова", "ZS3D2DFont2", 0, -150, COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(text, "ZS3D2DFont2", 0, 0, COLOR_CYAN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		--self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1))
	cam.End3D2D()
end

local colFlash = Color(0, 240, 240)
local vOffset = Vector(15, 10.1, 20)
local vOffset2 = Vector(15, -10.2, 20)
local aOffset = Angle(0, -180, 90)
local aOffset2 = Angle(180, -180, -90)
local matGlow2 = Material("sprites/glow04_noz")

function ENT:DrawTranslucent()
	if (self:WorldSpaceCenter() - EyePos()):Dot(EyeVector()) < 0 then return end
	if not IsValid(MySelf) then return end

    render.SetMaterial(matGlow2)
    render.DrawQuadEasy(self:GetPos() + Vector(0, 0, 22), self:GetUp(), 128, 128, Color(100, 150, 255, 50), 0)
	
	local prop = self.SelfBase15
	if prop and prop:IsValid() then
		prop:SetLocalAngles(angle_zero + Angle(0,  CurTime() * 100, 0))
		prop:SetPos(self:GetPos() + Vector(0, 0, 35))
		prop:SetParent(self)
	end
end