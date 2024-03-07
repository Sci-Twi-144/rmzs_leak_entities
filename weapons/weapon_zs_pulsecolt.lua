DEFINE_BASECLASS("weapon_zs_base")
AddCSLuaFile()	

SWEP.PrintName = (translate.Get("wep_pulsecolt"))	
SWEP.Description = (translate.Get("desc_pulsecolt"))	
SWEP.Slot = 1	
SWEP.SlotPos = 0	

if CLIENT then	
	SWEP.ViewModelFlip = false	
	SWEP.ViewModelFOV = 70	

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1.1, -0.55, 0.4)
	SWEP.HUD3DAng = Angle(180, 0, -125)
	SWEP.HUD3DScale = 0.015
	
	SWEP.VMPos = Vector(2, 4, -1)
	SWEP.VMAng = Vector(0, 0, 0)

	function SWEP:DrawAds()
		if not self:GetIronsights() then
			self.ViewModelFOV = 60
		end
	end
	
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, Color(192, 128, 0), self:GetResource(), self.AbilityMax, "POWER SHOT", true, 3, 1/3)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, Color(192, 128, 0), self:GetResource(), self.AbilityMax, "Power Shot", true, 3, 1/3)
	end
	
	function SWEP:HandleParticles(turn)
		local vm = self:GetOwner():GetViewModel()
		if turn then
			vm:StopParticles()
			ParticleEffectAttach( "disintegrator_beam_balls", PATTACH_POINT_FOLLOW, vm, 1)
			ParticleEffectAttach( "disintegrator_beam_balls", PATTACH_POINT_FOLLOW, vm, 1)
			ParticleEffectAttach( "disintegrator_beam_balls", PATTACH_POINT_FOLLOW, vm, 1)
		else
			vm:StopParticles()
		end
	end
end	

SWEP.Base = "weapon_zs_base"	

SWEP.HoldType = "pistol"	

SWEP.ViewModel = "models/rmzs/weapons/pulsecolt/c_pulsecolt.mdl"	
SWEP.WorldModel = "models/rmzs/weapons/pulsecolt/w_pulse_colt.mdl"	
SWEP.UseHands = true	

SWEP.CSMuzzleFlashes = false	

SWEP.SoundFireVolume = 0.8
SWEP.SoundFireLevel = 79
SWEP.SoundPitchMin = 97
SWEP.SoundPitchMax = 103

SWEP.ReloadSound = nil
SWEP.Primary.Sound = Sound("Pulse_M1911.Fire")
SWEP.Primary.Damage = 54
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 60
SWEP.RequiredClip = 2	

SWEP.ConeMax = 2	
SWEP.ConeMin = 1.5	

SWEP.IronSightsPos = Vector(-4.32, 9, 1.4)
SWEP.IronSightsAng = Vector(-0.2, 0.02, 0)

SWEP.TracerName = "AR2Tracer"	
--SWEP.TracerName = "tracer_disentegrator"	

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.25)	
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)	
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 4, 1)

SWEP.PointsMultiplier = 1.1	

SWEP.HasAbility = true
SWEP.AbilityMax = 650 * 3

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 1
SWEP.LegDamage = 1
SWEP.InnateLegDamage = true
SWEP.Tier = 4

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HasAbility = true
SWEP.BaseDamage = SWEP.Primary.Damage
SWEP.ReloadAct = ACT_VM_RELOAD
SWEP.ReloadActEmpt = ACT_VM_RELOAD_EMPTY
SWEP.FirstDraw = true
SWEP.ChargeShot = false

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
local math_random = math.random

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "weapons/pulsepistol/pulse_pistol_charging.wav")
end

