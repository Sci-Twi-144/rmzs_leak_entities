AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_smg"))
SWEP.Description = (translate.Get("desc_smg"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54

	SWEP.HUD3DBone = "Bolt"
	SWEP.HUD3DPos = Vector(0, 0.2, -1)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "AUTO"
		elseif self:GetFireMode() == 1 then
			return "BURST"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Auto"
		elseif self:GetFireMode() == 1 then
			return "3 Round-Burst"
		end
	end


	SWEP.ViewModelBoneMods = {
		["ValveBiped.square"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/rmzs/weapons/mp5k/c_mp5k.mdl"
SWEP.WorldModel = "models/rmzs/weapons/mp5k/w_mp5k.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapon/hmg/hmg_fire_player_01.wav"

SWEP.Primary.Damage = 15.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.13

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 1.19

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 4.5
SWEP.ConeMin = 2.5

SWEP.WalkSpeed = SPEED_FAST

SWEP.ResistanceBypass = 1.15

SWEP.IronSightsPos = Vector(-4.176, 4, 1.5)
SWEP.IronSightsAng = Vector(0.368, -0.197, 0)

SWEP.CantSwitchFireModes = false
SWEP.Primary.BurstShots = 3
SWEP.SetUpFireModes = 1

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin
SWEP.DamageSave = SWEP.Primary.Damage
SWEP.DelaySave = SWEP.Primary.Delay

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.StandartIronsightsAnim = false

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)


SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_IDLE or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	if self:GetFireMode() == 0 then
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	elseif self:GetFireMode() == 1 then
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 3.4)
		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)
		self:EmitFireSound()
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.ConeMin = self.ConeMinSave
		self.ConeMax = self.ConeMaxSave
		self.Primary.Damage = self.DamageSave
		self.Primary.Delay = self.DelaySave
		self:RecalculateCSBurstFire(false)
	elseif self:GetFireMode() == 1 then
		self.ConeMin = self.ConeMinSave * 0.75
		self.ConeMax = self.ConeMaxSave * 0.6
		self.Primary.Damage = self.DamageSave * 1.1
		self.Primary.Delay = self.DelaySave * 1.6
		self:RecalculateCSBurstFire(true)
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if self:GetFireMode() == 1 then
		self:ProcessBurstFire(3)
	end

	if CLIENT then
		if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle( math.random(0,1), math.random(-1,1), 0) )
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, 0, 0) )
		else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(0, 0, 0) )
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  Vector(0, 0, 0) )
		end
	end
end

-- function SWEP.BulletCallback(attacker, tr, dmginfo)		
	-- if SERVER then
		-- local wep = dmginfo:GetInflictor()
		-- if wep:GetFireMode() == 1 then
			-- local ent = tr.Entity
			-- if ent:IsValidLivingZombie() then
				-- local hits = rawget(PlayerIsMarked2, ent)["Hitcount"] or 0
				-- if hits and hits >= 3 then
					-- ent:ThrowFromPositionSetZ(tr.StartPos, 175, nil, true)
					-- -- --ent:ApplyZombieDebuff("zombiestrdebuff", 3, {Applier = attacker, Damage = 0.15}, true, 40)
					-- rawset(PlayerIsMarked2, ent, {})
				-- end

				-- local hitcount = rawget(PlayerIsMarked2, ent)["Hitcount"] and (rawget(PlayerIsMarked2, ent)["Hitcount"] + 1 ) or 1
				-- rawset(PlayerIsMarked2, ent, {Time = CurTime() + 0.25, Hitcount = hitcount})
			-- end
		-- end
	-- end
-- end
	
sound.Add({
	name = "Weapon_SMG2.Fire",
	channel = CHAN_USER_BASE+10,
	volume = 0.8,
	level = 60,
	pitch = {142, 148},
	sound = ")weapons/hmg/hmg_fire_player_01.wav"
})

sound.Add({
	name = "Weapon_SMG2.NPC_Fire",
	channel = CHAN_USER_BASE+10,
	volume = 0.75,
	level = 140,
	pitch = {142, 148},
	sound = ")weapons/hmg/hmg_fire_player_01.wav"
})

sound.Add({
	name = "Weapon_SMG2.Bolt_Grab",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapons/hmg/handling/hmg_bolt_grab_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = "weapons//handling/.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapons/akm/handling/akm_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Lock",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapons/hmg/handling/hmg_bolt_lock_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_bolt_release_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapons/akm/handling/akm_mag_in_01.wav"
})
