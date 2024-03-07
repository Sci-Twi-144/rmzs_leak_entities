AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_beretta"))
SWEP.Description = (translate.Get("desc_beretta"))

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.AbilityText = "Mass Ammo Back"
SWEP.AbilityColor = Color(0, 150, 50)
SWEP.AbilityMax = 1600 * (GAMEMODE.ZombieEscape and 4 or 1)

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80
	SWEP.ShowWorldModel = false 

	SWEP.HUD3DBone = "weapon"
	SWEP.HUD3DPos = Vector(0.9, -4, 0.5)
	SWEP.HUD3DAng = Angle(180, 0, -125)
	SWEP.HUD3DScale = 0.0125

--	SWEP.VMPos = Vector(0,3,0)
	SWEP.VMPos = Vector(1.5,1,-1)

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_m9.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.1, -1.3), angle = Angle(0, -7, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}	

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "IRONSIG"
		else
			return "ABILITY"
		end
	end
	
	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "IRONSIGHTS"
		else
			return "MASS AMMO STATUS"
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"
SWEP.LoweredHoldType = "normal"

SWEP.ViewModel = "models/weapons/tfa_ins2/c_beretta.mdl"
SWEP.WorldModel	= "models/weapons/tfa_ins2/w_m9.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/tfa_ins2/m9/fire_"..math.random(1,3)..".wav"
SWEP.Primary.Damage = 60
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 15
GAMEMODE:SetupDefaultClip(SWEP.Primary)
SWEP.Primary.Recoil = 0.75

SWEP.FireAnimSpeed = 0.9

SWEP.ResistanceBypass = 0.8

SWEP.HasAbility = true
SWEP.SpecificCond = true

SWEP.Tier = 5

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false

SWEP.Primary.Ammo = "pistol"
SWEP.BulletType = SWEP.Primary.Ammo
SWEP.ConeMax = 1.6
SWEP.ConeMin = 0.7

SWEP.IronSightsPos = Vector(-3.7, -2, 1.425)
SWEP.IronSightsAng = Vector(-0.058, 0, 0)



function SWEP:SecondaryAttack()
	if self:GetFireMode() == 1 then
		self:GiveStatus()
	elseif self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:GiveStatus()
	local attacker = self:GetOwner()
	if self:GetTumbler() then
		self:SetResource(0)
		self:SetTumbler(false)
		attacker:EmitSound("ambient/machines/combine_terminal_idle2.wav", 70, 75)
		if SERVER then
			attacker:ApplyHumanBuff('ammoback', 15, {Applier = attacker})
			local wep = attacker:GetActiveWeapon()
			local count = 0
			for _, ent in pairs(util.BlastAlloc(wep, attacker, attacker:GetPos(), 64)) do
				if ent:IsValidLivingPlayer() and ent ~= attacker then
					ent:ApplyHumanBuff('ammoback', 15, {Applier = attacker})
					count = count + 1
					if count >= 3 then break end
				end
			end
		end
	end
end	

function SWEP:SendWeaponAnimation()
	local iron = self:GetIronsights()

	if self:Clip1() == 0 then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_EMPTY)
	else
		self:SendWeaponAnim(iron and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK)
	end
	self.IdleActivity = (self:Clip1() == 0) and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
	self.IdleActivity = ACT_VM_IDLE
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:Deploy()
	self:SendWeaponAnim((self:Clip1() == 0) and ACT_VM_DRAW_EMPTY or ACT_VM_DRAW_DEPLOYED)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self.BaseClass.Deploy(self)
	return true
end

SWEP.LowAmmoSoundThreshold = 0.5
SWEP.LowAmmoSoundHandgun = ")weapons/tfa/lowammo_indicator_handgun.wav"
SWEP.LastShot = ")weapons/tfa/lowammo_dry_handgun.wav"
function SWEP:EmitFireSound()
	local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
	local mult = clip1 / maxclip1
	self:EmitSound(self.LowAmmoSoundHandgun, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
	if self:Clip1() <= 1 then
		self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
	end

	self:EmitSound(self.Primary.Sound, self.SoundFireLevel, 100 + (1 - (clip1 / maxclip1)) * 35, self.SoundFireVolume, CHAN_WEAPON)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity 
	if SERVER and ent:IsValidLivingZombie() and (tr.HitGroup == HITGROUP_HEAD) then
		if wep:GetResource() > wep.AbilityMax then
			wep:SetResource(wep.AbilityMax)
			wep:SetTumbler(true)
		else
			wep:SetResource(wep:GetResource() + dmginfo:GetDamage())
		end
	end
end

sound.Add({
	name = 			"TFA_INS2.M9.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m9/handling/m9_boltback.wav"
})

sound.Add({
	name = 			"TFA_INS2.M9.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m9/handling/m9_boltrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.M9.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m9/handling/m9_empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.M9.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m9/handling/m9_magrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.M9.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m9/handling/m9_magout.wav"
})

sound.Add({
	name = 			"TFA_INS2.M9.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m9/handling/m9_magin.wav"
})

sound.Add({
	name = 			"TFA_INS2.M9.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/m9/handling/m9_maghit.wav"
})