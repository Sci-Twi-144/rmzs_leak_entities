AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"
DEFINE_BASECLASS("weapon_zs_baseshotgun")

SWEP.PrintName = (translate.Get("wep_fracture"))
SWEP.Description = (translate.Get("desc_fracture"))

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-1, -4, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

SWEP.VElements = {
	["element_name4"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "v_weapon.M3_PUMP", rel = "", pos = Vector(-0.014, 0.275, -0.227), angle = Angle(-90, -90, 0), size = Vector(0.057, 0.034, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name1"] = { type = "Model", model = "models/weapons/w_shot_xm1014.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(0.175, 2.605, -8.36), angle = Angle(-90, 90, 0), size = Vector(0.915, 0.718, 1.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/mask", skin = 0, bodygroup = {} },
	["element_name2+++"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(8.067, -0.16, 5.057), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name2"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(8.067, 1.246, 6.534), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name7"] = { type = "Model", model = "models/shells/shell_12gauge.mdl", bone = "v_weapon.M3_SHELL", rel = "", pos = Vector(0, -0.08, -0.116), angle = Angle(-90, 0, 0), size = Vector(1.141, 1.6, 1.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["element_name3+"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(12.493, -1.675, 6.486), angle = Angle(0, -90, -90), size = Vector(0.5, 0.5, 0.347), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/arm", skin = 0, bodygroup = {} },
	["element_name2+"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(8.067, -0.16, 7.818), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name3+++"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(11.958, 1.429, 6.69), angle = Angle(-180, -90, -90), size = Vector(0.5, 0.5, 0.347), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/arm", skin = 0, bodygroup = {} },
	["element_name5"] = { type = "Model", model = "models/props_c17/trappropeller_engine.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(3.339, 0.05, 7.83), angle = Angle(-90, -180, 0), size = Vector(0.061, 0.065, 0.214), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name2++++"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(8.067, -1.481, 6.534), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name6"] = { type = "Model", model = "models/props_phx/construct/metal_tube.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(-2.918, -0.073, 5.25), angle = Angle(0, 0, 0), size = Vector(0.061, 0.016, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name3++"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(11.958, -0.205, 8.027), angle = Angle(-90, -90, -90), size = Vector(0.5, 0.5, 0.347), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/arm", skin = 0, bodygroup = {} },
	["element_name3"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(11.925, -0.084, 4.901), angle = Angle(90, -90, -90), size = Vector(0.5, 0.5, 0.347), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/arm", skin = 0, bodygroup = {} },
	["element_name2++"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "v_weapon.M3_PARENT", rel = "element_name1", pos = Vector(8.067, -0.16, 6.448), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["element_name4"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.149, 1.014, -3.625), angle = Angle(-8.841, 0, -2.697), size = Vector(0.057, 0.034, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name1"] = { type = "Model", model = "models/weapons/w_shot_xm1014.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.409, 0.964, 2.088), angle = Angle(-7.788, 0, -180), size = Vector(0.915, 0.718, 1.026), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/mask", skin = 0, bodygroup = {} },
	["element_name2"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(8.067, 1.246, 6.534), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name3+++"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(11.958, 1.429, 6.69), angle = Angle(-180, -90, -90), size = Vector(0.5, 0.5, 0.347), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/arm", skin = 0, bodygroup = {} },
	["element_name3+"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(12.493, -1.675, 6.486), angle = Angle(0, -90, -90), size = Vector(0.5, 0.5, 0.347), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/arm", skin = 0, bodygroup = {} },
	["element_name2+"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(8.067, -0.16, 7.818), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name2+++"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(8.067, -0.16, 5.057), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name5"] = { type = "Model", model = "models/props_c17/trappropeller_engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(3.339, 0.05, 7.83), angle = Angle(-90, -180, 0), size = Vector(0.061, 0.065, 0.214), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name2++++"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(8.067, -1.481, 6.534), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name6"] = { type = "Model", model = "models/props_phx/construct/metal_tube.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-2.918, -0.073, 5.243), angle = Angle(0, 0, 0), size = Vector(0.061, 0.016, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["element_name3++"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(11.958, -0.205, 8.027), angle = Angle(-90, -90, -90), size = Vector(0.5, 0.5, 0.347), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/arm", skin = 0, bodygroup = {} },
	["element_name3"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(11.925, -0.084, 4.901), angle = Angle(90, -90, -90), size = Vector(0.5, 0.5, 0.347), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_advisor/arm", skin = 0, bodygroup = {} },
	["element_name2++"] = { type = "Model", model = "models/props_phx/wheels/drugster_back.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(8.067, -0.16, 6.448), angle = Angle(-90, 0, 0), size = Vector(0.032, 0.032, 0.202), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} }
}
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.UseHands = true

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.ReloadDelay = 0.5

SWEP.Primary.Sound = ")weapons/m3/m3-1.wav"
SWEP.Primary.Damage = 14.75
SWEP.Primary.NumShots = 7
SWEP.Primary.Delay = 0.9

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 7.55
SWEP.ConeMin = 5.25

SWEP.FireAnimSpeed = 1
SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_SHOT_COUNT, 1, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.05, 1)

function SWEP:PrimaryAttack()
	self.AttackContext = true
	BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	self.AttackContext = nil
	BaseClass.PrimaryAttack(self)
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/m3/m3-1.wav", 75, math.random(134, 136), 0.7)
	self:EmitSound("weapons/xm1014/xm1014-1.wav", 75, math.random(172, 180), 0.5, CHAN_WEAPON + 20)
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local sprd = (self.AttackContext and 2 or 2.75)*cone/6
	local recp = self.AttackContext and 2 or 1.25
	self.SpreadPattern = {}
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	for i = 1, numbul do
		local delta = 10/(numbul-1)
		local curpos = -5 - delta + delta * i
		self.SpreadPattern[i] = self.AttackContext and {curpos, 0} or {0, curpos}
	end
	owner:LagCompensation(true)
		owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, self.Pierces, self.DamageTaper, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)
end
