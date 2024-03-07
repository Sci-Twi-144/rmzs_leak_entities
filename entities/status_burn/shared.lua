ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

ENT.TickRate = 0.5

function ENT:Initialize()
	self:DrawShadow(false)
	if self:GetDTFloat(1) == 0 then
		self:SetDTFloat(1, CurTime())
	end


	if SERVER then
		timer.Simple(0, function()
			if self.Damager and self.Damager:IsValid() then
				self.Damager:ProcessStatusFloater(1, self:GetOwner()) -- bullshit а можно просто флоатер пускать аааааа
			end
		end)
	end
end

function ENT:AddDamage(damage, attacker)
	self:SetDamage(self:GetDamage() + damage)

	if attacker then
		self.Damager = attacker
	end
end

function ENT:SetDamage(damage)
	self:SetDTFloat(0, math.min(GAMEMODE.MaxBurnDamage or 250, damage))
end

function ENT:GetDamage()
	return self:GetDTFloat(0)
end

function ENT:AddTickRateMul(mul)
	self:SetTickRateMul(self:GetTickRateMul() + mul)
end

function ENT:SetTickRateMul(mul)
	self:SetDTFloat(2, mul)
end

function ENT:GetTickRateMul()
	return self:GetDTFloat(2)
end