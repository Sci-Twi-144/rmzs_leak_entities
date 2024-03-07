SWEP.Base = "weapon_zs_zombie"
SWEP.PrintName = "Corruptor"
SWEP.MeleeReach = 48
SWEP.MeleeDelay = 0.9
SWEP.MeleeSize = 4.5 --1.5
SWEP.MeleeDamage = 45 --40
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.35

SWEP.Primary.Delay = 1.6

SWEP.FleshThrowRecoil = 40

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = false

function SWEP:PlayHitSound()
	self:GetOwner():EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 75, 80)
end

function SWEP:PlayMissSound()
	self:GetOwner():EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 75, 80)
end

function SWEP:PlayAttackSound()
	self:GetOwner():EmitSound("NPC_PoisonZombie.ThrowWarn")
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("NPC_PoisonZombie.Alert")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound
