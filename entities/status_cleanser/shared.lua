ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Stacks", "Int", 1)

function ENT:AddStacks(amount, ply)
	local newstacks = self:GetStacks()
	self:SetStacks(newstacks + amount)
	if IsValid(ply) and SERVER then
		self.Appliers[ply] = (self.Appliers[ply] or 0) + (self:GetStacks() - newstacks)
		if self.Appliers[ply] <= 0 then self.Appliers[ply] = nil end
	end
end

function ENT:SetStacks(amount)
	self:SetDTInt(1,math.min(amount, 3))
end