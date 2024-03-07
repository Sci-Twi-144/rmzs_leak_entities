SWEP.PrintName = "Akimbo Base"
SWEP.Description = ""
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "duel"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.ViewModel_L = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.SoundFireVolume = 1
SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/mac10/mac10-1.wav"
SWEP.Primary.Damage = 16.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.075

SWEP.SoundFireVolume_S = 1
SWEP.SoundFireLevel_S = 140
SWEP.SoundPitchMin_S = 100
SWEP.SoundPitchMax_S = 110

SWEP.Secondary.Sound = ")weapons/mac10/mac10-1.wav"
SWEP.Secondary.Damage = 16.5
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Delay = 0.075

SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.Secondary.ClipSize = 35
SWEP.Secondary.DefaultClip = 35
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "smg1"

SWEP.Auto = false
SWEP.PushFunction = true

SWEP.ShouldMuzzleL = true
SWEP.ShouldMuzzleR = true

SWEP.RequiredClip = 1

SWEP.ConeMax = 5.5
SWEP.ConeMin = 2.5

SWEP.ConeMax_S = 5.5
SWEP.ConeMin_S = 2.5
SWEP.ConeRamp_S = 2

SWEP.FireAnimSpeed = 1.5

SWEP.Tier = 4

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false

SWEP.ViewModelFlip = false	--the default viewmodel won't be flipped
SWEP.ViewModelFlip1 = true	--the second viewmodel will

SWEP.UseHands1 = false
SWEP.DualHands = true

SWEP.UseStandartReloadAim = true

SWEP.IsAkimbo = true

-- ANIMATION INDEX NUMBER --

-- get list numbers of index.
--PrintTable( self:GetSequenceList() )

SWEP.FireAnimIndexMin = 2
SWEP.FireAnimIndexMax = 4
SWEP.ReloadAnimIndex = 1
SWEP.DeployAnimIndex = 5

SWEP.FireAnimIndexMin_S = 2
SWEP.FireAnimIndexMax_S = 4
SWEP.ReloadAnimIndex_S = 1
SWEP.DeployAnimIndex_S = 5

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
    if not self:IsValid() then return end --???
    local stbl = E_GetTable(self)

    self:SetWeaponHoldType(self.HoldType)
    GAMEMODE:DoChangeDeploySpeed(self)
	self:SetSecondaryShoot(false)

    -- Higher tier guns auto swap to with a higher priority than low tier ones.
    if stbl.Weight and stbl.Tier then
        stbl.Weight = stbl.Weight + stbl.Tier
    end

    -- Maybe we didn't want to convert the weapon to the new system...
    if stbl.Cone then
        stbl.ConeMin = stbl.ConeIronCrouching
        stbl.ConeMax = stbl.ConeMoving
        stbl.ConeRamp = 2
    end
	
	self:GenerateCSMultipliers()
	
    if CLIENT then
        self:CheckCustomIronSights()
        self:Anim_Initialize_Akimbo()
    end
end

function SWEP:FireAnimationEvent( pos, ang, event, options )
	return true
end

function SWEP:SendViewModelAnim( seq , index , rate )
	local vm = self:GetOwner():GetViewModel( index )

	if not IsValid(vm) then return end

	vm:SendViewModelMatchingSequence(seq)
	vm:SetPlaybackRate( rate or 1 )
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel(1)
	if IsValid(vm) then
		vm:SetWeaponModel(self.ViewModel_L, self)
	end

	if SERVER then
		self:SecondaryHands(false)
	end

	self:SendViewModelAnim( self.DeployAnimIndex , 0 )
	self:SendViewModelAnim( self.DeployAnimIndex_S , 1 )

	return true
end

