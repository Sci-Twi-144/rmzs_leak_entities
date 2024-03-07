ENT.Type = "anim"
ENT.Base = "status__base"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetEndTime(time)
	self:SetDTFloat(0, time)
end

function ENT:GetEndTime()
	return self:GetDTFloat(0)
end

function ENT:SetStartTime(time)
	self:SetDTFloat(1, time)
end

function ENT:GetStartTime()
	return self:GetDTFloat(1)
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.Seed = math.Rand(0, 10)

	hook.Add("Move", self, self.Move)

	if CLIENT then
		hook.Add("Draw", self, self.Draw)
	end
end

-- function ENT:Move(pl, move)
	-- if pl ~= self:GetOwner() then return end

	-- local sloweffect = 1 - 0.7 * (pl.SlowEffTakenMul or 1)

	-- move:SetMaxSpeed(move:GetMaxSpeed() * sloweffect)
	-- move:SetMaxClientSpeed(move:GetMaxClientSpeed() * sloweffect)
-- end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end
