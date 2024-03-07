AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Stacks", "Int", 1)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
	if SERVER then
		self:Processing()
	end
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if SERVER then
		self:CreateSVHook(self)
	end
end
function ENT:OnRemove()
	if SERVER then
		self:RemoveSVHook(tostring(self))
	end

	self.BaseClass.OnRemove(self)
end