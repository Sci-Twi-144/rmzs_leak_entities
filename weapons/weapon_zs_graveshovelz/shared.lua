SWEP.Base = "weapon_zs_graveshovel"
SWEP.ZombieOnly = true

SWEP.MeleeDamage = 40
SWEP.MeleeKnockBack = 0
SWEP.ResourceMul = 1
SWEP.ResCap = 200
SWEP.HasAbility = true

SWEP.CanBlocking = false
SWEP.NoGlassWeapons = true

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end