AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_quicksilver"))
SWEP.Description = (translate.Get("desc_quicksilver"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.g3sg1_Parent"
	SWEP.HUD3DPos = Vector(-1.2, -5.75, -1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/g3sg1/g3sg1-1.wav"
SWEP.Primary.Damage = 81.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.38

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 6.5
SWEP.ConeMin = 1

SWEP.IronSightsPos = Vector(11, -9, -2.2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOW

SWEP.HeadshotMulti = 2.25

SWEP.Tier = 4
SWEP.ResistanceBypass = 0.4

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.06, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 4, 1)
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_mercurial")), (translate.Get("desc_mercurial")), function(wept)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_CLIP_SIZE, 0, 4, branch)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_FIRE_DELAY, 0, 4, branch)
	wept.ViewModel = "models/weapons/c_quicksilver.mdl"
	wept.WorldModel = "models/weapons/w_quicksilver.mdl"

	wept.Primary.Damage = wept.Primary.Damage / 5
	wept.Primary.NumShots = 6
	wept.ConeMin = 3
	
	wept.HeadshotMulti = 2

	wept.IronSightsPos = Vector(0, 12, 1.2)
	wept.IronSightsAng = Vector(0, 0, 0)

	wept.IsScoped = function(self)
		return false
	end

	if CLIENT then
		wept.IronsightsMultiplier = 0.6
	end
end)
branch.Killicon = "weapon_zs_quicksilver2"

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end
