include("shared.lua")

ENT.NextEmit = 0
ENT.Seed = 0

function ENT:Initialize()
	self:SetModelScale(0.05, 0)
	self:DrawShadow(false)

	self.Seed = math.Rand(0, 10)
end

--[[
local matGlow = Material("effects/splash2")
local matSplay = Material("particles/smokey")
function ENT:Draw()
	local owner = self:GetOwner()
	if GAMEMODE.NoDrawHumanProjectilesInFPS_H and not (owner == MySelf) and not owner:ShouldDrawLocalPlayer() then return end
	local type = self:GetDTInt(5)
	local c = type == 0 and Color(120, 205, 60, 70) or type == 1 and Color(205, 120, 60, 70) or Color(70, 195, 235, 70)
	self:SetColor(c)
	render.SetBlend(0.7)
	self:DrawModel()
	render.SetBlend(1)

	local pos = self:GetPos()
	local add = math.sin((CurTime() + self.Seed) * 3) * 2

	render.SetMaterial(matSplay)
	render.DrawSprite(pos, 8 - add, 8 + add, c)
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 12 + add, 12 - add, c)
end]]
local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local vector_origin = vector_origin

function ENT:Draw()
	local owner = self:GetOwner()
	if GAMEMODE.NoDrawHumanProjectilesInFPS_H and not (owner == MySelf) and not owner:ShouldDrawLocalPlayer() then return end
	local type = self:GetDTInt(5)
	local c = type == 0 and Color(120, 205, 60, 70) or type == 1 and Color(205, 120, 60, 70) or Color(70, 195, 235, 70)
	local c2 = type == 0 and {190, 255, 130} or type == 1 and {255, 150, 75} or {70, 195, 235}
	local c3 = type == 0 and Color(0, 255, 0, 255) or type == 1 and Color(255, 150, 0, 255) or Color(0, 255, 255, 255)
	self:SetColor(c)

	render.SuppressEngineLighting(true)
	render.SetBlend(0.75)
	self:DrawModel()
	render.SetBlend(1)
	render.SuppressEngineLighting(false)
	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 1 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 45)
		particle:SetDieTime(0.15)
		particle:SetStartAlpha(75)
		particle:SetEndAlpha(0)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetRollDelta(math.Rand(-10, 10))
		particle:SetColor(c2[1], c2[2], c2[3])
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)

	if self:GetVelocity() ~= vector_origin then
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, 15, 15, c)
		render.SetMaterial(matGlow2)
		render.DrawSprite(pos, 35, 35, c)
		render.DrawSprite(pos, 25, 25, c3)
	end
end


function ENT:OnRemove()
	local pos = self:GetPos()
	local type = self:GetDTInt(5)
	local c = type == 0 and Color(120, 205, 60) or type == 1 and Color(205, 120, 60) or Color(70, 195, 235)

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=1, 12 do
		particle = emitter:Add("particles/smokey", pos)
		particle:SetDieTime(0.4)
		particle:SetColor(c.r, c.g, c.b)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(0)
		particle:SetCollide(true)
		particle:SetGravity(Vector(0, 0, -300))
		particle:SetVelocity(VectorRand():GetNormal() * 120)
	end
	for i=0,5 do
		particle = emitter:Add("sprites/light_glow02_add", pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(1, 2))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(c.r, c.g, c.b)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
