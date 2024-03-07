AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

-- Лучшее средство от всего живого

SWEP.PrintName = (translate.Get("wep_antimaterial"))
SWEP.Description = (translate.Get("desc_antimaterial"))
SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.Deagle_Slide"
	SWEP.HUD3DPos = Vector(-1, 0, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
	
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/awp/awp1.wav"
SWEP.Primary.Damage = 500
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.45

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.DefaultClip = 10

SWEP.HeadshotMulti = 2

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 3.4
SWEP.ConeMin = 1.25

SWEP.Tier = 1
SWEP.ResistanceBypass = 0.4

SWEP.TracerName = "tracer_railgunhit"

SWEP.Pierces = 99
SWEP.DamageTaper = 3

SWEP.Primary.ProjExplosionRadius = 144
SWEP.Primary.ProjExplosionTaper = 0.85

SWEP.IronSightsPos = Vector(-6.35, 5, 1.7)

SWEP.WalkSpeed = SPEED_SLOWER

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09, 1)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if SERVER and attacker:IsValidLivingZombie() and not attacker:GetZombieClassTable().NeverAlive or attacker.ZombieConstruction then
		local ent = tr.Entity
		local pos = tr.HitPos
		local wep = attacker:GetActiveWeapon()
		
		for _, ent2 in pairs(util.BlastAlloc(attacker:GetActiveWeapon(), attacker, pos, 40000)) do
			if ent2:IsValid() then
				ent2:TakeDamage(dmginfo:GetDamage() * 77, attacker, wep) -- dmginfo:GetDamage() * 0.135
			end
		end
		
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("hit_hunter", effectdata)
end
