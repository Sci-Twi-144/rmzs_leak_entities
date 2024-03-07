AddCSLuaFile()

SWEP.Base = "weapon_zs_zombietorso"

SWEP.PrintName = "Skeletal Crawler"

SWEP.MeleeDelay = 0.25
SWEP.MeleeDamage = 20

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound(string.format("npc/strider/creak%d.wav", math.random(4)), 70, math.random(125, 135))
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/stalker/breathing3.wav", 70, math.random(120, 130))
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/fast_zombie/wake1.wav", 70, math.random(125, 150))
end

if SERVER then
	function SWEP:ApplyMeleeDamage(ent, trace, damage)
		if ent:IsPlayer() then
			ent:ApplyZombieDebuff("anchor", 2, {Applier = self:GetOwner()}, true, 34)
		end
	
		self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
	end
end

if not CLIENT then return end

local matSheet = Material("models/props_c17/doll01")

function SWEP:PreDrawViewModel(vm, wep, pl)
	render.ModelMaterialOverride(matSheet)
end

function SWEP:PostDrawViewModel(vm, wep, pl)
	render.ModelMaterialOverride(nil)
end
