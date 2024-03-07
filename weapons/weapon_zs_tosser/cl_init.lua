include("shared.lua")

DEFINE_BASECLASS("weapon_zs_base")

SWEP.AbilityText = "GRENADE"
SWEP.AbilityColor = Color(65, 112, 214)

SWEP.HUD3DBone = "Base"
SWEP.HUD3DPos = Vector(1.5, 1.55, 0)
SWEP.HUD3DAng = Angle(0, 90, 90)
SWEP.HUD3DScale = 0.015

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60

SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Vector(0, 0, 0)

local uBarrelOrigin = SWEP.VMPos
local lBarrelOrigin = Vector(0, 0, 0)
-- function SWEP:Think()
    -- BaseClass.Think(self)
    -- if self.IsShooting >= CurTime() then
        -- self.VMPos = LerpVector( FrameTime() * 8, self.VMPos, Vector(math.random(-0.8, -1.2), -6, math.random(-0.05, -0.45)) )
    -- else
        -- self.VMPos = LerpVector( FrameTime() * 8, self.VMPos,  uBarrelOrigin )
    -- end
-- end	

SWEP.LowAmmoSoundThreshold = 0.33
SWEP.LowAmmoSound = ")weapons/tfa/lowammo_indicator_automatic.wav"
SWEP.LastShot = ")weapons/tfa/lowammo_dry_automatic.wav"
function SWEP:EmitFireSound()
    BaseClass.EmitFireSound(self)
    local clip1, maxclip1 = self:Clip1(), self:GetMaxClip1()
    local mult = clip1 / maxclip1
    self:EmitSound(self.LowAmmoSound, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
    if self:Clip1() <= 1 then
        self:EmitSound(self.LastShot, self.SoundFireLevel, math.random(self.SoundPitchMin, self.SoundPitchMax), 1 - (mult / math.max(self.LowAmmoSoundThreshold, 0.01)), CHAN_WEAPON + 1)
    end
end

function SWEP:DrawAds()
    if self.ViewModelFOV == 70 then return end
    if not self:GetIronsights() then
        self.ViewModelFOV = 70
    end
end

function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
    self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, CurTime() - self:GetResource(), self.AbilityMax, self.AbilityText)
end

function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
    self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, CurTime() - self:GetResource(), self.AbilityMax, self.AbilityText)
end

function SWEP:DefineFireMode3D()
    if self:GetFireMode() == 0 then
        return "AUTO"
    else
        return "GL"
    end
end

function SWEP:DefineFireMode2D()
    if self:GetFireMode() == 0 then
        return "Full Auto"
    else
        return "Grenade Launcher"
    end
end
