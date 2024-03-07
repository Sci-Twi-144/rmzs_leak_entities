SWEP.DryFireSound = ")weapons/pistol/pistol_empty.wav"
SWEP.Primary.BurstShots = -1
SWEP.Primary.Damage = -1
SWEP.Primary.KnockbackScale = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0


SWEP.ReloadTime = 0

SWEP.ConeMax = -1 
SWEP.ConeMin = -1
SWEP.ConeRamp = 2

SWEP.CSMuzzleFlashes = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.RequiredClip = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "dummy"

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HoldType = "pistol"
SWEP.IronSightsHoldType = "ar2"

SWEP.IronSightsPos = Vector(0, 0, 0)

SWEP.EmptyWhenPurchased = true
SWEP.AllowQualityWeapons = true
SWEP.CantSwitchFireModes = true
SWEP.StandartIronsightsAnim = true

SWEP.Recoil = 0

SWEP.ReloadSpeed = 1.0
SWEP.FireAnimSpeed = 1.0

SWEP.IdleActivity = ACT_VM_IDLE
SWEP.FakeReload = 0
SWEP.ProceduralPattern = false
SWEP.PatternShape = "circle"
SWEP.SecondPattern = false

SWEP.Tier = 1
SWEP.Weight = 5
SWEP.IsShotgun = false

SWEP.CSRecoilMul = 1 --simple mul to control power of generated recoil
SWEP.CSRecoilPower = 0 -- все равно будет перегенерироваться на инициализации
SWEP.CSSinousGraphMul = 1 -- множитель синусоиды чтобы немного изменить форму паттерна
SWEP.CSFalloff = 1 --множитель времени отдачи, контролирует сколько времени потребуется для возвращаение в нулевую отдачу РАБОТАЕТ ХУЕВО НЕ ТРОГАЙТЕ
SWEP.NoCSRecoil = false

SWEP.CSAmmoRecoilTable = {
	["pistol"] = 1.2,
	["buckshot"] = 1.5,
	["smg1"] = 1.15,
	["ar2"] = 1.3, --assault rifle
	["357"] = 1.4, --rifle
	["pulse"] = 1.1 --pulse will be the lover recoil power
}

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	if not self:IsValid() then return end --???
	local stbl = E_GetTable(self)

	self:SetWeaponHoldType(self.HoldType)
	GAMEMODE:DoChangeDeploySpeed(self)
	
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
	
	if stbl.ProceduralPattern then
		stbl.SpreadPattern = stbl:GeneratePattern(stbl.PatternShape, stbl.Primary.NumShots)
		if stbl.SecondPattern then
			stbl.SpreadPattern2 = stbl:GeneratePattern(stbl.PatternShapeSecond, stbl.Secondary.NumShots)
		end
	end
	
	self:GenerateCSMultipliers()
	
	if CLIENT then
		self:CheckCustomIronSights()
		self:Anim_Initialize()
	end
end

function SWEP:GenerateCSMultipliers()
	local ammomod = self.CSAmmoRecoilTable[self.Primary.Ammo] and self.CSAmmoRecoilTable[self.Primary.Ammo] or 1
	local weightmod = (self.WalkSpeed - SPEED_SLOWEST)/40 + 1
	local damagemod = (self.Primary.Damage * self.Primary.NumShots)/100 + 1
	local automod = self.Primary.Automatic and 1 or 1.4
	local primaryburst = self.Primary.BurstShots >= 2 and self.CantSwitchFireModes and 0.3 or 1
	self.CSRecoilPower = math.min((self.Primary.Delay * 1.6 * primaryburst) * self.CSRecoilMul * automod, 1)
	self.CSRecoilCircle = 1 * ammomod * weightmod * (1 + self.Tier * 0.1) * damagemod
		-- i don't know but it's need to be initialized every time to update actual numbers
	--print(self.CS.RecoilPower)
end

