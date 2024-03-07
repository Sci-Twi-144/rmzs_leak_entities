ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if CLIENT then
		local ent = self
		hook.Add("Draw", tostring(ent), function()
			if not IsValid(self) then return end
			
			local owner = ent:GetOwner()
			if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
			if owner:GetZombieClassTable().IgnoreTargetAssist then return end
		
			if SpawnProtection[owner] then return end
		
			if CurTime() < ent.NextEmit then return end
			ent.NextEmit = CurTime() + 0.15
		
			local pos = owner:WorldSpaceCenter()
			pos.z = pos.z + 12
		
			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(16, 24)
		
			for i = 1, 3 do
				particle = emitter:Add("trails/electric", pos + VectorRand() * 8)
				particle:SetDieTime(0.1)
				particle:SetStartAlpha(230)
				particle:SetEndAlpha(0)
				particle:SetStartSize(2)
				particle:SetEndSize(0)
				particle:SetVelocity(VectorRand() * 5)
				particle:SetAirResistance(300)
				particle:SetStartLength(12)
				particle:SetEndLength(12)
				particle:SetColor(150, 255, 150)
			end
		
			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end)
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if CLIENT then
		hook.Remove("Draw", tostring(self))
	end
end

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)