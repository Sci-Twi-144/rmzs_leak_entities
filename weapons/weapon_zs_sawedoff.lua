AddCSLuaFile()

--in memory of Gormaoife 1999-2016 rip

SWEP.PrintName = (translate.Get("wep_sawedoff"))
SWEP.Description = (translate.Get("desc_sawedoff"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(-1.3, -1.2, 1.8)
	SWEP.HUD3DAng = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.010

    SWEP.VMPos = Vector(1.5, -6.5, -0.25)

    SWEP.ViewModelBoneMods = {
        ["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(0, 0, 0), angle = Angle(-20, 0, 25) },
        ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(0.95, 0, 0.15), angle = Angle(-1, 0, -45) },
        ["j_wristtwist_le"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["j_wrist_le"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
    }

    function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "SLUG"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "SLUG"
		end
	end	
end

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/arccw/c_waw_sawedoff.mdl"
SWEP.WorldModel = "models/weapons/arccw/w_waw_sawedoff.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = ")weapons/arccw/waw_shotgun/wpn_dbshot_st_f.wav"
SWEP.Primary.DoubleSound = ")weapons/arccw/waw_shotgun/wpn_dbshot_st_f2.wav"
SWEP.Primary.Damage = 13.25
SWEP.DamageSave = SWEP.Primary.Damage
SWEP.Primary.NumShots = 9
SWEP.Secondary.NumShots = SWEP.Primary.NumShots  * 2
SWEP.Primary.Delay = 0.6
SWEP.Secondary.Delay = 0.5
SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 9
SWEP.ConeMin = 6.75
SWEP.Recoil = 7.5

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.ReloadSpeed = 0.59

SWEP.ProceduralPattern = true
SWEP.PatternShape = "rectangle"
SWEP.SecondPattern = true
SWEP.PatternShapeSecond = "circle"
SWEP.SpreadPatternSave = {}
SWEP.IsShotgun = true

SWEP.Tier = 2

SWEP.DryFireSound = Sound("Weapon_Shotgun.Empty")

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -1.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.08, 2)
--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.03, 1)

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.SpreadPatternSave = self:GeneratePattern(self.PatternShape, self.Primary.NumShots)
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
        self.Primary.Damage = self.DamageSave
		self.ResistanceBypass = 1
		self.Primary.NumShots = 8
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.ClassicSpread = false
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave * 5.35
		self.ResistanceBypass = 0.6
		self.Primary.NumShots = 1
		self.ConeMax = self.ConeMaxSave * 0.35
		self.ConeMin = self.ConeMinSave * 0.20
		self.ClassicSpread = true
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end
 
function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
		self:EmitSound(self.Primary.Sound)
		
		self.SpreadPattern = self.SpreadPatternSave
		
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())

		self:TakePrimaryAmmo(1)
		self:GetOwner():ViewPunch(1 * 0.5 * self.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SecondaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:EmitSound(self.Primary.DoubleSound)

		local clip = self:Clip1()
			
		self.SpreadPattern = clip > 1 and self.SpreadPattern2 or self.SpreadPatternSave
		
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self:GetCone())

		self:TakePrimaryAmmo(clip)
		self:GetOwner():ViewPunch(clip * 0.5 * self.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self:GetOwner():SetGroundEntity(NULL)
		self:GetOwner():SetVelocity(-50 * clip * self:GetOwner():GetAimVector())

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SendReloadAnimation()
	if (self:Clip1() == 0) then
		self:SendWeaponAnim(ACT_VM_RELOAD_EMPTY)
	else
		self:SendWeaponAnim(ACT_VM_RELOAD)
	end
end

sound.Add( {
    name = "ArcCW_WAW.DBS_Fire",
    channel = CHAN_STATIC,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/wpn_dbshot_st_f.wav",
    }
} )

sound.Add( {
    name = "ArcCW_WAW.DBS_Fire2",
    channel = CHAN_STATIC,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/wpn_dbshot_st_f2.wav",
    }
} )

sound.Add( {
    name = "ArcCW_WAW.DBS_Mech",
    channel = CHAN_USER_BASE + 2,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/wpn_dbshot_st_act.wav",
    }
} )

sound.Add( {
    name = "ArcCW_WAW.DBS_Click",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_click.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Break",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_break.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Shake",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_shake.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_1Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_shake_1brl.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Shell1",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_shell_in_1.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Shell2",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_shell_in_2.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Close",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_close.wav",
    }
} )