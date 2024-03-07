AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.Base = "weapon_zs_base"

SWEP.PrintName = "'Caballeron' Pulse Carbine"
SWEP.Description = "Импульсный карабин, собраный из того что было."

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.IronSightsPos = Vector(-8.8, 10, 4.32)
	SWEP.IronSightsAng = Vector(1.4, 0.1, 5)
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(2.4, 0, -8)
	SWEP.HUD3DScale = 0.025
	
	SWEP.VElements = {
	["ruchk"] = { type = "Model", model = "models/props_junk/MetalBucket01a.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, 0.234, 12.118), angle = Angle(179.141, 90, 0), size = Vector(0.31, 0.199, 1.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_tower01a", skin = 0, bodygroup = {} },
	["main+"] = { type = "Model", model = "models/Combine_Helicopter/helicopter_bomb01.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, 0.456, -4.319), angle = Angle(0, 90, 0), size = Vector(0.187, 0.126, 0.764), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper001", skin = 0, bodygroup = {} },
	["dul"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, -0.706, 16.368), angle = Angle(0, 0, 0), size = Vector(0.028, 0.028, 0.261), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_tower01a", skin = 0, bodygroup = {} },
	["sigh"] = { type = "Model", model = "models/props_c17/gravestone004a.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, -2.566, 22.94), angle = Angle(0, 0, -90), size = Vector(0.037, 0.076, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/tpcontroller_disp", skin = 0, bodygroup = {} },
	["main"] = { type = "Model", model = "models/props_c17/FurnitureFridge001a.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, 2.158, -10.664), angle = Angle(0, 90, 0), size = Vector(0.172, 0.082, 0.372), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper001", skin = 0, bodygroup = {} }
	}
	SWEP.ViewModelBoneMods = {
	["ValveBiped.Gun"] = { scale = Vector(0.698, 0.698, 0.698), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Pump"] = { scale = Vector(0.09, 0.09, 0.09), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	SWEP.WElements = {
	["ruchk"] = { type = "Model", model = "models/props_junk/MetalBucket01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(23.278, 0.99, -6.189), angle = Angle(81.612, 0.949, -0), size = Vector(0.259, 0.163, 0.972), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_tower01a", skin = 0, bodygroup = {} },
	["main+"] = { type = "Model", model = "models/Combine_Helicopter/helicopter_bomb01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.559, 1.121, -4.9), angle = Angle(82.546, 1.105, 0), size = Vector(0.157, 0.093, 0.614), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper001", skin = 0, bodygroup = {} },
	["dul"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(28.947, 0.921, -7.494), angle = Angle(-97.569, 0.958, 0.165), size = Vector(0.017, 0.017, 0.089), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combine_tower01a", skin = 0, bodygroup = {} },
	["sigh"] = { type = "Model", model = "models/props_c17/gravestone004a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(28.284, 0.93, -9.188), angle = Angle(-180, -88.877, 7.407), size = Vector(0.037, 0.061, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/tpcontroller_disp", skin = 0, bodygroup = {} },
	["main"] = { type = "Model", model = "models/props_c17/FurnitureFridge001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.338, 1.177, -3.264), angle = Angle(-96.823, -2.879, -3.764), size = Vector(0.131, 0.097, 0.397), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/combinethumper001", skin = 0, bodygroup = {} }
	}
end

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = ""
SWEP.Primary.Damage = 94.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.55

SWEP.RequiredClip = 3

SWEP.ReloadSpeed = 0.3

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 30

SWEP.ConeMax = 4
SWEP.ConeMin = 0.25

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 2.5
SWEP.LegDamage = 2.5
SWEP.InnateLegDamage = true

SWEP.ReloadSound = Sound("npc/scanner/scanner_siren1.wav")

SWEP.WalkSpeed = SPEED_SLOW

SWEP.TracerName = "AR2Tracer"

SWEP.Tier = 5

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.06)

function SWEP:EmitFireSound()
	self:EmitSound("weapons/gauss/fire1.wav", 45, math.random(100, 125), 1, CHAN_WEAPON + 20)
	self:EmitSound("weapons/shotgun/shotgun_fire"..math.random(6,7)..".wav", 100, math.random(75, 85), 1, CHAN_WEAPON)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	self.BaseClass.Think(self)
end

if not CLIENT then return end

local ghostlerp = 0
function SWEP:CalcViewModelViewExtra(vm, oldpos, oldang, pos, ang)
	if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 2)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 2.5)
	end

	if ghostlerp > 0 then
		ang:RotateAroundAxis(ang:Right(), -10 * ghostlerp)
	end

	return pos, ang
end
