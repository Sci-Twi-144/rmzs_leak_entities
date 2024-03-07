
SWEP.PrintName = "'Iceberg' Метатель льда"
SWEP.Description = "Временное оружие, стреляет кусками льда"

if CLIENT then
	SWEP.Slot = 3

	SWEP.HUD3DPos = Vector(4, 0, 15)
	SWEP.HUD3DAng = Angle(0, 180, 180)
	SWEP.HUD3DScale = 0.04
	SWEP.HUD3DBone = "base"

	SWEP.VElements = {
		["xmas_light1++++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(2.032, 4.37, 28.048), angle = Angle(10.519, -135, 90), size = Vector(0.885, 0.885, 0.885), color = Color(0, 255, 63, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1+++++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(3.072, 3.51, 28.048), angle = Angle(10.519, -135, 90), size = Vector(0.885, 0.885, 0.885), color = Color(0, 255, 63, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1++++++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(-2.245, 5.493, 28.048), angle = Angle(10.519, -180, 90), size = Vector(0.885, 0.885, 0.885), color = Color(225, 0, 0, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(4.223, -0.806, 28.048), angle = Angle(10.519, -90, 90), size = Vector(0.885, 0.885, 0.885), color = Color(225, 0, 0, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1+++++++++++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(-6.207, -3.083, 28.048), angle = Angle(10.519, 45, 90), size = Vector(0.885, 0.885, 0.885), color = Color(0, 255, 63, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1++++++++++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(-5.164, -4.113, 28.048), angle = Angle(10.519, 45, 90), size = Vector(0.885, 0.885, 0.885), color = Color(0, 255, 63, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1+++++++++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(-2.191, -5.395, 28.048), angle = Angle(10.519, 0, 90), size = Vector(0.885, 0.885, 0.885), color = Color(225, 0, 0, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1+++++++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(-0.9, 5.493, 28.048), angle = Angle(10.519, -180, 90), size = Vector(0.885, 0.885, 0.885), color = Color(225, 0, 0, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1+"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(3.263, -3.524, 28.048), angle = Angle(10.519, -45, 90), size = Vector(0.885, 0.885, 0.885), color = Color(0, 255, 63, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1+++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(4.223, 0.765, 28.048), angle = Angle(10.519, -90, 90), size = Vector(0.885, 0.885, 0.885), color = Color(225, 0, 0, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(2.368, -4.437, 28.048), angle = Angle(10.519, -45, 90), size = Vector(0.885, 0.885, 0.885), color = Color(0, 255, 63, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		["xmas_light1++++++++"] = { type = "Model", model = "models/weapons/w_eq_fraggrenade_thrown.mdl", bone = "base", rel = "", pos = Vector(-0.824, -5.395, 28.048), angle = Angle(10.519, 0, 90), size = Vector(0.885, 0.885, 0.885), color = Color(225, 0, 0, 255), surpresslightning = false, material = "model_color", skin = 0, bodygroup = {} },
		//////
		["light2++++"] = { type = "Model", model = "models/weapons/w_eq_xmaslight.mdl", bone = "base", rel = "", pos = Vector(-0.779, -3.957, 21.785), angle = Angle(-62.943, 127.5, 4.252), size = Vector(0.708, 0.708, 0.708), color = Color(255, 255, 255, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {[2] = 1} },
		["light2"] = { type = "Model", model = "models/weapons/w_eq_xmaslight.mdl", bone = "base", rel = "", pos = Vector(3.119, -0.533, 18.031), angle = Angle(-47.814, 41.873, 23.7), size = Vector(0.708, 0.708, 0.708), color = Color(255, 255, 255, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {[2] = 1} },
		["light2+"] = { type = "Model", model = "models/weapons/w_eq_xmaslight.mdl", bone = "base", rel = "", pos = Vector(3.786, -0.761, 7.306), angle = Angle(-66.033, -8.796, 4.252), size = Vector(0.708, 0.708, 0.708), color = Color(255, 255, 255, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {[2] = 1} },
		["light2++"] = { type = "Model", model = "models/weapons/w_eq_xmaslight.mdl", bone = "base", rel = "", pos = Vector(2.026, -2.023, 13.864), angle = Angle(-66.033, 52.37, 4.252), size = Vector(0.708, 0.708, 0.708), color = Color(255, 255, 255, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {[2] = 1} },
		["light2+++++"] = { type = "Model", model = "models/weapons/w_eq_xmaslight.mdl", bone = "base", rel = "", pos = Vector(-0.029, -3.444, 10.821), angle = Angle(-111.04, 83.111, 12.857), size = Vector(0.708, 0.708, 0.708), color = Color(255, 255, 255, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {[2] = 1} },
		["light2+++"] = { type = "Model", model = "models/weapons/w_eq_xmaslight.mdl", bone = "base", rel = "", pos = Vector(1.597, -3.135, 21.785), angle = Angle(-62.943, 88.615, 4.252), size = Vector(0.708, 0.708, 0.708), color = Color(255, 255, 255, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {[2] = 1} }
	}
end

SWEP.Base = "weapon_zs_baseproj"

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.HoldType = "rpg"

SWEP.SoundFireVolume = 0.65
SWEP.SoundPitchMin = 150
SWEP.SoundPitchMax = 200
SWEP.Primary.Sound = ")weapons/grenade_launcher1.wav"

SWEP.Primary.Delay = 0.7
SWEP.Primary.Damage = 39
SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "gravity"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Projectile = "projectile_eice"
SWEP.Primary.ProjVelocity = 650

SWEP.Colors = {Color(95, 228, 255), Color(50, 221, 255), Color(0, 213, 255)}