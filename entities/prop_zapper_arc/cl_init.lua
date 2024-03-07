include("shared.lua")
ENT.IsArk = true
local arcscolor = Color(150, 150, 150)
function ENT:Initialize()
	local matrix = Matrix()
	--matrix:Scale(Vector(0.85, 0.85, 1.2))
	--matrix:SetTranslation( Vector(0, 0, -10))
	--self:SetBodygroup(1,1)
	self:EnableMatrix( "RenderMultiply", matrix )

	self.AmbientSound = CreateSound(self, "ambient/machines/combine_shield_touch_loop1.wav")
	self.AmbientSound:SetSoundLevel(65)
	self.PointMatrices = {}

	--[[local cmodel = ClientsideModel("models/props_trainstation/trainstation_ornament002.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, 0, -25.6)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(Color(195, 195, 145))
		cmodel:SetParent(self)
		cmodel:SetOwner(self)

		matrix = Matrix()
		matrix:Scale(Vector(2, 2, 0.25))
		cmodel:EnableMatrix( "RenderMultiply", matrix )

		cmodel:Spawn()

		self.CModel = cmodel
	end

	cmodel = ClientsideModel("models/props_c17/utilityconnecter005.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, -2, 25.6)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, -70)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(arcscolor)
		cmodel:SetMaterial("models/shiny")
		cmodel:SetParent(self)
		cmodel:SetOwner(self)

		matrix = Matrix()
		matrix:Scale(Vector(2, 1.25, 0.25))
		cmodel:EnableMatrix( "RenderMultiply", matrix )

		cmodel:Spawn()

		self.ArcOne = cmodel
	end

	cmodel = ClientsideModel("models/props_c17/utilityconnecter005.mdl")
	if cmodel:IsValid() then
		cmodel:SetPos(self:LocalToWorld(Vector(0, 2, 25.6)))
		cmodel:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 70)))
		cmodel:SetSolid(SOLID_NONE)
		cmodel:SetMoveType(MOVETYPE_NONE)
		cmodel:SetColor(arcscolor)
		cmodel:SetMaterial("models/shiny")
		cmodel:SetParent(self)
		cmodel:SetOwner(self)

		matrix = Matrix()
		matrix:Scale(Vector(2, 1.25, 0.25))
		cmodel:EnableMatrix( "RenderMultiply", matrix )

		cmodel:Spawn()

		self.ArcTwo = cmodel
	end]]
end

local material = Material("models/shiny")
local matBeam = Material("trails/electric")
function ENT:DrawZapper()
	--[[render.ModelMaterialOverride(material)
	render.SetColorModulation(0.4, 0.4, 0.4)
	self:DrawModel()
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)]]
	self:DrawModel()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 1 then
		local charge = math.Clamp(29 - ((self:GetNextZap() - CurTime())/4.5)*49, -20, 34)
		local spread = ((20 +charge)/34)*9

		local pos1 = self:LocalToWorld(Vector(-10, spread, 0 + charge/4)) --+ VectorRand()/1.5
		local pos2 = self:LocalToWorld(Vector(-10, -spread, 0 + charge/4)) --+ VectorRand()/1.5
		local pos3 = self:LocalToWorld(Vector(0, 0, -3 + charge)) --+ VectorRand()/1.5

		-- pos1.z = pos1.z + charge/2.5
		-- pos2.z = pos2.z + charge/2.5

		--render.SetMaterial(matBeam)
		--render.DrawBeam(pos1, pos3, 1, 0, 1, COLOR_CYAN)
		--render.DrawBeam(pos2, pos3, 1, 0, 1, COLOR_CYAN)
		self:DrawLightning(pos1, pos3, 1, false, true, COLOR_CYAN)
		self:DrawLightning(pos2, pos3, 2, false, true, COLOR_CYAN)
	end
end

local beam1mat = Material("trails/electric", "smooth")
function ENT:DrawLightning(startpos, endpos, iteration, sizable, randomdivides)
	local pi = math.pi
	local dir = endpos - startpos
	local dirnorm = dir:GetNormalized()
	local life = 0.2
	
	local function Dir()
		local ang = dir:Angle()
		local forward = ang:Forward()
		ang:RotateAroundAxis(forward, math.random(360))
		return ang:Up()
	end
	
	if not self.PointMatrices[iteration] or self.PointMatrices[iteration][2] < CurTime() then
		local points = randomdivides and math.random(15,20) or 10
		self.PointMatrices[iteration] = {}
		self.PointMatrices[iteration][1] = {}
		for i = 1, points do
			table.insert(self.PointMatrices[iteration][1], i, Dir())
		end
		self.PointMatrices[iteration][2] = CurTime() + life
	end
	if self.PointMatrices[iteration] then
		render.SetMaterial(beam1mat)
		local ldelta = math.Clamp((self.PointMatrices[iteration][2] - CurTime())/life, 0, 1)
		local count = #self.PointMatrices[iteration][1]
		local tbl = self.PointMatrices[iteration][1]
		local between = dir:LengthSqr()^0.5 / (count - 1)
		render.StartBeam(count)
			for i=1, count do
				local sinmod = math.sin(i/count * pi)
				render.AddBeam(startpos + dirnorm * between * (i - 1) + tbl[i] * 0.5 * (2 - ldelta), 6 * sinmod, 1, Color(190, 190, 255, 255 * ldelta))
			end
		render.EndBeam()
	end
end

function ENT:Think()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 2 then
		local charge = math.Clamp(29 - ((self:GetNextZap() - CurTime())/4.5)*49, -20, 25)

		self.AmbientSound:PlayEx(0.6, 65 + charge/1.5)

		if CurTime() >= self.NextEmit then
			self.NextEmit = CurTime() + 0.2

			local pos = self:LocalToWorld(Vector(0, 0, 36))
			
			if ShouldDrawGlobalParticles(pos) then
				local emitter = ParticleEmitter(pos)
				emitter:SetNearClip(24, 32)

				for i=1, 2 do
					local particle = emitter:Add("effects/blueflare1", pos)
					particle:SetDieTime(0.3)
					particle:SetColor(110,130,245)
					particle:SetStartAlpha(200)
					particle:SetEndAlpha(0)
					particle:SetStartSize(1)
					particle:SetEndSize(0)
					particle:SetVelocity(VectorRand():GetNormal() * 20)
				end

				local chargepos = self:LocalToWorld(Vector(0, 0, charge))

				for i=1, 6 do
					local particle = emitter:Add("effects/blueflare1", chargepos)
					particle:SetDieTime(0.4)
					particle:SetColor(110,130,245)
					particle:SetStartAlpha(200)
					particle:SetEndAlpha(0)
					particle:SetStartSize(2)
					particle:SetEndSize(0)
					particle:SetVelocity(VectorRand():GetNormal() * 20)
				end

				emitter:Finish() emitter = nil collectgarbage("step", 64)
			end
		end
	else
		self.AmbientSound:Stop()
	end

	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:OnRemove()
	self.AmbientSound:Stop()

	if self.CModel and self.CModel:IsValid() then
		self.CModel:Remove()
	end

	if self.ArcOne and self.ArcOne:IsValid() then
		self.ArcOne:Remove()
	end

	if self.ArcTwo and self.ArcTwo:IsValid() then
		self.ArcTwo:Remove()
	end
end