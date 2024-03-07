AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_hm500"))
SWEP.Description = (translate.Get("desc_hm500"))

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 65

	SWEP.HUD3DBone = "j_gun"
	SWEP.HUD3DPos = Vector(1.25, -0.5, 3.15)
	SWEP.HUD3DAng = Angle(0, -90, 75)

	SWEP.VMPos = Vector(1.75, 4, 0)
	SWEP.VElements = {}
	SWEP.WElements = {
		["element_name"] = { type = "Model", model = "models/weapons/yurie_customs/w_hm500.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.5, 1.5, -1.75), angle = Angle(1, -4, 178), size = Vector(1.1000000238419, 1.1000000238419, 1.1000000238419), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/yurie_customs/c_hm500.mdl"
SWEP.WorldModel	= "models/weapons/yurie_customs/w_hm500.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.Sound = Sound(")weapons/yurie_customs/hm500/magnum-"..math.random(1,3)..".wav")
SWEP.Primary.Damage = 66
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
GAMEMODE:SetupDefaultClip(SWEP.Primary)
SWEP.Recoil = 0.75

SWEP.Primary.Ammo = "pistol"
SWEP.ConeMax = 3.3
SWEP.ConeMin = 1.7
SWEP.Tier = 4

SWEP.IronSightsPos = Vector(-3.435, -2, 0.725)
SWEP.IronSightsAng = Vector(0.401, -0.015, 0)

SWEP.CannotHaveExtendetMag = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.05)
function SWEP:EmitReloadSound()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/yurie_customs/hm500/handling/cloth_startreload01.wav", 75, 75, 1, CHAN_WEAPON + 21)
		timer.Create("reload_cyclopen", 0.66 / reloadspeed, 1, function()
			self:EmitSound("weapons/yurie_customs/hm500/handling/revolver_open_chamber.wav", 75, 75, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("reload_dumprounds", 0.73 / reloadspeed, 1, function()
			self:EmitSound("weapons/yurie_customs/hm500/handling/revolver_dump_rounds.wav", 75, 75, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("reload_magtransition", 1.26 / reloadspeed, 1, function()
			self:EmitSound("weapons/yurie_customs/hm500/handling/cloth_magtransition01.wav", 70, 57, 0.1, CHAN_WEAPON + 22)
		end)
		timer.Create("reload_slinsert", 1.6 / reloadspeed, 1, function()
			self:EmitSound("weapons/yurie_customs/hm500/handling/revolver_speed_loader_insert.wav", 70, 57, 0.1, CHAN_WEAPON + 23)
		end)
		timer.Create("reload_reload_cyclclose", 2.1 / reloadspeed, 1, function()
			self:EmitSound("weapons/yurie_customs/hm500/handling/revolver_close_chamber.wav", 70, 57, 0.1, CHAN_WEAPON + 24)
		end)
	end
end

function SWEP:RemoveAllTimers()
	timer.Remove("reload_start")
	timer.Remove("reload_cyclopen")
	timer.Remove("reload_dumprounds")
	timer.Remove("reload_magtransition")
	timer.Remove("reload_slinsert")
	timer.Remove("reload_reload_cyclclose")
end

local math_random = math.random
function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, self.SoundFireLevel, math_random(self.SoundPitchMin, self.SoundPitchMax), self.SoundFireVolume, CHAN_WEAPON+20)
	self:EmitSound("weapons/yurie_customs/hm500/handling/revolver_cock_hammer.wav", 75, math.random(81, 85), 0.8)
end

function SWEP:Holster()
	self:RemoveAllTimers()
	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)
	self:RemoveAllTimers()
end


local buffs = {
	[1] = "healdartboost",
	[2] = "focused",
	[3] = "renegade",
	[4] = "reaper"
}

function SWEP:OnZombieKilled()
	local killer = self:GetOwner()
	if killer:IsValid() then
		killer:ApplyHumanBuff(buffs[math_random(1, 4)], 6 * (killer.BuffDuration or 1), {Applier = killer, Stacks = 1}, true)
	end

end

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.Draw",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/draw.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/holster.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.CockHammer",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/revolver_cock_hammer.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.CylinderOpen",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/revolver_open_chamber.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.CylinderClose",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/revolver_close_chamber.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.DumpRounds",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/revolver_dump_rounds.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.SpeedLoaderInsert",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/revolver_speed_loader_insert.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.MagTransition",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/cloth_magtransition01.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.StartReload",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/cloth_startreload01.wav"
})

sound.Add({
	name = 			"YURIE_CUSTOMS.HM500.ReturnToIdle",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/yurie_customs/hm500/handling/cloth_returntoidle01.wav"
})