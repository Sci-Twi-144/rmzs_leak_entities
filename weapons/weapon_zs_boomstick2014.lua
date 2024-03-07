AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = (translate.Get("wep_boomstick2014")) -- Boomstick v2014
SWEP.Description = (translate.Get("desc_boomstick2014")) -- Старая версия бумстика, которая имеет колоссальный урон, но отсуствует кнокбэк

-- Ивентовое оружие. Бумстик из 2014 сборки, имел колоссальный урон и практически отсутсвовала отдача, также отсутсвовал кнокбэк, в этом свепе урон был увеличен (стандарт 36х6)
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.65, 0, -8)
	SWEP.HUD3DScale = 0.025

	SWEP.ViewModelFlip = false
end

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadDelay = 0.5

SWEP.Primary.Sound = ")weapons/shotgun/shotgun_dbl_fire.wav"
SWEP.Primary.Damage = 38
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 1

SWEP.Recoil = 1

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.DefaultClip = 28

SWEP.ConeMax = 13.5
SWEP.ConeMin = 12

SWEP.Tier = 5
--SWEP.MaxStock = 2

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.FireAnimSpeed = 0.4

SWEP.PumpActivity = ACT_SHOTGUN_PUMP
SWEP.PumpSound = Sound("Weapon_Shotgun.Special1")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity

	if SERVER and ent and ent:IsValidLivingZombie() then
		dmginfo:SetDamageForce(attacker:GetUp() * 280000 + attacker:GetForward() * 750000)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self:GetOwner()

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitSound(self.Primary.Sound)

	local clip = self:Clip1()

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self:GetCone())

	self:TakePrimaryAmmo(clip)
	owner:ViewPunch(clip * 0.5 * self.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end
