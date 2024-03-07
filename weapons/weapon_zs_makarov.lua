AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_pm"))
SWEP.Description = (translate.Get("desc_pm"))

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80

	SWEP.HUD3DBone = "weapon"
	SWEP.HUD3DPos = Vector(0.9, -3.5, 0.5)
	SWEP.HUD3DAng = Angle(180, 0, -125)
	SWEP.HUD3DScale = 0.0125

	SWEP.VMPos = Vector(2.5,3.5,-1.5)

	SWEP.VElements = {
		--["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_pistol.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(0.4, 0, 0.8), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
		["mag"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_magazine_pm_8.mdl", bone = "Magazine", rel = "", pos = Vector(0.4, 0, 0.8), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true, bonemerge = true }
		--["mag_drum"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/v_pmdrum.mdl", bone = "Magazine", rel = "", pos = Vector(1.8, -13.2, -1.15), angle = Angle(0, 270, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
		--["mag_ext"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_magazine_pm_15.mdl", bone = "Magazine", rel = "", pos = Vector(1.4, -10.8, -0.45), angle = Angle(0, 270, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
		
	}
	SWEP.WElements = {
		--["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_sil_pistol.mdl", bone = "ATTACH_Muzzle", rel = "ref", pos = Vector(-23.1, 1.2, -5.9), angle = Angle(-2.5, 0, 180), size = Vector(0.8, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
		["mag_drum"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_pmdrum.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "weapon", pos = Vector(-0.25, 0, 1), angle = Angle(0, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["mag"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_magazine_makarov_8.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "weapon", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_pm.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 1, -1), angle = Angle(-1, -5, 178), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["A_Suppressor"] = { scale = Vector(0.7, 0.7, 0.7), pos = Vector(0.02, 0, 0), angle = Angle(0, 0, 0) },
		["Magazine"] = { scale = Vector(1, 1, 1.095), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		--["L UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0.5, -2, -1), angle = Angle(0, 0, 0) }
	}

	SWEP.WorldModelBoneMods = {
		["ATTACH_Muzzle"] = { scale = Vector(0.72, 0.65, 0.65), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["W_PIS_MAGAZINE"] = { scale = Vector(1, 1, 1), pos = Vector(-0.1, 0, 0.21), angle = Angle(0, 0, 0) },
	}

	local m_C = math.Clamp
	local defaultpos = Vector(0, 0, 0)
	function SWEP:UpdateBeltBG(vm)
		local target = self:Clip1()
		local ammo = self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
		local vm = self:GetOwner():GetViewModel()
		local time = CurTime()

		local postirony = m_C(math.ceil((target + ammo) ), 0, 9) + 1
		if (self:GetNextReload() < (time - 1.1))  and not (self:GetReloadFinish() == 0 )then
			vm:SetBodygroup(1, m_C((postirony), 0, self:GetMaxClip1()+1))
		else
			vm:SetBodygroup(1, m_C(self:Clip1(), 0, self:GetMaxClip1()+1))
		end
	end

	function SWEP:Think()
		self:UpdateBeltBG()
		--[[
		if self:GetReloadFinish() > 0 then
            self.ViewModelBoneMods[ "L UpperArm" ].pos = LerpVector( FrameTime() * 8, self.ViewModelBoneMods[ "L UpperArm" ].pos, Vector(0.4, -0.4, -0.2) )
		--	self.ViewModelBoneMods[ "L UpperArm" ].pos = LerpVector( FrameTime() * 8, self.ViewModelBoneMods[ "L UpperArm" ].pos, Vector(0.5, -2, -1) )
        else
            self.ViewModelBoneMods[ "L UpperArm" ].pos = LerpVector( FrameTime() * 8, self.ViewModelBoneMods[ "L UpperArm" ].pos, defaultpos )
        end
		]]
		return BaseClass.Think(self)
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/tfa_ins2/v_pm.mdl"
SWEP.WorldModel	= "models/weapons/tfa_ins2/w_pm.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/tfa_ins2/pm/pm_fire.wav" --pm_suppressed
SWEP.Primary.Damage = 23.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.136
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 8
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 0.75

SWEP.Primary.Ammo = "pistol"
SWEP.BulletType = SWEP.Primary.Ammo
SWEP.ConeMax = 2.4
SWEP.ConeMin = 1.1

SWEP.IronSightsPos = Vector(-4.585, 4.363, 1.87)
SWEP.IronSightsAng = Vector(0.5, 0, 0)

SWEP.IronSightActivity = ACT_VM_PRIMARYATTACK_1

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
   	self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
end

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_pmdrum")), (translate.Get("desc_pmdrum")), function(wept)
	wept.ConeMax = wept.ConeMax * 1.65
	wept.ConeMin = wept.ConeMin * 1.35
	wept.Primary.Damage = wept.Primary.Damage * 0.7
	wept.Primary.ClipSize = wept.Primary.ClipSize * 5
	
	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitFireSound()
	
		local altuse = self:GetAltUsage()
		if not altuse then
			self:TakeAmmo()
		end
		self:SetAltUsage(not altuse)
	
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	if CLIENT then
		wept.VElements = {
			["mag_drum"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/v_pmdrum.mdl", bone = "Magazine", rel = "", pos = Vector(1.8, -13.2, -1.15), angle = Angle(0, 270, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true }	
		}
		wept.WElements = {
			["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_pm.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 1, -1), angle = Angle(-1, -5, 178), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["mag_drum"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_pmdrum.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "weapon", pos = Vector(-0.25, 0, 1), angle = Angle(0, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}

		wept.GetDisplayAmmo = function(self, clip, spare, maxclip)
			local minus = self:GetAltUsage() and 0 or 1
			return math.max(0, (clip * 2) - minus), spare * 2, maxclip * 2
		end

		local ghostlerp = 0
		wept.CalcViewModelViewExtra = function(self, vm, oldpos, oldang, pos, ang)
			if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
				ghostlerp = math.min(1, ghostlerp + FrameTime() * 1)
			elseif ghostlerp > 0 then
				ghostlerp = math.max(0, ghostlerp - FrameTime() * 1.5)
			end

			if ghostlerp > 0 then
				ang:RotateAroundAxis(ang:Right(), -15 * ghostlerp)
			end

			return pos, ang
		end
	end
end)

function SWEP:EmitReloadSound()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local checkempty = (self:Clip1() == 0)
	if not checkempty and IsFirstTimePredicted() then
		timer.Create("Magrelease", 0.73 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_magrelease.wav", 87, 100, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("Magout", 0.9 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_magout.wav", 87, 100, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("Magin", 1.76 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_magin.wav", 87, 100, 0.1, CHAN_WEAPON + 22)
		end)
		timer.Create("MagHit", 2.13 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_maghit.wav", 87, 100, 1, CHAN_WEAPON + 23)
		end)
	end
	--
	if checkempty and IsFirstTimePredicted() then
		timer.Create("Magrelease", 0.73 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_magrelease.wav", 87, 100, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("Magout", 0.9 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_magout.wav", 87, 100, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("Magin", 1.76 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_magin.wav", 87, 100, 0.1, CHAN_WEAPON + 22)
		end)
		timer.Create("MagHit", 2.13 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_maghit.wav", 87, 100, 1, CHAN_WEAPON + 23)
		end)
		timer.Create("Boltrelease", 2.4 / reloadspeed, 1, function ()
			self:EmitSound("weapons/tfa_ins2/pm/handling/makarov_boltrelease.wav", 87, 100, 1, CHAN_WEAPON + 24)
		end)
	end
end

function SWEP:RemoveAllTimers()
	local checkempty = (self:Clip1() == 0)
	if checkempty then
		timer.Remove("Magrelease")
		timer.Remove("Magout")
		timer.Remove("Magin")
		timer.Remove("MagHit")
		timer.Remove("Boltrelease")
	else
		timer.Remove("Magrelease")
		timer.Remove("Magout")
		timer.Remove("Magin")
		timer.Remove("MagHit")
	end
end

function SWEP:Holster()
	self:RemoveAllTimers()
	return BaseClass.Holster(self)
end

function SWEP:OnRemove()
	BaseClass.OnRemove(self)
	self:RemoveAllTimers()
end

function SWEP:SetAltUsage(usage)
	self:SetDTBool(8, usage)
end

function SWEP:GetAltUsage()
	return self:GetDTBool(8)
end

sound.Add({
	name = 			"PM.PistolDraw",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/pm/pm_draw.wav"
})

sound.Add({
	name = 			"PM.PistolHolster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/pm/pm_draw.wav"
})


sound.Add({
	name = 			"Weapon_PM.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/pm/pm_boltback.wav"
})

sound.Add({
	name = 			"Weapon_PM.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/pm/pm_boltrelease.wav"
})

sound.Add({
	name = 			"Weapon_PM.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/pm/pm_empty.wav"
})

sound.Add({
	name = 			"Weapon_PM.MagHit",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/pm/pm_maghit.wav"
})

sound.Add({
	name = 			"Weapon_PM.Magin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/pm/pm_magin.wav"
})

sound.Add({
	name = 			"Weapon_PM.Magout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/pm/pm_magout.wav"
})
