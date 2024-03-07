AddCSLuaFile()

SWEP.Base = "weapon_zs_base_akimbo"

if CLIENT then

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54

	SWEP.VMPos = Vector(4.48, 0, -2.24)
	
	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(-1.3, -1.2, 1.8)
	SWEP.HUD3DAng = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.010
	
	SWEP.HUD3DBone2 = "tag_weapon"
	SWEP.HUD3DPos2 = Vector(-1.3, 1.2, 1.8)
	SWEP.HUD3DAng2 = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.010
	
	SWEP.VElementsR = {}
	SWEP.VElementsL = {}
	
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-10, 0, 0), angle = Angle(0, 0, 0) }
	}

    SWEP.WElements = {
        ["fixleft"] = { type = "Model", model = "models/weapons/arccw/w_waw_sawedoff.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.001, 0.001, 0.001), color = Color(165, 165, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["UZIWM2"] = { type = "Model", model = "models/weapons/arccw/w_waw_sawedoff.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "fixleft", pos = Vector(10, 1.4, 1.5), angle = Angle(0, 0, 0), size = Vector(0.99, 1.014, 0.99), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["UZIWM1"] = { type = "Model", model = "models/weapons/arccw/w_waw_sawedoff.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, -0.3, -1.5), angle = Angle(0, 0, 180), size = Vector(0.99, 1.014, 0.99), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }
end

SWEP.PrintName = (translate.Get("wep_sawedoff_akimbo"))
SWEP.Description = (translate.Get("desc_sawedoff_akimbo"))
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/arccw/c_waw_sawedoff.mdl"
SWEP.ViewModel_L = "models/weapons/arccw/c_waw_sawedoff.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = false

SWEP.SoundFireVolume = 1
SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/arccw/waw_shotgun/wpn_dbshot_st_f.wav"
SWEP.Primary.Damage = 13.25
SWEP.Primary.NumShots = 8
SWEP.Primary.Delay = 0.6

SWEP.SoundFireVolume_S = 1
SWEP.SoundPitchMin_S = 100
SWEP.SoundPitchMax_S = 110

SWEP.Secondary.Sound = ")weapons/arccw/waw_shotgun/wpn_dbshot_st_f.wav"
SWEP.Secondary.Damage = 13.25
SWEP.Secondary.NumShots = 8
SWEP.Secondary.Delay = 0.06

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"

SWEP.Secondary.ClipSize = 2
SWEP.Secondary.DefaultClip = 40
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "buckshot"

SWEP.RequiredClip = 1
SWEP.Auto = false
SWEP.CantSwitchFireModes = true

SWEP.ConeMax = 10 * 1.3
SWEP.ConeMin = 7.75 * 1.3

SWEP.ConeMax_S = 10 * 1.3
SWEP.ConeMin_S = 7.75 * 1.3

SWEP.FireAnimSpeed = 1.5

SWEP.Tier = 2

-- SWEP.FireAnimIndexMin = 1
-- SWEP.FireAnimIndexMax = 2
-- SWEP.ReloadAnimIndex = 7
-- SWEP.DeployAnimIndex = 3

-- SWEP.FireAnimIndexMin_S = 1
-- SWEP.FireAnimIndexMax_S = 2
-- SWEP.ReloadAnimIndex_S = 0
-- SWEP.DeployAnimIndex_S = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07)

function SWEP:SendReloadAnimation()
	if (self:Clip1() == 0) then
		self:SendWeaponAnim(ACT_VM_RELOAD_EMPTY)
	else
		self:SendWeaponAnim(ACT_VM_RELOAD_EMPTY)
	end
end

function SWEP:PrimaryFire()
	if not self:CanAttackCheck(false) then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()
	self:TakeAmmo(false)

	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin, self.FireAnimIndexMax), 0, self.FireAnimSpeed)
end

function SWEP:SecondaryFire()
	if not self:CanAttackCheck(true)  then return end

	self:SetNextSecondaryFire(CurTime() + self:GetFireDelay(true))
	self:EmitFireSound_S()
	self:TakeAmmo(true)
	
	self:ShootBullets_Left(self.Secondary.Damage, self.Secondary.NumShots, self:GetCone_S())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SendViewModelAnim(math.random(self.FireAnimIndexMin_S, self.FireAnimIndexMax_S), 1, self.FireAnimSpeed)
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