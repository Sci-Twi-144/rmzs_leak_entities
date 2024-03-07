include("shared.lua")

DEFINE_BASECLASS("weapon_zs_base")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70

SWEP.HUD3DBone = "Weapon"
SWEP.HUD3DPos = Vector(1.4, 0.5, 0.3)
SWEP.HUD3DAng = Angle(180, 0, -125)
SWEP.HUD3DScale = 0.015

SWEP.VMPos = Vector(-0.35, 1.15, 0)
SWEP.VMAng = Vector(0.25, 0, 0)

SWEP.VElements = {}
SWEP.WElements = {
    ["base"] = { type = "Model", model = "models/weapons/c_ak103_m.mdl ", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-3.3, 4.2, -8), angle = Angle(0, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

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

function SWEP:DrawAds() -- Client only
    if self:GetIronsights() then
        local ipos = (self:GetFireMode() == 0) and Vector(-2.56, -2, 0.95) or Vector(-1.0, -4.5, 0.95)
        local iang = (self:GetFireMode() == 0) and Vector(-0.15, 0.02, 0) or Vector(1.05,-0.01,0)

        self.IronSightsPos = ipos
        self.IronSightsAng = iang
    end
end

function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
    self:DrawAbilityBar3D(x, y, hei, wid, Color(128, 128, 255), self:GetResource(), 8, "CONTRACT")
end

function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
	self:DrawAbilityBar2D(x, y, hei, wid, Color(128, 128, 255), self:GetResource(), 8, "CONTRACT")
end

function SWEP:Draw2DHUDAds(x, y, hei, wid)
	local clip = self:Clip2()
	local spare = self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType())
	local maxclip = self.Secondary.ClipSize

	local dclip, dspare, dmaxclip = self:GetDisplayAmmo(clip, spare, maxclip)

	draw.SimpleTextBlurry(dclip.." / "..dspare, "ZSHUDFontSmall", x + wid * 0.5, y + hei * 1.6, Color(128, 128, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:Draw3DHUDAds(x, y, hei, wid)
	local clip = self:Clip2()
	local spare = self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType())
	local maxclip = self.Secondary.ClipSize

	local dclip, dspare, dmaxclip = self:GetDisplayAmmo(clip, spare, maxclip)

	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(x, y + hei * 0.92, wid, 34)
	draw.SimpleTextBlurry(dclip.."/"..dspare, "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 1, Color(128, 128, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

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