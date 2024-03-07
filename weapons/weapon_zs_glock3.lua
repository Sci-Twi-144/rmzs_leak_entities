AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")
SWEP.PrintName = (translate.Get("wep_glock3"))
SWEP.Description = (translate.Get("desc_glock3"))

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
    SWEP.ViewModelFOV = 60
    SWEP.ViewModelFlip = false

    SWEP.HUD3DBone = "glock_slide"
    SWEP.HUD3DPos = Vector(0.8, 0, -1)
    SWEP.HUD3DAng = Angle(0, 180, 160)
    SWEP.HUD3DScale = 0.01

	SWEP.ViewModelBoneMods = {
		["glock_slide"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local lBarrelOrigin = Vector(0, 0, 0)
	function SWEP:Think()
		if (self:Clip1() == 0) and not (self:GetReloadFinish() > 0) then
            self.ViewModelBoneMods[ "glock_slide" ].pos = LerpVector( FrameTime() * 16, self.ViewModelBoneMods[ "glock_slide" ].pos, Vector(0, 0, -1) )
        else
            self.ViewModelBoneMods[ "glock_slide" ].pos = LerpVector( FrameTime() * 16, self.ViewModelBoneMods[ "glock_slide" ].pos, lBarrelOrigin )
        end

		if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
			self:SetIronsights(false)
		end

		if self:GetReloadFinish() > 0 then
			if CurTime() >= self:GetReloadFinish() then
				self:FinishReload()
			end

			return
		elseif self.IdleAnimation and self.IdleAnimation <= CurTime() then
			self.IdleAnimation = nil
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
		self:SmoothRecoil()
	end

	function SWEP:DrawWorldModel()
		self:SetBodygroup(self:FindBodygroupByName("w_pistol"), self.BodyGroup)
		self.BaseClass.DrawWorldModel(self)
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/rmzs/weapons/glock/c_glock18.mdl"
SWEP.WorldModel = "models/rmzs/weapons/glock/w_glock18.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/glock/fire_40.ogg"
SWEP.Primary.Sound2 = ")weapons/glock/fire-40-01.ogg"
SWEP.Primary.Damage = 17
SWEP.Primary.NumShots = 3
SWEP.Primary.Delay = 0.23

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.FireAnimSpeed = 1

SWEP.FirstDraw = true

SWEP.ConeMax = 4.5
SWEP.ConeMin = 3

SWEP.ResistanceBypass = 1.35

SWEP.Tier = 2
SWEP.BodyGroup = 0

SWEP.IronSightsPos = Vector(-2.3, 18, 2.6)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_FIDGET)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self.BaseClass.Deploy(self)
	local vm = self:GetOwner():GetViewModel()
	vm:SetBodygroup(vm:FindBodygroupByName("glock_slide"), self.BodyGroup)
	return true
end

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
	self.ReloadTimerAnim = CurTime() + self:SequenceDuration() * self:GetReloadSpeedMultiplier()
end

function SWEP:SendWeaponAnimation()
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
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

	if self.BodyGroup == 2 then
		self:EmitSound(")weapons/glock/fire_supp_40.ogg", self.SoundFireLevel, 100 + (1 - (clip1 / maxclip1)) * 35, self.SoundFireVolume, CHAN_WEAPON)
		self:EmitSound(")weapons/glock/fire-40-sup-01.ogg", self.SoundFireLevel, 100 + (1 - (clip1 / maxclip1)) * 35, self.SoundFireVolume, CHAN_WEAPON)
	else
		self:EmitSound(self.Primary.Sound, self.SoundFireLevel, 100 + (1 - (clip1 / maxclip1)) * 35, self.SoundFireVolume, CHAN_WEAPON)
		self:EmitSound(self.Primary.Sound2, self.SoundFireLevel, 100 + (1 - (clip1 / maxclip1)) * 35, self.SoundFireVolume, CHAN_WEAPON)
	end
end

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.2, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.25, 3)

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_collider")), (translate.Get("desc_collider")), function(wept)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_RESISTANCE_BYPASS, 0, 4, branch)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_CLIP_SIZE, 0, 4, branch)
	wept.Primary.NumShots = 2
	wept.Primary.Damage = wept.Primary.Damage * 1.45
	wept.ConeMin = wept.ConeMin * 0.65
	wept.ConeMax = wept.ConeMax * 0.65
	wept.Primary.Delay = 0.34

	wept.HasAbility = true
	wept.SpecificCond = true

	wept.BodyGroup = 1

	if CLIENT then
		wept.AbilityBar3D = function(self, x, y, hei, wid, col, val, max, name)
			self:DrawAbilityBar3D(x, y, hei, wid, Color(130, 30, 140), self:GetResource(), 15, "REAPER STACK")
		end

		wept.AbilityBar2D = function(self, x, y, hei, wid, col, val, max, name)
			self:DrawAbilityBar2D(x, y, hei, wid, Color(130, 30, 140), self:GetResource(), 15, "REAPER STACK")
		end

		wept.Draw3DHUD = function(self, vm, pos, ang)
			self.BaseClass.Draw3DHUD(self, vm, pos, ang)
		
			local wid, hei = 180, 200
			local x, y = wid * -0.6, hei * -0.5
		
			cam.Start3D2D(pos, ang, self.HUD3DScale)
				local owner = self:GetOwner()
				local ownerstatus = owner:GetStatus("reaper")
				if ownerstatus then
					local text = ""
					for i = 0, ownerstatus:GetStacks() -1 do
						text = text .. "+"
					end
					draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x + wid/2, y + hei * 0.15, Color(60, 30, 175, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			cam.End3D2D()
		end	
	end

	-- Dont forget upgrade that thing later and maybe add hud info
	wept.OnZombieKilled = function(self, zombie)
		local killer = self:GetOwner()	
			if killer:GetStatus("reaper") and killer:IsValid() then
			local reaperstatus = killer:GiveStatus("reaper", 14)
			if reaperstatus and reaperstatus:IsValid() then
				killer:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetStacks() * 30, 0.45)
			end
		end
	end
		
	wept.BulletCallback = function(attacker, tr, dmginfo)
		local trent = tr.Entity
		local wep = dmginfo:GetInflictor()

		if SERVER and trent and trent:IsValidZombie() then
			if trent:GetZombieClassTable().Skeletal then
				dmginfo:SetDamage(dmginfo:GetDamage() * 1.2)
			end
			
			if IsValid(wep) then
				if wep:GetTumbler() then
					wep:SetResource(wep:GetResource() - 15)
					local reaperstatus = attacker:GiveStatus("reaper", 14)
					if reaperstatus and reaperstatus:IsValid() then
						reaperstatus:SetStacks(math.min(reaperstatus:GetStacks() + 1, 3))
						attacker:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetStacks() * 30, 0.45)
						attacker.ColliderShootCount = 0
					end
				else
					wep:SetResource(wep:GetResource() + (1 * (attacker.AbilityCharge or 1)))
				end
				if wep:GetResource() >= 15 then
					wep:SetTumbler(true)
					wep:SetResource(15)
				elseif wep:GetResource() < 1 then
					wep:SetResource(0)
					wep:SetTumbler(false)
				end
			end
		end
	end
