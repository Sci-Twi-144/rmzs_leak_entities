SWEP.Base = "weapon_zs_headcrab"

SWEP.PounceDamage = 6
SWEP.SpecialDamage = 2
SWEP.PounceDamageType = DMG_SLASH
SWEP.IsVariant = true

SWEP.ChargeTime = 1


--[[
function SWEP:Reload()
end
]]

function SWEP:Think()
	if self:GetCharge() >= 1 then
		self:GetOwner():Kill()
	end
	self.BaseClass.Think(self)
end

function SWEP:SecondaryAttack()
	if not self:IsBurrowed() then
		if CurTime() < self:GetNextSecondaryFire() then return end
			self:SetNextSecondaryFire(CurTime() + 2)
		if SERVER then
			self:EmitIdleSound()
		end
	elseif self:IsBurrowed() then
		if self:GetChargeStart() == 0 then
			self:SetChargeStart(CurTime())
			if IsFirstTimePredicted() then
				self:GetOwner():EmitSound("npc/headcrab/pain1.wav", 80, 60)
			end
		end
	end
end

function SWEP:SetChargeStart(time)
	self:SetDTFloat(7, time)
end

function SWEP:GetChargeStart()
	return self:GetDTFloat(7)
end

function SWEP:GetCharge()
	if self:GetChargeStart() == 0 then return 0 end

	return math.Clamp((CurTime() - self:GetChargeStart()) / self.ChargeTime, 0, 1)
end

--self.BaseClass.Initialize(self)