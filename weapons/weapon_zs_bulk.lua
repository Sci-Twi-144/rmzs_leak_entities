AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_baseshotgun")

SWEP.PrintName = (translate.Get("wep_bulk"))
SWEP.Description = (translate.Get("desc_bulk"))

SWEP.AbilityText = "Instant Reload"
SWEP.AbilityColor = Color(250, 240, 65)
SWEP.AbilityMax = 3

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 65

	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(2, -2.1, -0.1)
	SWEP.HUD3DAng = Angle(0, 270, 0)
	SWEP.HUD3DScale = 0.014

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, true, 3, 1/3)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, true, 3, 1/3)
	end
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/rmzs/weapons/bulk/c_bulk_cannon.mdl"
SWEP.WorldModel = "models/rmzs/weapons/bulk/w_bulk_cannon.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = Sound("Weapon_BulkCannon.fire")
SWEP.Primary.Damage = 19.25
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.22

SWEP.ReloadDelay = 0.95

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 6
SWEP.ConeMin = 4.75

SWEP.SpecificCond = true
SWEP.HasAbility = true
SWEP.CannotHaveExtendetMag = true

SWEP.FireAnimSpeed = 1.2
SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 5

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

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)

function SWEP:OnZombieKilled(pl, totaldamage, dmginfo)
	local owner = self:GetOwner()
	if self:IsValid() then
		self:SetResource(self:GetResource() + 1)
		if self:GetResource() >= 3 then
			self:SetResource(0)
			if self:Clip1() < self.Primary.ClipSize then
				if owner:GetAmmoCount(self.Primary.Ammo) >= 1 then
					timer.Simple(0, function()
						if self:IsValid() and owner:IsValidLivingHuman() then
							self:TakeCombinedPrimaryAmmo(1)
							self:SetClip1(self:Clip1() + 1)
							owner:EmitSound(")weapons/tfa/lowammo_dry_handgun.wav", 0, 100)
						end
					end)
				end
			end
		end
	end
end

sound.Add({
	name = 			"Weapon_BulkCannon.fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			")weapons/BulkCannon/fire.wav"
})

sound.Add({
	name = 			"Weapon_BulkCannon.Shellout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/BulkCannon/shellout.wav"	
})

sound.Add({
	name = 			"Weapon_BulkCannon.insertshell",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/BulkCannon/insertshell.wav"	
})

sound.Add({
	name = 			"Weapon_BulkCannon.LidClose",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/BulkCannon/closelid.wav"	
})

sound.Add({
	name = 			"Weapon_BulkCannon.LidLock",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/BulkCannon/lock.wav"	
})

sound.Add({
	name = 			"Weapon_BulkCannon.LidOpen",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/BulkCannon/openlid.wav"	
})