end)

local branch2 = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_glock3_silent")), (translate.Get("desc_shroud")), function(wept)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_RESISTANCE_BYPASS, 0, 4, branch2)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_CLIP_SIZE, 0, 4, branch2)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_MAX_SPREAD, 0, 4, branch2)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_MIN_SPREAD, 0, 4, branch2)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1, branch2)
	
	wept.Primary.Damage = 42
	wept.Primary.NumShots = 1
	wept.Primary.Delay = 0.3

	wept.ResistanceBypass = 1

	wept.HasAbility = true
	wept.SpecificCond = true

	wept.ConeMin = 0.9 -- надо было б описание тогда написать но лан, баг есть баг
	wept.ConeMax = 1.8

	wept.BodyGroup = 2

	wept.GetAuraRange = function(self)
		return 512
	end
end)
branch2.Colors = {Color(170, 170, 170), Color(120, 120, 120), Color(70, 70, 70)}
branch2.NewNames = {"Cloaked", "Covert", "Silent"}
branch2.Killicon = "weapon_zs_glock_fd917"

sound.Add({
	name = "SlideOpens",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/glock/slide_open.ogg"
})

sound.Add({
	name = "SlideCloses",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/glock/slide_close.ogg"
})

sound.Add({
	name = "MagTap",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound =  "weapons/glock/magtap.ogg"
})

sound.Add({
	name = "MagOut",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound =  "weapons/glock/magout.ogg"
})

sound.Add({
	name = "MagIn",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/glock/magin.ogg"
})

sound.Add({
	name = "MagOutEmpty",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/glock/magout_empty.ogg"
})

sound.Add({
	name = "MagInEmpty",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 100,
	sound = "weapons/glock/magin_empty.ogg"
})

sound.Add({
	name = "Starts",
	channel = CHAN_STATIC,
	volume = 0,
	level = 60,
	pitch = 100,
	sound = nil
})
