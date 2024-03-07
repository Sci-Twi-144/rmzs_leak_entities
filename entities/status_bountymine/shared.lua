ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Magnitude", "Int", 1)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local enty = self
	if SERVER then
		self:CreateSVHook(enty)
	end

	if CLIENT then
		hook.Add("Draw", tostring(enty), function()
			if not IsValid(self) then return end
			
			local owner = enty:GetOwner()
			if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
			if owner:GetZombieClassTable().IgnoreTargetAssist then return end
		
			if SpawnProtection[owner] then return end
		
			if CurTime() < enty.NextEmit then return end
			enty.NextEmit = CurTime() + 0.5
		
			local pos = owner:WorldSpaceCenter()
		
			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(16, 24)
		
			for i = 1, 2 do
				particle = emitter:Add("sprites/light_glow02_add", pos + VectorRand() * 12)
				particle:SetDieTime(math.Rand(1.1, 1.2))
				particle:SetStartAlpha(230)
				particle:SetEndAlpha(0)
				particle:SetStartSize(2)
				particle:SetEndSize(0)
				particle:SetGravity(Vector(0, 0, 75))
				particle:SetAirResistance(300)
				particle:SetStartLength(1)
				particle:SetEndLength(35)
				particle:SetColor(157, 84, 224)
			end
		
			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end)		
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if SERVER then
		self:RemoveSVHook(tostring(self))
	end

	if CLIENT then
		hook.Remove("Draw", tostring(self))
	end
end

function ENT:SetDamage(damage)
	local ddmg = math.Clamp(damage, 0.05, 1)
	self:SetDTFloat(5, ddmg)
	self:SetMagnitude(math.ceil(ddmg * 100))
end

function ENT:GetDamage()
	if self:GetDTFloat(5) >= 0.05 then -- ebic
		return self:GetDTFloat(5)
	end
end