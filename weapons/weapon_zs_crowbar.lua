AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_crowbar"))
SWEP.Description = (translate.Get("desc_crowbar"))

if CLIENT then
	SWEP.ViewModelFOV = 65
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 65
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 64
SWEP.MeleeSize = 1.5

SWEP.Primary.Delay = 1.2

SWEP.SwingTime = 0.6
SWEP.SwingRotation = Angle(10, -20, -20)
SWEP.SwingHoldType = "grenade"

SWEP.BlockRotation = Angle(0, 15, -50)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockReduction = 6
SWEP.BlockStability = 0.2
SWEP.StaminaConsumption = 8

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 1, 1)

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_Crowbar.Single")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_Crowbar.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_Crowbar.Melee_Hit")
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and hitent:IsHeadcrab() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		hitent:TakeSpecialDamage(math.min(hitent:Health(), 200), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
	end
end

--[[function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and hitent:IsHeadcrab() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		self.MeleeDamage = hitent:GetMaxHealth() * 10
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = self.OriginalMeleeDamage
end]]