function SWEP:RecalculateCSBurstFire(isburst)
	local automod = (self.Primary.Automatic and 1) or (isburst and 1.5) or 1.5
	if isburst then
		self.CSRecoilPower = (1 + self.Tier * 0.05) * (self.Primary.Delay * 1.6 / 2) * self.CSRecoilMul * automod
	else
		self.CSRecoilPower = (1 + self.Tier * 0.05) * (self.Primary.Delay * 1.6) * self.CSRecoilMul * automod
	end
end

function SWEP:GeneratePattern(shape, numshots)
	local pattern = {}
	local pi = math.pi
	if shape == "circle" then
		local innercicle = math.floor((numshots - 1) * 0.4)
		local outercircle = math.floor((numshots - 1) - innercicle)
		for i = 0, (numshots - 1) do
			if i == 0 then
				table.insert( pattern, 1, {0,0} )
			elseif i <= innercicle then
				local x, y = math.cos(pi/2 + ((i -1) * (360/innercicle) * pi)/180), math.sin(pi/2 + ((i -1) * (360/innercicle) * pi)/180)
				table.insert( pattern, 1, {x * 2.5, y * 2.5} )
			else
				local x, y = math.cos(pi/2 + ((i - 1 - innercicle) * (360/outercircle) * pi)/180), math.sin(pi/2 + ((i - 1 - innercicle) * (360/outercircle) * pi)/180)
				table.insert( pattern, 1, {x * 5, y * 5} )
			end
		end
	elseif shape == "quad" then
		local del = numshots ^ 0.5
		for i = 0, (del - 1) do
			for d = 0, (del - 1) do
				local x, y = i * (10/(del - 1)) - 5, d * (10/(del - 1)) - 5
				table.insert( pattern, 1, {x, y} )
			end
		end
	elseif shape == "rectangle" then
		local height = math.floor(numshots ^ 0.5)
		local length = math.floor(numshots/height)
		for i = 0, (length - 1) do
			for d = 0, (height - 1) do
				local x, y = i * (10/(length - 1)) - 5, d * (10/(length - 1)) - 10/(length-1) * (height-1)/2
				table.insert( pattern, 1, {x, y} )
			end
		end
	end
	
	return pattern
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	local owner = self:GetOwner()
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	
	local stbl = E_GetTable(self)
	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(stbl.Primary.Damage, stbl.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:ProcessBurstFire(delaydiv, donttakeammo, ability)
	local delaydiv = delaydiv or 6
	local shotsleft = self:GetShotsLeft()
	if shotsleft > 0 and CurTime() >= self:GetNextShot() then
		self:SetShotsLeft(shotsleft - 1)
		self:SetNextShot(CurTime() + self:GetFireDelay()/delaydiv)

		if donttakeammo and (self:GetReloadFinish() == 0) or (self:Clip1() > 0 and self:GetReloadFinish() == 0)  then
			self:EmitFireSound()
			if not donttakeammo then
				self:TakeAmmo()
			end
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
			if ability then
				self:SetTumbler(false)
				self:SetResource(0)
			end

			self.IdleAnimation = CurTime() + self:SequenceDuration()
		else
			self:SetShotsLeft(0)
		end
	end
end

function SWEP:ProcessCharge()
	if self:GetCharging() then
		if not self:GetOwner():KeyDown(IN_ATTACK) then
			self:EmitFireSound()
			self:ShootBullets(self.Primary.Damage * self:GetGunCharge(), self.Primary.NumShots, self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()

			self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
			self:SetCharging(false)
			self:SetLastChargeTime(CurTime())
			self:SetGunCharge(0)
		elseif self:GetGunCharge() < self.MaxCharge and self:Clip1() ~= 0 and self:GetLastChargeTime() + self.ChargeTime < CurTime() then
			self:SetGunCharge(self:GetGunCharge() + 1)
			self:SetLastChargeTime(CurTime())
			self:TakeAmmo()
		end

		self.ChargeSound:PlayEx(1, math.min(255, 165 + self:GetGunCharge() * 18))
	else
		self.ChargeSound:Stop()
	end
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
	end
end

function SWEP:ForceReload() -- do it anyway whe needed
	local owner = self:GetOwner()
	if not (self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0) then return end
	if owner:IsHolding() or self:GetCharging() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	local stbl = E_GetTable(self)

	if self:IsValid() and (not stbl.NoMagazine and not stbl.AmmoIfHas or stbl.AllowEmpty) then
		local primary = self:ValidPrimaryAmmo()
		if primary and 0 < self:Clip1() then
			if SERVER then
				owner:GiveAmmo(self:Clip1(), primary, true)
			end
			self:SetClip1(0)
		end
		local secondary = self:ValidSecondaryAmmo()
		if secondary and 0 < self:Clip2() then
			if SERVER then
				owner:GiveAmmo(self:Clip2(), secondary, true)
			end
			self:SetClip2(0)
		end
	end

	stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	self:SetNextReload(stbl.IdleAnimation)
	self:SetReloadStart(CurTime())

	self:SendReloadAnimation()
	self:ProcessReloadEndTime()

	owner:DoReloadEvent()

	self:EmitReloadSound()
end

SWEP.CannotHaveExtendetMag = false

function SWEP:GetPrimaryClipSize()
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	local cap = math.Clamp(4, 4, 7)
	local check = stbl.Primary.ClipSize / stbl.RequiredClip
	local multi = owner.ExtendMagMul or 1
	local skillmulti = check >= cap and (owner.ExtendMagMulAlt or 1) or 1

	local traitmulti_h = owner.HasExtendetMagazine and (owner.ExtendMagMulTr or 1) or 1
	local traitmulti_l = check >= cap and owner.HasExtendetMagazine and (owner.ExtendMagMulAltTr or 1) or 1
	
	traitresult = (check >= 8 and traitmulti_h or traitmulti_l)

	result = (check >= 8 and (multi * (owner.ExtendMagMulTr or 1)) or (skillmulti * (owner.ExtendMagMulAltTr or 1)))

	boundcheck = stbl.CannotHaveExtendetMag and 1 or result

	return math.floor(self:GetMaxClip1() * (stbl.Tier <= 5 and boundcheck or traitresult))
end

function SWEP:FinishReload()
	self:SendWeaponAnim(self.IdleActivity or ACT_VM_IDLE)
	self:SetNextReload(0)
	self:SetReloadStart(0)
	self:SetReloadFinish(0)
	self:EmitReloadFinishSound()

	local owner = self:GetOwner()
	if not owner:IsValid() then return end
	if self.FakeReload >= CurTime() then return end

	local max1 = self:GetPrimaryClipSize()
	local max2 = self.IsAkimbo and self:GetSecondaryClipSize() or self:GetMaxClip2()

	if max1 > 0 then
		local ammotype = self:GetPrimaryAmmoType()
		local spare = owner:GetAmmoCount(ammotype)
		local current = self:Clip1()
		local needed = max1 - current

		needed = math.min(spare, needed)

		self:SetClip1(current + needed)
		if SERVER then
			owner:RemoveAmmo(needed, ammotype)
		end
	end

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

function SWEP:GetCone()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	local status = owner.Focused and owner.Focused.DieTime >= CurTime() and owner.Focused.Stacks * 0.17 or 0
	local basecone = stbl.ConeMin
	local conedelta = stbl.ConeMax - basecone

	local orphic = not otbl.Orphic and 1 or self:GetIronsights() and 0.9 or 1.1
	local spreadmulads = otbl.TargetingVisor and (otbl.AimSpreadMulAds or 0) / (stbl.Tier or 1) or 0
	local spreadmul = (otbl.AimSpreadMul or 1) - spreadmulads - status

	if otbl.TrueWooism then
		return (basecone + conedelta * 0.5 ^ stbl.ConeRamp) * spreadmul * orphic
	end

	if not owner:OnGround() or stbl.ConeMax == basecone then return stbl.ConeMax end

	local multiplier = math.min(owner:GetVelocity():Length() / stbl.WalkSpeed, 1) * 0.5

	local ironsightmul = 0.25 * (otbl.IronsightEffMul or 1)
	local ironsightdiff = 0.25 - ironsightmul
	multiplier = multiplier + ironsightdiff

	if not owner:Crouching() then multiplier = multiplier + 0.25 end
	if not self:GetIronsights() then multiplier = multiplier + ironsightmul end
	
	local cscone = owner.HasCsShoot and (self.IsShotgun and ((1 + self:GetCSRecoil()) * 0.5) or ((1 + self:GetCSRecoil() * 4) * 0.2 * 0.3)) or 1
	
	return (basecone + conedelta * (stbl.FixedAccuracy and 0.6 or multiplier) ^ stbl.ConeRamp) * spreadmul * orphic * cscone
end

function SWEP:GetRecoilMovementMul()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	local multiplier = 1 + math.min(owner:GetVelocity():Length() / stbl.WalkSpeed, 1) * 0.5
	local ironsightmul = 0.25 * (otbl.IronsightEffMul or 1)
	local crouchmul = (owner:Crouching()) and 0.25 or 0
	local ironsight = (self:GetIronsights()) and ironsightmul or 0
	local jumpmul = not owner:OnGround() and 1 or 0
	multiplier = multiplier - crouchmul - ironsight + jumpmul
	return multiplier
end

function SWEP:GetWalkSpeed()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if self:GetIronsights() then
		return math.min(stbl.WalkSpeed, math.max(90, stbl.WalkSpeed * (otbl.Wooism and 0.75 or 0.5)))
	end

	return stbl.WalkSpeed
end

SWEP.SoundFireVolume = 1.0
SWEP.SoundFireLevel = 140
SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100
SWEP.Primary.Sound = ")weapons/pistol/pistol_fire2.wav"

local math_random = math.random
function SWEP:EmitFireSound()
	local stbl = E_GetTable(self)

	self:EmitSound(stbl.Primary.Sound, stbl.SoundFireLevel, math_random(stbl.SoundPitchMin, stbl.SoundPitchMax), stbl.SoundFireVolume, CHAN_WEAPON)
end

function SWEP:SetIronsights(b)
	self:SetDTBool(DT_WEAPON_BASE_BOOL_IRONSIGHTS, b)
	local stbl = E_GetTable(self)

	if stbl.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(stbl.IronSightsHoldType)
		else
			self:SetWeaponHoldType(stbl.HoldType)
		end
	end

	gamemode.Call("WeaponDeployed", self:GetOwner(), self)
end

function SWEP:Deploy()
	self:SetNextReload(0)
	self:SetReloadFinish(0)

	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self:SetIronsights(false)

	E_GetTable(self).IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		self:CheckCustomIronSights()
		--self.bInitBobVars = true
	end

	return true
end

function SWEP:Holster()
	if CLIENT then
		self:Anim_Holster()
	end

	return true
end

SWEP.AU = 0
function SWEP:TakeAmmo()
	local stbl = E_GetTable(self)

	if stbl.AmmoUse then
		stbl.AU = stbl.AU + stbl.AmmoUse
		if stbl.AU >= 1 then
			local use = math.floor(stbl.AU)
			self:TakePrimaryAmmo(use)
			stbl.AU = stbl.AU - use
		end
	else
		self:TakePrimaryAmmo(stbl.RequiredClip)
	end
end

function SWEP:TakePrimaryAmmo(num) -- override this for add hook
	gamemode.Call("AmmoCheckHook", self, num, self:GetPrimaryAmmoTypeString())
	if self:Clip1() <= 0 then
		if self:Ammo1() <= 0 then return end

		self:GetOwner():RemoveAmmo(num, self:GetPrimaryAmmoType())

		return
	end

	self:SetClip1(self:Clip1() - num)
end

function SWEP:EmitReloadSound()
	local stbl = E_GetTable(self)

	if stbl.ReloadSound and IsFirstTimePredicted() then
		self:EmitSound(stbl.ReloadSound, 75, 100, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:Think()
	if SERVER then
		self:sv_Think()
	elseif CLIENT then
		self:cl_Think()
	end
	self:SmoothRecoil()
end

function SWEP:EmitReloadFinishSound()
	if self.ReloadFinishSound and IsFirstTimePredicted() then
		self:EmitSound(self.ReloadFinishSound, 75, 100, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:CanReload()
	return self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0 and
		(
			self:GetMaxClip1() > 0 and self:Clip1() < self:GetPrimaryClipSize() and self:ValidPrimaryAmmo() and self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) > 0
			or self:GetMaxClip2() > 0 and self:Clip1() < self:GetMaxClip2() and self:ValidSecondaryAmmo() and self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType()) > 0
		)
end

function SWEP:GetIronsights()
	return self:GetDTBool(7)
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
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, stbl.Primary.Delay))
		return false
	end
	
	--self:AddCSTimers()
	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:CanAttackCS()
	local stbl = E_GetTable(self)
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end
	if (self:Clip1() < stbl.RequiredClip) then return false end
	return true
