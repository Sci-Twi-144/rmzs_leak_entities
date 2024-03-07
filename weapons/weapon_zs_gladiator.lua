AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = (translate.Get("wep_gladiator"))
SWEP.Description = (translate.Get("desc_gladiator"))

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.VMPos = Vector(0, 2, -3)
	SWEP.VMAng = Angle(0, 0, 0)

	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-3, -7, -12)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/rmzs/weapons/trespasser/c_trespasser.mdl"
SWEP.WorldModel = "models/rmzs/weapons/trespasser/w_trespasser.mdl"
SWEP.UseHands = true

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Primary.Sound = "Fire1"--")weapons/trespasser/wpn_shotgun_q4_fire1.wav"
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 16
SWEP.Primary.Delay = 1.2

SWEP.RequiredClip = 2

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 8.5
SWEP.ConeMin = 7.25

SWEP.ReloadSpeed = 1
SWEP.FireAnimSpeed = 1
SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self.BaseClass.PrimaryAttack(self)
	timer.Simple(0.3, function()
		if self:IsValid() then 
			self:EmitSound("Pump2")
		end
	end)
end

function SWEP:SecondaryAttack()
	if self:CanPrimaryAttack() and self:Clip1() >= 4 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 1.35)

		self:TakePrimaryAmmo(4)
		self:EmitSound("Fire2")
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * 2, self:GetCone())
		self:GetOwner():ViewPunch(2 * 0.5 * 7.5 * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))
		self:GetOwner():SetGroundEntity(NULL)
		self:GetOwner():SetVelocity(-150 * 2 * self:GetOwner():GetAimVector())

		timer.Simple(0.3, function()
			if self:IsValid() then 
				self:EmitSound("Pump2")
			end
		end)

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -1.75, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -1.25, 1)

SWEP.SpreadPattern = {
	{-5, 0},
	{-4, 3},
	{0, 5},
	{4, 3},
	{5, 0},
	{4, -3},
	{2, 2},
	{-2, -2},
	{-2, 2},
	{2, -2},
	{0, 2},
	{0, -2},
	{-2, 0},
	{2, 0},
	{0, -5},
	{-4, -3},
}

SWEP.ProceduralPattern = true
SWEP.PatternShape = "rectangle"

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	
	if SERVER then
		if ent:IsValidLivingZombie() and tobool(ent:GetZombieShield()) and (ent:GetZombieShield() > 1) then
			dmginfo:SetDamage(dmginfo:GetDamage() * 2)
		end
	end
end

sound.Add({
	name = "Fire1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	level = 75,
	pitch = {75, 90},
	sound = ")weapons/zs_rebel/fire1.wav"
})

sound.Add({
	name = "Fire2",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	level = 75,
	pitch = {60, 70},
	sound = ")weapons/zs_rebel/fire1.wav"
})

--[[
sound.Add({
	name = 			"Weapon_M3.Pump",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_rebel/pump.wav"	
})]]

sound.Add({
	name = 			"Pump2",			
	channel = 		CHAN_ITEM,
	volume = 0.7,
	level = 30,
	pitch = {75, 75},
	sound = 			"weapons/zs_rebel/pump.wav"	
})

--[[
sound.Add({
	name = 			"Weapon_M3.Insertshell",			
	channel = 		CHAN_ITEM,
	volume = 1,
	level = 60,
	pitch = {80, 80},
	sound = 			"weapons/zs_rebel/insert.wav"	
})]]
