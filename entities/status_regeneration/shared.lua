ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

function ENT:Initialize()
	self:DrawShadow(false)
	if self:GetDTFloat(1) == 0 then
		self:SetDTFloat(1, CurTime())
	end
end

function ENT:AddHeal(heal, ply)
	local newheal = self:GetHeal()
	self:SetHeal(newheal + heal)
	if IsValid(ply) and SERVER then
		self.Appliers[ply] = (self.Appliers[ply] or 0) + (self:GetHeal() - newheal)
		if self.Appliers[ply] <= 0 then self.Appliers[ply] = nil end
		if not STATUS_HEAL and IsValid(ply) and ply.HealTickSpeed and ply.HealTickSpeed < self:GetTickMultiplier() or self:GetTickMultiplier() == 1.0 then
			self:SetTickMultiplier(ply.HealTickSpeed)
		end
	end
end

function ENT:SetHeal(heal)
	self:SetDTFloat(0, math.min(GAMEMODE.MaxHealthRegeneration or 1000, heal))
end

function ENT:GetHeal()
	return self:GetDTFloat(0)
end

function ENT:SetTickMultiplier(mul)
	local v = tonumber(mul)
	if v then
		self:SetDTFloat(2, v)
	end
end

function ENT:GetTickMultiplier()
	return self:GetDTFloat(2)
end

function ENT:SetTickAnyway(bool)
	self:SetDTBool(5, bool)
end

function ENT:GetTickAnyway()
	return self:GetDTBool(5)
end