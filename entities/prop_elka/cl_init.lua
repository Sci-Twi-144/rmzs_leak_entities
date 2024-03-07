include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 200))
	self:SetModelScaleVector(Vector(1, 1, 1))
	self.AmbientSound = CreateSound(self, "ambient/atmosphere/tunnel1.wav")
end

function ENT:Think()
	if EyePos():DistToSqr(self:GetPos()) <= 4900000 then -- 700^2
		self.AmbientSound:PlayEx(0.33, 75)
	else
		self.AmbientSound:Stop()
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

ENT.NextEmit = 0
ENT.Rotation = math.random(360)

local matWhite = Material("models/debug/debugwhite")
local matGlow = Material("sprites/light_glow02_add")
local cDraw = Color(255, 242, 0)
local cDrawWhite = Color(255, 255, 255)

local math_sin = math.sin
local math_cos = math.cos
local math_abs = math.abs
local cam_Start3D = cam.Start3D
local cam_End3D = cam.End3D
local render_SetBlend = render.SetBlend
local render_ModelMaterialOverride = render.ModelMaterialOverride
local render_SetColorModulation = render.SetColorModulation
local render_SuppressEngineLighting = render.SuppressEngineLighting
local render_DrawQuadEasy = render.DrawQuadEasy
local render_DrawSprite = render.DrawSprite

function ENT:DrawTranslucent()
	self:RemoveAllDecals()
--	if true then return end

	local scale = 1

	local curtime = CurTime()
	local sat = math_abs(math_sin(curtime))
	local colsat = sat * 0.125
	local eyepos = EyePos()
	local eyeangles = EyeAngles()
	local forwardoffset = 16 * scale * self:GetForward()
	local rightoffset = 16 * scale * self:GetRight()
	local radius = (180 + math_cos(sat) * 40) * scale
	local whiteradius = (32 + math_sin(sat) * 32) * scale
	local up = self:GetUp()
	local spritepos = self:GetPos() + up
	local spritepos2 = self:WorldSpaceCenter()
	local r, g, b

    r = 0.15 + colsat
    g = 0.4 + colsat
    b = 1
	cDrawWhite.r = r * 255
	cDrawWhite.g = g * 255
	cDrawWhite.b = b * 255

	self:DrawModel()
	--render.DrawSprite(spritepos, number width, number height, table color = Color( 255, 255, 255 ) )
	render.SetMaterial(matGlow)
	render_DrawSprite(spritepos2 + (up * -3), 32, 32, cDraw)

		render_DrawQuadEasy(spritepos, up, whiteradius, whiteradius, cDrawWhite, self.Rotation)
		render_DrawQuadEasy(spritepos, up * -1, whiteradius, whiteradius, cDrawWhite, self.Rotation)

	if curtime < self.NextEmit then return end
	self.NextEmit = curtime + 0.05

	local offset = VectorRand()
	offset.z = 0
	offset:Normalize()
	offset = math.Rand(-32, 32) * scale * offset
	offset.z = 1
	local pos = self:LocalToWorld(offset)

	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		local particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetDieTime(math.Rand(1.5, 4))
		particle:SetVelocity(Vector(0, 0, math.Rand(32, 64) * scale))
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(2, 4) * scale)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(r * 255, g * 255, b * 255)

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
