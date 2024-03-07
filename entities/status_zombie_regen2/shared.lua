ENT.Type = "anim"
ENT.Base = "status__base"
ENT.ThinkRate = 0.1

ENT.Ephemeral = true

function ENT:SetHealLeft(healleft)
	self:SetDTFloat(0, healleft)
end

function ENT:GetHealLeft()
	return self:GetDTFloat(0)
end