end

function SWEP:OnRestore()
	self:SetIronsights(false)
end

SWEP.IsShooting = 0
SWEP.IronSightActivity = ACT_VM_IDLE
--SWEP.StandartIronsightsAnim = nil
function SWEP:SendWeaponAnimation()
	local stbl = E_GetTable(self)
	stbl.IsShooting = CurTime() + 0.006
	local dfanim = (not stbl.StandartIronsightsAnim and self:GetIronsights()) and stbl.IronSightActivity or ACT_VM_PRIMARYATTACK
	self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

SWEP.ReloadActivity = ACT_VM_RELOAD
function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(self.ReloadActivity)
end

function SWEP:GetReloadSpeedMultiplier()
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	local primstring = self:GetPrimaryAmmoTypeString()
	local reloadspecmulti = primstring and "ReloadSpeedMultiplier" .. string.upper(primstring) or nil
	local metamul = stbl.Tier <= 5 and (1 - (owner.ReloadSpeedMultiplierEx or 0)) or 1
	local status = owner.FastHand
	
	local extramulti = 1 + (owner.FastHand and owner.FastHand.DieTime >= CurTime() and ((owner.FastHand.Stacks * 0.12) or 0) or 0)

	local multads = owner.HasAmmoVest and (owner.ReloadSpeedMultiplierAds or 0) / ((stbl.Tier or 1) * 0.65) or 0

	return (self:GetOwner():GetTotalAdditiveModifier("ReloadSpeedMultiplier", reloadspecmulti) + math.max(0, multads - metamul)) * (owner:GetStatus("frost") and 0.7 or 1) * extramulti
