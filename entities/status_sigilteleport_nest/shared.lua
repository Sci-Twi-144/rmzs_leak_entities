ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:GetTimeRemaining()
	return math.max(0, self:GetEndTime() - CurTime())
end

function ENT:RefreshMaxTime()
	self:SetMaxTime(math.max(self:GetMaxTime(), self:GetEndTime() - self:GetStartTime()))
end

function ENT:SetMaxTime(time)
	self:SetDTFloat(2, time)
end

function ENT:GetMaxTime()
	return self:GetDTFloat(2)
end

function ENT:SetEndTime(time)
	self:SetDTFloat(0, time)
	self:RefreshMaxTime()
end

function ENT:GetEndTime()
	return self:GetDTFloat(0)
end

function ENT:GetStartTime()
	return self:GetDTFloat(1)
end

function ENT:SetStartTime(time)
	self:SetDTFloat(1, time)
	self:RefreshMaxTime()
end

function ENT:GetTargetSigil(cached)
	local owner = self:GetParent()

	if owner:IsValid() and not self:GetSigilSight() and SERVER and not cached then
		self:SetDTEntity(2, owner:SigilTeleportDestination(nil, nil, self:GetNestTP()))
		return self:GetDTEntity(2)
	end
	return self:GetDTEntity(2)
end

function ENT:SetFromSigil(ent)
	self:SetDTEntity(1, ent)
end

function ENT:GetFromSigil()
	return self:GetDTEntity(1)
end

function ENT:SetSigilSight(bool)
	self:SetDTBool(1, bool)
end

function ENT:GetSigilSight()
	return self:GetDTBool(1)
end

function ENT:SetClearPlace(bool)
	self:SetDTBool(15, bool)
end

function ENT:GetClearPlace()
	return self:GetDTBool(15)
end

function ENT:SetNestTP(bool)
	self:SetDTBool(16, bool)
end

function ENT:GetNestTP()
	return self:GetDTBool(16)
end