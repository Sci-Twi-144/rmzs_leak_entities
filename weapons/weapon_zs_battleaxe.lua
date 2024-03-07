AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_battleaxe"))
SWEP.Description = (translate.Get("desc_battleaxe"))

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "slide"
	SWEP.HUD3DPos = Vector(0.9, -0.55, 0.4)
	SWEP.HUD3DAng = Angle(180, 0, 90)
	SWEP.HUD3DScale = 0.012

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)

	SWEP.ViewModelBoneMods = {
		--["v_weapon.USP_Slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	--[[local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(3, -0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -12, 0) )
            self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos, Vector(-0, 0, 15) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
            self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.USP_Slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end]]
	
	function SWEP:Think()
		self.BaseClass.Think(self)
	end

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "SILENT"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "SILENT"
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/rmzs/weapons/usp/c_usp_tactical.mdl"
SWEP.WorldModel = "models/rmzs/weapons/usp/w_usp_tactical.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/usp/usp_unsil-1.wav"
SWEP.Primary.Damage = 26
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

--SWEP.IronSightsPos = Vector(-3, -1, 1.4)
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.ConeMax = 1.5
SWEP.ConeMin = 0.75

SWEP.AuraRange = 2048

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.ReloadActivity = ACT_VM_RELOAD
SWEP.IdleActivity = ACT_VM_IDLE
SWEP.AttackActivity = ACT_VM_PRIMARYATTACK
SWEP.DeployActivity = ACT_VM_DRAW
SWEP.ReloadAct = ACT_VM_RELOAD
SWEP.ReloadActEmpt = ACT_VM_RELOAD_EMPTY

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)

SWEP.IsShooting = 0

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.FirstDraw = true
end

function SWEP:FireAnimationEvent(pos, ang, event, options, source)
	--print(event, options)
	local vm = self:GetOwner():GetViewModel()
	if event == 3112 then
		vm:SetBodygroup(vm:FindBodygroupByName(options), 1)
	elseif event == 3111 then
		vm:SetBodygroup(vm:FindBodygroupByName(options), 0)
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
        self:SendWeaponAnim(self:OwnerAllowedIron(self:GetOwner()) and self:GetIronsights() and ACT_VM_ISHOOTDRY or ACT_VM_DRYFIRE)
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

