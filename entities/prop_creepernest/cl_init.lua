include("shared.lua")

ENT.Seed = 0
ENT.Tall = 0
ENT.LocalRotation2 = 0
ENT.MulForPolip = 0
ENT.NextStage = 1

ENT.Polip1Multi = 0
ENT.Polip2Multi = 0
ENT.Polip3Multi = 0

function ENT:Initialize()
	local dist = math.max(16, GAMEMODE.CreeperNestDist) * 2

	self:SetModelScale(0.2, 0)
	self:SetRenderBounds(Vector(-dist, -dist, -dist), Vector(dist, dist, dist))
	self:ManipulateBoneScale(0, self.ModelScale)

	self.Polip1Multi = 1 + 1 / math.random(3, 6)
	self.Polip2Multi = 1 + 1 / math.random(3, 6)
	self.Polip3Multi = 1 + 1 / math.random(3, 6)

	self.AmbientSound = CreateSound(self, "ambient/levels/citadel/citadel_drone_loop5.wav")

	self.FloorModel = ClientsideModel("models/props_wasteland/antlionhill.mdl")
	if self.FloorModel:IsValid() then
		self.FloorModel:SetParent(self)
		self.FloorModel:SetOwner(self)
		self.FloorModel:SetPos(self:GetPos())
		self.FloorModel:SetAngles(self:GetAngles())
		self.FloorModel:Spawn()
		self.FloorModel:ManipulateBoneScale(0, Vector(0.01, 0.01, 0.01))
		self.FloorModel:SetMaterial("models/flesh")
		self.FloorModel:SetSolid(SOLID_NONE)
	end

	ent = ClientsideModel("models/props_junk/trashcluster01a.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 0, 1))
        ent:SetLocalAngles(angle_zero)
        ent:SetMaterial("models/flesh")
		
        matrix = Matrix()
        matrix:Scale(Vector(0, 0, 0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
		ent:SetSolid(SOLID_NONE)
        self.SelfBase = ent
    end

	polip = ClientsideModel("models/rmzs/flesh/meat_polyp.mdl")
    if polip:IsValid() then
        polip:SetParent(self)
        polip:SetLocalPos(vector_origin + Vector(0, 35, 0))
        polip:SetLocalAngles(angle_zero + Angle(0, math.random(360), 0))
        --polip:SetMaterial("models/flesh")
		
        matrix = Matrix()
        matrix:Scale(Vector(0,0,0))
        polip:EnableMatrix("RenderMultiply", matrix)

        polip:Spawn()
		polip:SetSolid(SOLID_NONE)
        self.Polip1 = polip
    end

	ent = ClientsideModel("models/props_junk/trashcluster01a.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, 35, 1))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))
        ent:SetLocalAngles(angle_zero)
        ent:SetMaterial("models/flesh")
		
        matrix = Matrix()
        matrix:Scale(Vector(0,0,0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
		ent:SetSolid(SOLID_NONE)
        self.Polip1base = ent
    end

	polip2 = ClientsideModel("models/rmzs/flesh/meat_polyp.mdl")
    if polip2:IsValid() then
        polip2:SetParent(self)
        polip2:SetLocalPos(vector_origin + Vector(30, -20, 0))
        polip2:SetLocalAngles(angle_zero + Angle(0, math.random(360), 0))
        --polip2:SetMaterial("models/flesh")
		
        matrix = Matrix()
        matrix:Scale(Vector(0,0,0))
        polip2:EnableMatrix("RenderMultiply", matrix)

        polip2:Spawn()
		polip2:SetSolid(SOLID_NONE)
        self.Polip2 = polip2
    end

	ent = ClientsideModel("models/props_junk/trashcluster01a.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(30, -20, 1))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))
        ent:SetLocalAngles(angle_zero)
        ent:SetMaterial("models/flesh")
		
        matrix = Matrix()
        matrix:Scale(Vector(0,0,0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
		ent:SetSolid(SOLID_NONE)
        self.Polip2base = ent
    end

	polip3 = ClientsideModel("models/rmzs/flesh/meat_polyp.mdl")
    if polip3:IsValid() then
        polip3:SetParent(self)
        polip3:SetLocalPos(vector_origin + Vector(-25, -25, 0))
        polip3:SetLocalAngles(angle_zero + Angle(0, math.random(360), 0))
        --polip3:SetMaterial("models/flesh")
		
        matrix = Matrix()
        matrix:Scale(Vector(0,0,0))
        polip3:EnableMatrix("RenderMultiply", matrix)

        polip3:Spawn()
		polip3:SetSolid(SOLID_NONE)
        self.Polip3 = polip3
    end

	ent = ClientsideModel("models/props_junk/trashcluster01a.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(-25, -25, 1))
        ent:SetLocalAngles(angle_zero + Angle(0, 0, 0))
        ent:SetLocalAngles(angle_zero)
        ent:SetMaterial("models/flesh")
		
        matrix = Matrix()
        matrix:Scale(Vector(0,0,0))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
		ent:SetSolid(SOLID_NONE)
        self.Polip3base = ent
    end

	self.Seed = math.Rand(0, 10)
end

local EmitSounds = {
	Sound("physics/flesh/flesh_squishy_impact_hard1.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard2.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard3.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard4.wav"),
	Sound(")npc/barnacle/barnacle_die1.wav"),
	Sound(")npc/barnacle/barnacle_die2.wav"),
	Sound(")npc/barnacle/barnacle_digesting1.wav"),
	Sound(")npc/barnacle/barnacle_digesting2.wav"),
	Sound(")npc/barnacle/barnacle_gulp1.wav"),
	Sound(")npc/barnacle/barnacle_gulp2.wav")
}

function ENT:Think()
	self.Tall = math.Approach(self.Tall, math.Clamp(self:GetNestHealth() / self:GetNestMaxHealth(), 0.001, 1), FrameTime())

	if self.LocalRotation2 < CurTime() then
		self.LocalRotation2 = CurTime() + 0.1
		if (self:GetNestMutationLevel() == self.NextStage) then
			self.MulForPolip = math.min(1, self.MulForPolip + 0.05)
			if self.MulForPolip == 1 then
				self.NextStage = self.NextStage + 1
				self.MulForPolip = 0
			end
		end

		if MySelf:IsValid() and MySelf:Team() == TEAM_UNDEAD then
			local blocked = false
			local nearest = self:GetPos()
			for _, human in pairs(team.GetPlayers(TEAM_HUMAN)) do
				if util.SkewedDistance(human:GetPos(), nearest, 2.75) <= GAMEMODE.CreeperNestDist then
					blocked = true
					break
				end
			end
	
			self.Blocked = blocked
		end

		if self.Polip1:IsValid() and self.Polip1base:IsValid() and (1 == self.NextStage) then
			matrix = Matrix()
			matrix:Scale(Vector(1, 1, 1) * self.MulForPolip * self.Polip1Multi)
			self.Polip1:EnableMatrix("RenderMultiply", matrix)
			matrix = Matrix()
			matrix:Scale(Vector(1.2, 0.6, 0.15) * self.MulForPolip * self.Polip1Multi)
			self.Polip1base:EnableMatrix("RenderMultiply", matrix)
		end

		if self.Polip2:IsValid() and self.Polip2base:IsValid() and (2 == self.NextStage) then
			matrix = Matrix()
			matrix:Scale(Vector(1, 1, 1) * self.MulForPolip * self.Polip2Multi)
			self.Polip2:EnableMatrix("RenderMultiply", matrix)
			matrix = Matrix()
			matrix:Scale(Vector(1.2, 0.6, 0.15) * self.MulForPolip * self.Polip2Multi)
			self.Polip2base:EnableMatrix("RenderMultiply", matrix)
		end

		if self.Polip3:IsValid() and self.Polip3base:IsValid() and (3 == self.NextStage) then
			matrix = Matrix()
			matrix:Scale(Vector(1, 1, 1) * self.MulForPolip * self.Polip3Multi)
			self.Polip3:EnableMatrix("RenderMultiply", matrix)
			matrix = Matrix()
			matrix:Scale(Vector(1.2, 0.6, 0.15) * self.MulForPolip * self.Polip3Multi)
			self.Polip3base:EnableMatrix("RenderMultiply", matrix)
		end
	end

	if self.SelfBase:IsValid() and not self:GetDTBool(0) then
		local mul = self:GetNestHealth() / 350
		matrix = Matrix()
        matrix:Scale(Vector(1.75 * mul, 0.75 * mul, 0.15 * mul))
		self.SelfBase:EnableMatrix("RenderMultiply", matrix)
	end

	if self.FloorModel:IsValid() then
		local a = math.abs(math.sin(CurTime())) ^ 3
		local hscale = 0.2 + a * 0.04
		self.FloorModel:ManipulateBoneScale(0, Vector(hscale * 1.1 + 0.05, hscale * 1.1 + 0.05, 0.02 * self.Tall))
	end

	if self.DoEmitNextFrame then
		self.DoEmitNextFrame = nil
		self:EmitSound(EmitSounds[math.random(#EmitSounds)], 65, math.random(95, 105))
	end

	self.AmbientSound:PlayEx(0.6, 100 + CurTime() % 1)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()

	if self.Polip1:IsValid() then
		self.Polip1:Remove()
	end
	if self.Polip1base:IsValid() then
		self.Polip1base:Remove()
	end
	if self.Polip2:IsValid() then
		self.Polip2:Remove()
	end
	if self.Polip2base:IsValid() then
		self.Polip2base:Remove()
	end
	if self.Polip3:IsValid() then
		self.Polip3:Remove()
	end
	if self.Polip3base:IsValid() then
		self.Polip3base:Remove()
	end
	if self.SelfBase:IsValid() then
		self.SelfBase:Remove()
	end
	if self.FloorModel:IsValid() then
		self.FloorModel:Remove()
	end
end

ENT.NextEmit = 0
local gravParticle = Vector(0, 0, -200)
local matFlesh = Material("models/flesh")
local matWireframe = Material("models/wireframe")
function ENT:Draw()
	local curtime = CurTime() + self.Seed
	local a = math.abs(math.sin(curtime)) ^ 3
	local hscale = 0.2 + a * 0.04
	local built = self:GetNestBuilt()
	local floormodel = self.FloorModel
	local fmvalid = floormodel:IsValid()

	if built then
		render.ModelMaterialOverride(matFlesh)
	else
		render.ModelMaterialOverride(matWireframe)
		render.SetColorModulation(self.Tall, 0, 0)
	end

	if fmvalid then
		floormodel:ManipulateBoneScale(0, Vector(hscale * 1.1 + 0.05, hscale * 1.1 + 0.05, 0.02 * self.Tall))
	end

	self:ManipulateBoneScale(0, Vector(hscale * 5, hscale * 5, (0.5 - a * 0.025) * self.Tall))
	self:DrawModel()

	render.SetColorModulation(1, 1, 1)
	render.ModelMaterialOverride()

	if not built or curtime < self.NextEmit then return end
	self.NextEmit = curtime + math.Rand(0.4, 2)

	if math.random(4) == 1 then
		self.DoEmitNextFrame = true
	end

	local pos = self:GetPos() + self:GetUp() * 8

	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(16, 24)

		for i=0, math.Rand(0, 1) ^ 0.5 * 10 do
			local particle = emitter:Add("!sprite_bloodspray"..math.random(8), pos)
			particle:SetGravity(gravParticle)
			particle:SetDieTime(math.Rand(4, 6))
			particle:SetVelocity(Angle(math.Rand(-85, -70), math.Rand(0, 360), 0):Forward() * math.Rand(100, 200))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(math.Rand(2, 4))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-2, 2))
			particle:SetColor(180, 0, 0)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
