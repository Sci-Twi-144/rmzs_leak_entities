include("shared.lua")

function ENT:Initialize()
	--self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local vOffset = Vector(43, 267.5, 140)
local vOffset2 = Vector(43, 274.5, 140)
local aOffset = Angle(0, 0, 90)
local aOffset2 = Angle(0, 180, 90)

local colFlash = Color(30, 255, 30)
function ENT:RenderInfo(pos, ang, owner)
	cam.Start3D2D(pos, ang, 0.055)
		draw.SimpleText("The ShitHouse", "ZS3D2DFont2", 0, 30, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if owner:IsValid() and owner:IsPlayer() then
			draw.SimpleText(owner:ClippedName(), "ZS3D2DFont2", 0, 160, owner == MySelf and COLOR_LBLUE or COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1), nil, 250, 0.85)
	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN then return end

	local owner = self:GetObjectOwner()
	self:RenderInfo(self:LocalToWorld(vOffset), self:LocalToWorldAngles(aOffset), owner)
	self:RenderInfo(self:LocalToWorld(vOffset2), self:LocalToWorldAngles(aOffset2), owner)
end
