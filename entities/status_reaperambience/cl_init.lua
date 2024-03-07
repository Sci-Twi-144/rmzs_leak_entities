include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.NextEmit = 0
function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))

	self.AmbientSound = CreateSound(self, "npc/antlion_guard/growl_idle.wav")
	self.AmbientSound:PlayEx(0.55, 110)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	if self.AmbientSound then
		self.AmbientSound:PlayEx(0.67, 100 + math.sin(RealTime()))
	end
end

function ENT:DrawTranslucent()
	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.1
	local owner = self:GetOwner()
	local speed = owner:GetVelocity()

	if owner:IsValid() then
		local emitter = ParticleEmitter(self:GetPos())
		emitter:SetNearClip(40, 50)

		-- Body
		--[[
		local attach = owner:GetAttachment(owner:LookupAttachment("maw"))
		
		if attach then
			self:SetAngles(attach.Ang)
			local pos = attach.Pos - Vector(0, 0, 10)
			self:SetPos(pos)
			local particle = emitter:Add("effects/fire_cloud1", pos)
			self:Blood(particle,math.Rand(5, 10),speed)
		end
		]]
		-- Left Hand

		local attach = owner:GetAttachment(owner:LookupAttachment("Blood_Left"))

		if attach then
			self:SetAngles(attach.Ang)
			local pos = attach.Pos
			self:SetPos(pos)
			local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos)
			self:Blood(particle,math.Rand(4, 12),speed)
		end

		-- Right Hand
		local attach = owner:GetAttachment(owner:LookupAttachment("Blood_Right"))

		if attach then
			self:SetAngles(attach.Ang)
			local pos = attach.Pos
			self:SetPos(pos)
			local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos)
			self:Blood(particle,math.Rand(4, 12),speed)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	return
end

function ENT:Blood(particle, size, speed)
	particle:SetVelocity(speed)
	particle:SetDieTime(math.Rand(0.4, 0.6))
	particle:SetColor(255, 0, 0)
	particle:SetStartAlpha(255)
	particle:SetStartSize(size)
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-1, 1))
	particle:SetGravity(Vector(0,0,125))
	particle:SetCollide(true)
	particle:SetAirResistance(12)
end