function SWEP:GetSecondaryClipSize()
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	local cap = math.Clamp(4, 4, 7)
	local check = stbl.Secondary.ClipSize / stbl.RequiredClip
	local multi = owner.ExtendMagMul or 1
	local skillmulti = check >= cap and (owner.ExtendMagMulAlt or 1) or 1

	local traitmulti_h = owner.HasExtendetMagazine and (owner.ExtendMagMulTr or 1) or 1
	local traitmulti_l = check >= cap and owner.HasExtendetMagazine and (owner.ExtendMagMulAltTr or 1) or 1
	
	traitresult = (check >= 8 and traitmulti_h or traitmulti_l)

	result = (check >= 8 and (multi * (owner.ExtendMagMulTr or 1)) or (skillmulti * (owner.ExtendMagMulAltTr or 1)))

	boundcheck = stbl.CannotHaveExtendetMag and 1 or result

	return math.floor(self:GetMaxClip2() * (stbl.Tier <= 5 and boundcheck or traitresult))
end

function SWEP:SendReloadAnimation()
	local reloadtime = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	self:SendViewModelAnim(self.ReloadAnimIndex, 0, reloadtime)
	self:SendViewModelAnim(self.ReloadAnimIndex_S, 1, reloadtime)
	if self.UseStandartReloadAim then
		self:SendWeaponAnim(ACT_VM_RELOAD)
	end
	self.ReloadTime = self:SequenceDuration(self.ReloadAnimIndex or self.ReloadAnimIndex_S) / reloadtime
end

function SWEP:CanReload()
	return self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0 and
		(
			self:GetMaxClip1() > 0 and self:Clip1() < self:GetPrimaryClipSize() and self:ValidPrimaryAmmo() and self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) > 0
			or self:GetMaxClip2() > 0 and self:Clip2() < self:GetSecondaryClipSize() and self:ValidSecondaryAmmo() and self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType()) > 0
		)
end

function SWEP:Holster()
	local vm = self:GetOwner():GetViewModel(1)
	if IsValid(vm) then
		vm:SetWeaponModel(self.ViewModel_L, nil)

		if SERVER then
			self:SecondaryHands(true)
		end
	end

	return true
end

function SWEP:TakeAmmo(LH)
	if LH then
		self:TakeSecondaryAmmo(1)
	else
		self:TakePrimaryAmmo(1)
	end
end


function SWEP:GetFireDelay(LH)
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	local divider = LH and stbl.Secondary.Delay or stbl.Primary.Delay

	return (divider / (owner:GetStatus("frost") and 0.7 or 1)) * (owner:GetStatus("expertise") and 0.9 or 1)
end

function SWEP:CanAttackCheck(LH)
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	if (LH and self:Clip2() or self:Clip1())  < 1 then
		self:EmitSound(self.DryFireSound)

		if LH then
			self:SetNextSecondaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		else
			self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		end

		return false
	end

	return (LH and self:GetNextSecondaryFire() or self:GetNextPrimaryFire()) <= CurTime()
end

-- Not worth for networking from serverside just for muzzle.
local function CreateMuzzleFlashEffect(self, left)
	if GAMEMODE.OverTheShoulder then return end -- no need effect in thirdperson!

	local data = EffectData()
		data:SetFlags(0)
		data:SetEntity(self:GetOwner():GetViewModel(left and 1 or 0))
		data:SetAttachment(1)
		data:SetScale(1)
	util.Effect("CS_MuzzleFlash", data)
end

function SWEP:PrimaryAttack()
	if self:GetFireMode() == 0 then
		self:PrimaryFire()
	elseif self:GetFireMode() == 1 then
		if self:GetSecondaryShoot() then
			if self:CanAttackCheck(true) then
				self:SecondaryFire()
				self:SetSecondaryShoot(false)
			else
				self:SetSecondaryShoot(false)
			end
		else
			if self:CanAttackCheck(false) then
				self:PrimaryFire()
				self:SetSecondaryShoot(true)
			else
				self:SetSecondaryShoot(true)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if self:GetFireMode() == 0 then
		self:SecondaryFire()
	else return end
end

function SWEP:PrimaryFire()
	if not self:CanAttackCheck(false) then return end

	if self:GetFireMode() == 1 then
		self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(true) * 0.5)
	end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

	self:EmitFireSound()

	self:TakeAmmo(false)

	if CLIENT and self.ShouldMuzzleR then
		CreateMuzzleFlashEffect(self, false)
	end
	
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin, self.FireAnimIndexMax), 0, self.FireAnimSpeed)
end

