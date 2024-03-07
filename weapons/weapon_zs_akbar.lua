AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_akbar"))
SWEP.Description = (translate.Get("desc_akbar"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 65

	SWEP.HUD3DBone = "weapon"
	SWEP.HUD3DPos = Vector(-8, -3.5, 1.2)
	SWEP.HUD3DAng = Angle(-90, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Vector(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/rmzs/c_ak74.mdl"
SWEP.WorldModel = "models/weapons/rmzs/w_ak74.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = false
SWEP.Primary.Sound = Sound(")weapons/custom/ak47_shoot"..math.random(1,4)..".ogg")
SWEP.Primary.Damage = 21.85
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.11

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.65
SWEP.ConeMin = 1.275

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 3
SWEP.ResistanceBypass = 0.7

SWEP.IronSightsPos = Vector(-3.4, -8, 1.455)
SWEP.IronSightsAng = Vector(0.707, 0, 0)



GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.344)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.172)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.085, 1)
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_ksyuha")), (translate.Get("desc_ksyuha")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.95
	wept.Primary.Delay = wept.Primary.Delay * 0.75
	wept.Primary.ClipSize = 30
	wept.ConeMax = 3
	wept.ConeMin = 1.5

	wept.ViewModel = "models/weapons/tfa_csgo/c_aks74u.mdl"
	wept.WorldModel	= "models/weapons/tfa_csgo/w_aks74u.mdl"
	wept.Primary.Sound = Sound(")weapons/custom/ak74u_shoot"..math.random(1,3)..".ogg")
	wept.FireAnimSpeed = 0.75 -- mitigate  
	wept.ConeMax = 3
	wept.ConeMin = 1.5

	wept.IronsightsMultiplier = 0.75

	wept.IronSightsPos = Vector(-3.30, -3.25, 0.60)
	wept.IronSightsAng = Vector(0, 0, 0)

	wept.IsShooting = 0
	wept.SendWeaponAnimation = function(self)
		self.IsShooting = CurTime() + 0.006
		local dfanim = self:GetIronsights() and ACT_VM_IDLE or ACT_VM_PRIMARYATTACK
		self:SendWeaponAnim(dfanim)
		self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
	end
	
	wept.BulletCallback = function(attacker, tr, dmginfo)
		local ent = tr.Entity

		if ent:IsValid() and ent:IsPlayer()	and ent:Health() <= ent:GetMaxHealthEx() * 0.4 then
			dmginfo:SetDamage(dmginfo:GetDamage() * 1.2)
		end
	end

	if CLIENT then
		wept.ViewModelFlip = false
		wept.ViewModelFOV = 55
		wept.ShowWorldModel = false
		
		wept.HUD3DBone = "Weapon"
		wept.HUD3DPos = Vector(1.5, 2, 1.5)
		wept.HUD3DAng = Angle(180, 0, -125)
		wept.HUD3DScale = 0.01
		
		wept.VMPos = Vector(0, -0.75, 0)
		wept.VMAng = Vector(0, 0, 0)
		
		wept.VElements = {}
		wept.WElements = {
			["weapon"] = { type = "Model", model = "models/weapons/tfa_csgo/w_aks74u.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.2, 2, 1.2), angle = Angle(-13, 3, 178), size = Vector(1.0, 1.0, 1.0), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
		
		wept.ViewModelBoneMods = {
			["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.652, 0), angle = Angle(0, 0, 0) },
			["ValveBiped.Bip01_L_Wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.301), angle = Angle(0, 0, 75) },
			["ValveBiped.Bip01_L_Ulna"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 45) },
			["bolt"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		}

		local uBarrelOrigin = wept.VMPos
		local lBarrelOrigin = Vector(0, 0, 0)
		wept.Think = function(self)
			BaseClass.Think(self)
			if self.IsShooting >= CurTime() then
				self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -5, 0) )
				self.ViewModelBoneMods[ "bolt" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "bolt" ].pos, Vector(0, 8, 0) )
			else
				self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
				self.ViewModelBoneMods[ "bolt" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "bolt" ].pos, lBarrelOrigin )
			end
		end	
	end
end)
branch.Killicon = "weapon_zs_aks74u"

function SWEP.BulletCallback(attacker, tr, dmginfo)

	local ent = tr.Entity

	if ent:IsValid() and ent:IsPlayer()	and ent:Health() >= ent:GetMaxHealthEx() * 0.6 then
		dmginfo:SetDamage(dmginfo:GetDamage() * 1.2)
	end
	
end

sound.Add({
	name = "Weapon_AKM.Fire",
	channel = CHAN_STATIC,
	volume = 0.85,
	level = 60,
	pitch = {97, 103},
	sound = {
		")weapons/akm/akm_fire_player_01.wav",
		")weapons/akm/akm_fire_player_02.wav",
		")weapons/akm/akm_fire_player_03.wav",
		")weapons/akm/akm_fire_player_04.wav"
	}
})

sound.Add({
	name = "Weapon_AKM.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = 140,
	pitch = {97, 103},
	sound = {
		")weapons/akm/akm_fire_player_01.wav",
		")weapons/akm/akm_fire_player_02.wav",
		")weapons/akm/akm_fire_player_03.wav",
		")weapons/akm/akm_fire_player_04.wav"
	}
})

sound.Add({
	name = "Weapon_AKM.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/akm/handling/akm_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/akm/handling/akm_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/akm/handling/akm_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/akm/handling/akm_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/akm/handling/akm_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/akm/handling/akm_bolt_release_01.wav"
})