end

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()

	self:SetReloadFinish(CurTime() + self:SequenceDuration() / reloadspeed)

	self.ReloadTime = self:SequenceDuration() / reloadspeed
	self:SetNextPrimaryFire(CurTime() + self.ReloadTime)
	if not self.DontScaleReloadSpeed then
		self:GetOwner():GetViewModel():SetPlaybackRate(reloadspeed)
	end
end

function SWEP:GetFireDelay()
	local stbl = E_GetTable(self)

	local owner = self:GetOwner()
	local status = owner.FFTotem and owner.FFTotem.DieTime >= CurTime() and (1 - owner.FFTotem.Stacks * 0.07) or 1
	return (stbl.Primary.Delay / (owner:GetStatus("frost") and 0.7 or 1)) * status
end

SWEP.Pierces = 1
SWEP.DamageTaper = 1

local A_Meta = FindMetaTable("Angle")
local A_Up = A_Meta.Up
local A_Set = A_Meta.Set
local A_Forward = A_Meta.Forward
local A_Right = A_Meta.Right
local A_RotateAroundAxis = A_Meta.RotateAroundAxis

local V_Meta = FindMetaTable("Vector")
local V_Angle = V_Meta.Angle
local V_GetNormalized = V_Meta.GetNormalized

function SWEP:ShootBullets(dmg, numbul, cone)

	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	local iscs = otbl.HasCsShoot
	--print(self:GetCSSinSpread())

	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	

	if stbl.PointsMultiplier then
		POINTSMULTIPLIER = stbl.PointsMultiplier
	end
	
	local aimvec = owner:GetAimVector()		
	if iscs and not self.NoCSRecoil then
		local v = self:GetCSFireParams(aimvec)
		aimvec = v
	end

	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), aimvec, cone, numbul, stbl.Pierces, stbl.DamageTaper, dmg, nil, stbl.Primary.KnockbackScale, stbl.TracerName, stbl.BulletCallback, stbl.Primary.HullSize, nil, stbl.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)

	if stbl.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end
	self:AddCSTimers()
	self:HandleVisualRecoil(stbl, iscs, owner, cone)
