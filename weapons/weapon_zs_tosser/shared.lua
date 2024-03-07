DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_tosser"))
SWEP.Description = (translate.Get("desc_tosser"))

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CoolDown = 15
SWEP.AbilityMax = SWEP.CoolDown
SWEP.TakeAmmoForGR = 15

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/rmzs/weapons/mp7/c_mp7a3.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

-- SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")

SWEP.SoundFireVolume = 0.55
SWEP.SoundFireLevel = 140
SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 105
SWEP.Primary.Sound = Sound("Project_MMOD_SMG1.Fire")

SWEP.Primary.Damage = 18.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.08

SWEP.Primary.ClipSize = 45
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.BulletType = SWEP.Primary.Ammo
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.Secondary.Delay = 0.75
SWEP.Secondary.Damage = 75
SWEP.Secondary.ClipSize = 1
--SWEP.Secondary.Ammo = "impactmine"
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Sound = ")weapons/mp7/glauncher.wav"
SWEP.DryFireSoundGL = ")weapons/ak103/gp30_empty.wav"
GAMEMODE:SetupDefaultClip(SWEP.Secondary)

SWEP.ReloadSpeed = 0.78
SWEP.FireAnimSpeed = 0.55

SWEP.Tier = 3

SWEP.ConeMax = 5.5
SWEP.ConeMin = 2.5

SWEP.IronSightsPos = Vector(-4.45, 5, 1.65)

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ResistanceBypass = 0.75

SWEP.HasAbility = true
SWEP.SpecificCond = true

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false

SWEP.Primary.Projectile = "projectile_grenade_ak103"
SWEP.Primary.ProjVelocity = 2200

SWEP.Primary.ProjExplosionRadius = 72
SWEP.Primary.ProjExplosionTaper = 0.96

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_COOLDOWN, -2)
local branch1 = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_thrower")), (translate.Get("desc_thrower")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 1.1
	wept.Primary.Delay = wept.Primary.Delay * 7.5
	wept.Primary.BurstShots = 3
	wept.CoolDown = wept.CoolDown * 0.6
	wept.Primary.ClipSize = 30
	wept.TakeAmmoForGR = 18

	wept.ConeMax = 5.5 * 0.5
	wept.ConeMin = 2.5 * 0.75

	wept.InnateBounty = true
	wept.BountyDamage = 0.33

	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end
		if self:GetFireMode() == 1 then
			self:RecalculateCSBurstFire(false)

			self:SetNextPrimaryFire(CurTime() + 0.75)
	
			self:EmitGlFireSound()
			self:TakeCombinedPrimaryAmmo(self.TakeAmmoForGR)
			if SERVER then
				self:ShootGrenade(self.Primary.Damage, self.Primary.NumShots)
			end
			self.IdleAnimation = CurTime() + self:SequenceDuration()
		end
	
		if self:GetFireMode() == 1 then return end
		self:RecalculateCSBurstFire(true)
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitFireSound()

		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	if CLIENT then
		wept.DefineFireMode3D = function(self)
			if self:GetFireMode() == 0 then
				return "BURST"
			else
				return "GL"
			end
		end
		
		wept.DefineFireMode2D = function(self)
			if self:GetFireMode() == 0 then
				return "3 Round Burst"
			else
				return "Grenade Launcher"
			end
		end
	end

	wept.VMPos = Vector(0, 0, 0)
	wept.VMAng = Vector(0, 0, 0)
	
	wept.BulletCallback = function(attacker, tr, dmginfo)
		if SERVER then
		local wep = dmginfo:GetInflictor()
			local ent = tr.Entity
			if ent:IsValidLivingZombie() then
				local hits = rawget(PlayerIsMarked2, ent)["Hitcount"] or 0
				if hits and hits >= 3 then
					ent:ThrowFromPositionSetZ(tr.StartPos, 175, nil, true)
					-- --ent:ApplyZombieDebuff("zombiestrdebuff", 3, {Applier = attacker, Damage = 0.15}, true, 40)
					rawset(PlayerIsMarked2, ent, {})
				end

				local hitcount = rawget(PlayerIsMarked2, ent)["Hitcount"] and (rawget(PlayerIsMarked2, ent)["Hitcount"] + 1 ) or 1
				rawset(PlayerIsMarked2, ent, {Time = CurTime() + 0.25, Hitcount = hitcount})
			end
		end
	end
	
	wept.Think = function(self)
		BaseClass.Think(self)

		self:ProcessBurstFire()
	end

	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_COOLDOWN, 0, 4, branch1)
	--GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_FIRE_DELAY, -0.065, 1, branch1)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_BOUNTY, 0.07, 3, branch1)
