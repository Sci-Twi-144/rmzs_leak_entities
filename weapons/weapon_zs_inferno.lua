AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_inferno"))
SWEP.Description = (translate.Get("desc_inferno"))

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.AbilityText = "FireBall"
SWEP.AbilityColor = Color(250, 65, 65)
SWEP.AbilityMax = 1200 * (GAMEMODE.ZombieEscape and 4 or 1)

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.aug_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.5, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/aug/aug-1.wav"
SWEP.Primary.Damage = 24
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.ResistanceBypass = 0.65

SWEP.TracerName = "tracer_firebullet"

SWEP.InnateTrinket = "trinket_flame_rounds"
SWEP.InnateBurnDamage = true 
SWEP.FlatBurnChance = 14
SWEP.BurnTickRateOff = 2

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 4
SWEP.ConeMin = 1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.HasAbility = true

SWEP.Tier = 4

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)
 
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 4, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_tavor")

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity 
	local pos = tr.HitPos
	if SERVER and ent:IsValidLivingZombie() then
		if wep:GetResource() >= wep.AbilityMax then
			wep:SetResource(0)

			local tapper = 1
			for _, ent2 in pairs(util.BlastAlloc(self, owner, pos, 96 * (attacker.ExpDamageRadiusMul or 1))) do
				if ent2:IsValidZombie() then
					ent2:AddBurnDamage(wep.Primary.Damage * 3 * tapper, attacker or dmginfo:GetInflictor(), 2)
					tapper = tapper * 0.93
				end
			end

			local ent = ents.Create("prop_shieldbr")
			if ent:IsValid() then
				ent:SetPos(tr.HitPos)
				ent.Scale = 3
				ent:Spawn()
			end
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("hit_fire", effectdata)
	end
end