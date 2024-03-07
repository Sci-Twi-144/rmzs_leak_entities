AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_stunbaton"))
SWEP.Description = (translate.Get("desc_stunbaton"))

if CLIENT then
	SWEP.ViewModelFOV = 50
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.MeleeDamage = 48
SWEP.MeleeRange = 65
SWEP.MeleeSize = 1.5
SWEP.Primary.Delay = 0.9

SWEP.SwingTime = 0.25
SWEP.SwingRotation = Angle(60, 0, 0)
SWEP.SwingOffset = Vector(0, -50, 0)
SWEP.SwingHoldType = "grenade"

SWEP.BlockRotation = Angle(0, 15, -40)
SWEP.BlockOffset = Vector(3, 7, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.1
SWEP.BlockReduction = 5
SWEP.StaminaConsumption = 8

--SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

SWEP.InnateTrinket = "trinket_pulse_attachement"
SWEP.LegDamageMul = 1

SWEP.AllowQualityWeapons = true

--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09)
--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_LEG_DAMAGE, 2)

---- ulx luarun print(math.Round(math.abs((1 - math.min(1, (math.min(GAMEMODE.MaxLegDamage, ((Entity(1):GetActiveWeapon().MeleeDamage * 1.6) * (0.1 * 3.37)) * 0.125)) / GAMEMODE.MaxLegDamage)-1) * 100),2))

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_StunStick.Swing")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_StunStick.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_StunStick.Melee_Hit")
end
--[[
function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() then
		hitent:AddLegDamageExt(self.LegDamage, self:GetOwner(), self, SLOWTYPE_PULSE)
	end
end
]]
