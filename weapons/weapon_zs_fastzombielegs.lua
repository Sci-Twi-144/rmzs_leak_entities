AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Fast Zombie Kung Fu"

SWEP.Primary.Delay = 1

SWEP.MeleeDelay = 0.25
SWEP.MeleeReach = 38
SWEP.MeleeDamage = 14

SWEP.DelayWhenDeployed = true

--[[function SWEP:Move(mv)
	if self:IsSwinging() then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)
	end
end]]

function SWEP:PrimaryAttack(fromsecondary)
	local n = self:GetNextPrimaryAttack()

	if self:GetOwner():IsOnGround() or self:GetOwner():WaterLevel() >= 2 or self:GetOwner():GetMoveType() ~= MOVETYPE_WALK then
		self.BaseClass.PrimaryAttack(self)
	end

	if not fromsecondary and n ~= self:GetNextPrimaryAttack() then
		self:SetDTBool(10, false)
	end
end

function SWEP:SecondaryAttack()
	local n = self:GetNextPrimaryAttack()
	self:PrimaryAttack(true)
	if n ~= self:GetNextPrimaryAttack() then
		self:SetDTBool(10, true)
	end
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/zombie/zombie_pound_door.wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/zombie/foot_slide"..math.random(3)..".wav")
end

function SWEP:Reload()
end