AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_survivor"))
SWEP.Description = (translate.Get("desc_survivor"))
SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	SWEP.HUD3DBone = "gun"
	SWEP.HUD3DPos = Vector(-2, 2, 4)
	SWEP.HUD3DAng = Angle(0, 90, 90)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/rmzs/weapons/single/c_sniper_single.mdl"
SWEP.WorldModel = "models/rmzs/weapons/single/w_sniper_single.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_SniperRifle.Fire")
SWEP.Primary.Damage = 178
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 10

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ReloadDelay = 2.5

SWEP.HeadshotMulti = 2.5

SWEP.Recoil = 5

SWEP.ConeMax = 5.75
SWEP.ConeMin = 0

SWEP.Pierces = 3

SWEP.ProjExplosionTaper = 0.47
SWEP.DamageTaper = SWEP.ProjExplosionTaper

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 4

SWEP.ResistanceBypass = 0.4

SWEP.IsAoe = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)
	
function SWEP.BulletCallback(attacker, tr, dmginfo)
	if attacker:IsValidLivingHuman() then
		local ent = tr.Entity
		local pos = tr.HitPos
		local wep = attacker:GetActiveWeapon()
	
		if tr.HitGroup == HITGROUP_HEAD then
			if gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
				if SERVER then
					dmginfo:SetDamageType(DMG_DIRECT)
					util.BlastDamagePlayer(attacker:GetActiveWeapon(), attacker, pos, 72 * (attacker.ExpDamageRadiusMul or 1), dmginfo:GetDamage() / 1.5, DMG_ALWAYSGIB, 0.95)
				end
				local effectdata = EffectData()
					effectdata:SetOrigin(pos)
				util.Effect("Explosion", effectdata, true, true)
			end
		end
		
	end
	
	-- local effectdata = EffectData()
		-- effectdata:SetOrigin(tr.HitPos)
		-- effectdata:SetNormal(tr.HitNormal)
	-- util.Effect("hit_survivor", effectdata)
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end

sound.Add({
	name = "Weapon_SniperRifle.Fire",
	channel = CHAN_USER_BASE+10,
	volume = 0.8,
	level = 79,
	pitch = {97, 103},
	sound = {
		")weapons/sniperrifle/sniperrifle_fire_player_01.wav",
		")weapons/sniperrifle/sniperrifle_fire_player_02.wav",
		")weapons/sniperrifle/sniperrifle_fire_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_SniperRifle.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = 140,
	pitch = {97, 103},
	sound = {
		")weapons/sniperrifle/sniperrifle_fire_player_01.wav",
		")weapons/sniperrifle/sniperrifle_fire_player_02.wav",
		")weapons/sniperrifle/sniperrifle_fire_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_SniperRifle.Zoom_In",
	channel = CHAN_STATIC,
	level = 60,
	sound = "weapons/sniperrifle/handling/sniperrifle_zoom_in_01.wav"
})
sound.Add({
	name = "Weapon_SniperRifle.Zoom_Out",
	channel = CHAN_STATIC,
	level = 60,
	sound = "weapons/sniperrifle/handling/sniperrifle_zoom_out_01.wav"
})

sound.Add({
	name = "Weapon_SniperRifle.Bolt_Up",
	channel = CHAN_STATIC,
	volume = 0.25,
	level = 60,
	sound = {
		"weapons/sniperrifle/handling/sniperrifle_bolt_up_01.wav",
		"weapons/sniperrifle/handling/sniperrifle_bolt_up_02.wav",
		"weapons/sniperrifle/handling/sniperrifle_bolt_up_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bolt_Back",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = {
		"weapons/sniperrifle/handling/sniperrifle_bolt_back_01.wav",
		"weapons/sniperrifle/handling/sniperrifle_bolt_back_02.wav",
		"weapons/sniperrifle/handling/sniperrifle_bolt_back_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bolt_Forward",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = {
		"weapons/sniperrifle/handling/sniperrifle_bolt_forward_01.wav",
		"weapons/sniperrifle/handling/sniperrifle_bolt_forward_02.wav",
		"weapons/sniperrifle/handling/sniperrifle_bolt_forward_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bolt_Down",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = {
		"weapons/sniperrifle/handling/sniperrifle_bolt_down_01.wav",
		"weapons/sniperrifle/handling/sniperrifle_bolt_down_02.wav",
		"weapons/sniperrifle/handling/sniperrifle_bolt_down_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bullet_Futz",
	channel = CHAN_STATIC,
	volume = 0.25,
	level = 60,
	sound = {
		"weapons/sniperrifle/handling/sniperrifle_bullet_futz_01.wav",
		"weapons/sniperrifle/handling/sniperrifle_bullet_futz_02.wav",
		"weapons/sniperrifle/handling/sniperrifle_bullet_futz_03.wav"
	}
})
sound.Add({
	name = "Weapon_SniperRifle.Bullet_Load",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = {
		"weapons/sniperrifle/handling/sniperrifle_bullet_load_01.wav",
		"weapons/sniperrifle/handling/sniperrifle_bullet_load_02.wav",
		"weapons/sniperrifle/handling/sniperrifle_bullet_load_03.wav"
	}
})
