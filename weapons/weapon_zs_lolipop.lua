AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_lolipop"))

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.ViewModelBoneMods = {}

	SWEP.VElements = {
		["Pop"] = { type = "Model", model = "models/props_phx/cannonball.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Stick", pos = Vector(32.282, 1.029, 0), angle = Angle(2.171, 0, -90), size = Vector(0.079, 0.079, 0.039), color = Color(156, 100, 116, 255), surpresslightning = false, material = "models/props_debris/building_template010a", skin = 0, bodygroup = {} },
		["Stick"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Base", pos = Vector(1.7, 1.5, 10.423), angle = Angle(-96.304, 176.354, 3.191), size = Vector(1.299, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Loli+"] = { type = "Model", model = "models/props_phx/normal_tire.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Pop", pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0), size = Vector(0.15, 0.15, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Loli+++"] = { type = "Model", model = "models/props_phx/normal_tire.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Pop", pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0), size = Vector(0.259, 0.259, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Base"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 1.5), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Loli"] = { type = "Model", model = "models/props_phx/normal_tire.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Pop", pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Loli++"] = { type = "Model", model = "models/props_phx/normal_tire.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Pop", pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0), size = Vector(0.2, 0.2, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["LoliPop"] = { type = "Model", model = "models/props_vehicles/carparts_wheel01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Pop", pos = Vector(0, 0, 1), angle = Angle(0, 0, 90), size = Vector(0.268, 0.109, 0.268), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["Base"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.481, -0.41, 0.537), angle = Angle(0, 0, -5.099), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Loli++"] = { type = "Model", model = "models/props_phx/normal_tire.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pop", pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0), size = Vector(0.2, 0.2, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Pop"] = { type = "Model", model = "models/props_phx/cannonball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Stick", pos = Vector(32.282, 1, 0), angle = Angle(-10.957, 0, -90), size = Vector(0.079, 0.079, 0.039), color = Color(156, 100, 116, 255), surpresslightning = false, material = "models/props_debris/building_template010a", skin = 0, bodygroup = {} },
		["Stick"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Base", pos = Vector(1.7, 1.5, 10.423), angle = Angle(-96.304, 176.354, 3.191), size = Vector(1.299, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Loli+"] = { type = "Model", model = "models/props_phx/normal_tire.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pop", pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0), size = Vector(0.15, 0.15, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Stick+"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Stick", pos = Vector(0.004, 0.008, -0.026), angle = Angle(0, 0, -139.424), size = Vector(1.299, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Loli"] = { type = "Model", model = "models/props_phx/normal_tire.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pop", pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["Loli+++"] = { type = "Model", model = "models/props_phx/normal_tire.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pop", pos = Vector(0, 0, 0.4), angle = Angle(0, 0, 0), size = Vector(0.259, 0.259, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} },
		["LoliPop"] = { type = "Model", model = "models/props_vehicles/carparts_wheel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pop", pos = Vector(0, 0, 1), angle = Angle(0, 0, 90), size = Vector(0.268, 0.109, 0.268), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/awning001c", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 60
SWEP.MeleeRange = 76
SWEP.MeleeSize = 1.5
SWEP.Primary.Delay = 0.9

SWEP.SwingTime = 0.25
SWEP.SwingRotation = Angle(60, 0, 0)
SWEP.SwingOffset = Vector(0, -50, 0)
SWEP.SwingHoldType = "grenade"

SWEP.BlockRotation = Angle(0, 15, -40)
SWEP.BlockOffset = Vector(3, 7, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.4
SWEP.BlockReduction = 6 --?
SWEP.StaminaConsumption = 6

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09)

function SWEP:PlaySwingSound()
	self:EmitSound("garrysmod/save_load"..math.random(1,4)..".wav", 140, math.random(95, 105), 1.0, CHAN_WEAPON)
end

function SWEP:PlayHitSound()
	self:EmitSound("garrysmod/balloon_pop_cute.wav", 140, math.random(95, 105), 1.0, CHAN_WEAPON)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("garrysmod/balloon_pop_cute.wav", 140, math.random(95, 105), 1.0, CHAN_WEAPON)
end