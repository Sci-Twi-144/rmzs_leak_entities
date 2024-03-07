include("shared.lua")

ENT.NextEmit = 0

local materialp = {}
materialp["$refractamount"] = 0.02
materialp["$colortint"] = "[1.6 1.3 1.0]"
materialp["$SilhouetteColor"] = "[5.0 3.5 2.1]"
materialp["$BlurAmount"] = 0.04
materialp["$SilhouetteThickness"] = 0.05
materialp["$normalmap"] = "effects/combineshield/comshieldwall"
function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner.ShadeShield = self
	end

	self:EmitSound("weapons/physcannon/physcannon_charge.wav", 70, 250)

	self.AmbientSound = CreateSound(self, "weapons/physcannon/superphys_hold_loop.wav")
	self.ShieldMaterial = CreateMaterial("shadeshield" .. self:EntIndex(), "Aftershock_dx9", materialp)

	self:CreateHook()
end

function ENT:CreateHook()
	local ent = self
	local ENTC = tostring(ent)

	hook.Add("Move", ENTC, function(pl, move)
		if not IsValid(self) then return end

		if pl ~= ent:GetOwner() then return end
	
		move:SetMaxSpeed(0)
		move:SetMaxClientSpeed(0)
	end)

	hook.Add("CreateMove", ENTC, function(cmd)
		if not IsValid(self) then return end

		if MySelf ~= ent:GetOwner() then return end
	
		if bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 then
			cmd:SetButtons(cmd:GetButtons() - IN_JUMP)
		end
	end)

	hook.Add("ShouldDrawLocalPlayer", ENTC, function(pl)
		if not IsValid(self) then return end
		
		if pl ~= ent:GetOwner() then return end
	
		return true
	end)
end

function ENT:RemoveHook()
	local ENTC = tostring(self)
	hook.Remove("Move", ENTC)
	hook.Remove("CreateMove", ENTC)
	hook.Remove("ShouldDrawLocalPlayer", ENTC)
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner.ShadeShield = nil
	end

	self.AmbientSound:Stop()
	self:RemoveHook()
end

function ENT:Think()
	local curtime = CurTime()

	if self:GetStateEndTime() <= curtime and self:GetState() == 0 then
		self.AmbientSound:PlayEx(0.77, 53)

		if curtime >= self.NextEmit then
			self.NextEmit = curtime + 0.05

			local pos = self:WorldSpaceCenter()
			pos.z = pos.z + 8
			local owner = self:GetOwner()

			if ShouldDrawGlobalParticles(pos) then
				local emitter = ParticleEmitter(pos)
				local handpos = owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH")).Pos
				emitter:SetNearClip(16, 24)

				local particle = emitter:Add("sprites/glow04_noz", handpos)
				local dir = (pos - handpos + (VectorRand() * 2)):GetNormalized()
				particle:SetVelocity(dir * math.Rand(120, 125))
				particle:SetDieTime(math.Rand(0.25, 0.27))
				particle:SetStartAlpha(math.Rand(230, 250))
				particle:SetEndAlpha(0)
				particle:SetStartSize(1)
				particle:SetEndSize(math.Rand(12, 14))
				particle:SetColor(125, 75, 0)

				emitter:Finish() emitter = nil collectgarbage("step", 64)
			end
		end
	elseif self:GetState() == 1 then
		self.AmbientSound:Stop()
	end
end

local matWhite = Material("models/debug/debugwhite")
function ENT:DrawTranslucent()
	local curtime = CurTime()
	local diff = self:GetStateEndTime() - curtime
	local scalar = self:GetState() == 1 and diff or 0.5 - diff
	local scale = math.Clamp((scalar ^ 2)/0.25, 0, 1)

	local mul = self:GetObjectHealth()/self:GetMaxObjectHealth()
	render.SetColorModulation(0.5, 0.25 * mul/2, 0)
	local blend = 0.3 + math.abs(math.cos(CurTime())) ^ 2 * 0.1
	render.SetBlend(blend * scale)
	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride(matWhite)

	self:DrawModel()

	render.SetColorModulation(1, 1, 1)
	render.SuppressEngineLighting(false)
	render.ModelMaterialOverride()
	render.SetBlend(1)

	if render.SupportsPixelShaders_2_0() then
		self.ShieldMaterial:SetFloat("$refractamount", 0.01 * scale)
		self.ShieldMaterial:SetFloat("$BlurAmount", 0.01 * scale)
		render.UpdateRefractTexture()

		render.ModelMaterialOverride(self.ShieldMaterial)
		nodraw = true
		self:DrawModel()
		nodraw = false
		render.ModelMaterialOverride(0)
	end
end
