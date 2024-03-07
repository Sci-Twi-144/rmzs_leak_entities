AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")
local BaseClassMelee = baseclass.Get("weapon_zs_basemelee")

SWEP.Base = "weapon_zs_base"

SWEP.PrintName = (translate.Get("wep_garand"))
SWEP.Description = (translate.Get("desc_garand"))
SWEP.Slot = 3
SWEP.SlotPos = 0
if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 74

	SWEP.IronSightsPos = Vector(-2.706, 0, 1.2)
	SWEP.IronSightsAng = Vector(-0.375, 0, 0)

	SWEP.HUD3DBone = "Bolt"
	SWEP.HUD3DPos = Vector(3, 1, 0)
	SWEP.HUD3DAng = Angle(180, 0, 270)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)

	-- function SWEP:DefineFireMode3D()
		-- if self:GetFireMode() == 0 then
			-- return "STOCK"
		-- elseif self:GetFireMode() == 1 then
			-- return "MELEE"
		-- end
	-- end

	-- function SWEP:DefineFireMode2D()
		-- if self:GetFireMode() == 0 then
			-- return "STOCK"
		-- elseif self:GetFireMode() == 1 then
			-- return "MELEE"
		-- end
	-- end

	function SWEP:DrawWorldModel()
		self.BaseClass.DrawWorldModel(self)
	end
end

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/rmzs/weapons/garand/v_doi_garand.mdl"
SWEP.WorldModel = "models/rmzs/weapons/garand/w_doi_garand.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = Sound("TFA_DOI_GARAND.1")
SWEP.Primary.Damage = 68
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.45

SWEP.ReloadDelay = 1
SWEP.FireAnimSpeed = 1
SWEP.ReloadSpeed = 1

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 25

SWEP.MeleeDamage = 60
SWEP.MeleeRange = 82
SWEP.MeleeSize = 0.95
SWEP.MeleeKnockBack = 55
SWEP.StaminaConsumption = 10
SWEP.DamageType = DMG_SLASH
SWEP.BloodDecal = "Blood"
SWEP.SwingTime = 0.12
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 1.3
SWEP.MeleeFlagged = true
SWEP.NoDrawMeleeHudStates = true

SWEP.ConeMax = 4
SWEP.ConeMin = 2

SWEP.BodyGroup = 0 -- Штык должен остаться

SWEP.WalkSpeed = SPEED_SLOW
SWEP.Tier = 2
SWEP.ResistanceBypass = 0.4

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = true
SWEP.PushFunction = true

SWEP.FirstDraw = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.025, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.08, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.04, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_garand")), (translate.Get("desc_pgarand")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 1.2
	wept.Primary.Delay = wept.Primary.Delay * 1.35
	wept.ConeMin = wept.ConeMin * 0.12
	wept.ConeMax = wept.ConeMax * 0.8

	wept.CantSwitchFireModes = true
	wept.BodyGroup = 1
	
	if CLIENT then
	
		wept.IronSightsPos = Vector(5.015, -8, 2.52)
		wept.IronSightsAng = Vector(0, 0, 0)
		wept.IronsightsMultiplier = 0.25

			wept.GetViewModelPosition = function(self, pos, ang)
				if GAMEMODE.DisableScopes then return end

				if self:IsScoped() then
					return pos + ang:Up() * 256, ang
				end

				return BaseClass.GetViewModelPosition(self, pos, ang)
			end

			wept.DrawHUDBackground = function(self)
				if GAMEMODE.DisableScopes then return end

				if self:IsScoped() then
					self:DrawRegularScope()
			end
		end
	end
end)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if SERVER and ent:IsValidLivingZombie() and ent.PuncStabbed and ent.PuncStabbed > CurTime() then
		dmginfo:SetDamage(dmginfo:GetDamage() * 1.7)
	end
end

function SWEP:CallWeaponFunction()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 and self:GetFireMode() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if self.Branch != 1 and owner:KeyDown(IN_SPEED) then
		if not self:CanSecondaryAttack() then return end
		self:SetNextAttack()

		if self.SwingTime == 0 then
			BaseClassMelee.MeleeSwing(self)
			self:SendWeaponAnim(ACT_VM_HITCENTER) -- Если оно так работает
		else
			self:SendWeaponAnim(ACT_VM_HITCENTER)
			BaseClassMelee.StartSwinging(self)
		end
	else
		if not self:CanPrimaryAttack() then return end
		local vm = self:GetOwner():GetViewModel()
		vm:SetBodygroup(vm:FindBodygroupByName("Belt"), math.min(self:Clip1(), 8))

		self.BaseClass.PrimaryAttack(self)
	end
end

function SWEP:Deploy()
    self:SendWeaponAnim((self.FirstDraw and ACT_VM_DRAW_DEPLOYED) or ((self:Clip1() == 0) and ACT_VM_DRAW_EMPTY) or ACT_VM_DRAW)
	self.IdleActivity = (self:Clip1() == 0) and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
	self.FirstDraw = false

	self.BaseClass.Deploy(self)

	-- local num = self.ISBranch and 1 or 0
	local vm = self:GetOwner():GetViewModel()
	vm:SetBodygroup(vm:FindBodygroupByName("scope"), self.BodyGroup)
	vm:SetBodygroup(vm:FindBodygroupByName("bayonet"), self.BodyGroup)

	return true
end
-- ACT_VM_HITCENTER -- блок
function SWEP:SendWeaponAnimation()
	local iron = self:GetIronsights()

	if self:Clip1() == 0 then
		self:SendWeaponAnim(iron and ACT_VM_PRIMARYATTACK_2 or ACT_VM_PRIMARYATTACK_EMPTY)
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
	timer.Simple(((self:Clip1() == 0) and 0.5 or 1.5) * self:GetReloadSpeedMultiplier(), function()
		if self:IsValid() then
			local owner = self:GetOwner()
			local vm = owner:GetViewModel()
			local ammotype = self:GetPrimaryAmmoType()
			local spare = owner:GetAmmoCount(ammotype)
			vm:SetBodygroup(vm:FindBodygroupByName("Belt"), math.min(8, spare))
		end
	end)
