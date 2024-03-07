AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Materia"
end

SWEP.Base = "weapon_zs_redeemers"
DEFINE_BASECLASS(SWEP.Base)

SWEP.InfiniteAmmo = true
SWEP.CanFireUnderwater = true
SWEP.Primary.Damage = 80
SWEP.Primary.Delay = 0.15

SWEP.Primary.DefaultClip = 99999
SWEP.Primary.KnockbackScale = ZE_KNOCKBACKSCALE
SWEP.ReloadTimeMultiplier = 1

SWEP.ConeMax = 0.03
SWEP.ConeMin = 0.01

SWEP.WalkSpeed = SPEED_ZOMBIEESCAPE_SLOW

function SWEP:Initialize()
	BaseClass.Initialize( self )
	self:SetNoDraw(true)
end

function SWEP:DrawHUD()
	surface.SetFont("ZSHUDFontSmall")
	local color =  Color(255 * math.abs(math.sin(RealTime() * 6)) * 0.6,255 * math.abs(math.sin(RealTime() * 6)) * 0.6,255 * math.abs(math.sin(RealTime() * 6)) * 0.6)

	local text = "Press ALT to drop your material."

	draw.SimpleTextBlurry(text, "ZSHUDFontBig", ScrW() * 0.5, ScrH() * 0.2, color, TEXT_ALIGN_CENTER)

	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

local glowmat = Material("sprites/glow04_noz")
function SWEP:DrawWorldModel()
	local owner = self:GetOwner()
	if owner:IsValid() then return end

	local pos = self:GetPos()
	local col = self:GetClass() == "weapon_knife" and Color(0, 255, 0, 200) or Color(255, 125, 63, 200)

	render.SetMaterial(glowmat)
	render.DrawSprite(pos, math.abs(30 + 15 * math.sin(RealTime() * 7 + 1.5)), math.abs(30 + 15 * math.sin(RealTime() * 7)), col)
end

SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel