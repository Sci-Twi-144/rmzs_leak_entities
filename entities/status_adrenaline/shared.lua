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

	local ent = self
	hook.Add("Move", tostring(self), function(pl, move)
		if not IsValid(ent) then return end
		
		if pl ~= ent:GetOwner() then return end

		move:SetMaxSpeed(move:GetMaxSpeed() + 10)
		move:SetMaxClientSpeed(move:GetMaxSpeed())
	end)
end 

function ENT:OnRemove()
	if SERVER then
		self:RemoveSVHook(tostring(self))
	end
	hook.Remove("Move", tostring(self))

	self.BaseClass.OnRemove(self)
end