end

function SWEP:Think()
	if self:IsSwinging() and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()

		BaseClassMelee.MeleeSwing(self)
	end

	--[[if CLIENT then
		local mul = 1 - math.floor(CurTime() / self:GetNextSecondaryFire())
		local PosOrigin = Vector(0, 4 * mul, -1 * mul)
		local AngOrigin = Angle(5 * mul, 3 * mul, 0)

		if self:IsSwinging() and (self:GetFireMode() == 1) then
			self.VMPos = LerpVector( FrameTime() * 1, self.VMPos, Vector(1.5, -10, -1.5) )
			self.VMAng = LerpAngle( RealFrameTime() * 5, self.VMAng, Angle(5, 3, 0) )
		else
			self.VMPos = LerpVector( FrameTime() * 12, self.VMPos,  PosOrigin )
			self.VMAng = LerpAngle( RealFrameTime() * 1, self.VMAng, AngOrigin )
		end
	end]]
	BaseClass.Think(self)
end

--MELEE SHIT

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
end

function SWEP:PlayStartSwingSound()
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf_club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_stab.wav", 70, math.random(95, 105), 1, CHAN_AUTO+20)
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	return self:GetNextSecondaryFire() <= CurTime() and not self:IsSwinging()
end

function SWEP:DoMeleeAttackAnim()
	self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM)
end

function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay + self.SwingTime * armdelay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay * armdelay)
end

function SWEP:Holster()
	if self:GetFireMode() == 0 then
		return BaseClass.Holster(self)
	elseif self:GetFireMode() == 1 then
		return BaseClassMelee.Holster(self)
	end
end

if SERVER then
	local BaseClassMelee = baseclass.Get("weapon_zs_basemelee")
	DEFINE_BASECLASS("weapon_zs_base")

	function SWEP:ServerMeleeHitEntity(tr, hitent, damagemultiplier)
		BaseClassMelee.ServerMeleeHitEntity(self, tr, hitent, damagemultiplier)
	end

	function SWEP:ServerMeleePostHitEntity(tr, hitent, damagemultiplier)
		BaseClassMelee.ServerMeleePostHitEntity(self, tr, hitent, damagemultiplier)
	end

	function SWEP:ServerHitFleshEffects(hitent, tr, damagemultiplier)
		BaseClassMelee.ServerHitFleshEffects(self, hitent, tr, damagemultiplier)
	end
end

function SWEP:MeleeHitEntity(tr, hitent, damagemultiplier)
	hitent.PuncStabbed = CurTime() + 3
	BaseClassMelee.MeleeHitEntity(self, tr, hitent, damagemultiplier)
end

function SWEP:PlayerHitUtil(owner, damage, hitent, dmginfo)
	BaseClassMelee.PlayerHitUtil(self, owner, damage, hitent, dmginfo)
end

function SWEP:PostHitUtil(owner, hitent, dmginfo, tr, vel)
	BaseClassMelee.PostHitUtil(self, owner, hitent, dmginfo, tr, vel)
end

function SWEP:SetupDataTables()
	BaseClassMelee.SetupDataTables(self)
end

function SWEP:StopSwinging()
	BaseClassMelee.StopSwinging(self)
end

function SWEP:IsSwinging()
	return BaseClassMelee.IsSwinging(self)
end

function SWEP:OnHeavy()
end

function SWEP:AfterSwing()
end

function SWEP:BeforeSwing(damagemultiplier)
	return damagemultiplier
end

function SWEP:SetSwingEnd(swingend)
	BaseClassMelee.SetSwingEnd(self, swingend)
end

function SWEP:GetSwingEnd()
	return BaseClassMelee.GetSwingEnd(self)
end

function SWEP:IsHeavy()
	return BaseClassMelee.IsHeavy(self)
end

function SWEP:SetHeavy(heavy)
	BaseClassMelee.SetHeavy(self, heavy)
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

sound.Add({
	name = "TFA_DOI_GARAND.1",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {90, 110},
	sound = {
		")weapons/garand/garand_fp.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/uni_weapon_draw_03.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/Garand-BoltForward.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.Boltback",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/Garand-BoltForward.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.Magrelease",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		--"weapons/garand/Garand-BoltForward.wav"
	}
})

sound.Add({  -- звук при первом драве
	name = "TFA_DOI_GARAND.LeanIn",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		--"weapons/garand/garand_ping_01.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.Ping",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/garand_ping_01.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.Empty",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/garand_empty.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.Magin",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/garand_magin.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.MagHit",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/Garand-In.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.DamageMajor",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/pl_damage_major_05.wav",
		"weapons/garand/pl_damage_major_14.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.DamageMinor",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/pl_damage_minor_05.wav",
		"weapons/garand/pl_damage_minor_14.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.BeginADS",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/uni_ads_in_01.wav"
	}
})

sound.Add({ -- звук после непустой перезарядки
	name = "TFA_DOI_GARAND.Rattle",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		--"weapons/garand/garand_ping_01.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.SprintWeaponLower",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/uni_weapon_lower_03.wav"
	}
})

sound.Add({ -- звук когда берешь магазин с патронами
	name = "TFA_DOI_GARAND.MagFetch",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		--"weapons/garand/garand_ping_01.wav"
	}
})

sound.Add({
	name = "TFA_DOI_GARAND.Holster",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {100, 100},
	sound = {
		"weapons/garand/uni_weapon_holster_04.wav"
	}
})

