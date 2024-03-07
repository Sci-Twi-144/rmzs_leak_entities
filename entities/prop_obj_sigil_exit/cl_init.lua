include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	--self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 200))

	self:CreateHook()
	self.AmbientSound = CreateSound(self, "ambient/levels/citadel/field_loop2.wav")
	self.AmbientSound2 = CreateSound(self, "ambient/levels/citadel/citadel_drone_loop3.wav")
end
--self.AmbientSound = CreateSound(self, "ambient/levels/citadel/field_loop2.wav")
--"ambient/levels/citadel/citadel_drone_loop3.wav"
function ENT:Think()
	if EyePos():DistToSqr(self:GetPos()) <= 4900000 then -- 700^2
		if self:IsOpened() or self:IsOpening() then
			self.AmbientSound:PlayEx(0.75, 150)
			self.AmbientSound2:PlayEx(0.5, 150)
		end
	else
		self.AmbientSound:Stop()
		self.AmbientSound2:Stop()
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
	self.AmbientSound2:Stop()
end

function ENT:CreateHook()
	local ent = self
	local ENTC = tostring(ent)

	local CModWhiteOut = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	}

	hook.Add("RenderScreenspaceEffects", ENTC, function()
		local eyepos = EyePos()
		local nearest = ent:NearestPoint(eyepos)
		local power = math.Clamp(1 - eyepos:DistToSqr(nearest) / 45000, 0, 0.7) ^ 2 * ent:GetOpenedPercent()

		if power > 0 then
			local size = 1 + power * 2

			CModWhiteOut["$pp_colour_brightness"] = power * 0.25
			if MySelf:GetObserverMode() == OBS_MODE_NONE then
				CModWhiteOut["$pp_colour_brightness"] = CModWhiteOut["$pp_colour_brightness"] / 2
			end
			DrawBloom(1 - power, power * 4, size, size, 1, 1, 1, 1, 1)
			DrawColorModify(CModWhiteOut)

			if render.SupportsPixelShaders_2_0() then
				local eyevec = EyeVector()
				local pos = ent:LocalToWorld(ent:OBBCenter()) - eyevec * 16
				pos.z = pos.z - 15
				local distance = eyepos:Distance(pos)
				local dot = (pos - eyepos):GetNormalized():Dot(eyevec) - distance * 0.001
				if dot > 0 then
					local srcpos = pos:ToScreen()
					DrawSunbeams(0.9, dot * power, 0.1, srcpos.x / w, srcpos.y / h)
				end
			end
		end
	end)
end

function ENT:RemoveHook()
	hook.Remove("RenderScreenspaceEffects", tostring(self))
end

function ENT:OnRemove()
	self:RemoveHook()
end

ENT.NextEmit = 0
ENT.Multi = 1

local matWhite = Material("models/debug/debugwhite")
local SigilMaterial = Material("models/rmzs/sigil/sigil_complex")

function ENT:DrawTranslucent()
	local curtime = CurTime()
	local rise = self:GetRise() ^ 2
	local normal = self:GetUp()
	local openedpercent = self:GetOpenedPercent()
	local basetint = Vector(2, 2, 2)
	local basetint2 = Vector(0.5, 0.5, 0.5)
	if self:IsOpened() or self:IsOpening() then
		self.Multi = math.min(self.Multi + 0.001, 2)
	end
	basetint2 = basetint2 * self.Multi or 1
	basetint = basetint * (2 - self.Multi) or 1

	SigilMaterial:SetVector("$emissiveblendtint", basetint)
	SigilMaterial:SetVector("$phongtint", basetint)
	SigilMaterial:SetVector("$color2", basetint2)
	SigilMaterial:SetVector("$cubemaptint", basetint2)

	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		local size = 100 + openedpercent * 200
		size = size * (1 + math.sin(curtime * math.pi) * 0.075)

		dlight.Pos = self:LocalToWorld(Vector(-24, 0, 40))
		dlight.r = 180
		dlight.g = 200
		dlight.b = 255
		dlight.Brightness = 1 + openedpercent * 4
		dlight.Size = size
		dlight.Decay = size * 2
		dlight.DieTime = curtime + 1
	end

	if self:IsOpened() then
		render.ModelMaterialOverride(matWhite)
	end
	render.SetBlend(0.5 * self.Multi)
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	render.SetBlend(1)
	if self:IsOpened() then
		render.ModelMaterialOverride(nil)
	end

	if curtime < self.NextEmit or openedpercent == 0 then return end
	self.NextEmit = curtime + 0.01 + (1 - openedpercent) * 0.15

	local dir = (tobool(math.random(2) == 2) and self:GetForward() or self:GetRight()) * (tobool(math.random(2) == 2) and 1.5 or 2) + VectorRand()
	dir:Normalize()
	local startpos = self:LocalToWorld(Vector(0, 0, 35))

	if ShouldDrawGlobalParticles(startpos) then
		local emitter = ParticleEmitter(startpos)
		emitter:SetNearClip(32, 48)

		for i=1, 4 do
			dir = dir * -1

			local particle = emitter:Add("sprites/glow04_noz", startpos + dir * 180)
			particle:SetDieTime(0.5)
			particle:SetVelocity(dir * -360)
			particle:SetStartAlpha(0)
			particle:SetEndAlpha(255 * openedpercent)
			particle:SetStartSize(math.Rand(2, 5) * openedpercent)
			particle:SetEndSize(0)
			if math.random(2) == 2 then
				particle:SetColor(220, 240, 255)
			end
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-5, 5))
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end