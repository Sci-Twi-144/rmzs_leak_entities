SWEP.PrintName = (translate.Get("wep_thruster"))
SWEP.Description = (translate.Get("desc_thruster"))

SWEP.UseHands = true

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "rpg"

SWEP.ViewModel = "models/rmzs/weapons/rpg_blueshift/c_rpg_blueshift.mdl"
SWEP.WorldModel = "models/rmzs/weapons/rpg_blueshift/w_rpg_blueshift.mdl"

SWEP.Primary.Delay = 0.88
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Damage = 170

SWEP.ReloadSound = nil
SWEP.Primary.Sound = Sound("weapon_rpg.Fire")

SWEP.ReloadSpeed = 0.7
SWEP.Recoil = 3

SWEP.ConeMin = 0.0001
SWEP.ConeMax = 0.0001

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_RPG

SWEP.WalkSpeed = SPEED_SLOWEST * 0.85

SWEP.FireAnimSpeed = 1

SWEP.Tier = 6
SWEP.MaxStock = 2
SWEP.FirstDraw = true
SWEP.IsAoe = true
SWEP.IsThruster = true
SWEP.Primary.ProjExplosionTaper = 0.75
SWEP.Primary.ProjExplosionRadius = 116
SWEP.LastTarget = nil
SWEP.BonusTime = 15

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.15, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_scavenger")), (translate.Get("desc_scavenger")), "weapon_zs_scavenger")
-- GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_helldash")), (translate.Get("desc_helldash")), "weapon_zs_helldash")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:FireAnimationEvent(pos, ang, event, options, source)
	local vm = self:GetOwner():GetViewModel()
	if event == 3112 then
		vm:SetBodygroup(vm:FindBodygroupByName(options), 1)
	elseif event == 3111 then
		vm:SetBodygroup(vm:FindBodygroupByName(options), 0)
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
	elseif self:GetSequenceActivityName(self:GetSequence()) != "ACT_VM_FIDGET" and self:GetReloadFinish() < CurTime() then
		self:SendWeaponAnim(ACT_VM_FIDGET)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:Deploy()
	if self.FirstDraw then
		self:SendWeaponAnim(self.FirstDraw and ACT_VM_PICKUP or ACT_VM_DRAW)
		self.FirstDraw = false
	end
	self.BaseClass.Deploy(self)
	return true
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_RELOAD)
end

function SWEP:SecondaryAttack()
	if IsFirstTimePredicted() then
		self:SetDTBool(8, not self:GetDTBool(8))

		if CLIENT then
			MySelf:EmitSound(self:GetDTBool(8) and "buttons/button17.wav" or "buttons/button19.wav", 0)
		end
	end
end


function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	if (self:Clip1() < self.RequiredClip) and self:CanReload() then
		self:Reload()
		return false
	end

	if self:Clip1() < self.RequiredClip or self:GetOwner():WaterLevel() > 2 then
		self:EmitSound(self.DryFireSound)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:OnZombieKilled(zombie, total, dmginfo)
	if self.LastTarget and zombie == self.LastTarget then
		self:HandleBonus(1)
	end
end

function SWEP:HandleBonus(num)
	local n = num or 1
	local owner = self:GetOwner()
	if self:GetBonusTime() >= CurTime() then
		self:SetBonus(math.min(self:GetBonus() + n, 3))
		self:SetBonusTime(CurTime() + (self.BonusTime * 1/(owner.ProjectileSpeedMul or 1)))
	else
		self:SetBonus(n)
		self:SetBonusTime(CurTime() + (self.BonusTime * 1/(owner.ProjectileSpeedMul or 1)))
	end
	self.LastTarget = nil
end

function SWEP:SetBonus(stack)
	self:SetDTInt(15, stack)
end

function SWEP:GetBonus()
	return self:GetDTInt(15)
end

function SWEP:SetBonusTime(dur)
	self:SetDTFloat(16, dur)
end

function SWEP:GetBonusTime()
	return self:GetDTFloat(16)
end

sound.Add({
	name = 			"weapon_rpg.Fidget",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rpg_blueshift/idle_fidget.wav"
})

sound.Add({
	name = 			"weapon_rpg.Fidget2_UCrazy",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rpg_blueshift/idle_fidget2.wav"
})

sound.Add({
	name = 			"weapon_rpg.Fidget3",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rpg_blueshift/idle_fidget3.wav"
})

sound.Add({
	name = 			"weapon_rpg.Fidget4",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rpg_blueshift/idle_fidget4.wav"
})

sound.Add({
	name = 			"weapon_rpg.Reload",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rpg_blueshift/reload.wav"
})

sound.Add({
	name = 			"weapon_rpg.holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rpg_blueshift/holster.wav"
})

sound.Add({
	name = 			"weapon_rpg.draw",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		{"weapons/rpg_blueshift/draw1.wav",
						"weapons/rpg_blueshift/draw2.wav",
						"weapons/rpg_blueshift/draw3.wav",
						"weapons/rpg_blueshift/draw4.wav",
						"weapons/rpg_blueshift/draw5.wav"
					}
})

sound.Add({
	name = 			"weapon_rpg.DrawAdmire",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rpg_blueshift/draw_admire.wav"
})

sound.Add({
	name = 			"weapon_rpg.Fire",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rpg_blueshift/single.wav"
})