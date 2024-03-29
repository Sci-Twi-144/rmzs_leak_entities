include("shared.lua")

local matWhite = Material("models/debug/debugwhite")
local matGlow = Material("sprites/light_glow02_add")

function ENT:Draw()
	local alt = self:GetDTBool(0)
	local alt2 = self:GetDTBool(1)

	render.ModelMaterialOverride(matWhite)
	render.SetColorModulation(0.5, 0.5, 1)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride(nil)

	if self:GetVelocity():LengthSqr() > 100 then
		self:SetAngles(self:GetVelocity():Angle())

		render.SetMaterial(matGlow)

		local glowcol = Color(128, 128, 255)

		render.DrawSprite(self:GetPos(), 15, 3, glowcol)
		render.DrawSprite(self:GetPos(), 3, 15, glowcol)
	end
end

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:OnRemove()
	local pos = self:GetPos()
	local alt = self:GetDTBool(0)
	local alt2 = self:GetDTBool(1)

	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)
		for i=0,30 do
			local particle = emitter:Add(matGlow, pos)
			particle:SetVelocity(VectorRand() * 45)
			particle:SetDieTime(0.3)
			particle:SetStartAlpha(160)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(2, 6))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(-0.8, 0.8))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetColor(128, 128, 255)
		end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
