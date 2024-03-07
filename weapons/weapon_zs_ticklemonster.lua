AddCSLuaFile()

SWEP.PrintName = "Tickle Monster"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 32
SWEP.MeleeDamageVsProps = 28
SWEP.MeleeReach = 100
SWEP.MeleeSize = 5

SWEP.Primary.Delay = 1.1

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = self.MeleeDamageVsProps
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav")
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() then
		
		ent:ApplyZombieDebuff("sickness", 12, {Applier = self:GetOwner()}, true, 12)
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/Charple/Charple1_sheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
