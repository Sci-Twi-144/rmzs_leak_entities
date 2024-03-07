AddCSLuaFile()

SWEP.Base = "weapon_zs_base_akimbo"

if CLIENT then
    SWEP.HUD3DBone = "Object01"
	SWEP.HUD3DPos = Vector(-1.3, -1.8, 0)
    SWEP.HUD3DAng = Angle(0, 0, -25)

    SWEP.HUD3DBone2 = "Object01"
	SWEP.HUD3DPos2 = Vector(-1.8, 1.8, 0)
    SWEP.HUD3DAng2 = Angle(0, 180, -25)

	SWEP.VElementsR = {}
	SWEP.VElementsL = {}
	SWEP.WElements = {
		["wep_right"] = { type = "Model", model = "models/weapons/dm1973/w_dmi_colt_peacemkr.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 1, 2.5), angle = Angle(0, -13, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["wep_left"] = { type = "Model", model = "models/weapons/dm1973/w_dmi_colt_peacemkr.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.5, 1, -2.5), angle = Angle(0, -10, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.VMAng = Vector(1, 0, 0)
	SWEP.VMPos = Vector(0.3, -3, -0.25)
	SWEP.IronSightsPos = Vector(-2, -1, 1)
end

--SWEP.PrintName = "'Akimbo Shroud'"
--SWEP.Description = "Akimbo"
SWEP.PrintName = (translate.Get("wep_akimbo_shroud"))
SWEP.Description = (translate.Get("desc_akimbo_shroud"))
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/dm1973/c_dmi_colt_peacemkr.mdl"
SWEP.ViewModel_L = "models/weapons/dm1973/c_dmi_colt_peacemkr.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = "^weapons/peacemaker/peacemaker_single1.wav"
SWEP.Primary.Damage = 59
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.5

SWEP.SoundPitchMin_S = 95
SWEP.SoundPitchMax_S = 110

SWEP.Secondary.Sound = "^weapons/peacemaker/peacemaker_single1.wav"
SWEP.Secondary.Damage = 59
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Delay = 0.55

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = 6
SWEP.Secondary.DefaultClip = 60
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "pistol"

SWEP.RequiredClip = 1

SWEP.ConeMax = 3.75
SWEP.ConeMin = 2

SWEP.ConeMax_S = 3.75
SWEP.ConeMin_S = 2

SWEP.FireAnimSpeed = 1.5
SWEP.ReloadSpeed = 0.5

SWEP.Tier = 4

SWEP.BounceMulti = 1.5

SWEP.ResistanceBypass = 0.7

SWEP.CannotHaveExtendetMag = true

SWEP.ShouldMuzzleL = true
SWEP.ShouldMuzzleR = true

SWEP.UseStandartReloadAim = false

SWEP.CantSwitchFireModes = true

-- ANIMATION INDEX NUMBER --

-- get list numbers of index.
--PrintTable( self:GetSequenceList() )
-- нет драва при деплое
SWEP.FireAnimIndexMin = 2
SWEP.FireAnimIndexMax = 4
SWEP.ReloadAnimIndex = 9
SWEP.DeployAnimIndex = 1

SWEP.FireAnimIndexMin_S = 2
SWEP.FireAnimIndexMax_S = 4
SWEP.ReloadAnimIndex_S = 9
SWEP.DeployAnimIndex_S = 1


function SWEP:ProcessReloadEndTime()
	local vm = self:GetOwner():GetViewModel(0)
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()

	--print(vm:SequenceDuration()/reloadspeed, "duration")

	self:SetReloadFinish(CurTime() + vm:SequenceDuration() / reloadspeed)

	if not self.DontScaleReloadSpeed then
		self:GetOwner():GetViewModel():SetPlaybackRate(reloadspeed)
	end
end

local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)

	local RicoCallback = function(att, tr, dmginfo)
		local ent = tr.Entity
		if SERVER and tr.HitWorld and not tr.HitSky then
			local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * 1.2
			timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
		end
	end

	attacker.RicochetBullet = true
	if RicoBounces <= 1 and attacker:IsValid() then
		FORCE_B_EFFECT = true
		RicoBounces = RicoBounces + 1
		attacker:FireBulletsLua(hitpos, 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, 0, 1, 1, 1, damage, nil, nil, "tracer_rico", RicoCallback, nil, nil, nil, nil, attacker:GetActiveWeapon())
		FORCE_B_EFFECT = nil
	end
	attacker.RicochetBullet = nil
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	RicoBounces = 0
	local ent = tr.Entity
	if SERVER and tr.HitWorld and not tr.HitSky then
		local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * attacker:GetActiveWeapon().BounceMulti
		timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
	end
end