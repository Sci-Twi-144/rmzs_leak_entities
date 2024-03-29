AddCSLuaFile()

SWEP.Base = "weapon_zs_basefood"

SWEP.PrintName = "Watermelon"

if CLIENT then
	SWEP.ViewModelFOV = 60

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/watermelon01_chunk02a.mdl",bone = "ValveBiped.Grenade_Body", rel = "", pos = Vector(1, -2, -2), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/watermelon01_chunk02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1, -3), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.ViewModel = "models/weapons/foods/c_gren_fruit.mdl"
SWEP.WorldModel = "models/props_junk/watermelon01_chunk02a.mdl"

SWEP.Primary.Ammo = "foodwatermelon"

SWEP.FoodHealth = 14
SWEP.FoodEatTime = 4
SWEP.Rarity = "rare"
SWEP.FoodType = "fruit"
