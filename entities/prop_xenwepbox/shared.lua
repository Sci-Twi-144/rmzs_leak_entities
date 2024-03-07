ENT.Type = "anim"

function ENT:SetSelfType(type1)
	self:SetDTFloat(2, type1)
end

function ENT:GetSelfType()
	return self:GetDTFloat(2)
end