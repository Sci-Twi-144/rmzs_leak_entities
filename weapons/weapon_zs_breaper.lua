AddCSLuaFile()

SWEP.PrintName = "Perfect Zombinium"
SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeReach = 50
SWEP.MeleeSize = 4.5
SWEP.MeleeDamage = 15
SWEP.MeleeDamageVsProps = 28

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:GetOwner():EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav")
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = self.MeleeDamageVsProps
	end
	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() then
		local leech = ent:GiveStatus("bleed")
		if leech and leech:IsValid() then
			leech:AddDamage(damage * 10)
			leech:SetType(1)
			leech.Damager = self:GetOwner()
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