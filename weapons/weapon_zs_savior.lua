AddCSLuaFile()
local BaseClass = baseclass.Get("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_savior"))
SWEP.Description = (translate.Get("desc_savior"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelFOV = 70
	
	SWEP.HUD3DPos = Vector(1, -2.5, -0.20)
	SWEP.HUD3DAng = Angle(180, 0, -20)
	SWEP.HUD3DBone = "v_weapon.223_parent"

	SWEP.VMAng = Angle(0,0,0)
	SWEP.VMPos = Vector(0,0,0)

	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_fo4/c_deliverer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-12.6, 4.1, -3.85), angle = Angle(-4.5, 0, 175), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[2] = 1} }
	}

	SWEP.VElements = {}
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-10, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.75, 0.75, 0.75), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.75, 0.75, 0.75), pos = Vector(-0.0, -0.05, 0.2), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.95, 0.95, 0.95), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.95, 0.95, 0.95), pos = Vector(0.25, 0, 0), angle = Angle(0, 0, 0) }
	}
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "IRON"
		else
			return "DODGE"
		end
	end
	
	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Ironsights"
		else
			return "Dodge"
		end
	end
end

SWEP.ViewModel = "models/weapons/tfa_fo4/c_deliverer.mdl"
SWEP.WorldModel = "models/weapons/tfa_fo4/w_deliverer.mdl"

SWEP.Base = "weapon_zs_base"
SWEP.UseHands = true

SWEP.HoldType = "pistol"
SWEP.LoweredHoldType = "normal"

SWEP.Primary.Sound = Sound("weapons/tfa_fo4/10mm/WPN_Pistol10mm_Fire_2D_Silenced.ogg")
--SWEP.Primary.SilencedSound = Sound("TFA_FO4_DELIVERER.1")
SWEP.Primary.Damage = 27.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.16

SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Ammo = "pistol"
SWEP.BulletType = SWEP.Primary.Ammo

SWEP.ConeMax = 2.25
SWEP.ConeMin = 1.15

SWEP.IronsightsMultiplier = 0.85
SWEP.IronSightsPos = Vector(-2.84, -3, 1.58)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Tier = 3

SWEP.DoExtraDamageFromBehind = true

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.Speed = 450
SWEP.SlowDownThreshold = 0.15
SWEP.CanDodgeForward = true
function SWEP:SecondaryAttack()     
    if self:GetNextSecondaryFire() >= CurTime() then return end      
    self:SetNextSecondaryFire(CurTime() + 1)
	if self.IsDodge then
		self:Dodge()
	end
end 

function SWEP:CallWeaponFunction()
	if self:GetFireMode() == 1 then
		self.IsDodge = true
	elseif self:GetFireMode() == 0 then
		self.IsDodge = false
	end
end

function SWEP:GetAuraRange()
	return 128
end

--[[
-- Don't remove this or animation fucked up!
SWEP.MoveHandDown = 0
SWEP.MoveHandUp = 0
SWEP.ReloadTimerAnim = 0
SWEP.ReadyHandLeftDown = 0
function SWEP:Deploy()
	BaseClass.Deploy(self)

	self.NextDeploy = CurTime() + 1

	self.MoveHandDown = 0
	self.MoveHandUp = 0

	self.ViewModelBoneMods = {
		["v_weapon.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.186, -0.556), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0.185, -0.556, -0.556), angle = Angle(0, 0, 0) },
		["v_weapon.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	return true
end
-- i think need ACT_VM_FIDGET here
function SWEP:Think()
	BaseClass.Think(self)
	local owner = self:GetOwner()

	if (self:GetReloadFinish() == 0) and not (owner:Crouching() or self:GetIronsights()) then
		self.MoveHandUp = math.max(-10, self.MoveHandUp - 0.2)
		self.ViewModelBoneMods = {
			["v_weapon.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.186, -0.556), angle = Angle(0, 0, 0) },
			["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0.185, -0.556, -0.556), angle = Angle(0, 0, 0) },
			["v_weapon.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, self.MoveHandUp), angle = Angle(0, 0, 0) }
		}
	else
		self.MoveHandUp = math.min(0, self.MoveHandUp + 0.35)
		self.ViewModelBoneMods = {
			["v_weapon.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.186, -0.556), angle = Angle(0, 0, 0) },
			["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0.185, -0.556, -0.556), angle = Angle(0, 0, 0) },
			["v_weapon.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, self.MoveHandUp), angle = Angle(0, 0, 0) }
		}
	end
end
]]
