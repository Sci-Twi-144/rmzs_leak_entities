ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local enty = self
	if SERVER then
		self:CreateSVHook(enty)
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if SERVER then
		self:RemoveSVHook(tostring(self))
	end
end
