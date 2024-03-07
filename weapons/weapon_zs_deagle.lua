AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_deagle"))
SWEP.Description = (translate.Get("desc_deagle"))
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "weapon"
	SWEP.HUD3DPos = Vector(1.25, -2, -0.5)
	SWEP.HUD3DAng = Angle(180, 0, -15)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(1.5,3,-1.5)
	SWEP.VMAng = Angle(0, 0, 0)

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_deagle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.8, 1.1, -1.9), angle = Angle(-5, -4, 175), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-0.33, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.IronSightsPos = Vector(-5.085, -3, 1.95)
	SWEP.IronSightsAng = Vector(-0.072, 0.025, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"
SWEP.ViewModel = "models/weapons/tfa_ins2/c_deagle.mdl"
SWEP.WorldModel	= "models/weapons/tfa_ins2/w_deagle.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110
--")weapons/tfa_ins2/deagle/de_single.wav"
SWEP.Primary.Sound = ")weapons/DEagle/deagle-1.wav"
SWEP.Primary.Damage = 57
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.32
SWEP.Primary.KnockbackScale = 2

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3.16
SWEP.ConeMin = 1.16

SWEP.FireAnimSpeed = 1.3

SWEP.HeadshotMulti = 2.2

SWEP.Tier = 3

SWEP.StandartIronsightsAnim = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.07)

function SWEP:SendWeaponAnimation()
	local iron = self:GetIronsights()

	if self:Clip1() == 0 then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_EMPTY)
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
end

function SWEP:Deploy()
	self:SendWeaponAnim((self:Clip1() == 0) and ACT_VM_DRAW_EMPTY or ACT_VM_DRAW_DEPLOYED)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self.BaseClass.Deploy(self)
	return true
end

