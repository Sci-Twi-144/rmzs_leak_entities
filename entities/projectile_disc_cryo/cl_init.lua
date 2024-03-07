include("shared.lua")

ENT.RenderGroup = RENDERGROUP_OPAQUE

local Vector = Vector
local Angle = Angle
local SysTime = SysTime
local render = render
local mat = "models/effects/splodearc_sheet"

function ENT:Initialize()
	self:SetModelScale(2, 0)
	self:DrawShadow(false)
	
	self:Activate()
	
	local Ang = Angle(0, 0, 0)
	self:SetMaterial(mat)
end

function ENT:Draw()	
	render.SetColorModulation(0.65, 0.65, 0.65)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
	self:SetMaterial(mat)
end