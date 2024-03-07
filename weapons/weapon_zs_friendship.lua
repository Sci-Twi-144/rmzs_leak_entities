AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_friendship")) -- 'Friendship' Machine Shotgun
SWEP.Description = (translate.Get("desc_friendship")) -- Мощный пулеметный дробовик

SWEP.Slot = 3
SWEP.SlotPos = 0

-- Ивент оружие, аналог абзаца из метро 2033, но более скорострельный и вместительный, был найден в одной мертвой сборке оружек
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.m249"
	SWEP.HUD3DPos = Vector(1.4, -1.3, 5)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015
	SWEP.VElements = {
	["4"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.bullet8", rel = "", pos = Vector(-0.08, 0, -0.325), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.bullet2", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/xqm/cylinderx1.mdl", bone = "v_weapon.m249", rel = "", pos = Vector(0.129, -1.517, 20.549), angle = Angle(90, 0, 0), size = Vector(1.6, 0.2, 0.2), color = Color(40, 40, 40, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["5"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.bullet7", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["2"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.bullet10", rel = "", pos = Vector(0, 0, -0.412), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["6"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.bullet6", rel = "", pos = Vector(0, 0, 0.239), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["7"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.bullet4", rel = "", pos = Vector(0.319, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
	["1"] = { type = "Model", model = "models/xqm/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(23.333, 1.001, -8.931), angle = Angle(-10.928, 0, 0), size = Vector(1.69, 0.25, 0.25), color = Color(40, 40, 40, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/xm1014/xm1014-1.wav"
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 32
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.DefaultClip = 96

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.Recoil = 3

SWEP.ConeMax = 6
SWEP.ConeMin = 4.75

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 6
-- SWEP.MaxStock = 2

SWEP.ResistanceBypass = 0.6

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)

SWEP.SpreadPattern = {
    {0, 0},
    {-5, 0},
    {-4, 3},
    {0, 5},
    {4, 3},
    {5, 0},
    {4, -3},
    {0, -5},
    {-4, -3},
}

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)