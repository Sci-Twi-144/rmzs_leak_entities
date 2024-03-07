include("shared.lua")

function ENT:Initialize()
	local alt = self:GetDTBool(0)
	local cmodel = ClientsideModel("models/healthvial.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(-4, 0, 0)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(90, 0, 0)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(Color(alt and 255 or 75, 75, alt and 75 or 255))
		cmodel:SetParent(self)
		cmodel:SetOwner(self)
		cmodel:SetModelScale(0.4, 0)
		cmodel:Spawn()

		self.CModel = cmodel
	end
end

local matOverride = Material("models/shiny")
function ENT:Draw()
	local alt = self:GetDTInt(15) == 1
	local alt2 = self:GetDTInt(15) == 2
	if alt2 then
		render.SetColorModulation(0.3, 0.88, 0.43)
	else
		render.SetColorModulation(alt and 1 or 0.3, 0.4, alt and 0.3 or 1)
	end
	render.ModelMaterialOverride(matOverride)

	self:DrawModel()

	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)

	if self:GetMoveType() == MOVETYPE_NONE or CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.01

	local pos = self:GetPos()

	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		local particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(self:GetVelocity() * -0.1 + VectorRand() * 30)
		particle:SetDieTime(0.35)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(2)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 255))
		particle:SetRollDelta(math.Rand(-10, 10))
		if alt2 then
			particle:SetColor(75, 215, 110)
		else
			particle:SetColor(alt and 255 or 90, 140, alt and 90 or 255)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
