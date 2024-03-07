AddCSLuaFile()

SWEP.PrintName = "Wunderwaffe DG-2"
SWEP.Description = "POWAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.VMPos = Vector(0, -2, -1)
	SWEP.VMAng = Vector(0, 0, 0)

	SWEP.HUD3DBone = "j_gun"
	SWEP.HUD3DPos = Vector(16, -1.75, 2.75)
	SWEP.HUD3DAng = Angle(0, -90, 90)
	SWEP.HUD3DScale = 0.012

	SWEP.LightNum = 3
	function SWEP:FireAnimationEvent(pos, ang, event, options)
		local vm = self:GetOwner():GetViewModel()
		-- First Raise = 9091
		-- Pullout = 9001
		-- Fire = 9061
		-- Finish Reload = 9071
		-- Start Reload = 9081

		local clip = self:Clip1()
		local lv2 = self.QualityTier and self.QualityTier == 2
		local lv3 = self.QualityTier and self.QualityTier == 3

		if event == 9001 or event == 9091 or event == 9011 or event == 9061 then -- First Raise
			if clip >= (lv3 and 50 or lv2 and 35 or 30) then
				vm:StopParticles()
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 2)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 3)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 4)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 5)
			elseif clip >= (lv3 and 30 or lv2 and 25 or 20) then
				vm:StopParticles()
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 2)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 3)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 5)
			elseif clip >= (lv3 and 10 or lv2 and 15 or 10) then
				vm:StopParticles()
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 2)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 5)
			elseif clip <= (lv3 and 0 or lv2 and 5 or 0) then
				vm:StopParticles()
			end
		end

		if event == 9081 then -- Start Reload	
			vm:StopParticles()
		end

		if event == 9061 and not DoOnce then -- Fire
			ParticleEffectAttach( "tesla_mflash", PATTACH_POINT_FOLLOW, vm, 1)
			DoOnce = true

			timer.Simple(1, function() if IsValid(self) then DoOnce = false end end)
		end

		local multiplier = (self.QualityTier and self.QualityTier - 1 or 1)

		self.LightNum = math.Clamp(clip + self:GetOwner():GetAmmoCount(self.Primary.Ammo), 0, 30 * multiplier)
		if event == 9071 then -- Finish Reload
			if self.LightNum >= 30 * multiplier then
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 2)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 3)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 4)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 5)
			elseif self.LightNum >= 20 * multiplier then
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 2)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 3)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 5)
			elseif self.LightNum < 10 * multiplier then
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 2)
				ParticleEffectAttach( "tesla_vm_glow", PATTACH_POINT_FOLLOW, vm, 5)
			end
		end
	end
end

sound.Add({
	name = "Weapon_WunderWaffe.FlipOff",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/tesla_gun/tesla_switch_flip_off.wav"
})
sound.Add({
	name = "Weapon_WunderWaffe.HandlePull",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/tesla_gun/tesla_handle_pullback.wav"
})
sound.Add({
	name = "Weapon_WunderWaffe.ClipIn",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/tesla_gun/tesla_clip_in.wav"
})
sound.Add({
	name = "Weapon_WunderWaffe.HandleRelease",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/tesla_gun/tesla_handle_release.wav"
})
sound.Add({
	name = "Weapon_WunderWaffe.FlipOn",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 80,
	sound = "weapons/tesla_gun/tesla_switch_flip_on.wav"
})

SWEP.ShowWorldModel = true
SWEP.ShowViewModel = true

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"
SWEP.TracerName = "tracer_waffe"

SWEP.ViewModel			= "models/weapons/wunderwaffe/v_wunderwaffe.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/wunderwaffe/w_wunderwaffe.mdl" -- Weapon world model path
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = Sound(")weapons/tesla_gun/tesla_fire.wav")
SWEP.Primary.Damage = 145
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.25

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.RequiredClip = 10

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 0.2
SWEP.ConeMin = 0.2

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ReloadSpeed = 1

SWEP.Tier = 6
SWEP.MaxStock = 2
SWEP.NoReviveFromKills = true

SWEP.IronSightsPos = Vector(-4.8, -3, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.18, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 20, 1)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	dmginfo:SetDamageType(DMG_SHOCK)

	if tr.HitWorld then
		util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end

	local wep = attacker:GetActiveWeapon()

	if SERVER and IsValid(wep) then
		util.ElectricWonder(wep, attacker, tr.HitPos, 5000, wep.Primary.Damage, 0.6, 5)
	end
end 