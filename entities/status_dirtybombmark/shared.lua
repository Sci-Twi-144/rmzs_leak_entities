ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local ENTC = tostring(self)
	if SERVER then
		self:CreateSVHook(ENTC)
	end	

	--print("succ")
end

function ENT:OnRemove()
	local ENTC = tostring(self)
	if SERVER then
		self:RemoveSVHook(ENTC)
	end	
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end
