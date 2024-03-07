AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_hunter"))
SWEP.Description = (translate.Get("desc_hunter"))
SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "W_Main"
	SWEP.HUD3DPos = Vector(1.6, -0.2, 1)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015
end
--[[
sound.Add(
{
	name = "Weapon_Hunter.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitchstart = 134,
	pitchend = 10,
	sound = "weapons/awp/awp1.wav"
})
]]
SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/rmzs/weapons/css_awp_new/c_awp_new.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/awp_new/awp_new.wav"
SWEP.Primary.Damage = 108.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 15

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ReloadDelay = 2.5

SWEP.ConeMax = 5.75
SWEP.ConeMin = 0

SWEP.Pierces = 2

SWEP.ProjExplosionTaper = 0.55
SWEP.DamageTaper = SWEP.ProjExplosionTaper

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 3

SWEP.ResistanceBypass = 0.4

-- SWEP.TracerName = "AR2Tracer"

-- SWEP.ReloadActivity = ACT_VM_PRIMARYATTACK

SWEP.NumKills = 0

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BULLET_PIERCES, 1, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TAPER, 0.1, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_needlegun")

-- if RMZS and not RMZS.ObjectiveMap then
	-- GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_hunter_exp")), (translate.Get("desc_hunter_exp")), function(wept)
		-- wept.Primary.ClipSize = 2
		-- wept.RequiredClip = 2
		-- --wept.ReloadSpeed = 0.9
		-- wept.IsAoe = true

		-- wept.Primary.ProjExplosionRadius = 72
		-- wept.Primary.ProjExplosionTaper = 0.94

		-- wept.OnZombieKilled = function(self, zombie, total, dmginfo)
			-- local killer = self:GetOwner()
			-- local minushp = -zombie:Health()
			-- if killer:IsValidLivingHuman() and minushp > 25 and self.NumKills <= 6 then -- 10
				-- local pos = zombie:GetPos()
               	-- self.NumKills = self.NumKills + 1

				-- if dmginfo:GetInflictor() == killer:GetActiveWeapon() then
					-- timer.Simple(0.15, function()
						-- if killer:IsValidLivingHuman() then -- just in case
							-- util.BlastDamagePlayer(killer:GetActiveWeapon(), killer, pos, 72, minushp, DMG_ALWAYSGIB, 0.94)
						-- end
					-- end)
				-- end

				-- local effectdata = EffectData()
					-- effectdata:SetOrigin(pos)
				-- util.Effect("Explosion", effectdata, true, true)
			-- end
		-- end
	-- end)
-- end

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
	self.ReloadTimerAnim = CurTime() + self:SequenceDuration() / (1.25 * self:GetReloadSpeedMultiplier())
end

function SWEP:FireAnimationEvent(pos,ang,event)
	-- print(event, options)
	return (event==20)
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

-- function SWEP:SendWeaponAnimation()
	-- self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	-- local owner = self:GetOwner()
	-- local vm = owner:GetViewModel()
	-- local speed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()

	-- if vm:IsValid() then
		-- vm:SetPlaybackRate(0.5 * speed)
	-- end

	-- self.ReloadTime =  2.5 / speed
	-- self:SetReloadFinish(CurTime() + 2.5 / speed)
-- end
 
-- function SWEP:MockReload()
	-- local speed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	-- self:SetReloadFinish(CurTime() + 2.5 / speed)
-- end

-- function SWEP:Reload()
	-- local owner = self:GetOwner()
	-- if owner:IsHolding() then return end

	-- if self:GetIronsights() then
		-- self:SetIronsights(false)
	-- end

	-- if self:CanReload() then
		-- self:MockReload()
	-- end
-- end

function SWEP:FinishReload()
	self.NumKills = 0 
	self.IdleActivity = ACT_VM_IDLE
	self.BaseClass.FinishReload(self)
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
    self.NumKills = 0

	return true
end

-- function SWEP:Think()
	-- self.BaseClass.Think(self)

	-- if self:Clip1() <= 0 and self:GetPrimaryAmmoCount() <= 0 then
		-- self:MockReload()
	-- end
-- end

-- function SWEP.BulletCallback(attacker, tr, dmginfo)
	-- local effectdata = EffectData()
		-- effectdata:SetOrigin(tr.HitPos)
		-- effectdata:SetNormal(tr.HitNormal)
	-- util.Effect("hit_hunter", effectdata)
-- end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end

sound.Add({
	name = 			"NEW_AWP.Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			")weapons/awp_new/awp1.wav"
})

sound.Add({
	name = 			"NEW_AWP.Boltup",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_boltup.wav"
})

sound.Add({
	name = 			"NEW_AWP.Boltpull",
	channel = 		CHAN_ITEM2,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_boltpull.wav"
})

sound.Add({
	name = 			"NEW_AWP.Boltdown",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_boltdown.wav"
})

sound.Add({
	name = 			"NEW_AWP.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_clipout.wav"
})

sound.Add({
	name = 			"NEW_AWP.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_clipin.wav"
})
