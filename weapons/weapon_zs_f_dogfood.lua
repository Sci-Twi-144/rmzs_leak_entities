AddCSLuaFile()

SWEP.Base = "weapon_zs_basefood"

SWEP.PrintName = "Dog Food"

if CLIENT then
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/garbage_metalcan001a.mdl", bone = "ValveBiped.Grenade_Body", rel = "", pos = Vector(-0.5, 0, -0.5), angle = Angle(0, 0, 90), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["chunk"] = { type = "Model", model = "models/props_debris/concrete_chunk05g.mdl", bone = "ValveBiped.Pin", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/garbage_metalcan001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2.5, 0), angle = Angle(180, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.ViewModel = "models/weapons/foods/c_gren_canned.mdl"
SWEP.WorldModel = "models/props_junk/garbage_metalcan001a.mdl"

SWEP.Primary.Ammo = "fooddogfood"

SWEP.FoodHealth = 7
SWEP.FoodEatTime = 3
SWEP.Rarity = "rare"
SWEP.FoodType = "canned"

if SERVER then -- рофлинки
	function SWEP:BuffMe()
		local owner = self:GetOwner()
		if owner:GetModel() == "models/player/yukipm/yukipm.mdl" then
			self.FoodHealth = self.FoodHealth * 6
			owner:ApplyHumanBuff("auf", 6 * (owner.BuffDuration or 1), {Applier = owner, Stacks = 1, Max = 3}, true, false)
		end
	end
end