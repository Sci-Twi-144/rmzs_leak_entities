ENT.Type = "anim"
ENT.Base = "status__base"


AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
	self:GetDTEntity(0).DamageBuffEnd = CurTime() + self:GetDTFloat(0)
end

local matDamage = Material("Models/props_debris/concretefloor013a")
function ENT:Initialize()
--	print(self:GetDTFloat(0), "time")
--	print("pass")

	self.BaseClass.Initialize(self)

	local enty = self
	if SERVER then
		self:CreateSVHook(enty)
		self:SetSolid(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
	end
end

function ENT:OnRemove()
	if SERVER then
		self:RemoveSVHook(tostring(self))
	end

	self.BaseClass.OnRemove(self)
end