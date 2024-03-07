SWEP.Base = "weapon_zs_zombie"

SWEP.PrintName = "Frozen Puke Pus"

SWEP.Primary.Delay = 6

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.NextPuke = 0
SWEP.PukeLeft = 0
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

function SWEP:Initialize()
	self:HideViewAndWorldModel()

	self.BaseClass.Initialize(self)
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() then return end
	local owner = self:GetOwner()
	local delay = owner:GetMeleeSpeedMul()
	local div = (owner.PoisonBuffZombie and owner.PoisonBuffZombie.DieTime >= CurTime() and 0.5) or 1
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * delay * div)

	local SCD = self:GetNextPrimaryFire() - CurTime()
	self:SetResource(SCD, true)
	self:SetMaxCooldown(SCD)

	self.PukeLeft = 20

	owner:EmitSound("npc/barnacle/barnacle_die2.wav")
	owner:EmitSound("npc/barnacle/barnacle_digesting1.wav")
	owner:EmitSound("npc/barnacle/barnacle_digesting2.wav")
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end
