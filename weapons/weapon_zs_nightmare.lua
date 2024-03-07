AddCSLuaFile()

SWEP.PrintName = "Nightmare"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 15
SWEP.BleedDamage = 15
SWEP.SlowDownScale = 5.4
SWEP.MeleeDamageVsProps = 45
SWEP.EnfeebleDurationMul = 10 / SWEP.MeleeDamage

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav")
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = self.MeleeDamageVsProps
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() then
		local owner = self:GetOwner()
		ent:TakeStamina(damage * 0.16, 4)
		ent:ApplyZombieDebuff("frightened", 6, {Applier = owner}, true, 39)
		ent:ApplyZombieDebuff("dimvision", 10, {Applier = owner}, true, 7)
		ent:ApplyZombieDebuff("slow", 7, {Applier = owner}, true, 8)

		local bleed = ent:GiveStatus("bleed")
		if bleed and bleed:IsValid() then
			bleed:AddDamage(self.BleedDamage)
			bleed.Damager = self:GetOwner()
		end
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
