ENT.Type = "anim"
ENT.Base = "status__base"


function ENT:Initialize()
	self.BaseClass.Initialize(self)
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if CLIENT then
		hook.Remove("Draw", tostring(self))
	end

	if SERVER then
		hook.Remove("SpecialPlayerDamage", tostring(self))
		self:RemoveSVHook(tostring(self))
	end
end

function ENT:SetDamage(damage)
	self:SetDTFloat(0, math.Clamp(damage, 0.05, 0.25))
end

function ENT:GetDamage()
	if self:GetDTFloat(0) > 0.05 then -- ebic
		return self:GetDTFloat(0)
	end
end