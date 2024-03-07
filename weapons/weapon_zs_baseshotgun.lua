AddCSLuaFile()

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.ReloadDelay = 0.5 -- Это блядский shelltime он не важен, почему ты вообще решил что он может иметь приоритеты в помповых дробовиках????

SWEP.Primary.Sound = ")weapons/m3/m3-1.wav"
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 6
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 7
SWEP.ConeMin = 5.25

SWEP.WalkSpeed = SPEED_SLOW

SWEP.ReloadActivity = ACT_VM_RELOAD
SWEP.PumpActivity = ACT_SHOTGUN_RELOAD_FINISH
SWEP.ReloadStartActivity = ACT_SHOTGUN_RELOAD_START
SWEP.ReloadStartGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.CanHaveExtendetMag = false
SWEP.ForceShellLoad = true
SWEP.CantSwitchFireModes = true
SWEP.PumpAction = true
SWEP.IsShotgun = true
--SWEP.ForceShotgunRules = true


local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if not self:IsReloading() and self:CanReload() then
		self:StartReloading()
	end
end

function SWEP:ForceReload()
	local owner = self:GetOwner()
	if owner:IsHolding() then return end

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

	if not self:IsReloading() and self:CanReload() then
		self:StartReloading()
	end
end

function SWEP:Think()
	if self:ShouldDoReload() then
		self:DoReload()
	end
	self:SmoothRecoil()
	self:NextThink(CurTime())
	return true
end

function SWEP:StartReloading()
	local stbl = E_GetTable(self)
	local checkempty = (self:Clip1() == 0) and stbl.ReloadStartActivityEmpty or stbl.ReloadStartActivity
	local reloadspeed = stbl.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local validate = stbl.UseEmptyReloads and checkempty or stbl.ReloadStartActivity
	local seq = self:SequenceDuration(self:SelectWeightedSequence(validate)) / reloadspeed
	local delay = self:GetReloadDelay()
	self:SetDTFloat(15, CurTime() + seq)
	
	stbl.ReloadTime = self:GetReloadTime()
	self:SetDTFloat(16, CurTime() + stbl.ReloadTime)
	self:SetDTBool(9, true) -- force one shell load
	local time = CurTime() + math.max(stbl.Primary.Delay, stbl.ReloadTime)
	self:SetNextPrimaryFire(time)
	self:SetSwitchDelay(time)

	self:GetOwner():DoReloadEvent()

	self:StartReloadingExtra()

	if validate then
		self:SendWeaponAnim(validate)
		if not stbl.UseEmptyReloads then
			self:ProcessReloadAnim()
		end
	end
end

function SWEP:StartReloadingExtra()
end

function SWEP:StopReloading()
	self:SetDTFloat(15, 0)
	self:SetDTBool(9, false)
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local seq2 = self:SequenceDuration(self:SelectWeightedSequence(self.PumpActivity))
	local time = math.max(CurTime() + seq2 / reloadspeed, self:GetNextPrimaryFire())
	self:SetNextPrimaryFire(time)
	self:SetSwitchDelay(time)

	-- do the pump stuff if we need to
	if self:Clip1() > 0 then
		if self.PumpSound then
			self:EmitSound(self.PumpSound)
		end
		if self.BoltAction then
			timer.Simple(0, function()
			self:SendWeaponAnim(self.BoltAction)
			self:ProcessReloadAnim()
			end)
		end
		if self.PumpActivity then
			self:SendWeaponAnim(self.PumpActivity)
			self:ProcessReloadAnim()
		end
	end
end