SWEP.LowAmmoSoundThreshold = 0.65
SWEP.LowAmmoSoundHandgun = ")weapons/tfa/lowammo_indicator_handgun.wav"
SWEP.LastShot = ")weapons/tfa/lowammo_dry_handgun.wav"
function SWEP:EmitFireSound()
	local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
	local mult = clip1 / maxclip1
	self:EmitSound(self.LowAmmoSoundHandgun, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
	if self:Clip1() <= 1 then
		self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
	end

	self:EmitSound(self.Primary.Sound, self.SoundFireLevel, 100 + (1 - (clip1 / maxclip1)) * 35, self.SoundFireVolume, CHAN_WEAPON)
end

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
local br = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_faraday")), (translate.Get("desc_faraday")), function(wept)
	wept.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
	wept.WorldModel = "models/weapons/w_pist_deagle.mdl"
	wept.Primary.Sound = ")weapons/DEagle/deagle-1.wav"

	wept.Primary.Damage = wept.Primary.Damage * 0.85
	wept.Primary.ClipSize = wept.Primary.ClipSize * 2
	wept.RequiredClip = 2
	wept.Primary.Ammo = "pulse"
	wept.HasAbility = true
	wept.AbilityMax = 200

	wept.HeadshotMulti = 2

	wept.InnateTrinket = "trinket_pulse_rounds"
    wept.LegDamageMul = 1.1
	wept.LegDamage = 1.1
	wept.InnateLegDamage = true

	wept.SendWeaponAnimation = function(self)
		self.BaseClass.SendWeaponAnimation(self)
	end
	
	wept.SendReloadAnimation = function(self)
		self.BaseClass.SendReloadAnimation(self)
	end
	
	wept.Deploy = function(self)
		self.BaseClass.Deploy(self)
		return true
	end

	if CLIENT then

		wept.ViewModelFlip = false
		wept.ViewModelFOV = 55 --70
	
		wept.HUD3DBone = "v_weapon.Deagle_Slide"
		wept.HUD3DPos = Vector(-1.5, 0, 1)
		wept.HUD3DAng = Angle(0, 0, 0)
		wept.HUD3DScale = 0.015

		wept.IronSightsPos = Vector(-6.32, 3, 1.85)


		wept.AbilityBar3D = function(self, x, y, hei, wid, col, val, max, name)
			self:DrawAbilityBar3D(x, y, hei, wid, Color(0, 128, 192), self:GetResource(), self.AbilityMax, "PULSE ARC")
		end

		wept.AbilityBar2D = function(self, x, y, hei, wid, col, val, max, name)
			self:DrawAbilityBar2D(x, y, hei, wid, Color(0, 128, 192), self:GetResource(), self.AbilityMax, "PULSE ARC")
		end

		wept.VElements = {
			["4"] = { type = "Model", model = "models/props_combine/combine_interface001.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.161, 0.546, -0.113), angle = Angle(0, 0, -180), size = Vector(0.024, 0.024, 0.024), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["8"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(0, 0.63, 3.006), angle = Angle(0, 0, -15.41), size = Vector(0.041, 0.052, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["3+"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.62, 0.317, -1.056), angle = Angle(180, 90, -21.452), size = Vector(0.104, 0.104, 0.104), color = Color(0, 255, 255, 255), surpresslightning = false, material = "models/effects/slimebubble_sheet", skin = 0, bodygroup = {} },
			["5"] = { type = "Model", model = "models/props_combine/combine_interface001.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.251, 0.138, 1.631), angle = Angle(0, 0, 90), size = Vector(0.021, 0.037, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["element_name2"] = { type = "Model", model = "models/props_trainstation/train005.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(-0.403, -3.319, -2.77), angle = Angle(0, 90, -90), size = Vector(0.016, 0.025, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["3+++"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.62, 0.869, -1.056), angle = Angle(180, 90, -21.452), size = Vector(0.104, 0.104, 0.104), color = Color(0, 255, 255, 255), surpresslightning = false, material = "models/effects/slimebubble_sheet", skin = 0, bodygroup = {} },
			["element_name1"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0, -3.708, -4.875), angle = Angle(0, 0, -90), size = Vector(0.012, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["3++++"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.62, 0.869, -1.056), angle = Angle(180, 90, -21.452), size = Vector(0.104, 0.104, 0.104), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/introomarea_sheet", skin = 0, bodygroup = {} },
			["3"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.62, 0.317, -1.056), angle = Angle(180, 90, -21.452), size = Vector(0.104, 0.104, 0.104), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/introomarea_sheet", skin = 0, bodygroup = {} },
			["7"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(0, -0.245, -4.223), angle = Angle(0, 0, 0), size = Vector(0.02, 0.02, 0.071), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/shadertest/shader1_dudv", skin = 0, bodygroup = {} },
			["2"] = { type = "Model", model = "models/props_junk/metalgascan.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(0, 0.31, 0.64), angle = Angle(0, -180, 0), size = Vector(0.15, 0.108, 0.175), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["1"] = { type = "Model", model = "models/Items/battery.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(-0.211, 0.637, -7.606), angle = Angle(0, 180, 0), size = Vector(0.252, 0.252, 0.583), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["element_name3"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0, -4.159, -2.237), angle = Angle(0, 90, 0), size = Vector(0.017, 0.014, 0.027), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["6"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(0, 0.172, 1.68), angle = Angle(0, -1.821, -38.688), size = Vector(0.216, 0.216, 0.115), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}

		wept.WElements = {
			["element_name2+"] = { type = "Model", model = "models/props_trainstation/train005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.538, 2.697, -2.981), angle = Angle(91.383, -95.089, -180), size = Vector(0.016, 0.025, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["1++"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.208, 2.354, -2.8), angle = Angle(0, -95.816, -92.491), size = Vector(0.252, 0.252, 0.583), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["element_name1"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.987, 2.085, -3.533), angle = Angle(-180, -94.731, 1.886), size = Vector(0.017, 0.009, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["1+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.047, 1.072, -3.119), angle = Angle(180, -94, -90.74), size = Vector(0.252, 0.252, 0.583), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["element_name2"] = { type = "Model", model = "models/props_trainstation/train005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.629, 1.174, -3.139), angle = Angle(91.383, -93.774, 0), size = Vector(0.016, 0.025, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["6"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.042, 1.133, -4.994), angle = Angle(-44.667, 19.111, 24.989), size = Vector(0.216, 0.216, 0.115), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["element_name3"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.619, 1.814, -4.539), angle = Angle(-82.945, -5.52, -180), size = Vector(0.017, 0.014, 0.027), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["2"] = { type = "Model", model = "models/props_junk/metalgascan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.27, 1.483, -4.112), angle = Angle(180, 84.804, -91.075), size = Vector(0.17, 0.097, 0.174), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
		}
	end

	wept.BulletCallback = function(attacker, tr, dmginfo)
		local ent = tr.Entity
		local wep = dmginfo:GetInflictor()
		if ent:IsValidLivingZombie() then
			if wep:GetResource() >= wep.AbilityMax then
				wep:SetTumbler(true)
				wep:SetResource(wep.AbilityMax)
			end

			if SERVER and IsValid(wep) and wep:GetTumbler() then
				util.ElectricWonder(wep, attacker, tr.HitPos, 192, wep.Primary.Damage * 0.65, 0.6, 3)
				wep:SetResource(0)
				wep:SetTumbler(false)
			end
		end

		if IsFirstTimePredicted() then
			util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
		end
	end
	
	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/deagle/deagle-1.wav", 75, math.random(81, 85), 0.8)
		self:EmitSound("weapons/tau/single0"..math.random(1,3)..".ogg", 75, math.random(90, 120), 0.7, CHAN_WEAPON + 20)
	end
	
	wept.EmitReloadSound = function(self)
		if IsFirstTimePredicted() then
			self:EmitSound("weapons/physcannon/physcannon_charge.wav", 70, 95, 0.65, CHAN_WEAPON + 21)
			timer.Create("deagle_reload", 1.25, 1, function ()
				self:EmitSound("items/battery_pickup.wav", 70, 57, 0.85, CHAN_WEAPON + 22)
			end) 
		end
	end

	wept.Holster = function(self)
		timer.Remove("deagle_reload")
		return self.BaseClass.Holster(self)
	end

	wept.OnRemove = function(self)
		self.BaseClass.OnRemove(self)
		timer.Remove("deagle_reload")
	end

end)
br.Colors = {Color(130, 130, 240), Color(65, 65, 120), Color(39, 39, 90)}

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_seditionist")), (translate.Get("desc_seditionist")), function(wept)
	wept.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
	wept.WorldModel = "models/weapons/w_pist_deagle.mdl"
	wept.Primary.Sound = ")weapons/DEagle/deagle-1.wav"

	wept.ConeMax = wept.ConeMax * 1.1
	wept.ConeMin = wept.ConeMin * 1.1
	wept.Primary.Damage = wept.Primary.Damage * 0.9
	wept.Primary.Delay = 0.42
	wept.Primary.Ammo = "pistol"
	wept.FireAnimSpeed = 1.3
	wept.Pierces = 4
	wept.DamageTaper = 0.65
	wept.HeadshotMulti = 1.5
	wept.ProjExplosionTaper = wept.DamageTaper

	wept.SendWeaponAnimation = function(self)
		self.BaseClass.SendWeaponAnimation(self)
	end
	
	wept.SendReloadAnimation = function(self)
		self.BaseClass.SendReloadAnimation(self)
	end
	
	wept.Deploy = function(self)
		self.BaseClass.Deploy(self)
		return true
	end

	if CLIENT then
		wept.ViewModelFOV = 55 

		wept.VElements = {
			["laserbeam"] = { type = "Sprite", sprite = "sprites/glow01", bone = "ValveBiped.Bip01_Spine4", rel = "back", pos = Vector(-0.018, -3.799, -1.691), size = { x = 0.79, y = 0.79 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
			["back++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.Deagle_Parent", rel = "back", pos = Vector(0, -0.387, -1.553), angle = Angle(0, 0, -180), size = Vector(0.018, 0.01, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["back"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0.02, -3.869, -4.113), angle = Angle(0, 0, -90), size = Vector(0.018, 0.013, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["scope"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back+", pos = Vector(2.154, 0, 2.752), angle = Angle(90, 0, 0), size = Vector(0.028, 0.024, 0.098), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
			["scopeinnard+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0.426, 0, 0.323), angle = Angle(90, 0, 0), size = Vector(0.025, 0.024, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["back+"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "v_weapon.Deagle_Slide", rel = "", pos = Vector(0, 1.519, 1.187), angle = Angle(90, -0.288, -90), size = Vector(0.01, 0.021, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
			["back+++++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.Deagle_Parent", rel = "back", pos = Vector(0, -3.51, -0.551), angle = Angle(0, 0, -90), size = Vector(0.03, 0.03, 0.03), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
			["dribble+"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back", pos = Vector(-1.209, 3.344, 0.642), angle = Angle(-105, 0, -90), size = Vector(0.025, 0.016, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["scopeinnard"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0.423, 0, 0.323), angle = Angle(90, 180, 0), size = Vector(0.025, 0.024, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/props_phx/trains/wheel_medium.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back", pos = Vector(0, -3.399, -1.675), angle = Angle(0, 0, -90), size = Vector(0.016, 0.016, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
			["dribble"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "back", pos = Vector(1.208, 3.344, 0.094), angle = Angle(105, 0, -90), size = Vector(0.025, 0.016, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}

		wept.WElements = {
			["scopeinnard+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0.029, 8.166, 1.659), angle = Angle(180, 90, 0), size = Vector(0.025, 0.024, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["laserbegins"] = { type = "Sprite", sprite = "sprites/glow01", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(-0.018, -3.799, -1.691), size = { x = 0.79, y = 0.79 }, color = Color(255, 0, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
			["scopeinnard++"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0.029, 8.166, 1.659), angle = Angle(0, 90, 0), size = Vector(0.025, 0.024, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["scope"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0.029, 7.666, 1.121), angle = Angle(90, 90, 0), size = Vector(0.028, 0.024, 0.098), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
			["back"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.425, 2.095, -4.106), angle = Angle(180, -94.622, 2.526), size = Vector(0.018, 0.013, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["back+"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.125, 1.56, -2.293), angle = Angle(178.087, -4.79, 0), size = Vector(0.01, 0.021, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
			["back+++++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0, -3.51, -0.551), angle = Angle(0, 0, -90), size = Vector(0.03, 0.03, 0.03), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
			["back++++"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0, -0.387, -1.553), angle = Angle(0, 0, -180), size = Vector(0.018, 0.01, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["dribble+"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(-1.209, 3.344, 0.642), angle = Angle(-105, 0, -90), size = Vector(0.025, 0.016, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/props_phx/trains/wheel_medium.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(0, -3.399, -1.675), angle = Angle(0, 0, -90), size = Vector(0.016, 0.016, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_train002", skin = 0, bodygroup = {} },
			["dribble"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "back", pos = Vector(1.208, 3.344, 0.094), angle = Angle(105, 0, -90), size = Vector(0.025, 0.016, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
		wept.HUD3DBone = "v_weapon.Deagle_Slide"
		wept.HUD3DPos = Vector(-1.5, 0, 1)
		wept.HUD3DAng = Angle(0, 0, 0)
		wept.HUD3DScale = 0.015

		wept.IronSightsPos = Vector(-6.32, 3, 1.55)

		--wept.IronSightsPos = Vector(-6.36, 5, 1.6)
	end
	
	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/deagle/deagle-1.wav", 75, math.random(122, 130), 0.6)
		self:EmitSound("weapons/elite/elite-1.wav", 75, math.random(82, 88), 0.4, CHAN_WEAPON + 20)
	end
end)
branch.Colors = {Color(110, 160, 170), Color(90, 140, 150), Color(70, 120, 130)}
branch.NewNames = {"Focused", "Transfixed", "Orphic"}
--branch.Killicon = "weapon_zs_seditionist"

sound.Add({
	name = 			"TFA_INS2.DEAGLE.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_boltback.wav"
})

sound.Add({
	name = 			"TFA_INS2.DEAGLE.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_boltrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.DEAGLE.Boltslap",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_boltslap.wav"
})

sound.Add({
	name = 			"TFA_INS2.DEAGLE.Boltbackslap",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_boltbackslap.wav"
})

sound.Add({
	name = 			"TFA_INS2.DEAGLE.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.DEAGLE.Magrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_magrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.DEAGLE.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_magout.wav"
})

sound.Add({
	name = 			"TFA_INS2.DEAGLE.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_magin.wav"
})

sound.Add({
	name = 			"TFA_INS2.DEAGLE.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/deagle/handling/deagle_maghit.wav"
})