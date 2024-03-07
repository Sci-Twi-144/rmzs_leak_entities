AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Stacks", "Int", 1)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
	self:Processing()
end

function ENT:Processing()--
	timer.Simple(0, function()
		local owner = self:GetOwner()
		owner.FrightDurationMul = 0
		owner.DimVisionEffMul = 0
		self:GetOwner():ApplyTrinkets()
		owner.FrightDurationMul = 0
		owner.DimVisionEffMul = 0
	end)
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if SERVER then
		self:CreateSVHook(self)
	end

	local ent = self

end 

function ENT:OnRemove()
	if SERVER then
		self:RemoveSVHook(tostring(self))
	end


	self.BaseClass.OnRemove(self)
end