end

function SWEP:HandleVisualRecoil(stbl, iscs, owner, cone)
	if iscs and not self.NoCSRecoil then
		local csy, csx = self:GetCSAngles()
		local pitch = -csy
		local yaw = -csx
		local roll = 0
		owner:ViewPunch(Angle(pitch, yaw, roll))
	else
		if stbl.Recoil > 0 then
			local r = math.Rand(0.8, 1)
			owner:ViewPunch(Angle(r * -stbl.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * stbl.Recoil))
		end
	end
end

function SWEP:AddCSTimers()
	local flatcsrecoil = math.max(self:GetDTFloat(26) - CurTime(), 0)
	local csrecoil = self:GetCSRecoil()
	--self:SetNextSmoothRecoil(self.Primary.Delay)
	self:SetCSRecoil(math.min(csrecoil + self.CSRecoilPower, 1 + self.Primary.Delay))
end

function SWEP:GetCSAngles()
	local recoilcircle = self:GetRecoilMovementMul() * self.CSRecoilCircle
	local up = (self:GetCSRecoil())^2 * recoilcircle
	local sinam = CurTime() --(variable >= 1) and self.Primary.Automatic and (1 + (variable - 1) * 0.9) or variable
	local sinuss = -math.sin((sinam * self.CSSinousGraphMul) * 2 * math.pi)
	local right = -sinuss * recoilcircle * math.min(0.05 + self:GetCSRecoil()^2, 1)
	return up, right
