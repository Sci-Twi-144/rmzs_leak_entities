ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if CLIENT then
		hook.Remove("Draw", tostring(self))
	end

	if SERVER then
		self:RemoveSVHook(tostring(self))
	end
end