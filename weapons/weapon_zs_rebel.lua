AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_rebel_fire"))
SWEP.Description = (translate.Get("desc_rebel_fire"))

SWEP.AbilityText = "PIERCE SHOT"
SWEP.AbilityColor = Color(250, 160, 60)
SWEP.AbilityMax = 1000
SWEP.AbilitySegmentation = false
if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(2, -1, 1)
	SWEP.HUD3DAng = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.013
	
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, self.AbilitySegmentation, 3, 1/3)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, self.AbilitySegmentation, 3, 1/3)
	end
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_w1200_a1.mdl"
SWEP.WorldModel = "models/weapons/w_w1200_a1.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/zs_rebel/fire1.wav"
SWEP.Primary.Damage = 9
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.75

SWEP.ReloadDelay = 0.6

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 6.75
SWEP.ConeMin = 5.25

SWEP.FireAnimSpeed = 1.2
SWEP.WalkSpeed = SPEED_SLOWER

SWEP.HasAbility = true
SWEP.ResourceCap = SWEP.AbilityMax

SWEP.ElemetalHit = "hit_fire"
SWEP.ElementalTracer = "tracer_firebullet"
SWEP.TracerName = "tracer_firebullet"

SWEP.Costil = false
SWEP.Tier = 3

SWEP.InnateTrinket = "trinket_flame_rounds"
SWEP.InnateBurnDamage = true
SWEP.FlatBurnChance = 50
SWEP.BurnDamageMul = 1

SWEP.SpreadPattern = {
    {0, 0},
    {-5, 0},
    {-4, 3},
    {0, 3},
    {4, 3},
    {5, 0},
    {4, -3},
    {0, -3},
    {-4, -3},
}

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.603, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.51, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.05, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.26, 3, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.11, 3, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_rebel_ice")), (translate.Get("desc_rebel_ice")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 6.35
	wept.Primary.NumShots = 1
	wept.ConeMin = wept.ConeMin * 0.20
	wept.ConeMax = wept.ConeMax * 0.35
	wept.ResistanceBypass = 0.6
	
	wept.AbilityText = "PIERCE SHOT"
	wept.AbilityColor = Color(140, 175, 205)
	
	wept.ClassicSpread = true
	wept.ElemetalHit = "hit_icebullet"
	wept.InnateTrinket = "trinket_ice_rounds"
	wept.InnateArmDamage = true
	wept.ArmDamageMul = 4
	wept.ElementalTracer = "tracer_icebullet"
	wept.TracerName = "tracer_icebullet"
	wept.InnateBurnDamage = false
	wept.FlatBurnChance = nil
	wept.BurnDamageMul = nil
end)

function SWEP:PrimaryAttack()
	self.BaseClass.PrimaryAttack(self)
	if self:GetTumbler() then
		self.Pierces = 4
		self.DamageTaper = 0.6
		self:SetResource(self:GetResource() - self.AbilityMax/5)
	else
		self.Pierces = 1
		self.DamageTaper = 0.6
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity
	
	if SERVER then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect(wep.ElemetalHit, effectdata)
	end
	
	if ent:IsValidLivingZombie() then
		if wep:GetResource() >= wep.AbilityMax then
			wep:SetTumbler(true)
			wep:SetResource(wep.AbilityMax)
		elseif wep:GetResource() <= 10 then
			wep:SetResource(0)
			wep:SetTumbler(false)
		end
	end
end

sound.Add({
	name = 			"w1200.pump",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_rebel/pump.wav"	
})

sound.Add({
	name = 			"w1200.insert",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_rebel/insert.wav"	
})

sound.Add({
	name = 			"w1200.draw",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_rebel/draw.wav"	
})
