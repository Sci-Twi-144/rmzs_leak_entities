AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_chempistol"))
SWEP.Description = (translate.Get("desc_chempistol"))

SWEP.FullColor = Color(50, 130, 25, 150)
SWEP.EmptyColor = Color(213, 203, 184, 255)
SWEP.FullMat = "models/spawn_effect2"
SWEP.EmptyMat = "metal2"

SWEP.Slot = 1
SWEP.SlotPos = 0
if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "clip"
	SWEP.HUD3DPos = Vector(-0.15, 8.75, 0)
	SWEP.HUD3DAng = Angle(0, 180, -90)
	SWEP.HUD3DScale = 0.015

	SWEP.WMPos = Vector(1, 2, 1)
	SWEP.WMAng = Angle(-9, 0, 180)
	SWEP.WMScale = 1.0
	
	SWEP.VElements = {
		["effect"] = { type = "Model", model = "models/xqm/cylinderx2.mdl", bone = "clip", rel = "", pos = Vector(0, 1.5, 0), angle = Angle(0, 90, 0), size = Vector(0.34999999403954, 0.13199999928474, 0.13199999928474), color = Color(50, 130, 25, 150), surpresslightning = true, material = "models/spawn_effect2", skin = 0, bodygroup = {} }
	}

	function SWEP:ChangeColor(state)
		if state == true then
			self.VElements["effect"].color = self.FullColor
			self.VElements["effect"].surpresslightning = true
			self.VElements["effect"].material = self.FullMat
		else
			self.VElements["effect"].color = self.EmptyColor
			self.VElements["effect"].surpresslightning = false
			self.VElements["effect"].material = self.EmptyMat
		end
	end

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(3, -0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -12, 0) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end
end

SWEP.UseHands = true
SWEP.WorldModelFix = true

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "pistol"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/chempistol/c_chempistol.mdl"
SWEP.WorldModel = "models/weapons/chempistol/w_chempistol.mdl"

SWEP.SoundFireVolume = 1.0
SWEP.SoundFireLevel = 140
SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Damage = 28
SWEP.Primary.Delay = 0.35
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 15
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "chemical"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ResistanceBypass = 0.1

SWEP.IronSightsPos = Vector(-5.8, 5, 3.2)
SWEP.IronSightsAng = Vector(-1, 0, 0)

SWEP.StandartIronsightsAnim = false

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 1

SWEP.IsAoe = true

SWEP.ConeMax = 3
SWEP.ConeMin = 1

SWEP.Primary.Projectile = "projectile_chemball_generic"
SWEP.Primary.ProjVelocity = 1500

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_chempistol")), (translate.Get("desc_chempistol")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage / 1.85
	wept.Primary.Delay = 0.55
	wept.Primary.NumShots = 2
	wept.Primary.ClipSize = 10
	wept.Primary.Automatic = true

	wept.Primary.ProjVelocity = 800
	wept.IsAoe = false
	wept.ConeMax = 6
	wept.ConeMin = 3
end)
branch.NewNames = {"MK I", "MK II", "MK III"}

--[[local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_interceptor_hot")), (translate.Get("desc_interceptor_hot")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.83
	wept.FullColor = Color(255, 160, 50, 150)
	
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTInt(5, 1)
		end
	end
end)
branch.Colors = {Color(255, 160, 50), Color(215, 120, 50), Color(175, 100, 40)}
branch.NewNames = {"Hot", "Searing", "Torching"}

branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_interceptor_cold")), (translate.Get("desc_interceptor_cold")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.74
	wept.FullColor = Color(50, 160, 255, 150)
	
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTInt(5, 2)
		end
	end
end)
branch.Colors = {Color(50, 160, 255), Color(50, 130, 215), Color(40, 115, 175)}
branch.NewNames = {"Cold", "Arctic", "Glacial"}]]

function SWEP:EmitFireSound()
	self:EmitSound("^weapons/mortar/mortar_fire1.wav", 70, math.random(88, 92), 0.65)
	self:EmitSound("npc/barnacle/barnacle_gulp2.wav", 70, 70, 0.85, CHAN_AUTO + 20)
end

function SWEP:PrimaryAttack()
	BaseClass.PrimaryAttack(self)
	
	if self:Clip1() <= 0 then
		if CLIENT then
			self:ChangeColor(false)
		end
	end
end

function SWEP:Reload()
	BaseClass.Reload(self)
	
	if self:Clip1() < 1 then
		if CLIENT then
			timer.Simple(0.8, function()
				self:ChangeColor(true)
			end)
		end
	end
end

sound.Add({
	name = 			"Interceptor.SlidePull",
	channel = 		CHAN_USER_BASE + 10,
	volume = 		1.0,
	sound = 			"weapons/interceptor/slidepull.wav"
})

sound.Add({
	name = 			"ChemPistol.ClipOut",
	channel = 		CHAN_USER_BASE + 10,
	volume = 		1.0,
	sound = 			"weapons/chempistol/clipout.wav"
})

sound.Add({
	name = 			"ChemPistol.ClipIn",
	channel = 		CHAN_USER_BASE + 10,
	volume = 		1.0,
	sound = 			"weapons/chempistol/clipin.wav"
})