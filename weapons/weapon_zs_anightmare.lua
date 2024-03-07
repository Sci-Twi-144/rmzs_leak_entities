AddCSLuaFile()

SWEP.PrintName = "Ancient Nightmare"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 65
SWEP.SlowDownScale = 1
SWEP.DamageType = DMG_DIRECT -- we do a little trolling

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 50
	end
end

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav", 75, 85)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsValidLivingHuman() then
		local cappeddmg = math.Round(math.max(25 - damage, 0))
		local owner = self:GetOwner()
		if (cappeddmg > 0) then
			if SERVER then
				ent:TakeSpecialDamage(cappeddmg, DMG_DIRECT, owner, self, tr.HitPos)
			end
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
