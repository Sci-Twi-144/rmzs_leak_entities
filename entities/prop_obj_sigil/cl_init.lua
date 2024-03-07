include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "ambient/atmosphere/tunnel1.wav")
end

function ENT:Think()
	if EyePos():DistToSqr(self:GetPos()) <= 4900000 then -- 700^2
		self.AmbientSound:PlayEx(0.33, 75 + (self:GetSigilHealth() / self:GetSigilMaxHealth()) * 25)
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
local SigilMaterial = Material("models/rmzs/sigil/sigil_complex")
local cDraw = Color(255, 255, 255)

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

	local scale = self.ModelScale
	local curtime = CurTime()
	local sat = math_abs(math_sin(curtime))
	local colsat = sat * 0.125
	local healthperc = self:GetSigilHealth() / self:GetSigilMaxHealth()
	local radius = (180 + math_cos(sat) * 40) * scale
	local up = self:GetUp()
	local eyepos = EyePos()
	local spritepos = self:GetPos() + up
	local spritepos2 = self:WorldSpaceCenter()
	local corrupt = self:GetSigilCorrupted()
	local humantint = Vector(0.27, 0.69, 0.97) * 2
	--local humantintps = Vector(1, 0.45, 0) * 2
	local ztint = Vector(0.3, 0.8, 0.3) * 2
	local fulltint = Vector(1, 1, 1) * 2
	local r, g, b

	--local longsin = math_abs(math_cos(curtime % 365))
	local hsvcolor = HSVToColor( (curtime % 365) * 40, 1, 1 )
	local humantintps = Vector(hsvcolor.r / 255, hsvcolor.g / 255, hsvcolor.b / 255) * 2

	if corrupt then
		r = colsat
		g = 0.75
		b = colsat
	else
		if GAMEMODE:IsPointSaveMode() then
			r = 1 * hsvcolor.r / 255
			g = 1 * hsvcolor.g / 255
			b = 1 * hsvcolor.b / 255
		--	r = 1
		--  g = 0.45 + colsat
		--	b = 0 + colsat
		else
			r = 0.27 + colsat
			g = 0.69 + colsat
			b = 1
		end
	end

	corruptthinkh = corrupt and 0 or healthperc
	corruptthinkz = corrupt and healthperc or 0
	basetint = ((GAMEMODE:IsPointSaveMode() and humantintps or humantint) * corruptthinkh + ztint * corruptthinkz)
	fulltint = fulltint * healthperc

	SigilMaterial:SetVector("$emissiveblendtint", fulltint)
	SigilMaterial:SetVector("$phongtint", fulltint)
	SigilMaterial:SetVector("$color2", basetint)
	SigilMaterial:SetVector("$cubemaptint", basetint)

	r = r * healthperc
	g = g * healthperc
	b = b * healthperc

	render_SetBlend(0.9)
	render_SuppressEngineLighting(true)
	self:DrawModel()
	render_SuppressEngineLighting(false)
	render_SetBlend(1)

	self.Rotation = self.Rotation + FrameTime() * 5
	if self.Rotation >= 360 then
		self.Rotation = self.Rotation - 360
	end

	cDraw.r = r * 250
	cDraw.g = g * 250
	cDraw.b = b * 250

	spritepos2.z = spritepos2.z - 15

	render.SetMaterial(matGlow)
	render_DrawSprite(spritepos2, radius * 0.9, radius * 2, cDraw)

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
		emitter:SetNearClip(16, 24)

		local particle = emitter:Add("rmzs/effects/rollerglow_white", pos)
		particle:SetDieTime(math.Rand(4, 8))
		particle:SetVelocity(Vector(0, 0, math.Rand(16, 36) * scale))
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(2, 3) * scale)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(r * 255, g * 255, b * 255)
		particle:SetAirResistance(15)

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
