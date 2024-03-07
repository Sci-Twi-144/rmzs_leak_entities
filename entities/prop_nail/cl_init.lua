include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.NextEmit = 0

function ENT:Initialize()
	local baseent=self:GetBaseEntity()
	if not baseent.Nails then baseent.Nails = {} end

	if IsValid(baseent) and baseent.Nails then
		table.insert(baseent.Nails, self)
	end
end

function ENT:SetAttachEntity(ent, physbone1, physbone2)
	self.m_AttachEntity = ent
end

function ENT:OnRemove()
	local baseent=self:GetBaseEntity()
	
	if not baseent.Nails then baseent.Nails = {} end
	
	if IsValid(baseent) and baseent.Nails then
		table.RemoveByValue(baseent.Nails, self)
	end
end

function ENT:Think()
	if self:GetNailHealth() / self:GetMaxNailHealth() < 0.35 and CurTime() > self.NextEmit then
		local normal = self:GetForward() * -1
		local pos = self:GetPos()
		local epos = pos + normal

		sound.Play("physics/metal/metal_box_impact_bullet"..math.random(1, 3)..".wav", pos, 58, math.random(210, 240))

		if ShouldDrawGlobalParticles(epos) then
			local emitter = ParticleEmitter(epos)
			emitter:SetNearClip(22, 32)
			for i=1, math.random(6, 12) do
				local vNormal = (VectorRand() * 0.6 + normal):GetNormalized()

				local particle = emitter:Add("effects/spark", epos + vNormal)
				particle:SetDieTime(math.Rand(0.1, 0.2))
				particle:SetGravity(Vector(math.random(-5, 5), math.random(-5, 5), math.random(1, 3)):GetNormal() * 50)
				particle:SetStartAlpha(100)
				particle:SetEndAlpha(0)
				particle:SetStartSize(4)
				particle:SetEndSize(1)
				particle:SetStartLength(10)
				particle:SetEndLength(0)
				particle:SetColor(165, 188, 0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-20, 20))
			end
			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end

		self.NextEmit = CurTime() + math.Rand(4.2, 5.8)
	end
end