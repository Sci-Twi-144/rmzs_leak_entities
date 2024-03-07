include("shared.lua")

function ENT:Initialize()
	self.Seed = math.Rand(0, 10)

	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 48 do
		particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(VectorRand() * 100)
		particle:SetDieTime(5.5)
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(200)
		particle:SetStartSize(3)
		particle:SetEndSize(3)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(255, 255, 100)
		particle:SetAirResistance(255)
	end

	for i=1, 48 do
		local heading = VectorRand()
		heading:Normalize()

		local particle = emitter:Add("effects/spark", pos + heading * 8)
		particle:SetVelocity(VectorRand() * 100)
		particle:SetDieTime(5)
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(0)
		particle:SetColor(255, 245, 245)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetAirResistance(255)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)

	local dlight = DynamicLight(0)
	if dlight then
		dlight.Pos = pos
		dlight.r = 50
		dlight.g = 255
		dlight.b = 50
		dlight.Brightness = 8
		dlight.Size = 300
		dlight.Decay = 1000
		dlight.DieTime = CurTime() + 1
	end

	self:DrawShadow(false)
end

function ENT:OnRemove()
end

ENT.Rotation = math.random(360)

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local matGlow3 = Material("sprites/orangecore1")
local matGlow4 = Material("sprites/orangecore2")
local matGlow5 = Material("sprites/light_glow02_add")
local matGlow6 = Material("effects/fire_cloud1")
local vector_origin = vector_origin
-- "sprites/light_glow02_add" "effects/splashwake1" "sprites/glow04_noz" "effects/fire_embers1" "effects/fire_cloud1" "particles/smokey" "sprites/light_ignorez" sprites/flamelet3 sprites/orangecore2 sprites/orangecore1.vmt


function ENT:Draw()
end

function ENT:DrawTranslucent()

	self.Rotation = self.Rotation + FrameTime() * 360
	if self.Rotation >= 360 then
		self.Rotation = self.Rotation - 360
	end
	local up = self:GetUp()
	local right = self:GetRight()
	local forward = self:GetForward()


	local pos = self:GetPos()
	local size = 80
	local color0 = Color(255, 255, 255, 150)
	local color = Color(100, 255, 100, 75)
	local colorz2 = Color(100, 255, 100, 200)
	local colorz = Color(0, 255, 0, 30)
	local color2 = Color(255, 150, 0, 200)
	local color3 = Color(255, 0, 0, 255)
	local color4 = Color(255, 230, 0)

	local sin = 1 + (math.abs(math.sin(CurTime() * 3))) / 5

	render.SetMaterial(matGlow6)
	render.DrawQuadEasy(pos, right, size, size, colorz, self.Rotation)
	render.DrawQuadEasy(pos, forward, size, size, colorz, self.Rotation)

	render.DrawQuadEasy(pos, right * -1, size, size, colorz, self.Rotation)
	render.DrawQuadEasy(pos, forward * -1, size, size, colorz, self.Rotation)

	render.SetMaterial(matGlow2)
	render.DrawSprite(pos, 128, 128, color)

	render.SetMaterial(matGlow3)
	render.DrawSprite(pos, 50 * sin, 50 * sin, color2)

	render.SetMaterial(matGlow4)
	render.DrawSprite(pos, 80 * sin, 80 * sin, color3)

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 32, 32, color4)

	--render.SetMaterial(matGlow)
	--render.DrawSprite(pos, 24, 24, color3)

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 16, 16, colorz2)
end

function ENT:OnRemove()
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetForward())
	util.Effect("explosion_teleport", effectdata, true, true)
end