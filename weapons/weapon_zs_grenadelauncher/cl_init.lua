include("shared.lua")

SWEP.HUD3DBone = "Weapon_Main"
SWEP.HUD3DPos = Vector(1.4, -1.5, 10)
SWEP.HUD3DAng = Angle(180, 0, -25)
SWEP.HUD3DScale = 0.015

SWEP.ViewModelFOV = 70

SWEP.ViewModelFlip = false
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.VMPos = Vector(0, 1, -1)
SWEP.VMAng = Angle(0, 1, 0)

SWEP.VElements = {}
SWEP.WElements = {
	["E"] = { type = "Model", model = "models/weapons/c_grenadelauncher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.443, 3.963, -6.074), angle = Angle(-10, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:ShootBullets(damage, numshots, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	if self.Recoil > 0 then
		local r = math.Rand(0.8, 1)
		owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
	end
end

function SWEP:DefineFireMode3D()
	if self:GetFireMode() == 0 then
		return "STOCK"
	else
		return "CONTACT"
	end
end

function SWEP:DefineFireMode2D()
	if self:GetFireMode() == 0 then
		return "STOCK"
	else
		return "CONTACT"
	end
end	