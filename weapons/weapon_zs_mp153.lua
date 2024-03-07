AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.PrintName = (translate.Get("wep_mp153"))
SWEP.Description = (translate.Get("desc_mp153"))

if CLIENT then
    SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
    SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "weapon"
	SWEP.HUD3DPos = Vector(1, 15, 1.5)
	SWEP.HUD3DAng = Angle(0, 180, 75)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(1.5, -4, -1.5)
	SWEP.VMAng = Angle(0, 0, 0)

	--SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime())  then
			self.VMAng = LerpAngle(FrameTime() * 1, self.VMAng, Angle(math.random(-3, 3), 0, math.random(-3, 3)))
            self.VMPos = LerpVector(FrameTime() * 1, self.VMPos, Vector(1.5, -8, math.random(-1.2, -1.7)))
        else
			self.VMAng = LerpAngle(FrameTime() * 2, self.VMAng, BarAngle )
            self.VMPos = LerpVector(FrameTime() * 2, self.VMPos,  uBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/arccw/darsu_eft/c_mp153.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8, 5, -5.5), angle = Angle(0, -5, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.ViewModel = "models/weapons/arccw/darsu_eft/c_mp153.mdl"
SWEP.WorldModel = "models/weapons/arccw/darsu_eft/c_mp153.mdl"
SWEP.UseHands = true

SWEP.HoldType = "shotgun"
SWEP.LoweredHoldType = "passive"

SWEP.CSMuzzleFlashes = true

SWEP.ReloadDelay = 0.5

SWEP.Primary.Sound = ")weapons/darsu_eft/mp153/mr153_fire_close"..math.random(1,2)..".wav"
SWEP.Primary.Damage = 9.25
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 60 / 150

SWEP.Recoil = 1.5

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.BulletType = SWEP.Primary.Ammo
SWEP.Primary.DefaultClip = 6

SWEP.ConeMax = 6.25
SWEP.ConeMin = 3.25

SWEP.IronSightsPos = Vector(-2.615, -6, 1.1)
SWEP.IronSightsAng = Vector(0.78, 0, 0)

SWEP.ReloadActivity = "reload_loop"
SWEP.PumpActivity = "reload_end"
SWEP.ReloadStartActivity = "reload_start"
SWEP.ReloadStartActivityEmpty = "reload_start_empty"

SWEP.ReloadSound = "weapons/darsu_eft/mp153/mr133_shell_in_mag2.wav" 
SWEP.PumpSound = "eft_shared/weap_handon.wav"
SWEP.StartSound = "eft_shared/weap_handoff.wav"

SWEP.UseEmptyReloads = false 
SWEP.DontScaleReloadSpeed = false

SWEP.Tier = 2
SWEP.WalkSpeed = SPEED_SLOWER

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

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.05
	self:SendSequence("fire")
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:EmitStartSound()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if IsFirstTimePredicted() then
		self:EmitSound(self.StartSound, 100, 100, 1, CHAN_WEAPON + 21)
		if self.UseEmptyReloads and (self:Clip1() == 0) then
			timer.Create("reload_pickup", 0.15 / reloadspeed, 1, function()
				self:EmitSound("weapons/darsu_eft/mp153/mr133_shell_pickup.wav", 100, 100, 1, CHAN_WEAPON + 21)
			end)
			timer.Create("reload_inport", 0.85 / reloadspeed, 1, function()
				self:EmitSound("weapons/darsu_eft/mp153/mr133_shell_in_port.wav", 100, 100, 1, CHAN_WEAPON + 21)
			end)
			timer.Create("reload_sliddown", 1.2 / reloadspeed, 1, function()
				self:EmitSound("weapons/darsu_eft/mp153/mr153_slider_down.wav", 100, 100, 1, CHAN_WEAPON + 21)
			end)
		end
	end	
end

function SWEP:EmitPumpSound()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if IsFirstTimePredicted() then
		timer.Create("reload_end", 0.1 / reloadspeed, 1, function()
			self:EmitSound(self.PumpSound, 100, 100, 1, CHAN_WEAPON + 21)
		end)
	end	
end

function SWEP:EmitReloadSound()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/darsu_eft/mp153/mr133_shell_pickup.wav", 10, 10, 1, CHAN_WEAPON + 21)
		timer.Create("reload_shell", 0.3 / reloadspeed, 1, function()
			self:EmitSound(self.ReloadSound, 100, 100, 1, CHAN_WEAPON + 21)
		end)
	end	
end

function SWEP:RemoveAllTimers()
	timer.Remove("reload_shell")
	timer.Remove("reload_pickup")
	timer.Remove("reload_inport")
	timer.Remove("reload_sliddown")
	timer.Remove("reload_end")
end

function SWEP:Holster()
	self:RemoveAllTimers()
	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)
	self:RemoveAllTimers()
end