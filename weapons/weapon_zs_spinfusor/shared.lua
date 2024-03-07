SWEP.PrintName = (translate.Get("wep_spinfusor"))
SWEP.Description = (translate.Get("desc_spinfusor"))

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
--[[
sound.Add(
{
	name = "Weapon_Slayer.Single",
	channel = CHAN_AUTO,
	volume = 1,
	soundlevel = 100,
	pitch = {125, 135},
	sound = {"weapons/physcannon/superphys_launch2.wav", "weapons/physcannon/superphys_launch3.wav"}
})
]]
SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Damage = 122
SWEP.Primary.Delay = 1.2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
--SWEP.Primary.Sound = Sound("Weapon_Slayer.Single")

function SWEP:EmitFireSound()
	self:EmitSound("weapons/physcannon/superphys_launch"..math.random(2,3)..".wav", 100, math.random(125, 135), 1.0, CHAN_WEAPON)
end

SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 30
SWEP.RequiredClip = 7

SWEP.ReloadSpeed = 0.9

SWEP.Recoil = 3

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.IsAoe = true

SWEP.FireAnimSpeed = 0.65

SWEP.Primary.ProjExplosionTaper = 0.85
SWEP.Primary.ProjExplosionRadius = 95

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.08, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_spinfusor")), (translate.Get("desc_spinfusor")), function(wept)
	wept.VElements = {
	    ["base+++"] = { type = "Model", model = "models/props_lab/eyescanner.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(-0, -1.854, 0.455), angle = Angle(-24.781, 90, 180), size = Vector(0.307, 0.476, 0.423), color = Color(153,153,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base+++++"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(-0, 1.748, -1.219), angle = Angle(-9.438, 90, -0), size = Vector(0.316, 0.428, 0.321), color = Color(102,102,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(-3.401, -0.851, 6.88), angle = Angle(0, -90, 0), size = Vector(0.174, 0.174, 0.174), color = Color(204,204,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base++++"] = { type = "Model", model = "models/props_combine/combinecrane002.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(0.391, -2.362, 14.17), angle = Angle(-180, 0, 0), size = Vector(0.032, 0.029, 0.067), color = Color(153,153,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base+"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(3.4, -0.851, 6.88), angle = Angle(0, -90, 0), size = Vector(0.174, 0.174, 0.174), color = Color(204,204,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base++"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.bolt", rel = "", pos = Vector(0, -0.468, 1.162), angle = Angle(0, 0, 90), size = Vector(0.054, 0.054, 0.014), color = Color(102,102,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	 
	wept.WElements = {
	    ["base+++++"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.879, 1.001, -0.686), angle = Angle(-100.002, 7.423, 0), size = Vector(0.316, 0.428, 0.321), color = Color(102,102,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base++"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.13, -0.075, -5.329), angle = Angle(0, 0, 0), size = Vector(0.054, 0.054, 0.014), color = Color(102,102,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base+"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.503, 3.358, -4.2), angle = Angle(90, -170, 0), size = Vector(0.174, 0.174, 0.174), color = Color(153,153,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base++++"] = { type = "Model", model = "models/props_combine/combinecrane002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(22.2, -1.374, -5.395), angle = Angle(180, -79.429, 90), size = Vector(0.032, 0.029, 0.067), color = Color(153,153,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base+++"] = { type = "Model", model = "models/props_lab/eyescanner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.237, 0.861, -5.441), angle = Angle(-57.536, -171.206, 0), size = Vector(0.307, 0.476, 0.423), color = Color(153,153,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	    ["base"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.208, -3.931, -4.16), angle = Angle(90, -170, 0), size = Vector(0.174, 0.174, 0.174), color = Color(204,204,0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	if SERVER then
		wept.Primary.Projectile = "projectile_disc_fire"
		wept.Primary.ProjVelocity = 1750
	end
	
	wept.Primary.Damage = wept.Primary.Damage * 0.6
	wept.Primary.Ammo = "impactmine"
	wept.Primary.DefaultClip = 2
	wept.Primary.ClipSize = 2
	wept.RequiredClip = 2
end)

local br2 = GAMEMODE:AddNewRemantleBranch(SWEP, 2, "Wunderwaffe DG-2", "POWAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "weapon_zs_wunderwaffe")
br2.Colors = {Color(130, 130, 240), Color(65, 65, 120), Color(39, 39, 90)}

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/ar2/ar2_reload.wav", 75, 100, 1, CHAN_WEAPON + 21)
		self:EmitSound("weapons/smg1/smg1_reload.wav", 75, 100, 1, CHAN_WEAPON + 22)
	end
end

util.PrecacheSound("weapons/ar2/ar2_reload.wav")
util.PrecacheSound("weapons/smg1/smg1_reload.wav")