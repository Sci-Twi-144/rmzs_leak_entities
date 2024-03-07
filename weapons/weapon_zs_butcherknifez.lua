AddCSLuaFile()

SWEP.Base = "weapon_zs_butcherknife"

SWEP.ZombieOnly = true
SWEP.MeleeDamage = 16
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.Primary.Delay = 0.45

SWEP.BleedDamageMul = 0.15

SWEP.CanBlocking = false
SWEP.NoGlassWeapons = true
SWEP.AllowQualityWeapons = false

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 15
	end
	local owner = self:GetOwner()
	if hitent:IsPlayer() then
		if SERVER then
			owner:SetHealth(math.min(owner:Health() + self.MeleeDamage, owner:GetMaxHealth()))
			hitent:AddArmDamage(4)
			hitent:AddBleedDamage(self.MeleeDamage * self.BleedDamageMul, self:GetOwner())
			local bleed = hitent:GiveStatus("bleed")
			if bleed and bleed:IsValid() then
				bleed:AddDamage(self.MeleeDamage * self.BleedDamageMul)
				bleed.Damager = self:GetOwner()
				bleed:SetType(1)
			end
		end
	end
end

SWEP.SwingTime = 0
local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	
	self:SetNextPrimaryFire(CurTime() + math.max(0.3, E_GetTable(self).Primary.Delay * (1 - self:GetDTInt(8) / 10)) * armdelay)
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = self.OriginalMeleeDamage
	if hitent:IsValid() and hitent:IsPlayer() then
		local combo = self:GetDTInt(8)
		local owner = self:GetOwner()

		self:SetDTInt(8, combo + 1)
	end
end

function SWEP:PostOnMeleeMiss(tr)
	self:SetDTInt(8, 0)
end
