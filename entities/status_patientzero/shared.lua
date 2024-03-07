ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	local enty = self
	local ENTC = tostring(enty)

	if SERVER then
		self:CreateSVHook(ENTC, enty)
	end

	hook.Add("Move", ENTC, function(pl, move)
		if not IsValid(self) then return end
		
		if pl ~= enty:GetOwner() then return end
	
		move:SetMaxSpeed(move:GetMaxSpeed() + 20)
		move:SetMaxClientSpeed(move:GetMaxSpeed())
	end)
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

function ENT:OnRemove()
	local ENTC = tostring(self)
	if SERVER then self:RemoveSVHook(ENTC) end
	hook.Remove("Move", ENTC)

	self.BaseClass.OnRemove(self)
end

function ENT:SetType(type)
	self:SetDTFloat(5, type)
end

function ENT:GetType()
	return self:GetDTFloat(5)
end