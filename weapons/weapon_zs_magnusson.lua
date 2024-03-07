AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")
SWEP.Base = "weapon_zs_base"

SWEP.PrintName = (translate.Get("wep_magnusson"))
SWEP.Description = (translate.Get("desc_magnusson"))
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "Python"
	SWEP.HUD3DPos = Vector(0.85, 0, -2.5)
	SWEP.HUD3DScale = 0.015

    SWEP.VElements = {
        ["element_name4"] = { type = "Model", model = "models/props_wasteland/controlroom_filecabinet002a.mdl", bone = "Python", rel = "", pos = Vector(-0.2, 0.068, 4.919), angle = Angle(180, 0, 0), size = Vector(0.037, 0.014, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/items/combinerifle_ammo", skin = 0, bodygroup = {} },
        ["5"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve180.mdl", bone = "Python", rel = "", pos = Vector(-0.005, 2.28, -0.796), angle = Angle(121.334, -90, -90), size = Vector(0.009, 0.013, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_room/combine_monitor001", skin = 0, bodygroup = {} },
        ["element_name2"] = { type = "Model", model = "models/Items/battery.mdl", bone = "Python", rel = "", pos = Vector(-0.232, -0.894, 1.271), angle = Angle(0, 180, 0), size = Vector(0.221, 0.3, 0.896), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name11"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "Python", rel = "", pos = Vector(0.001, -1.482, -0.157), angle = Angle(0, -90, 0), size = Vector(0.028, 0.072, 0.277), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
        ["element_name8"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "Cylinder", rel = "", pos = Vector(0, 0, -1.617), angle = Angle(0, 0, 0), size = Vector(0.023, 0.023, 0.057), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name9+++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "Bullet1", rel = "", pos = Vector(0.003, 0.707, -0.083), angle = Angle(0, 0, 0), size = Vector(0.075, 0.075, 0.059), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/props_lab/cornerunit_cloud", skin = 0, bodygroup = {} },
        ["element_name5"] = { type = "Model", model = "models/props_combine/combine_mortar01b.mdl", bone = "Python", rel = "", pos = Vector(0, -1.801, 7.367), angle = Angle(-180, 90, 0), size = Vector(0.009, 0.009, 0.18), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name3"] = { type = "Model", model = "models/Items/battery.mdl", bone = "Python", rel = "", pos = Vector(-0.24, 0.616, 1.226), angle = Angle(0, 180, 0), size = Vector(0.221, 0.3, 0.896), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["1"] = { type = "Model", model = "models/props_borealis/bluebarrel001.mdl", bone = "Python", rel = "", pos = Vector(0, -0.817, 1.49), angle = Angle(0, 0, -180), size = Vector(0.037, 0.032, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/shadertest/envball_1", skin = 0, bodygroup = {} },
        ["7+"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "Python", rel = "", pos = Vector(0, 0.155, -1.915), angle = Angle(61.886, 90, 0), size = Vector(0.33, 0.43, 0.368), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name13"] = { type = "Model", model = "", bone = "Python", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name5+"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "Python", rel = "", pos = Vector(0, 1.21, 0.589), angle = Angle(-180, 90, -180), size = Vector(0.016, 0.014, 0.061), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name9++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0.037, -1.446, -0.575), angle = Angle(0, 0, 0), size = Vector(0.075, 0.075, 0.009), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/props_combine/health_charger001", skin = 0, bodygroup = {} },
        ["element_name3+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "Python", rel = "", pos = Vector(0.136, 0.616, 1.218), angle = Angle(0, 0, 0), size = Vector(0.221, 0.3, 0.896), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["5+"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve180.mdl", bone = "Python", rel = "", pos = Vector(-0.394, 1.976, -0.611), angle = Angle(-180, -90, -90), size = Vector(0.023, 0.017, 0.012), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["4"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "Python", rel = "", pos = Vector(-0.331, 1.398, 0.19), angle = Angle(0, 94.28, 0), size = Vector(0.07, 0.046, 0.158), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/tpcontroller_sheet", skin = 0, bodygroup = {} },
        ["element_name4+"] = { type = "Model", model = "models/props_wasteland/controlroom_filecabinet002a.mdl", bone = "Python", rel = "", pos = Vector(-0.2, -0.278, 4.938), angle = Angle(180, 0, 0), size = Vector(0.037, 0.014, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/items/combinerifle_ammo", skin = 0, bodygroup = {} },
        ["3"] = { type = "Model", model = "models/props_junk/gascan001a.mdl", bone = "Python", rel = "", pos = Vector(0.002, 2.47, -3.478), angle = Angle(0, -0.635, -76.487), size = Vector(0.152, 0.143, 0.188), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_room/combine_monitor001", skin = 0, bodygroup = {} },
        ["element_name12+++"] = { type = "Model", model = "models/gibs/hgibs_spine.mdl", bone = "Python", rel = "", pos = Vector(0.238, -0.584, -3.971), angle = Angle(0, 0, -75.11), size = Vector(0.12, 0.12, 0.12), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/XQM/LightLinesRed_tool", skin = 0, bodygroup = {} },
        ["element_name12++"] = { type = "Model", model = "models/gibs/hgibs_spine.mdl", bone = "Python", rel = "", pos = Vector(-0.217, -0.584, -3.971), angle = Angle(0, 0, -75.11), size = Vector(0.12, 0.12, 0.12), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/XQM/LightLinesRed_tool", skin = 0, bodygroup = {} },
        ["element_name10"] = { type = "Model", model = "models/props_combine/combine_interface001a.mdl", bone = "Python", rel = "", pos = Vector(0, 0.421, -3.352), angle = Angle(-97.909, 90, 0), size = Vector(0.041, 0.041, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name2+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "Python", rel = "", pos = Vector(0.081, -0.894, 1.271), angle = Angle(0, 0, 0), size = Vector(0.221, 0.3, 0.896), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }

    SWEP.WElements = {
        ["element_name4"] = { type = "Model", model = "models/props_wasteland/controlroom_filecabinet002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.718, 0.528, -4.625), angle = Angle(0, -90, -95), size = Vector(0.02, 0.029, 0.134), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/items/combinerifle_ammo", skin = 0, bodygroup = {} },
        ["element_name999"] = { type = "Model", model = "models/props_c17/FurnitureShelf001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.664, 0.698, -5.203), angle = Angle(85.03, 0, 0), size = Vector(0.054, 0.025, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["element_name2"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.723, 0.968, -5.33), angle = Angle(0, -90, -95), size = Vector(0.221, 0.3, 0.865), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name8"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.314, 0.927, -3.57), angle = Angle(-96.542, 0, 0), size = Vector(0.025, 0.028, 0.068), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["7+"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.053, 0.999, -2.566), angle = Angle(55.95, -180, 0), size = Vector(0.33, 0.43, 0.368), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["3"] = { type = "Model", model = "models/props_junk/gascan001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.342, 0.961, -0.993), angle = Angle(0, -90, -153.118), size = Vector(0.259, 0.152, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_room/combine_monitor001", skin = 0, bodygroup = {} },
        ["element_name2+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.393, 0.573, -5.285), angle = Angle(0, 90, 95), size = Vector(0.221, 0.3, 0.896), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name5+"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.587, 1.101, -2.672), angle = Angle(86.475, 0, -180), size = Vector(0.016, 0.014, 0.061), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["element_name4+"] = { type = "Model", model = "models/props_wasteland/controlroom_filecabinet002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.718, 1.039, -4.625), angle = Angle(0, 90, 95), size = Vector(0.02, 0.029, 0.134), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/items/combinerifle_ammo", skin = 0, bodygroup = {} },
        ["element_name991+"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.982, 0.799, -5.896), angle = Angle(84.757, 0, 0), size = Vector(0.078, 0.078, 0.078), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["element_name991"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.192, 0.799, -3.902), angle = Angle(84.757, 0, 0), size = Vector(0.078, 0.078, 0.078), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["element_name2+++"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.723, 0.968, -3.49), angle = Angle(0, -90, -95), size = Vector(0.221, 0.3, 0.865), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["4"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.732, 0.865, -2.199), angle = Angle(87.717, 0, 0), size = Vector(0.07, 0.05, 0.158), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/tpcontroller_sheet", skin = 0, bodygroup = {} },
        ["element_name2++"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.393, 0.573, -3.442), angle = Angle(0, 90, 95), size = Vector(0.221, 0.3, 0.896), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }

    SWEP.ShowViewModel = false
    SWEP.ShowWorldModel = false
end


SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Delay = 0.6
SWEP.Primary.Damage = 52.9
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.TracerName = "AirboatGunTracer"
SWEP.RequiredClip = 2

SWEP.Tier = 2

SWEP.ResistanceBypass = 0.8

SWEP.ConeMax = 1.875
SWEP.ConeMin = 1

SWEP.IronSightsPos = Vector(-4.65, 4, 0.25)
SWEP.IronSightsAng = Vector(0, 0, 1)

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 1.5
SWEP.LegDamage = 1.5
SWEP.InnateLegDamage = true

SWEP.InnateBounty = true
SWEP.BountyDamage = 0.6

function SWEP.BulletCallback(attacker, tr, dmginfo)
    --[[
    local ent = tr.Entity
    if ent:IsValidLivingZombie() then
        ent:AddLegDamageExt(dmginfo:GetInflictor().LegDamage, attacker, attacker:GetActiveWeapon(), SLOWTYPE_PULSE)
    end
    ]]

    if IsFirstTimePredicted() then
        util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
    end
end

function SWEP:EmitFireSound()
    self:EmitSound("weapons/357/357_fire"..math.random(2,3)..".wav", 93, math.random(88, 93), 0.8)
    self:EmitSound("weapons/tau/single0"..math.random(1,3)..".ogg", 75, math.random(90, 120), 0.7, CHAN_WEAPON + 20)
end

function SWEP:EmitReloadSound()
    if IsFirstTimePredicted() then
        self:EmitSound("weapons/physcannon/physcannon_charge.wav", 70, 95, 0.65, CHAN_WEAPON + 21)
        timer.Simple(1.45, function()
            self:EmitSound("items/battery_pickup.wav", 70, 57, 0.85, CHAN_WEAPON + 22)
        end)
    end
end