end)

GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_proliferator")), (translate.Get("desc_proliferator")), "weapon_zs_proliferator")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	BaseClass.Initialize(self)

	timer.Simple(0.06, function()
		self.AbilityMax = self.CoolDown -- some tricks
		local ENTITY = self
		--print(ENTITY)
		hook.Add("Think", tostring(ENTITY), function() if not IsValid(ENTITY) then return end ENTITY:GrenadeThink() end)
	end)
end

function SWEP:Reload()
		local owner = self:GetOwner()
	if owner:IsHolding() or self:GetCharging() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	local stbl = E_GetTable(self)
	-- Custom reload function to change reload speed.
	if self:CanReload() then
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(stbl.IdleAnimation)
		self:SetReloadStart(CurTime())

		self:SendReloadAnimation()
		self:ProcessReloadEndTime()

		owner:DoReloadEvent()

		self:EmitReloadSound()
	elseif self:GetSequenceActivityName(self:GetSequence()) != "ACT_VM_FIDGET" and self:GetReloadFinish() < CurTime() then
		self:SendWeaponAnim(ACT_VM_FIDGET)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP.GrenadeThink(ENTITY)
	if not ENTITY:GetOwner() then hook.Remove("Think", tostring(ENTITY)) return end
	if not ENTITY:GetTumbler() then
		local timeleft = math.floor(CurTime() - ENTITY:GetResource())
		if not (timeleft < ENTITY.AbilityMax) or ENTITY:GetTumbler() then
			local cd = 1 * (ENTITY:GetOwner().AbilityCharge or 1)
			ENTITY:SetResource(ENTITY:GetResource() + cd, true)

			if timeleft == ENTITY.AbilityMax then
				ENTITY:SetTumbler(true)
				ENTITY:SetResource(ENTITY.AbilityMax - CurTime() ,true)
			end
		end
	end
end

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
	local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK
	self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
		if CLIENT then
			self.ViewModelFOV = 75
		end
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	local stbl = E_GetTable(self)
	local checkm = ((self:GetFireMode() == 1) and self:GetTumbler()) and self:Clip1() or 0
    local isgl = (self:GetFireMode() == 1) and checkm or self:Clip1()
	local chammo = stbl.RequiredClip

	if (self:GetFireMode() == 1) and self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) < self.TakeAmmoForGR then return end

	if not (self:GetFireMode() == 1) and (isgl < chammo) and self:CanReload() then
		self:Reload()
		return false
	end

	if ((isgl < chammo) and not (self:GetFireMode() == 1)) or ((self:GetFireMode() == 1) and not self:GetTumbler()) then
		self:EmitSound(isgl and stbl.DryFireSoundGL or stbl.DryFireSound, 75, 100, 0.7, CHAN_WEAPON)
		self:SetNextPrimaryFire(CurTime() + math.max(0.6, stbl.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    if self:GetFireMode() == 1 then
        self:SetNextPrimaryFire(CurTime() + 0.75)
        self:EmitGlFireSound()
		self:TakeCombinedPrimaryAmmo(self.TakeAmmoForGR)
        if SERVER then
            self:ShootGrenade(self.Primary.Damage, self.Primary.NumShots)
        end
        self.IdleAnimation = CurTime() + self:SequenceDuration()
    end

    if self:GetFireMode() == 1 then return end
    self.BaseClass.PrimaryAttack(self)
end

local math_random = math.random
function SWEP:EmitGlFireSound()
	self:EmitSound(self.Secondary.Sound, self.SoundFireLevel, math_random(self.SoundPitchMin, self.SoundPitchMax), self.SoundFireVolume, CHAN_WEAPON)
end

function SWEP:OnRemove()
	local ENTITY = self
	hook.Remove("Think", tostring(ENTITY))
end

sound.Add({
	name = 			"Project_MMOD_SMG1.Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = {
			"weapons/mp7/fire1.wav",
			"weapons/mp7/fire2.wav",
			"weapons/mp7/fire3.wav",			
}
})

sound.Add({
	name = 			"Project_MMOD_SMG1.ClipOut",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp7/clipout.wav"
})

sound.Add({
	name = 			"Project_MMOD_SMG1.ClipIn",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp7/clipin.wav"
})

sound.Add({
	name = 			"Project_MMOD_SMG1.BRelease",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp7/boltforward.wav"
})

sound.Add({
	name = 			"Project_MMOD_SMG1.GripFold",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp7/gripfold.wav"
})

sound.Add({
	name = 			"Project_MMOD_SMG1.GripUnfold",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp7/gripunfold.wav"
})
