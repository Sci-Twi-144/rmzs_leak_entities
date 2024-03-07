include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local color = Color(110,0,200)
local matGlow = Material("effects/splashwake1")
local matGlow2 = Material("sprites/glow04_noz")
local vector_origin = vector_origin

function ENT:Draw()
	render.SetBlend(0)
	render.SetColorModulation(0.45, 0, 1)
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
end

function ENT:Initialize()
	self:EmitSound("items/suitchargeok1.wav", 100, 250)
	self:EmitSound("hl1/ambience/particle_suck1.wav", 100, 150)
	self:EmitSound("ambient/levels/labs/electric_explosion1.wav", 100, 250)
	local cmodel = ClientsideModel("models/weapons/rmzs/scythe/w_grotesque.mdl", RENDERGROUP_TRANSLUCENT)
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(10, 0, 90)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetParent(self)
		cmodel:SetOwner(self)
		cmodel:SetModelScale(1, 0)
		cmodel:SetMaterial("models/debug/debugwhite")
		cmodel:SetColor(color)
		cmodel:Spawn()
		cmodel.RenderOverride = function(self)
			render.SuppressEngineLighting(true)
			render.SetBlend(0.5)
			self:DrawModel()
			render.SetBlend(1)
			render.SuppressEngineLighting(false)

			local pos = cmodel:LocalToWorld(Vector(30, 5, 30))

			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)
			local particle
			for i=1, 75 do
				particle = emitter:Add("effects/splash2", pos)
				particle:SetDieTime(0.1)
				particle:SetColor(110, 0, 200)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(2)
				particle:SetEndSize(0)
				particle:SetStartLength(1)
				particle:SetEndLength(15)
				particle:SetVelocity(VectorRand():GetNormal() * 200)
			end

			for i=0, 4 do
				particle = emitter:Add("sprites/glow04_noz", pos)
				particle:SetVelocity(VectorRand() * math.random(70, 130))
				particle:SetDieTime(2)
				particle:SetStartAlpha(200)
				particle:SetEndAlpha(100)
				particle:SetStartSize(3)
				particle:SetEndSize(0)
				particle:SetRollDelta(math.Rand(-10, 10))
				particle:SetColor(255, 0, 255)
				particle:SetAirResistance(255)
			end
			emitter:Finish() emitter = nil collectgarbage("step", 64)


		end

		self.CModel = cmodel
	end
end

function ENT:Think()
	self.CModel:SetLocalAngles(angle_zero + Angle(10, CurTime() * 512, 90))
end

function ENT:OnRemove()
	if self.CModel and self.CModel:IsValid() then
		self.CModel:Remove()
	end

	local pos = self:GetPos()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
	local particle
	for i=0, 19 do
		particle = emitter:Add(matGlow, pos)
		particle:SetVelocity(VectorRand() * 25)
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(10, 15))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(color.r, color.g, color.b)
	end
	for i=0,5 do
		particle = emitter:Add(matGlow2, pos)
		particle:SetVelocity(VectorRand() * 5)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(60, 70))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.8, 0.8))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetColor(color.r + 20, color.g + 20, color.b + 20)
	end
	for i=1, 45 do
		particle = emitter:Add("effects/splash2", pos)
		particle:SetDieTime(0.6)
		particle:SetColor(color.r, color.g, color.b)
		particle:SetStartAlpha(125)
		particle:SetEndAlpha(0)
		particle:SetStartSize(15)
		particle:SetEndSize(0)
		particle:SetStartLength(1)
		particle:SetEndLength(5)
		particle:SetVelocity(VectorRand():GetNormal() * 50)
	end
	emitter:Finish() emitter = nil collectgarbage("step", 64)
end
