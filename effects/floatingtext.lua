
EFFECT.LifeTime = 3

function EFFECT:Init(data)
	self:SetRenderBounds(Vector(-64, -64, -64), Vector(64, 64, 64))

	self.Seed = math.Rand(0, 10)

	self.Pos = data:GetOrigin()

	local amount = math.ceil(data:GetMagnitude())
	self.Message = GAMEMODE.BuffNamesAndColors[amount][1]
	self.Scolor = GAMEMODE.BuffNamesAndColors[amount][2]

	self.DeathTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	self.Pos.z = self.Pos.z + FrameTime() * 32
	return CurTime() < self.DeathTime
end

local cam_IgnoreZ = cam.IgnoreZ
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleText = draw.SimpleText
local math_Clamp = math.Clamp
local math_sin = math.sin
local EyeAngles = EyeAngles
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

local col = Color(40, 255, 40, 255)
local col2 = Color(0, 0, 0, 255)
function EFFECT:Render()
	local delta = math_Clamp(self.DeathTime - CurTime(), 0, self.LifeTime) / self.LifeTime
	col.a = delta * 240
	col2.a = col.a

	local ang = EyeAngles()
	local right = ang:Right()
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam_IgnoreZ(true)
	cam_Start3D2D(self.Pos + math_sin(CurTime() + self.Seed) * 30 * delta * right, ang, (delta * 0.24 + 0.09) / 2)
		draw_SimpleText(self.Message, "ZS3D2DFont2Small", 0, 0, self.Scolor or col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam_End3D2D()
	cam_IgnoreZ(false)
end
