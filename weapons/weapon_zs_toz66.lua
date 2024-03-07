AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_toz66")) -- "'Caballeron' Shotgun
SWEP.Description = (translate.Get("desc_toz66")) -- Что нибудь интересное

-- killicon.Add("weapon_zs_toz66", "zombiesurvival/killicons/weapon_zs_toz66")

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then

	SWEP.ViewModelFlip = false

	SWEP.ViewModelFOV = 60
	SWEP.HUD3DBone = "BM16_FRAME"
	SWEP.HUD3DPos = Vector(1.3, 3, 1.6)
	SWEP.HUD3DAng = Angle(0, 180, 90)
	SWEP.HUD3DScale = 0.011

	SWEP.VMPos = Vector(2.68, 0, -0.64)
	SWEP.VMAng = Vector(-1.407, -0.704, 0)

	--SWEP.WMPos = Vector(1, 8, -1)
	--SWEP.WMAng = Angle(-15, 0, 180)
	--SWEP.WMScale = 1.1

	SWEP.VElements = {}
	SWEP.WElements = {
		--["weapon"] = { type = "Model", model = "models/weapons/tfa_nmrih/w_fa_sv10.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11, 1.2, -3), angle = Angle(-15, 2.5, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.699, 0.699, 0.699), pos = Vector(2.874, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.699, 0.699, 0.699), pos = Vector(2.874, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.753, 0.753, 0.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

	-- function SWEP:DefineFireMode3D()
		-- if self:GetFireMode() == 0 then
			-- return "STOCK"
		-- else
			-- return "FLECH"
		-- end
	-- end

	-- function SWEP:DefineFireMode2D()
		-- if self:GetFireMode() == 0 then
			-- return "STOCK"
		-- else
			-- return "FLECH"
		-- end
	-- end	
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		elseif self:GetFireMode() == 1 then
			return "FLECH"
		elseif self:GetFireMode() == 2 then
			return "MAG"
		end
	end
	
	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		elseif self:GetFireMode() == 1 then
			return "FLECH"
		elseif self:GetFireMode() == 2 then
			return "MAG"
		end
	end

end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/rmzs/toz66/c_toz66.mdl"
SWEP.WorldModel	= "models/weapons/rmzs/toz66/w_toz66.mdl"
SWEP.ShowWorldModel = true

SWEP.UseHands = true
SWEP.HoldType = "shotgun"

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = "Arccw_FAS2_Weapon_TOZ66.Fire"
SWEP.Primary.SoundDouble = "Arccw_FAS2_Weapon_TOZ66.FireDouble"
SWEP.Primary.Damage = 23.6
SWEP.DamageSave = SWEP.Primary.Damage * (GAMEMODE.ZombieEscape and 4 or 1)
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.85
SWEP.Secondary.Delay = 0.5

SWEP.Primary.Recoil = 12.5

SWEP.Primary.Ammo = "buckshot"

SWEP.ReloadSpeed = 1.1

SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = false
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.IronSightsPos = Vector(-3.58, -2.638, 2.4)
SWEP.IronSightsAng = Vector(-0.071, 0.009, 0)

SWEP.ConeMax = 0.14
SWEP.ConeMin = 0.11

SWEP.ConeMax = 9.5
SWEP.ConeMin = 7.5

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.Recoil = 7.5

SWEP.Tier = 4

SWEP.SetUpFireModes = 2
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"
SWEP.SecondPattern = true
SWEP.PatternShapeSecond = "circle"
SWEP.SpreadPatternSave = {}
SWEP.Secondary.NumShots = SWEP.Primary.NumShots  * 2

SWEP.WorldModelFix = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.08)

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.SpreadPatternSave = self:GeneratePattern(self.PatternShape, self.Primary.NumShots)
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.Primary.NumShots = 9
		self.ConeMax = self.ConeMaxSave
		self.ConeMin = self.ConeMinSave
		self.Pierces = 1
		self.DamageTaper = 0.85
		self.ClassicSpread = false
	elseif self:GetFireMode() == 1 then
		self.Primary.Damage = self.DamageSave
		self.Primary.NumShots = 6
		self.ConeMax = self.ConeMaxSave * 0.45
		self.ConeMin = self.ConeMinSave * 0.3
		self.Pierces = 1
		self.DamageTaper = 0.85
		self.ClassicSpread = false
	elseif self:GetFireMode() == 2 then
		self.Primary.Damage = self.DamageSave * 4.5
		self.Primary.NumShots = 1
		self.ConeMax = self.ConeMaxSave * 0.25
		self.ConeMin = self.ConeMinSave * 0.1
		self.Pierces = 4
		self.DamageTaper = 0.85
		self.ClassicSpread = true
	end
	-- elseif self:GetFireMode() == 3 then
		-- self.Primary.Damage = self.DamageSave * 3
		-- self.Primary.NumShots = 1
		-- self.ConeMax = self.ConeMaxSave * 0.3
		-- self.ConeMin = self.ConeMinSave * 0.15
		-- self.Pierces = 1
		-- self.DamageTaper = 0.7
		-- self.ClassicSpread = true
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

-- function SWEP.BulletCallback(attacker, tr, dmginfo)
	-- local wep = dmginfo:GetInflictor()
	-- if SERVER and attacker:IsValidLivingHuman() and wep:GetFireMode() == 3 then
		-- local ent = tr.Entity
		-- local pos = tr.HitPos
	
		-- if ent:IsValid() then else
			-- timer.Simple(0.06, function()
			-- util.BlastDamagePlayer(wep, attacker, tr.HitPos, 76 * (attacker.ExpDamageRadiusMul or 1), dmginfo:GetDamage(), DMG_DIRECT, 0.8)
			-- end)
		-- end
		
		-- local effectdata = EffectData()
		-- effectdata:SetOrigin(hitpos)
		-- effectdata:SetNormal(hitnormal)
		-- util.Effect("Explosion", effectdata)
		-- util.Effect("explosion_rocket", effectdata)
		-- wep:EmitSound(")weapons/explode5.wav", 80, 130)
		
	-- end
-- end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
		self:EmitSound(self.Primary.Sound)
		
		self.SpreadPattern = self.SpreadPatternSave
		
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())

		self:TakePrimaryAmmo(1)
		self:GetOwner():ViewPunch(1 * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SecondaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		self:EmitSound(self:Clip1() > 1 and self.Primary.SoundDouble or self.Primary.Sound)

		local clip = self:Clip1()
		
		self.SpreadPattern = clip > 1 and self.SpreadPattern2 or self.SpreadPatternSave
		
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self:GetCone())

		self:TakePrimaryAmmo(clip)
		self:GetOwner():ViewPunch(clip * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		-- self:GetOwner():SetGroundEntity(NULL)
		-- self:GetOwner():SetVelocity(-50 * clip * self:GetOwner():GetAimVector())

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

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ66.Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			")weapons/arccw_mifl/fas2/toz66/toz66_fire.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ66.FireDouble",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz66/toz66_fire_double.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Fire2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_obrez.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Close",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_close.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Open",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_open_start.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Open2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_open_finish.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Insert",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_shell_in1.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Remove",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_remove.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Pull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_pull_hammer.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_TOZ34.Ejectorport",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/arccw_mifl/fas2/toz34/toz34_load_ejectorport.wav"
})


-- Звуки "Arccw_FAS2_Generic.Cloth_Movement" должны быть в Remington 870

sound.Add({
	name = 			"Arccw_FAS2_Generic.Magpouch_MG",
	channel = 		CHAN_ITEM3,
	volume = 		1.0,
	sound = "weapons/arccw_mifl/fas2/handling/generic_magpouch_mg1.wav"
})

sound.Add({
	name = 			"Arccw_FAS2_Weapon_Misc.Switch",
	channel = 		CHAN_ITEM3,
	volume = 		1.0,
	sound = "weapons/arccw_mifl/fas2/handling/switch.wav"
})