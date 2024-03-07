include("shared.lua")

ENT.RenderGroup = RENDERGROUP_OPAQUE

local Vector = Vector
local Angle = Angle
local SysTime = SysTime
local render = render
local render_SuppressEngineLighting = render.SuppressEngineLighting

function ENT:Initialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))
	self:DrawShadow(false)
	self:SetModelScale(1.5, 0)
	self:Activate()
	
	self.rotate = 0
	self.lasttime = 0
end

function ENT:Draw()
	local Ang = Angle(0, 0, 0)
	Ang:RotateAroundAxis(Ang:Up(), self.rotate)

	if (self.rotate > -359) then
		self.rotate = 0
	end

	self.rotate = self.rotate - (-65 * (self.lasttime - SysTime()))
	self.lasttime = SysTime()
	
	self:SetAngles(Ang)
	
	--render_SuppressEngineLighting(true)
	self:DrawModel()
	--render_SuppressEngineLighting(false)
end