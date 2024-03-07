AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_scavenger"))
SWEP.Description = (translate.Get("desc_scavenger"))

SWEP.Slot = 3
SWEP.SlotPos = 0

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80

	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(7, -1.85, 2.2)
	SWEP.HUD3DAng = Angle(180, 90, -110)
	SWEP.HUD3DScale = 0.02

	SWEP.VMPos = Vector(0, -6, -1)
	SWEP.VMAng = Vector(0.5, 0, 0)

	SWEP.VElements = {}
	SWEP.WElements = {
		["wmodel"] = { type = "Model", model = "models/weapons/scavenger/w_scavenger_fix.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13, 1, -5.2), angle = Angle(195, 180, 0), size = Vector(0.885, 0.885, 0.885), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

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

sound.Add(
{
    name = "Weapon_Scavenger.MagOut",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/mag_out.mp3"
})
sound.Add(
{
    name = "Weapon_Scavenger.MagIn",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/mag_in.mp3"
})
sound.Add(
{
    name = "Weapon_Scavenger.Beep",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/beep_onfullyreloaded.mp3"
})
sound.Add(
{
    name = "Weapon_Scavenger.BoltBack",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/bolt_back.mp3"
})
sound.Add(
{
    name = "Weapon_Scavenger.BoltForward",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/bolt_forward.mp3"
})

SWEP.Base = "weapon_zs_base"
SWEP.HoldType = "ar2"

SWEP.ViewModel			= "models/weapons/scavenger/v_scavenger_fix.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = "weapons/scavenger_shot.mp3"
SWEP.Primary.Damage = 170
SWEP.Primary.Radius = 123
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 2

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "impactmine"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 3
SWEP.ConeMin = 0.25

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.FireAnimSpeed = 1
SWEP.ReloadSpeed = 0.8

SWEP.IronSightsPos = Vector(2, 0, 0.62)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local wep = attacker:GetActiveWeapon()
	local pos = tr.HitPos
	local owner = wep:GetOwner()
	local radius = wep.Primary.Radius
	local damage = wep.Primary.Damage

	if SERVER then
		local spawn_ent = ents.Create("projectile_sniperexp")
		if IsValid(spawn_ent) then
			spawn_ent:SetPos(pos)
			spawn_ent:SetAngles(spawn_ent:GetAngles())
			if ent:IsValidLivingZombie() then
				spawn_ent:SetParent(ent)
				spawn_ent.PlayerParent = ent
			end
			spawn_ent:SetOwner(owner)
			spawn_ent.ProjDamage = damage * (owner.ProjectileDamageMul or 1) * 0.9 --0.75
			spawn_ent.ProjRadius = radius
			spawn_ent.ProjSource = wep
			spawn_ent.Team = owner:Team()
			spawn_ent:Spawn()
		end
	end
end