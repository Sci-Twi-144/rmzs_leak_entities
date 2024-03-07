DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_ak103"))
SWEP.Description = (translate.Get("desc_ak103"))

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_ak103_m.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.DryFireSound = ")weapons/ak103/empty.wav"
SWEP.DryFireSoundGL = ")weapons/ak103/gp30_empty.wav"

SWEP.Primary.Sound = ")weapons/ak103/fire.wav"
SWEP.Secondary.Sound = ")weapons/ak103/gp30_fp.wav"
SWEP.HeadshotMulti = 2.3
SWEP.Primary.Damage = 36.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Secondary.Delay = 0.75
SWEP.Secondary.Damage = 75
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.Ammo = "GrenadeHL1"
SWEP.Secondary.DefaultClip = 1

SWEP.Primary.Projectile = "projectile_grenade_ak103"
SWEP.Primary.ProjVelocity = 2200

SWEP.Primary.ProjExplosionRadius = 92
SWEP.Primary.ProjExplosionTaper = 0.92

SWEP.ReloadSpeed = 0.888

SWEP.ConeMax = 2.425
SWEP.ConeMin = 1.115

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 6
SWEP.MaxStock = 2
SWEP.ResistanceBypass = 0.75

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.HasAbility = true
SWEP.SpecificCond = true

SWEP.IronSightsPos = nil
SWEP.IronSightsAng = nil

SWEP.IdleActivity = nil

SWEP.PArsenalModel = "models/weapons/c_ak103_m.mdl"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.275)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.172)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5, 1)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	local stbl = E_GetTable(self)
    local isgl = (self:GetFireMode() == 1) and self:Clip2() or self:Clip1()

	if (isgl < stbl.RequiredClip) and self:CanReload() then
		self:Reload()
		return false
	end


    if isgl < stbl.RequiredClip then
        self:EmitSound(isgl and stbl.DryFireSoundGL or stbl.DryFireSound, 75, 100, 0.7, CHAN_WEAPON)
		self:SetNextPrimaryFire(CurTime() + math.max(0.6, stbl.Primary.Delay))
        self:SendWeaponAnimationDry()
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    if self:GetFireMode() == 1 then

        self:SetNextPrimaryFire(CurTime() + self:GetSecondaryFireDelay())

        local stbl = E_GetTable(self)

        self:EmitGlFireSound()
        self:TakeSecondaryAmmo(1)
        if SERVER then
            self:ShootGrenade(stbl.Primary.Damage, stbl.Primary.NumShots)
        end
        self.IdleAnimation = CurTime() + self:SequenceDuration()
    end

    if self:GetFireMode() == 1 then return end
    self.BaseClass.PrimaryAttack(self)
end

function SWEP:CallWeaponFunction()
    self.IdleActivity = (self:GetFireMode() == 0) and ACT_VM_IDLE or ACT_VM_IDLE_DEPLOYED
    self.Primary.Automatic = (self:GetFireMode() == 0) and true or false

    if self:GetSwitchDelay() >= CurTime() then return end

    local gltrans = (self:GetFireMode() == 0) and ACT_VM_UNDEPLOY_6 or ACT_VM_DEPLOY_6
    self:SendWeaponAnim(gltrans)
    local seq = self:SequenceDuration(self:SelectWeightedSequence(gltrans))
    
    self:SetSwitchDelay(CurTime() + seq)
    self:SetNextPrimaryFire(CurTime() + seq + 0.25) -- prevent anim glitch
end

function SWEP:SendWeaponAnimationDry() -- why not
    local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_DEPLOYED_6 or ACT_VM_DRYFIRE
    local dganim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_DEPLOYED_5 or ACT_VM_PRIMARYATTACK_5

    self:SendWeaponAnim((self:GetFireMode() == 0) and dfanim or dganim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SendWeaponAnimation()
    local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_DEPLOYED_4 or ACT_VM_PRIMARYATTACK
    local dganim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_DEPLOYED_7 or ACT_VM_PRIMARYATTACK_7
    self:SendWeaponAnim((self:GetFireMode() == 0) and dfanim or dganim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:SendReloadAnimation()
  --  local checkempty = (self:Clip1() == 0) and ACT_VM_RELOADEMPTY or ACT_VM_RELOAD
	self:SendWeaponAnim((self:GetFireMode() == 0) and ACT_VM_RELOAD or ACT_VM_RELOAD_M203)
    self:SetSwitchDelay(CurTime() + self:SequenceDuration() + 0.1)

    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
end

function SWEP:Deploy()
    self:SendWeaponAnim((self:GetFireMode() == 0) and ACT_VM_DRAW or ACT_VM_DRAW_M203)
    self.BaseClass.Deploy(self)
	return true
end

function SWEP:CanReload() -- oh fuck you!
    local clipone = (self:GetMaxClip1() > 0 and self:Clip1() < (self:GetPrimaryClipSize()) and self:ValidPrimaryAmmo() and self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) > 0)
    local cliptwo = (self:GetMaxClip2() > 0 and self:Clip2() < self:GetMaxClip2() and self:ValidSecondaryAmmo() and self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType()) > 0)
    local isgl = (self:GetFireMode() == 1) and cliptwo or (self:GetFireMode() == 0) and clipone
	return self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0 and isgl
end

function SWEP:FinishReload()
	self:SendWeaponAnim(self.IdleActivity or ACT_VM_IDLE)
	self:SetNextReload(0)
	self:SetReloadStart(0)
	self:SetReloadFinish(0)
	self:EmitReloadFinishSound()

	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local max1 = self:GetPrimaryClipSize()
	local max2 = self.IsAkimbo and self:GetSecondaryClipSize() or self:GetMaxClip2()

    if self:GetFireMode() == 0 then
        if max1 > 0 then
            local ammotype = self:GetPrimaryAmmoType()
            local spare = owner:GetAmmoCount(ammotype)
            local current = self:Clip1()
            local needed = max1 - current
            local checkempty = ((needed <= max1) and not (current == 0)) and 1 or 0

            needed = math.min(spare, needed) + checkempty

            self:SetClip1(current + needed)
            if SERVER then
                owner:RemoveAmmo(needed, ammotype)
            end
        end
    else
        if max2 > 0 then
            local ammotype = self:GetSecondaryAmmoType()
            local spare = owner:GetAmmoCount(ammotype)
            local current = self:Clip2()
            local needed = max2 - current

            needed = math.min(spare, needed)

            self:SetClip2(current + needed)
            if SERVER then
                owner:RemoveAmmo(needed, ammotype)
            end
        end
    end
end

local math_random = math.random
function SWEP:EmitGlFireSound()
	local stbl = E_GetTable(self)

	self:EmitSound(stbl.Secondary.Sound, stbl.SoundFireLevel, math_random(stbl.SoundPitchMin, stbl.SoundPitchMax), stbl.SoundFireVolume, CHAN_WEAPON)
end

function SWEP:GetSecondaryFireDelay()
	local stbl = E_GetTable(self)

	local owner = self:GetOwner()
	return (stbl.Secondary.Delay / (owner:GetStatus("frost") and 0.7 or 1)) * (owner:GetStatus("fftotem") and 0.5 or 1)
end

function SWEP:OnZombieKilled()
	local killer = self:GetOwner()

	if killer:IsValid() then
        self:SetResource(self:GetResource() + 1 * (killer.AbilityCharge or 1))
	
		if self:GetResource() >= 8 then
            killer:GiveAmmo(1, "GrenadeHL1")
            self:SetResource(0)
		end
	end
end
