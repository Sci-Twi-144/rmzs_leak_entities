ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.Seed = math.Rand(0, 10)

	local ENTC = tostring(self)
	local NextEmit = self.NextEmit
	local owner = self:GetOwner()

	hook.Add("Move", ENTC, function(pl, move)
		if not IsValid(self) then return end

		if pl ~= owner then return end

		local sloweffect = 1 - 0.4 * (pl.SlowEffTakenMul or 1)

		move:SetMaxSpeed(move:GetMaxSpeed() * sloweffect)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * sloweffect)
	end)

	if CLIENT then
		hook.Add("Draw", ENTC, function()
			if not IsValid(self) then return end
			
			if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
			if owner:GetZombieClassTable().IgnoreTargetAssist then return end

			if SpawnProtection[owner] then return end

			if CurTime() < NextEmit then return end
			NextEmit = CurTime() + 0.5

			local pos = owner:WorldSpaceCenter()
			pos.z = pos.z + 24

			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(16, 24)

			for i = 1, 3 do
				particle = emitter:Add("sprites/light_glow02_add", pos + VectorRand() * 12)
				particle:SetDieTime(math.Rand(1.1, 1.2))
				particle:SetStartAlpha(160)
				particle:SetEndAlpha(0)
				particle:SetStartSize(2)
				particle:SetEndSize(0)
				particle:SetGravity(Vector(0, 0, -155))
				particle:SetAirResistance(300)
				particle:SetStartLength(1)
				particle:SetEndLength(35)
				particle:SetColor(90, 140, 30)
			end

			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end)
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	self:GetOwner().DimVision = nil

	local ENTC = tostring(self)
	hook.Remove("Move", ENTC)
	hook.Remove("Draw", ENTC)
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end
