AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Red Marrow"
	
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(math.abs(self.LastUsed - CurTime()), 10, nil, "Next Shield", false, true)
	end
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 30
SWEP.LastUsed = 0

function SWEP:Think()
	local owner = self:GetOwner()
	if owner:GetStatus("redmarrow") then
		self.LastUsed = CurTime()
	end
	self.BaseClass.Think(self)
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if owner.RedMarrowShielded then
		self:SecondaryAttack()
	else
		self.BaseClass.PrimaryAttack(self)
	end
end

function SWEP:Reload()
	self.BaseClass.Reload(self)
	local owner = self:GetOwner()
	if SERVER and (self.LastUsed + 10 < CurTime()) and not owner:GetStatus("redmarrow") then
		owner:GiveStatus("redmarrow", 6)
	end
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() then
		ent:TakeStamina(damage * 0.5, 4)
		ent:SetBloodArmor(math.max(ent:GetBloodArmor() - damage * 0.33, 0))
	end
	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/fast_zombie/fz_scream1.wav", 75, math.random(60,70), 0.5)
	self:GetOwner():EmitSound("npc/fast_zombie/fz_scream1.wav", 75, math.random(70,80), 0.5)
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:GetOwner():EmitSound("npc/combine_soldier/die"..math.random(1,3)..".wav", 75, math.random(70,75), 0.5)
	self:GetOwner():EmitSound("npc/combine_soldier/die"..math.random(1,3)..".wav", 75, math.random(78,90), 0.5)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/flesh")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
