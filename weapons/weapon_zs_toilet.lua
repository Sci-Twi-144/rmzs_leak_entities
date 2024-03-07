AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_toilet"))
SWEP.Description = (translate.Get("desc_toilet"))

if CLIENT then
	SWEP.ViewModelFOV = 70
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
	["toilet"] = { type = "Model", model = "models/props/cs_militia/toilet.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.031, 2.5, 1.006), angle = Angle(18.113, 174.34, -167.547), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
 
	SWEP.WElements = {
	["toilet"] = { type = "Model", model = "models/props/cs_militia/toilet.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.031, 2.013, 1.006), angle = Angle(18.113, 174.34, -167.547), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props/cs_militia/toilet.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 250
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 85
SWEP.MeleeSize = 1.5

SWEP.Tier = 6

SWEP.Primary.Delay = 1.2

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingTime = 0.4
SWEP.SwingHoldType = "grenade"

SWEP.BlockRotation = Angle(0, 15, -50)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockReduction = 35
SWEP.BlockStability = 0.2
SWEP.StaminaConsumption = 10

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 1, 1)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 100, 100)
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/concrete/rock_impact_hard"..math.random(6)..".wav", 100, 100)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 100, 100)
end

--[[function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and hitent:IsHeadcrab() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		self.MeleeDamage = hitent:GetMaxHealth() * 10
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = self.OriginalMeleeDamage
end]]
