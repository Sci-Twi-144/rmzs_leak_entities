include("shared.lua")

ENT.NextEmit = 0

local Bones = {"ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_L_Foot"}
function ENT:Draw()
	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.05

	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end

	local boneid, particle, pos

	local emitter = ParticleEmitter(owner:GetPos())
	emitter:SetNearClip(12, 16)

	for _, bonename in pairs(Bones) do
		boneid = owner:LookupBone(bonename)
		if boneid and boneid > 0 then
			pos = owner:GetBonePositionMatrixed(boneid)
			if pos then
				pos.z = pos.z + 8

				particle = emitter:Add("particle/smokesprites_0001", pos)
				particle:SetDieTime(math.Rand(1, 1.3))
				particle:SetVelocity(Vector(math.Rand(-12, 12), math.Rand(-12, 12), 0))
				particle:SetGravity(Vector(0, 0, -20))
				particle:SetColor(0, 80, 0)
				particle:SetAirResistance(8)
				particle:SetStartAlpha(100)
				particle:SetEndAlpha(0)
				particle:SetStartSize(1)
				particle:SetEndSize(14)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-10, 10))
			end
		end
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end

function ENT:GetPower()
	return math.Clamp(self:GetStartTime() + self:GetDuration() - CurTime(), 0, 1)
end