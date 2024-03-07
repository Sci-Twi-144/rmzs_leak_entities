AddCSLuaFile()

SWEP.Base = "weapon_zs_basefood"

SWEP.PrintName = "Soda"

if CLIENT then
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 59, 0) },
	}

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Grenade_Body", rel = "", pos = Vector(-0.5, 0, -0.5), angle = Angle(0, 0, 90), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.ViewModel = "models/weapons/foods/c_gren_drink.mdl"
SWEP.WorldModel = "models/props_junk/popcan01a.mdl"

SWEP.Primary.Ammo = "foodsoda"

SWEP.FoodHealth = 5
SWEP.FoodEatTime = 2
SWEP.FoodIsLiquid = true
SWEP.Rarity = "common"
SWEP.FoodType = "drink"
