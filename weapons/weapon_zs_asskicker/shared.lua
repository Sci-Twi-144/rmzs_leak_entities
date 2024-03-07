SWEP.PrintName = "Giant Zombie Kung Fu"

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = "models/rmzs/weapons/zombies/asskicker/v_asskicker.mdl" -- Необходимо сделать 1 лицо, у меня нет полномочий
SWEP.WorldModel = ""

SWEP.MeleeDelay = 0.32
SWEP.MeleeReach = 80
SWEP.MeleeSize = 16
SWEP.MeleeDamage = 32
SWEP.Primary.Delay = 0.94

SWEP.DelayWhenDeployed = true

--[[function SWEP:Move(mv)
	if self:IsSwinging() then
		mv:SetMaxSpeed(50)
		mv:SetMaxClientSpeed(50)
	end
end]]

function SWEP:PrimaryAttack(fromsecondary)
	local n = self:GetNextPrimaryAttack()

	local owner = self:GetOwner()
	self.BaseClass.PrimaryAttack(self)

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
	self:EmitSound("npc/zombie/zombie_pound_door.wav", 77, 65, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/zombie/foot_slide"..math.random(3)..".wav", 77, 65, nil, CHAN_AUTO)
end

function SWEP:Reload()
end