end

function SWEP:SmoothRecoil()
	if self:GetOwner().HasCsShoot then
		if self:GetCSRecoil() > 0 and self:GetNextSmoothRecoil() <= CurTime() and (self:GetOwner():GetViewPunchVelocity().p > 5) then
			local owner = self:GetOwner()
			local db_pi = math.pi / 180
			local viewpunch_ang = owner:GetViewPunchAngles()
			local p, y = self:GetCSAngles()
			local needangle = Angle(-p, 0, 0)
			local anglediff = needangle - viewpunch_ang
			--local framemul = FrameTime() * 200
			local correctframemul = 0.014999999664724/FrameTime() * 3
			
			--shit that i found in source sdk
			
			--float damping = 1 - (PUNCH_DAMPING * gpGlobals->frametime);
			--#define PUNCH_SPRING_CONSTANT	65.0f	// bigger number increases the speed at which the view corrects
			--float springForceMagnitude = PUNCH_SPRING_CONSTANT * gpGlobals->frametime;
			--springForceMagnitude = clamp(springForceMagnitude, 0.f, 2.f );
			--player->m_Local.m_vecPunchAngleVel -= player->m_Local.m_vecPunchAngle * springForceMagnitude;
			
			owner:SetViewPunchVelocity(anglediff * correctframemul)
		end
	end
end

