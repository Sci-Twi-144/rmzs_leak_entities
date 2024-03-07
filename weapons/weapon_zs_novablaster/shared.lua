SWEP.PrintName = (translate.Get("wep_novablaster"))
SWEP.Description = (translate.Get("desc_novablaster"))

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_357.Single")
SWEP.Primary.Delay = 0.6
SWEP.Primary.Damage = 60
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 18
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 18

SWEP.RequiredClip = 2

SWEP.ConeMax = 3.5
SWEP.ConeMin = 1.75

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-4.65, 4, 0.25)
SWEP.IronSightsAng = Vector(0, 0, 1)

SWEP.StandartIronsightsAnim = false

SWEP.Tier = 2

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 1
SWEP.LegDamage = 1
SWEP.InnateLegDamage = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.7, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.4, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.05, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_novahelix")), (translate.Get("desc_novahelix")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.55
	wept.Primary.ProjVelocity = 450
	wept.Primary.NumShots = 2
	wept.Primary.Delay = wept.Primary.Delay * 1.25
	wept.Primary.ClipSize = 18

	wept.ReloadSpeed = 0.966

	wept.SameSpread = true
	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTBool(0, true)
			ent.Branch = true
		end
	end
end)

local br = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_magnusson")), (translate.Get("desc_magnusson")), "weapon_zs_magnusson")
br.Colors = {Color(130, 130, 240), Color(65, 65, 120), Color(39, 39, 90)}

function SWEP:EmitFireSound()
	self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 72, 219, 0.75)
	self:EmitSound("weapons/physcannon/superphys_launch1.wav", 72, 208, 0.65, CHAN_AUTO)
end