local math_random = math.random
function SWEP:EmitFireSound_S()
	self:EmitSound(self.Secondary.Sound, self.SoundFireLevel_S, math_random(self.SoundPitchMin_S, self.SoundPitchMax_S), self.SoundFireVolume_S, CHAN_WEAPON)
end

function SWEP:GetCone_S()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	local basecone = stbl.ConeMin_S
	local conedelta = stbl.ConeMax_S - basecone
	
	local orphic = not otbl.Orphic and 1 or self:GetIronsights() and 0.9 or 1.1
	local spreadmulads = otbl.TargetingVisor and (otbl.AimSpreadMulAds or 0) / (stbl.Tier or 1) or 0
	local spreadmul = (otbl.AimSpreadMul or 1) - spreadmulads

	if otbl.TrueWooism then
		return (basecone + conedelta * 0.5 ^ stbl.ConeRamp_S) * spreadmul * orphic
	end

	if not owner:OnGround() or stbl.ConeMax_S == basecone then return stbl.ConeMax_S end

	local multiplier = math.min(owner:GetVelocity():Length() / stbl.WalkSpeed, 1) * 0.5

	local ironsightmul = 0.25 * (owner.IronsightEffMul or 1)
	local ironsightdiff = 0.25 - ironsightmul
	multiplier = multiplier + ironsightdiff

	if not owner:Crouching() then multiplier = multiplier + 0.25 end
	if not self:GetIronsights() then multiplier = multiplier + ironsightmul end
	local cscone = owner.HasCsShoot and (self.IsShotgun and ((1 + self:GetCSRecoil()) * 0.5) or ((1 + self:GetCSRecoil() * 4) * 0.2)) or 1
	
	return (basecone + conedelta * (stbl.FixedAccuracy and 0.6 or multiplier) ^ stbl.ConeRamp_S) * spreadmul * orphic * cscone
end

function SWEP:SecondaryFire()
	if not self:CanAttackCheck(true)  then return end

	if self:GetFireMode() == 1 then
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 0.5)
	end
	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(true))

	self:EmitFireSound_S()

	self:TakeAmmo(true)

	if CLIENT and self.ShouldMuzzleL then
		CreateMuzzleFlashEffect(self, true)
	end
	
	self:ShootBullets_Left(self.Secondary.Damage, self.Secondary.NumShots, self:GetCone_S())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin_S, self.FireAnimIndexMax_S), 1, self.FireAnimSpeed)
end

function SWEP:ShootBullets_Left(dmg, numbul, cone)
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	
	owner:DoAttackEvent()

	if self.PointsMultiplier then
		POINTSMULTIPLIER = self.PointsMultiplier
	end
	
	local iscs = otbl.HasCsShoot
	local aimvec = owner:GetAimVector()		
	if iscs then
		local v = self:GetCSFireParams(aimvec, cone)
		aimvec = v
	end
	
	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), aimvec, cone, numbul, self.Pierces, self.DamageTaper, dmg, nil, self.Secondary.KnockbackScale, self.TracerName_S, self.BulletCallback, self.Secondary.HullSize, nil, self.Secondary.MaxDistance, nil, self, CLIENT and (GAMEMODE.OverTheShoulder and self or self:GetOwner():GetViewModel(1)) or self, GAMEMODE.OverTheShoulder and 2 or 1)
	owner:LagCompensation(false)

	if self.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end
	
	self:AddCSTimers()
	self:HandleVisualRecoil(stbl, iscs, owner, cone)
end

function SWEP:CallWeaponFunction()
	if self:GetFireMode() == 0 then
		if self.Automatic then
			self.Primary.Automatic = true
			self.Secondary.Automatic = true
		else
			self.Primary.Automatic = false
			self.Secondary.Automatic = false
		end
	elseif self:GetFireMode() == 1 then
		self.Primary.Automatic = true
		self.Secondary.Automatic = true
	end
end

function SWEP:SetSecondaryShoot(shoot)
	self:SetDTBool(11, shoot)
end

function SWEP:GetSecondaryShoot()
	return self:GetDTBool(11)
end