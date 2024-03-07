include("shared.lua")

ENT.Dinged = true

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local vOffset = Vector(18, 0, 8)
local vOffset2 = Vector(-18, 0, 8)

local aOffset = Angle(0, 90, 90)
local aOffset2 = Angle(0, 270, 90)

function ENT:Think()
	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:RenderInfo(pos, ang)
	cam.Start3D2D(pos, ang, 0.075)
		self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1), nil, 190)
	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN or ShouldVisibleDraw(self:GetPos()) then return end

	local ang = self:LocalToWorldAngles(aOffset)

	self:RenderInfo(self:LocalToWorld(vOffset), ang)
	self:RenderInfo(self:LocalToWorld(vOffset2), self:LocalToWorldAngles(aOffset2))
end
