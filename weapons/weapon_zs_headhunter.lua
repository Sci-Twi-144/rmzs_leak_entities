AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_headhunter"))
SWEP.Description = (translate.Get("desc_headhunter"))

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.AbilityText = "HEADSHOTS"
SWEP.AbilityColor = Color(75, 65, 250)
SWEP.AbilityMax = 14
if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(0.9, -0.55, 0.4)
	SWEP.HUD3DAng = Angle(180, 0, -125)
	SWEP.HUD3DScale = 0.015
	
	SWEP.VMPos = Vector(2, 2, -1)
	SWEP.VMAng = Vector(0, 0, 0)
	
	SWEP.IronSightsPos = Vector(-4.32, 9, 1.25)
	SWEP.IronSightsAng = Vector(0.8, 0.02, 0)
	
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	SWEP.WElements = {
		["wep"] = { type = "Model", model = "models/weapons/tfa_m1911/w_ins2_colt_m45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.591, 1.975, -1.839), angle = Angle(-7.23, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/rmzs/weapons/colt/c_m1911_and_m45.mdl"
SWEP.WorldModel = "models/rmzs/weapons/colt/w_m1911.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.SoundFireVolume = 0.7
SWEP.SoundPitchMin = 90
SWEP.SoundPitchMax = 120
SWEP.Primary.Sound = ")weapons/tfa_m1911/m1911_fire.wav"
SWEP.Primary.Damage = 62
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.3

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 0.7

SWEP.ConeMax = 2.5
SWEP.ConeMin = 1

SWEP.DryFireSound = ")weapons/tfa_m1911/m1911_empty.wav"
SWEP.PArsenalModel = "models/weapons/tfa_m1911/w_ins2_colt_m45.mdl"

SWEP.IdleActivity = ACT_VM_IDLE
SWEP.ReloadSpeed = 0.9
SWEP.ResistanceBypass = 0.65
SWEP.HeadshotMulti = 2
SWEP.HasAbility = true
SWEP.HeadshotCounter = true
SWEP.Tier = 4
SWEP.ReloadAct = ACT_VM_RELOAD
SWEP.ReloadActEmpt = ACT_VM_RELOADEMPTY
SWEP.CSRecoilMul = 0.8

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.46, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.22, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 2, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_speedy")), (translate.Get("desc_speedy")), function(wept)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_CLIP_SIZE, 3, 1, branch)
	wept.Primary.Damage = wept.Primary.Damage * 0.9
	wept.HeadshotMulti = 2
	wept.HeadshotCounter = false
	wept.AbilityText = "FASTHAND"
	wept.AbilityColor = Color(235, 210, 0)
	wept.AbilityMax = 800
	wept.ReloadAct = ACT_VM_RELOAD2
	wept.ReloadActEmpt = ACT_VM_RELOAD_EMPTY
	wept.Primary.ClipSize = 12
	wept.IronSightsPos = Vector(-4.32, 9, 1.5)
	wept.IronSightsAng = Vector(0.1, 0.02, 0)
	wept.WorldModel = "models/weapons/w_pistol.mdl"
	
	wept.Primary.BurstShots = 3
	
	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 3.1)
		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)
		self:EmitFireSound()

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	wept.Think = function(self)
		self.BaseClass.Think(self)
		self:ProcessBurstFire(3)
	end
	
	wept.BulletCallback = function(attacker, tr, dmginfo)
		local ent = tr.Entity
		local wep = dmginfo:GetInflictor()
		if ent:IsValidLivingZombie() then
			if wep:GetResource() >= 800 then
				wep:SetResource(0)
				if SERVER then
					attacker:GiveStatus("healdartboost", 8)
					attacker:SimpleStatus("fasthand",  15, {Applier = attacker, Stacks = 1, Max = 3}, true, false)
				end
			end
		end
	end
end)

local br = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_pulsecolt")), (translate.Get("desc_pulsecolt")), "weapon_zs_pulsecolt")
br.Colors = {Color(130, 130, 240), Color(65, 65, 120), Color(39, 39, 90)}
--GAMEMODE:AddNewRemantleBranch(SWEP, 3, "'Walther' Handgun", "", "weapon_zs_walther") -- too op, need new weapon mechanic

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.FirstDraw = true

	timer.Simple(0, function()
		if self:IsValid() and self:GetOwner():IsValid() and not self.Branch then
			self:ChangeGroup()
		end
	end)
end

function SWEP:ChangeGroup()
	if self:IsValid() and self:GetOwner():GetViewModel():IsValid() and self:GetOwner():GetViewModel() then
		local vm = self:GetOwner():GetViewModel()
		vm:SetBodygroup(vm:FindBodygroupByName("Weapon"), 1)
		vm:SetBodygroup(vm:FindBodygroupByName("Mag"), 1)
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

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

function SWEP:PrimaryAttack()
	if self.Branch ~= 1 then
		self.HeadshotMulti = self:GetTumbler() and 4 or 2
	end
    self.BaseClass.PrimaryAttack(self)
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

function SWEP:Deploy()
    self:SendWeaponAnim(self.FirstDraw and ACT_VM_READY or (self:Clip1() == 0) and ACT_VM_DRAW_EMPTY or ACT_VM_DRAW) -- you really don't need cock a weapon every time when you take it!
	self.IdleActivity = (self:Clip1() == 0) and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
	self.FirstDraw = false

	if not self.Branch then
		local vm = self:GetOwner():GetViewModel()
		vm:SetBodygroup(vm:FindBodygroupByName("Mag"), 1)
		vm:SetBodygroup(vm:FindBodygroupByName("Weapon"), 1)
	end

	self.BaseClass.Deploy(self)
	return true
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity 
	if SERVER and ent:IsValidLivingZombie() and wep:IsValid() then
		local minus = wep.AbilityMax/wep:GetPrimaryClipSize()
		if wep:GetTumbler() and not ent:CallZombieFunction2("ScalePlayerDamage", tr.HitGroup, dmginfo) then
			wep:SetResource(math.max(wep:GetResource() - minus, 0), false)
		end
		if wep:GetTumbler() and wep:GetResource() <= 0 then
			wep:SetTumbler(false) 
		elseif wep:GetResource() >= wep.AbilityMax then
			wep:SetTumbler(true)
		end
	end
end

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Safety",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_safety.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_boltback.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_boltrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_magrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_magout.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_magin.wav"
})

sound.Add({
	name = 			"TFA_INS2.Colt_M45.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/tfa_m1911/m1911_maghit.wav"
})