function SWEP:GetCSFireParams(vector)
	local owner = self:GetOwner()
	local base_ang = V_Angle(vector)
	local ishotgun = self.IsShotgun
	
	local viewpunch_ang = owner:GetViewPunchAngles()
	local db_pi = math.pi / 180
	local csy, csx = viewpunch_ang.y * -db_pi, viewpunch_ang.p * -db_pi
	
	vector = A_Forward(base_ang) + csy * A_Right(base_ang) + csx * A_Up(base_ang)
	return vector
end

local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]      	= ACT_HL2MP_IDLE_DUEL,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA
}

function SWEP:SetWeaponHoldType( t )
	t = string.lower( t )
	local index = ActIndex[ t ]

	if ( index == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set! (defaulting to normal) (from "..self:GetClass()..")\n" )
		t = "normal"
		index = ActIndex[ t ]
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= index
	self.ActivityTranslate [ ACT_MP_WALK ] 						= index+1
	self.ActivityTranslate [ ACT_MP_RUN ] 						= index+2
	self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= index+3
	self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= index+4
	self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= index+5
	self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index+5
	self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_JUMP ] 						= index+7
	self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM_IDLE ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM ] 						= index+9

	-- "normal" jump animation doesn't exist
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end

	-- these two aren't defined in ACTs for whatever reason
	if t == "knife" or t == "melee2" then
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] = nil
	end
end

SWEP:SetWeaponHoldType("pistol")

function SWEP:TranslateActivity(act)
	if self:GetIronsights() and self.ActivityTranslateIronSights then
		return self.ActivityTranslateIronSights[act] or -1
	end

	return self.ActivityTranslate and self.ActivityTranslate[act] or -1
end

function SWEP:RollFirearms()

	local qualities = {
	{"Common", 1.2},
	{"Rare", 1.4},
	{"Epic", 1.6},
	{"Heroic", 1.8},
	{"Legendary", 2}
	}
	
	local dql = math.random(5)
	
	local quality, qualitynum = qualities[dql][1], qualities[dql][2]

	print(quality, qualitynum)
	
	local function RollNum()
		local val = (math.random() + 0.8) * qualitynum
		print(val)
		return val
	end
	
	self.PrintName = quality .. (self.PrintName or "Shit")
	self.Primary.Damage = self.Primary.Damage * RollNum()
	self.Primary.Delay = math.max(self.Primary.Delay / RollNum(), 0.1)
	self.Primary.ClipSize = math.ceil(self.Primary.ClipSize * RollNum())
end

-- Burst tables
function SWEP:SetNextShot(nextshot)
	self:SetDTFloat(13, nextshot)
end

function SWEP:GetNextShot()
	return self:GetDTFloat(13)
end

function SWEP:SetShotsLeft(shotsleft)
	self:SetDTInt(12, shotsleft)
end

function SWEP:GetShotsLeft()
	return self:GetDTInt(12)
end

--Charge tables
function SWEP:SetLastChargeTime(lct)
	self:SetDTFloat(14, lct)
end

function SWEP:GetLastChargeTime()
	return self:GetDTFloat(14)
end

function SWEP:SetGunCharge(charge)
	self:SetDTInt(13, charge)
end

function SWEP:GetGunCharge(charge)
	return self:GetDTInt(13)
end

function SWEP:SetCharging(charge)
	self:SetDTBool(14, charge)
end

function SWEP:GetCharging()
	return self:GetDTBool(14)
end

function SWEP:SetCSRecoil(rcl)
	local faloff = rcl * self.CSFalloff
	self:SetDTFloat(25, CurTime() + faloff)
end

function SWEP:GetCSRecoil()
	return math.max(math.min(self:GetDTFloat(25) - CurTime(), 1), 0) / self.CSFalloff
end

function SWEP:SetNextSmoothRecoil(smth)
	self:SetDTFloat(26, CurTime() + smth)
end

function SWEP:GetNextSmoothRecoil()
	return self:GetDTFloat(26)
end
--