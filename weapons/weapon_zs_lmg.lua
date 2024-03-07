AddCSLuaFile()


DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'LMG-H"
SWEP.Description = ""

SWEP.PrintName = (translate.Get("wep_lmg"))
SWEP.Description = (translate.Get("desc_lmg"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
    SWEP.ShowViewModel = true

    SWEP.HUD3DBone = "body"
    SWEP.HUD3DPos = Vector(-1.5, -1, 3.6)
    SWEP.HUD3DAng = Angle(180, 0, -90)
    SWEP.HUD3DScale = 0.018

	SWEP.LowAmmoSoundThreshold = 0.33
	SWEP.LowAmmoSound = ")weapons/tfa/lowammo_indicator_automatic.wav"
	SWEP.LastShot = ")weapons/tfa/lowammo_dry_automatic.wav"
	function SWEP:EmitFireSound()
		BaseClass.EmitFireSound(self)
		local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
		local mult = clip1 / maxclip1
		self:EmitSound(self.LowAmmoSound, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
		if self:Clip1() <= 1 then
			self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/C_lmg.mdl"
SWEP.WorldModel = "models/w_lmg.mdl"
SWEP.UseHands = true

--SWEP.Primary.Sound = ")weapons/smg1/smg1_fire1.wav"
SWEP.Primary.Sound = Sound("fire")
SWEP.Primary.Damage = 26.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09
SWEP.Recoil = 0.6

SWEP.Primary.ClipSize = 75
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ResistanceBypass = 1.075

SWEP.ConeMax = 3.75
SWEP.ConeMin = 1.25

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.IronSightsPos = Vector(-3, 1, 1)

SWEP.TracerName = "AR2Tracer"
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.25, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local stbl = E_GetTable(self)
	local zeroclip = self:Clip1() == 0

	self:SendWeaponAnimation()
	owner:DoAttackEvent()
    --[[if self.Recoil > 0 then
        local r = math.Rand(0.8, 1)
        owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
    end]]

	if SERVER and (self:Clip1() % 15 == 1 or zeroclip) then
		for i = 1, zeroclip and 8 or 1 do
			local ent = ents.Create("projectile_shockball")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Up(), 90)
				ent:SetAngles(angle)

				ent:SetOwner(owner)
				ent.ProjDamage = self.Primary.Damage * 0.75 * (owner.ProjectileDamageMul or 1)
                ent.ProjSource = self
                ent.ShotMarker = i
                ent.Team = owner:Team()	

				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()

					angle = owner:GetAimVector():Angle()
					angle:RotateAroundAxis(angle:Forward(), math.Rand(0, 360))
					angle:RotateAroundAxis(angle:Up(), math.Rand(-cone/1.5, cone/1.5))
					phys:SetVelocityInstantaneous(angle:Forward() * 700 * (owner.ProjectileSpeedMul or 1))
				end
			end
		end
	end
	
	local aimvec = owner:GetAimVector()	
	local iscs = owner.HasCsShoot
	if iscs then
		local v = self:GetCSFireParams(aimvec)
		aimvec = v
	end
	
	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), aimvec, cone, numbul, self.Pierces, self.DamageTaper, dmg / (zeroclip and 1.5 or 1), nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)
	
	self:AddCSTimers()
	self:HandleVisualRecoil(stbl, iscs, owner, cone)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if IsFirstTimePredicted() then	
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)	
	end	
end


sound.Add(
{
	name = "lmg_draw",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	soundlevel = 100,
	pitch = {90,102},
	sound = {"weapons/lmg/lmg_draw.wav"}
})


sound.Add(
{
	name = "fire",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	soundlevel = 100,
	pitch = {90,102},
	sound = {"weapons/lmg/lmg_fire1.wav"}
})


sound.Add(
{
	name = "reload_start",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	soundlevel = 100,
	pitch = {95,102},
	sound = {"weapons/lmg/reload_start.wav"}
})

sound.Add(
{
	name = "reload_end",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	soundlevel = 100,
	pitch = {95,102},
	sound = {"weapons/lmg/reload_end.wav"}
})