function SWEP:Deploy()
	if self.FirstDraw then
		self:SendWeaponAnim(ACT_VM_DRAW_DEPLOYED)
		self.FirstDraw = false
	end

	self.BaseClass.Deploy(self)
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	if self:GetIronsights() and self:GetResource() >= self.AbilityMax/3 then
		self:SetTumbler(true)
		self.Primary.Damage = self.BaseDamage + self.BaseDamage * 1.35
		self.TracerName = "tracer_disentegrator"
	else
		if self:GetResource() < self.AbilityMax then
			self:SetTumbler(false)
		end
		self.Primary.Damage = self.BaseDamage
		self.TracerName = "AR2Tracer"
	end
	
	local owner = self:GetOwner()
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	
	local stbl = E_GetTable(self)
	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(stbl.Primary.Damage, stbl.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
local math_random = math.random


function SWEP.BulletCallback(attacker, tr, dmginfo)	
	local source = dmginfo:GetInflictor()
	if IsFirstTimePredicted() then	
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end	
	if source:GetTumbler() then
		local source = dmginfo:GetInflictor()
		local damage = dmginfo:GetDamage()
		if SERVER then
			util.BlastDamagePlayer(source, attacker, tr.HitPos, 100 * (attacker.ExpDamageRadiusMul or 1), damage, DMG_DIRECT, 0.8)			
			for _, enc in pairs(util.BlastAlloc(source, attacker, tr.HitPos, 100 * (attacker.ExpDamageRadiusMul or 1))) do
				if enc:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", enc, attacker) then
					enc:AddLegDamageExt(damage * 0.08, attacker, source, SLOWTYPE_PULSE)
				end
			end
			
			local effectdata = EffectData()
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetNormal(attacker:GetAimVector())
			util.Effect("explosion_disentegrator", effectdata, true, true)
		end
		source:SetResource(source:GetResource() - source.AbilityMax/3)
		source:SetTumbler(false)
	end
	if tr.Entity and tr.Entity:IsValidLivingZombie() and source:GetResource() >= source.AbilityMax then
		source:SetResource(source.AbilityMax)
		--source:SetTumbler(true)
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end
	--PrintTable(self:GetAttachments())
	local stbl = E_GetTable(self)
	
	if (self:Clip1() < stbl.RequiredClip) and self:CanReload() then
		self:Reload()
		return false
	end
	
    if self:Clip1() < stbl.RequiredClip then
        self:EmitSound(stbl.DryFireSound, 75, 100, 0.7, CHAN_WEAPON)
		self:SetNextPrimaryFire(CurTime() + math.max(0.3, stbl.Primary.Delay))
        self:SendWeaponAnim(self:GetIronsights() and ACT_VM_ISHOOTDRY or ACT_VM_DRYFIRE)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(((self:Clip1() == 0) and ACT_VM_SHOOTLAST) or (self:GetIronsights() and (self:Clip1() == 0) and ACT_VM_ISHOOT_LAST) or (self:GetIronsights() and ACT_VM_ISHOOT) or ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
	self.IdleActivity = (self:Clip1() == 0) and (self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim((self:Clip1() == 0) and self.ReloadActEmpt or self.ReloadAct)
end

function SWEP:FinishReload()
	self.IdleActivity = ACT_VM_IDLE
	self.BaseClass.FinishReload(self)
end

function SWEP:SecondaryAttack()
	self.BaseClass.SecondaryAttack(self)
	self.IdleActivity = (self:Clip1() == 0) and (self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE
	self:SendWeaponAnim((self:Clip1() == 0) and (self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE)
end

sound.Add({
	name = "Pulse_M1911.safety",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "weapons/pulse_colt/pulse_m1911_safety.wav"
})

sound.Add({
	name = "Pulse_M1911.Empty",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "weapons/pulse_colt/pulse_m1911_empty.wav"
})

sound.Add({
	name = "Pulse_M1911.Magout",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "weapons/pulse_colt/pulse_m1911_magout.wav"
})

sound.Add({
	name = "Pulse_M1911.MagHit",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "weapons/pulse_colt/pulse_m1911_maghit.wav"
})

sound.Add({
	name = "Pulse_M1911.Fire",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	sound = "weapons/pulse_colt/pulse_m1911_fire1.wav"
})

sound.Add({
	name = 			"Weapon_Nam_M1911.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_magrelease.wav"
})

sound.Add({
	name = 			"Weapon_Nam_M1911.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_magin.wav"
})

sound.Add({
	name = 			"Weapon_Nam_M1911.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_boltback.wav"
})

sound.Add({
	name = 			"Weapon_Nam_M1911.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_boltrelease.wav"
})