include("shared.lua")

ENT.CrateType = "Arsenal Crate!"
ENT.RenderGroup = RENDERGROUP_BOTH

local Vector = Vector
local CurTime = CurTime
local surface = surface
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local Color = Color
local cam = cam
local cam_Start3D2D = cam.Start3D2D
local draw = draw
local draw_RoundedBox = draw.RoundedBox
local draw_SimpleText = draw.SimpleText
local COLOR_GRAY = COLOR_GRAY
local COLOR_BLUE = COLOR_BLUE
local color_black_alpha120 = color_black_alpha120
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local math = math
local math_Clamp = math.Clamp
local math_abs = math.abs
local math_sin = math.sin
local cam_End3D2D = cam.End3D2D

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "zombiesurvival/zapper_idle.ogg")
end

function ENT:Think()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 0 and self:GetMaterial() == "" then
		self.AmbientSound:PlayEx(1, 100 + math.sin(CurTime()))
	else
		self.AmbientSound:Stop()
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

function ENT:DrawHealthBar(percentage)
	local y = -70
	local maxbarwidth = 560
	local barheight = 30
	local barwidth = maxbarwidth * percentage
	local startx = maxbarwidth * -0.5

	surface_SetDrawColor(0, 0, 0, 220)
	surface_DrawRect(startx, y, maxbarwidth, barheight)
	surface_SetDrawColor((1 - percentage) * 255, percentage * 255, 0, 220)
	surface_DrawRect(startx + 4, y + 4, barwidth - 8, barheight - 8)
	surface_DrawOutlinedRect(startx, y, maxbarwidth, barheight)
end

function ENT:Draw()
	self:DrawModel()
end

local colFlash = Color(30, 255, 30)
function ENT:DrawTranslucent()
	if (self:WorldSpaceCenter() - EyePos()):Dot(EyeVector()) < 0 then return end
	if not IsValid(MySelf) or ShouldVisibleDraw(self:GetPos()) then return end

	local ammo = self:GetAmmo()
	local w, h = 600, 300
	cam_Start3D2D(self:LocalToWorld(Vector(-23, 0, self:OBBMaxs().z -40)), self:LocalToWorldAngles(Angle(0,-90,0)), 0.05)
		draw_RoundedBox(64, w * -0.5, h * -0.5, w, h, color_black_alpha120)
		
		if ammo > 0 then
			draw_SimpleText("["..ammo.." / "..self.MaxAmmo.."]", "ZS3D2DFont2", 0, 0, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw_SimpleText(translate.Get("empty"), "ZS3D2DFont2", 0, 0, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--draw_SimpleText("Zapper", "ZS3D2DFont2", 0, 0, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if MySelf:Team() == TEAM_HUMAN then
			local percentage = math_Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1)
			self:DrawHealthBar(percentage)
		end

		local name
		local owner = self:GetObjectOwner()
		if IsValid(owner) and owner:IsPlayer() and owner:Team() == TEAM_HUMAN then
			name = owner:Name()
		end

		if name then
			draw_SimpleText(name, "ZS3D2DFont2", 0, 70, COLOR_GRAY, TEXT_ALIGN_CENTER)
		end
	cam_End3D2D()
end