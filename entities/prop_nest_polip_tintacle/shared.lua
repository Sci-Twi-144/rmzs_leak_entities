ENT.Type = "anim"

ENT.IsZMPolip = true

function ENT:GetCanAttack()
	return self:GetDTBool(9)
end

function ENT:SetCanAttack(bool)
	self:SetDTBool(9, bool)
end