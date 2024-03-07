AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Chopper' Heavy Pulse Gun"
SWEP.Description = "Оружие снятое со страйдера, достаточно тяжелое, чтобы держать в руках."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "Vent"
	SWEP.HUD3DPos = Vector(1, 0, 0)
	SWEP.HUD3DScale = 0.018
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	
	SWEP.ViewModelBoneMods = {
		["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {
		["screen+"] = { type = "Model", model = "models/hunter/plates/plate2x3.mdl", bone = "Base", rel = "", pos = Vector(6.443, 1.046, 4.736), angle = Angle(-45, -90, 0), size = Vector(0.032, 0.032, 0.128), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_citadel001", skin = 0, bodygroup = {} },
		["screen++"] = { type = "Model", model = "models/hunter/plates/plate2x3.mdl", bone = "Base", rel = "", pos = Vector(6.488, 0.87, 4.643), angle = Angle(-45, -90, 0), size = Vector(0.026, 0.026, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_interface_disp", skin = 0, bodygroup = {} },
		["ruch"] = { type = "Model", model = "models/Items/battery.mdl", bone = "Base", rel = "", pos = Vector(-0.232, 6.334, 3.197), angle = Angle(-180, 180, 107.542), size = Vector(0.275, 0.569, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["screen"] = { type = "Model", model = "models/mechanics/solid_steel/plank_4.mdl", bone = "Base", rel = "", pos = Vector(3.829, 1.034, 4.636), angle = Angle(45, 90, 0), size = Vector(0.045, 0.089, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_camera001", skin = 0, bodygroup = {} },
		["sda"] = { type = "Model", model = "models/gibs/gunship_gibs_nosegun.mdl", bone = "Base", rel = "", pos = Vector(-3.024, 0.229, 10.038), angle = Angle(95.252, 48.766, 0), size = Vector(0.354, 0.354, 0.354), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}

	SWEP.WElements = {
		["screen+"] = { type = "Model", model = "models/hunter/plates/plate2x3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.493, 7.679, -3.195), angle = Angle(-59.963, 7.236, 12.093), size = Vector(0.032, 0.032, 0.128), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_citadel001", skin = 0, bodygroup = {} },
		["screen++"] = { type = "Model", model = "models/hunter/plates/plate2x3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.276, 7.742, -3.277), angle = Angle(119.656, 5.243, -10.297), size = Vector(0.026, 0.026, 0.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_interface_disp", skin = 0, bodygroup = {} },
		["ruch"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.055, 0.56, 2.502), angle = Angle(1.34, -88.655, -172.096), size = Vector(0.441, 0.552, 0.819), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["screen"] = { type = "Model", model = "models/mechanics/solid_steel/plank_4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.745, 5.906, -2.951), angle = Angle(-59.924, -16.761, -8.297), size = Vector(0.045, 0.089, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_camera001", skin = 0, bodygroup = {} },
		["sda"] = { type = "Model", model = "models/gibs/gunship_gibs_nosegun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.59, -2.299, -5.324), angle = Angle(-8.421, 2.321, -42.644), size = Vector(0.535, 0.381, 0.381), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = ""
SWEP.Primary.Damage = 29.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06

SWEP.ReloadSpeed = 0.5

SWEP.Primary.ClipSize = 150
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3
SWEP.ConeMin = 1

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 1.5
SWEP.LegDamage = 2
SWEP.InnateLegDamage = true

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-3, 1, 1)

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

SWEP.TracerName = "AirboatGunHeavyTracer"

SWEP.FireAnimSpeed = 0.4

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.06)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/airboat/airboat_gun_lastshot1.wav", 100, math.random(100, 120), 1, CHAN_WEAPON + 20)
	self:EmitSound("weapons/flashbang/flashbang_explode2.wav", 100, math.random(125, 150), 1, CHAN_WEAPON)
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("npc/scanner/combat_scan5.wav", 100, 125)
	end
end


function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValidZombie() then
		local activ = attacker:GetActiveWeapon()
		ent:AddLegDamageExt(activ.LegDamage, attacker, activ, SLOWTYPE_PULSE)
	end

	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end
end
