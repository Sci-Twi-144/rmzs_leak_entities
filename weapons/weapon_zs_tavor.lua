AddCSLuaFile()

-- Возможно будущее оружие, 2 ветки ауга (возможно это будет TAR-21)
-- Каждое 6 попадание наносит кислотный урон
-- Если TAR-21 не подойдет, пригодиться любая пушка, системы буллпап

SWEP.PrintName = (translate.Get("wep_tavor"))
SWEP.Description = (translate.Get("desc_tavor"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.aug_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.5, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/aug/aug-1.wav"
SWEP.Primary.Damage = 22.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.08

SWEP.ResistanceBypass = 0.65

SWEP.TracerName = "tracer_biobullet"

-- SWEP.InnateTrinket = "trinket_flame_rounds"
-- SWEP.BurnTickRateOff = 3

SWEP.Primary.ClipSize = 42
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 4.5
SWEP.ConeMin = 1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4
--SWEP.MaxStock = 3

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)
 
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 6, 3)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local pos = tr.HitPos
	local wep = dmginfo:GetInflictor()
	
	if ent:IsValidLivingZombie() then
		wep:SetHitStacks(wep:GetHitStacks() + 1)
	end
	
	if SERVER and ent:IsValidLivingZombie() and wep:GetHitStacks() >= 6 then
		wep:SetHitStacks(0)
			for _, ent2 in pairs(util.BlastAlloc(attacker:GetActiveWeapon(), attacker, pos, 36)) do
				if ent2:IsValidZombie() then
					ent2:AddLegDamageExt(dmginfo:GetDamage() * 0.14, attacker, wep, SLOWTYPE_ACID) -- dmginfo:GetDamage() * 0.135
					ent2:TakeDamage(dmginfo:GetDamage() * 0.14, attacker, wep) -- dmginfo:GetDamage() * 0.135
				end
			end
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("hit_bio", effectdata)
	end
end

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end