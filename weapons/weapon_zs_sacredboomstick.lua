AddCSLuaFile()

SWEP.PrintName = "Sacred Boom Stick"
	
if CLIENT then
	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.65, 0, -8)
	SWEP.HUD3DScale = 0.025
	SWEP.ViewModelFlip = false

	SWEP.VElements = {
		["rave"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "pump", pos = Vector(0.335, -1.749, -0.396), angle = Angle(0, 90, -180), size = Vector(0.071, 0.071, 0.071), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["backarmsup"] = { type = "Model", model = "models/props_trainstation/train003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "mtoor", pos = Vector(-1.063, 0.177, -14.931), angle = Angle(0, -90, -90), size = Vector(0.013, 0.028, 0.024), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} },
		["clamp"] = { type = "Model", model = "models/props_wasteland/panel_leverHandle001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "mtoor", pos = Vector(-2.471, -3.148, -7.875), angle = Angle(0, 0, 90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe_underbarrel"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "mtoor", pos = Vector(-2.245, 0.048, 5.306), angle = Angle(0, 0, 0), size = Vector(0.864, 0.864, 0.864), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shell_barrel"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 0.032, -0.879), angle = Angle(0, 0, 0), size = Vector(0.032, 0.032, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cabn"] = { type = "Model", model = "models/props_junk/garbage_metalcan002a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "mtoor", pos = Vector(0, 0, 17.752), angle = Angle(0, 0, 0), size = Vector(0.515, 0.515, 1.322), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["rebar"] = { type = "Model", model = "models/props_junk/iBeam01a_cluster01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "mtoor", pos = Vector(1.509, 0.312, -6.132), angle = Angle(-90, -67.975, 0), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pump"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Pump", rel = "", pos = Vector(0, 0.716, 3.101), angle = Angle(-90, 0, 90), size = Vector(0.111, 0.082, 0.086), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["underbarrel_exten"] = { type = "Model", model = "models/props_wasteland/laundry_basket002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "pipe_underbarrel", pos = Vector(0.305, 0.165, 13.751), angle = Angle(0, 0, 0), size = Vector(0.041, 0.041, 0.112), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["mtoor"] = { type = "Model", model = "models/props_c17/trappropeller_engine.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-0.112, -0.468, 0), angle = Angle(0, 90, 0), size = Vector(0.167, 0.086, 1.004), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["rave"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pump", pos = Vector(-0.523, -1.509, -0.172), angle = Angle(0, 90, -180), size = Vector(0.057, 0.057, 0.057), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["backarmsup"] = { type = "Model", model = "models/props_trainstation/train003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "mtoor", pos = Vector(-1.063, 0.177, -12.879), angle = Angle(0, -90, -90), size = Vector(0.017, 0.024, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} },
		["pipe_underbarrel"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "mtoor", pos = Vector(-2.245, 0.048, 2.309), angle = Angle(0, 0, 0), size = Vector(0.864, 0.864, 0.681), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handleTV"] = { type = "Model", model = "models/props_c17/tv_monitor01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(3.187, -0.527, -3.654), angle = Angle(-68.609, -0.049, -88.161), size = Vector(0.46, 0.131, 0.108), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["clamp"] = { type = "Model", model = "models/props_wasteland/panel_leverHandle001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "backarmsup", pos = Vector(0.12, 0.177, 0.128), angle = Angle(-82.67, 179.585, -0.991), size = Vector(0.5, 1.601, 0.149), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handleTRIGGERHOOK"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handleCAR", pos = Vector(-0.927, 0.273, 0.142), angle = Angle(0, 90, -103.948), size = Vector(0.101, 0.101, 0.101), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handleCAR"] = { type = "Model", model = "models/props_vehicles/car001a_phy.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "handle", pos = Vector(-1.547, 0.078, -1.747), angle = Angle(0, 2.813, -180), size = Vector(0.067, 0.03, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cabn"] = { type = "Model", model = "models/props_junk/garbage_metalcan002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "mtoor", pos = Vector(0, 0, 10.303), angle = Angle(0, 0, 0), size = Vector(0.512, 0.512, 0.624), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pump"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.711, 0.699, -5.027), angle = Angle(5.711, -176.28, -3.011), size = Vector(0.111, 0.059, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["underbarrel_exten"] = { type = "Model", model = "models/props_wasteland/laundry_basket002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pipe_underbarrel", pos = Vector(0.305, 0, 7.185), angle = Angle(0, 0, 0), size = Vector(0.041, 0.041, 0.112), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["handle"] = { type = "Model", model = "models/weapons/w_pistol.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.679, 1.649, -4.036), angle = Angle(6.653, -176.392, -165.286), size = Vector(1.358, 1.358, 1.358), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["clamp+"] = { type = "Model", model = "models/props_wasteland/panel_leverHandle001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "mtoor", pos = Vector(-2.007, -1.683, -8.391), angle = Angle(0, 0, 90), size = Vector(0.374, 0.374, 0.374), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["rebar"] = { type = "Model", model = "models/props_junk/iBeam01a_cluster01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "mtoor", pos = Vector(1.299, 0.174, -3.419), angle = Angle(-90, -90, 0), size = Vector(0.043, 0.043, 0.043), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["mtoor"] = { type = "Model", model = "models/props_c17/trappropeller_engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.054, 0.999, -6.582), angle = Angle(-99.351, 50.259, 48.164), size = Vector(0.167, 0.086, 0.577), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_boomstick"
SWEP.Primary.Damage = 33
SWEP.Primary.Ammo = "buckshot"

SWEP.ReloadSpeed = 1.5

SWEP.Knockback = 110

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Weight = 7
SWEP.Tier = 6

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then
		if SERVER then
			ent:AddBurnDamage(53, attacker or dmginfo:GetInflictor(), attacker.BurnTickRate or 1)
		end
	end
end