function SWEP:SecondaryAttack()
	self.BaseClass.SecondaryAttack(self)
	--self:SendWeaponAnim((self:Clip1() == 0) and (self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE)
	--self.IdleActivity = (self:Clip1() == 0) and (self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE
end

function SWEP:SetIronsights(b)
	self:SetDTBool(DT_WEAPON_BASE_BOOL_IRONSIGHTS, b)
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	if stbl.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(stbl.IronSightsHoldType)
		else
			self:SetWeaponHoldType(stbl.HoldType)
		end
	end
	
	local blacklist = {
		["ACT_VM_DRAW_EMPTY"] = true,
		["ACT_VM_DRAW"] = true,
		["ACT_VM_PICKUP"] = true
	}
	
	if self:OwnerAllowedIron(owner) and not blacklist[self:GetSequenceActivityName(self:GetSequence())] then
		self:SendWeaponAnim((self:Clip1() == 0) and (self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE)
		self.IdleActivity = (self:Clip1() == 0) and (self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE
	end
	
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:OwnerAllowedIron(self:GetOwner()) and ((self:GetIronsights() and (self:Clip1() == 0) and ACT_VM_ISHOOT_LAST) or (self:GetIronsights() and ACT_VM_ISHOOT)) or ((self:Clip1() == 0) and ACT_VM_SHOOTLAST) or ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
	self.IdleActivity = (self:Clip1() == 0) and (self:OwnerAllowedIron(self:GetOwner()) and self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:OwnerAllowedIron(self:GetOwner()) and self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim((self:Clip1() == 0) and self.ReloadActEmpt or self.ReloadAct)
end

function SWEP:FinishReload()
	local isfake = self.FakeReload >= CurTime()
	
	self.IdleActivity = self:Clip1() < 1 and isfake and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
	self.BaseClass.FinishReload(self)
end

function SWEP:Deploy()
    self:SendWeaponAnim(self.FirstDraw and ACT_VM_PICKUP or (self:Clip1() == 0) and ACT_VM_DRAW_EMPTY or ACT_VM_DRAW) -- you really don't need cock a weapon every time when you take it!
	self.IdleActivity = (self:Clip1() == 0) and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
	self.FirstDraw = false
	
	if self:GetFireMode() == 1 then
		local vm = self:GetOwner():GetViewModel()
		vm:SetBodygroup(vm:FindBodygroupByName("Supressor"), 1)
	end

	self.BaseClass.Deploy(self)
	return true
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
	elseif self:GetSequenceActivityName(self:GetSequence()) != "ACT_VM_FIDGET" and self:GetReloadFinish() < CurTime() and self:Clip1() != 0 then
		self:SendWeaponAnim(ACT_VM_FIDGET)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.SpecialActivity = self:Clip1() == 0 and ACT_VM_PULLBACK_LOW or ACT_VM_DETACH_SILENCER
		self.Primary.Sound = ")weapons/usp/usp_unsil-1.wav"
		self.Primary.Damage = 26
		self.ConeMin = 0.75
		self.AuraRange = 2048
		self:SendSpecialAnimation()
	elseif self:GetFireMode() == 1 then
		self.SpecialActivity = self:Clip1() == 0 and ACT_VM_PULLBACK_HIGH or ACT_VM_ATTACH_SILENCER
		self.Primary.Sound = ")weapons/usp/usp1.wav"
		self.Primary.Damage = self.Primary.Damage * 0.9
		self.ConeMin = 0.5
		self.AuraRange = 512
		self:SendSpecialAnimation()
	end
end

function SWEP:OwnerAllowedIron(pl)
	return pl:GetInfo("zs_noironsights") != "1"
end

function SWEP:SendSpecialAnimation()
	self:SendWeaponAnim(self.SpecialActivity)
	local stbl = E_GetTable(self)
	local realtime = CurTime() + self:SequenceDuration(self:SelectWeightedSequence(self.SpecialActivity))
	self.FakeReload = realtime + 0.06
	self:SetSwitchDelay(realtime)
	self:SetReloadFinish(realtime) -- нужен другой способ
	self:SetNextPrimaryFire(realtime)
	stbl.IdleAnimation = CurTime() + realtime
	self.IdleActivity = (self:Clip1() == 0) and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
end

function SWEP:GetAuraRange()
	return self.AuraRange
end

sound.Add({
	name = "usp_fire",
	channel = CHAN_WEAPON,
	volume = 1,
	pitch = math.random(96, 105),
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/usp_tactical/pistol_fire_player_0"..math.random(1, 6)..".wav"
})

sound.Add({
	name = 			"usp_kpyxa.slide_rel",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/foley/pistol_slide_release_01.wav"
})

sound.Add({
	name = 			"usp_kpyxa.slide_pul",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/foley/pistol_slide_pull_01.wav"
})

sound.Add({
	name = 			"usp_kpyxa.mag_rel",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/foley/pistol_mag_release_01.wav"
})

sound.Add({
	name = 			"usp_kpyxa.mag_out",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/foley/pistol_mag_out_01.wav"
})

sound.Add({
	name = 			"usp_kpyxa.mag_in",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/foley/pistol_mag_in_01.wav"
})

sound.Add({
	name = 			"usp_kpyxa.slide_futz",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/foley/pistol_mag_futz_01.wav"
})

sound.Add({
	name = 			"usp_kpyxa.scrath",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/usp_silencer_screw" .. math.random(5) ..".wav"
})

sound.Add({
	name = 			"usp_kpyxa.att_finish",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/foley/usp_silencer_screw_off_end.wav"
})

sound.Add({
	name = 			"usp_kpyxa.attach_on",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/usp_silencer_screw_on_start.wav"
})

sound.Add({
	name = 			"usp_kpyxa.attach_off",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/usp_tactical/usp_silencer_screw_off_end.wav"
})