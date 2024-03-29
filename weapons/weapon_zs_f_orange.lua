AddCSLuaFile()

SWEP.Base = "weapon_zs_basefood"

SWEP.PrintName = "Orange"

if CLIENT then
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props/cs_italy/orange.mdl", bone = "ValveBiped.Grenade_Body", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 90), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props/cs_italy/orange.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2.5, -1), angle = Angle(0, 0, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.ViewModel = "models/weapons/foods/c_gren_fruit.mdl"
SWEP.WorldModel = "models/props/cs_italy/orange.mdl"

SWEP.Primary.Ammo = "foodorange"

SWEP.FoodHealth = 11
SWEP.FoodEatTime = 2.75
SWEP.Rarity = "uncommon"
SWEP.FoodType = "fruit"