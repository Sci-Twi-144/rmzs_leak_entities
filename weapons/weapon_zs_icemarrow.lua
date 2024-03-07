AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_zombie")

if CLIENT then
	SWEP.PrintName = "Ice Marrow"
	
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self.ResCap, col, "Mass Armor", false, true, false)
	end
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 30
SWEP.ResourceMul = 1
SWEP.ResCap = 200
SWEP.HasAbility = true

function SWEP:ApplyMeleeDamage(hitent, tr, damage)
	BaseClass.ApplyMeleeDamage(self, hitent, tr, damage)
	if SERVER and hitent:IsPlayer() then
		--hitent:ApplyZombieDebuff("frost", 5, {Applier = self:GetOwner()}, true, 10)
		hitent:AddLegDamageExt(30, self:GetOwner(), self, SLOWTYPE_COLD)
	end
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if (self:GetResource() >= self.ResCap) then
		local center = owner:GetPos() + Vector(0, 0, 32)
		if SERVER then
			for _, ent in pairs(util.BlastAlloc(self, owner, center, 150)) do
				if ent:IsValidLivingZombie() and WorldVisible(ent:WorldSpaceCenter(), center) and (ent:GetZombieClassTable().Name ~= "Red Marrow") then
					ent:SetZombieShield(GAMEMODE:CalcMaxShieldHealth(ent))
				end
			end
		end
		self:SetResource(0)
		self:SecondaryAttack()
	else
		self:SecondaryAttack()
	end
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

if SERVER then
	function SWEP:BotAttackMode( enemy )
		local dist = enemy:GetPos():DistToSqr(self:GetOwner():GetPos())
		if not enemy:IsPlayer() or dist<10000 then -- Square(100)
			return 0
		elseif (self:GetResource() >= self.ResCap) then
			return 2 
		end
	end
end

if not CLIENT then return end

local matSkin = Material("models/barnacle/barnacle_sheet")

function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSkin)
	render.SetColorModulation(0.3, 1, 1)
end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end