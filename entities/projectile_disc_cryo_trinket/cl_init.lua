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
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)

	self:SetMaterial(mat)

	local pos = self:GetPos()

	local velpos = VectorRand():GetNormal()
	velpos.z = 0
	-- VectorRand() * math.random(140, 255)
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle

	for i=1, 24 do
		particle = emitter:Add("effects/splash2", pos)
		particle:SetDieTime(0.1)
		particle:SetColor(0, 255, 200)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(3)
		particle:SetEndSize(0)
		particle:SetStartLength(1)
		particle:SetEndLength(15)
		particle:SetVelocity(VectorRand():GetNormal() * 200)
	end

	for i=0, 24 do
		particle = emitter:Add("sprites/glow04_noz", pos)
		particle:SetVelocity(velpos * 300)
		particle:SetDieTime(2)
		particle:SetStartAlpha(160)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(0, 255, 255)
		particle:SetAirResistance(150)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end