function SWEP:DoReload()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local delay = self:GetReloadDelay()
	local seq2 = self:SequenceDuration(self:SelectWeightedSequence(self.PumpActivity)) / reloadspeed
	
	if not self:CanReload() or not self:GetDTBool(9) and not self:GetOwner():KeyDown(IN_RELOAD) then
		self:StopReloading()
		return
	end

	if self.ReloadActivity and not ((self:Clip1() == 0) and self.UseEmptyReloads) then
		if self:GetOwner():KeyDown(IN_RELOAD) then
			local seq1 = self:SequenceDuration(self:SelectWeightedSequence(self.ReloadActivity)) / reloadspeed
			--self:SetDTFloat(16, math.min(math.max(0, self:GetDTFloat(16) + seq1), self:GetReloadTime() - seq1) + CurTime())
			self:SetDTFloat(16, math.min(math.max(0, self:GetDTFloat(16) + seq1), delay + seq2) + CurTime())
		end
			
		self:SendWeaponAnim(self.ReloadActivity)
		self:ProcessReloadAnim(true)
	end

	if self.ReloadSound then
		self:EmitSound(self.ReloadSound)
	end

	self:GetOwner():RemoveAmmo(1 * (self.ForceShellLoad and self.RequiredClip or 1), self.Primary.Ammo, false)
	self:SetClip1(self:Clip1() + 1 * (self.ForceShellLoad and self.RequiredClip or 1))

	self:DoReloadExtra()

	self:SetDTBool(9, false)
	-- We always wanna call the reload function one more time. Forces a pump to take place.
	self:SetDTFloat(15, CurTime() + delay)
	self:SetSwitchDelay(CurTime() + delay)

	--self:SetNextPrimaryFire(CurTime() + math.max(self.Primary.Delay, delay))
	--self:SetNextPrimaryFire(CurTime() + (delay + seq2) or self.Primary.Delay)
end

function SWEP:DoReloadExtra()
end

function SWEP:ProcessReloadAnim(loop)
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local baseseq = loop and self:SequenceDuration(self:SelectWeightedSequence(self.ReloadActivity))/self.ReloadDelay or 1
	if not self.DontScaleReloadSpeed then
		self:GetOwner():GetViewModel():SetPlaybackRate(reloadspeed * baseseq)
	end
end

function SWEP:GetReloadDelay()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	return self.ReloadDelay / reloadspeed
end

function SWEP:ShouldDoReload()
	return self:GetDTFloat(15) > 0 and CurTime() >= self:GetDTFloat(15)
end

function SWEP:IsReloading()
	return self:GetDTFloat(15) > 0
end

function SWEP:CanReload()
	local spare = self:GetOwner():GetAmmoCount(self.Primary.Ammo)

	return self:Clip1() < self:GetPrimaryClipSize() and 0 < spare and not (spare < (self.RequiredClip or 0))
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if (self:Clip1() < self.RequiredClip) and self:CanReload() then
		if self:GetIronsights() then
			self:SetIronsights(false)
		end
		self:Reload()
		return false
	end

	if self:Clip1() < self.RequiredClip then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)

		return false
	end

	if self:IsReloading() then
		if self:GetIronsights() then
			self:SetIronsights(false)
		end
		self:StopReloading()
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:GetReloadTime()
	local checkempty = (self:Clip1() == 0) and self.ReloadStartActivityEmpty or self.ReloadStartActivity
	local validate = self.UseEmptyReloads and checkempty or self.ReloadStartActivity
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local delay = self:GetReloadDelay()
	local reloaddelay = self.ReloadDelay / reloadspeed
	
	local seq = self:SequenceDuration(self:SelectWeightedSequence(validate))
	local seq1 = self:SequenceDuration(self:SelectWeightedSequence((self.UseEmptyReloads and (self:Clip1() == 0)) and self.PumpActivity or self.ReloadActivity))
	local seq2 = self:SequenceDuration(self:SelectWeightedSequence(self.PumpActivity))

	local offset = self:ShouldDoReload() and reloaddelay or reloaddelay
	
	time = seq + seq1 + seq2
	--print(((time + delay) - offset) / reloadspeed)
	--print(math.abs(self:GetDTFloat(16) - CurTime()), "float", self.ReloadTime)
	return ((time + delay) - offset) / reloadspeed
end