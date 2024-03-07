AddCSLuaFile()

SWEP.PrintName = "Снежок"--(translate.Get("wep_stone"))
SWEP.Description = ""--(translate.Get("desc_stone"))

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false

	SWEP.ViewModelBoneMods = {
		["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(3.3, 3, 0.15), angle = Angle(0, 0, 0) },
		["ValveBiped.cube"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-1, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 6.8, -20) }
	}
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/projectile/snowball_proj.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.6, 2.8, 0.15), angle = Angle(-54.206, 58.294, -50.114), size = Vector(0.99, 0.99, 0.99), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/projectile/snowball_proj.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.181, 2.273, -0.456), angle = Angle(-43.978, 27.614, 70.568), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basethrown"

SWEP.ViewModel = "models/weapons/rmzs/c_snowball.mdl"
SWEP.WorldModel = "models/projectile/snowball_proj.mdl"

SWEP.Primary.Ammo = "snowballs"
SWEP.GrenadeDamage= 65

SWEP.ThrownProjectile = "projectile_snowball"
SWEP.ThrowAngVel = 360
SWEP.ThrowVel = 900

function SWEP:Holster()
    if CLIENT then
        self:Anim_Holster()
    end
   
    return true
end