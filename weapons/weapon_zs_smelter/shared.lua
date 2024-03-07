SWEP.PrintName = (translate.Get("wep_smelter"))
SWEP.Description = (translate.Get("desc_smelter"))

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"

SWEP.UseHands = false

SWEP.CSMuzzleFlashes = false

SWEP.SoundFireVolume = 0.61
SWEP.SoundFireLevel = 75
SWEP.SoundPitchMin = 93
SWEP.SoundPitchMax = 108

SWEP.Primary.Sound = ")weapons/crossbow/fire1.wav"
SWEP.Primary.Delay = 1.25
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 25.5
SWEP.Primary.NumShots = 7

SWEP.Primary.ClipSize = 6
SWEP.Primary.Ammo = "scrap"
SWEP.Primary.DefaultClip = 15

SWEP.Recoil = 7

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5
--SWEP.MaxStock = 2
SWEP.IsAoe = true

SWEP.ConeMax = 6.5
SWEP.ConeMin = 5.75

SWEP.ReloadSpeed = 0.45

SWEP.ReloadActivity = ACT_VM_DRAW

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.07, 1)
-- local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_ripper")), (translate.Get("desc_ripper")), function(wept)
	-- wept.Primary.Damage = wept.Primary.Damage * 3.6
	-- wept.Primary.Delay = wept.Primary.Delay * 0.45
	-- wept.ConeMin = wept.ConeMin * 0.16
	-- wept.ConeMax = wept.ConeMax * 0.21
	-- wept.Primary.ClipSize = 8
	-- wept.Primary.ClipMultiplier = 12/18 * 2
	-- wept.HeadshotMulti = 2.3
	-- wept.ReloadSpeed = 0.72
	-- wept.Primary.NumShots = 1
	-- wept.IsAoe = false
	
	-- wept.Recoil = 0

	-- wept.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
	-- wept.WorldModel = "models/weapons/w_smg_ump45.mdl"

	-- wept.EmitFireSound = function(self, secondary)
		-- self:EmitSound("npc/roller/blade_cut.wav", 75, secondary and 56 or 66, 0.73)
		-- self:EmitSound("weapons/m249/m249-1.wav", 75, secondary and 86 or 146, 0.67, CHAN_AUTO+20)
	-- end

	-- wept.EmitReloadSound = function(self)
		-- if IsFirstTimePredicted() then
			-- self:EmitSound("weapons/357/357_reload1.wav", 75, 65, 1, CHAN_WEAPON + 21)
			-- self:EmitSound("weapons/ar2/ar2_reload_push.wav", 70, 67, 0.85, CHAN_WEAPON + 22)
		-- end
	-- end

	-- wept.EmitReloadFinishSound = function(self)
		-- if IsFirstTimePredicted() then
			-- self:EmitSound("weapons/galil/galil_boltpull.wav", 70, 110)
		-- end
	-- end

	-- wept.SetLastFired = function(self, float)
		-- self:SetDTFloat(8, float)
	-- end

	-- wept.GetLastFired =	function(self)
		-- return self:GetDTFloat(8)
	-- end

	-- wept.SetAltUsage =	function(self, usage)
		-- self:SetDTBool(8, usage)
	-- end

	-- wept.GetAltUsage =	function(self)
		-- return self:GetDTBool(8)
	-- end

	-- wept.PrimaryAttack = function(self)
		-- if not self:CanPrimaryAttack() then return end

		-- self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		-- self:SetLastFired(CurTime())

		-- self:EmitFireSound()

		-- local altuse = self:GetAltUsage()
		-- if not altuse then
			-- self:TakeAmmo()
		-- end
		-- self:SetAltUsage(not altuse)

		-- self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		-- self.IdleAnimation = CurTime() + self:SequenceDuration()
	-- end

	-- wept.SecondaryAttack = function(self)
	-- end

	-- if CLIENT then
		-- wept.VElements = {
			-- ["METALSPIKES"] = { type = "Model", model = "models/Mechanics/gears2/pinion_20t1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "METALFRONT", pos = Vector(-0.83, 0, 0), angle = Angle(0, -90, 0), size = Vector(0.201, 0.328, 0.166), color = Color(110, 100, 90, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["projectilepart2"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "projectile", pos = Vector(0, 0, -0.579), angle = Angle(0, 0, 0), size = Vector(0.92, 0.92, 0.09), color = Color(130, 125, 120, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["handle"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "METALback", pos = Vector(1.743, 0, 1.736), angle = Angle(0, 0, 0), size = Vector(0.134, 0.134, 0.085), color = Color(100, 90, 120, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			-- ["METALFRONT"] = { type = "Model", model = "models/props_c17/light_decklight01_on.mdl", bone = "v_weapon.Glock_Parent", rel = "", pos = Vector(-1.338, -4.442, 0.976), angle = Angle(-11.62, -107.073, -5), size = Vector(0.236, 0.621, 0.105), color = Color(110, 100, 90, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["METALback"] = { type = "Model", model = "models/props_combine/combine_interface003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "METALFRONT+", pos = Vector(-6.52, -10.306, 0), angle = Angle(0, 90, 90), size = Vector(0.167, 0.043, 0.15), color = Color(125, 120, 130, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			-- ["projectile"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "METALFRONT", pos = Vector(2.355, -1.673, 0), angle = Angle(0, 90, 90), size = Vector(0.224, 0.224, 0.564), color = Color(130, 125, 120, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["METALTOP"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "METALFRONT", pos = Vector(2.826, -7.87, 0), angle = Angle(0, 64.527, 90), size = Vector(0.63, 0.598, 0.63), color = Color(125, 120, 130, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			-- ["METALGASCAN"] = { type = "Model", model = "models/props_c17/canister_propane01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "METALFRONT+", pos = Vector(1.205, -5.669, 0), angle = Angle(90, 0, 0), size = Vector(0.104, 0.105, 0.089), color = Color(110, 100, 90, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["METALFRONT+"] = { type = "Model", model = "models/props_c17/light_decklight01_on.mdl", bone = "v_weapon.Glock_Parent", rel = "METALFRONT", pos = Vector(3.799, 1.751, 0), angle = Angle(180, 0, 0), size = Vector(0.236, 0.621, 0.105), color = Color(110, 100, 90, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} }
		-- }

		-- wept.WElements = {
			-- ["METALSPIKES"] = { type = "Model", model = "models/Mechanics/gears2/pinion_20t1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "METALFRONT", pos = Vector(-0.83, 0, 0), angle = Angle(0, -90, 0), size = Vector(0.347, 0.328, 0.166), color = Color(110, 100, 90, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["projectilepart2"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "projectile", pos = Vector(0, 0, -0.579), angle = Angle(0, 0, 0), size = Vector(0.92, 0.92, 0.09), color = Color(130, 125, 120, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["handle"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "METALback", pos = Vector(2.243, 0, 1.736), angle = Angle(0, 0, 0), size = Vector(0.134, 0.134, 0.085), color = Color(100, 90, 120, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			-- ["METALFRONT"] = { type = "Model", model = "models/props_c17/light_decklight01_on.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(21.676, 0.808, -9.053), angle = Angle(90.266, 0, 90), size = Vector(0.236, 1.067, 0.105), color = Color(110, 100, 90, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["METALback"] = { type = "Model", model = "models/props_combine/combine_interface003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "METALFRONT+", pos = Vector(-6.603, -17.254, 0), angle = Angle(0, 92.513, 90), size = Vector(0.232, 0.043, 0.15), color = Color(105, 100, 110, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			-- ["projectile"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "METALFRONT", pos = Vector(2.355, -6.348, 0), angle = Angle(90, 0, 0), size = Vector(0.224, 0.224, 0.564), color = Color(130, 125, 120, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["METALTOP"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "METALFRONT", pos = Vector(2.826, -11.686, 0), angle = Angle(0, 64.527, 90), size = Vector(0.63, 0.598, 0.63), color = Color(100, 90, 120, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			-- ["METALGASCAN"] = { type = "Model", model = "models/props_c17/canister_propane01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "METALFRONT+", pos = Vector(1.281, -11.554, 0), angle = Angle(90, 0, 0), size = Vector(0.104, 0.105, 0.098), color = Color(110, 100, 90, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} },
			-- ["METALFRONT+"] = { type = "Model", model = "models/props_c17/light_decklight01_on.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "METALFRONT", pos = Vector(3.799, 1.49, 0), angle = Angle(180, 0, 0), size = Vector(0.236, 1.258, 0.105), color = Color(110, 100, 90, 255), surpresslightning = false, material = "models/props_canal/metalwall005b", skin = 0, bodygroup = {} }
		-- }

		-- wept.HUD3DBone = "v_weapon.Glock_Parent"
		-- wept.HUD3DPos = Vector(3.338, -3.442, 1.976)
		-- wept.HUD3DAng = Angle(270, 0, 0)
		-- wept.HUD3DScale = 0.015

		-- wept.GetDisplayAmmo = function(self, clip, spare, maxclip)
			-- local minus = self:GetAltUsage() and 0 or 1
			-- return math.max(0, (clip * 2) - minus), spare * 2, maxclip * 2
		-- end
		
		-- wept.PostDrawViewModel = function(self, vm, pl, wep)
			-- if self.HUD3DPos and GAMEMODE:ShouldDraw3DWeaponHUD() then
				-- local pos, ang = self:GetHUD3DPos(vm)
				-- if pos then
					-- self:Draw3DHUD(vm, pos, ang)
				-- end
			-- end

			-- local lol = self:Clip1() == 0 and 0 or (CurTime() - self:GetLastFired())^1.2
			-- local resize = math.Clamp(lol, 0, 0.224)

			-- local rotsize = self.VElements["projectile"].size
			-- local rotsize2 = self.VElements["projectilepart2"].size
			-- rotsize.x = resize
			-- rotsize.y = resize
			-- rotsize2.y = resize * 4
			-- rotsize2.x = resize * 4

			-- local rots= self.VElements["projectile"].angle
			-- rots.x = rots.x + 1.5
		-- end

		-- local ghostlerp = 0
		-- wept.CalcViewModelView = function(self, vm, oldpos, oldang, pos, ang)
			-- if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
				-- ghostlerp = math.min(1, ghostlerp + FrameTime() * 1)
			-- elseif ghostlerp > 0 then
				-- ghostlerp = math.max(0, ghostlerp - FrameTime() * 1.5)
			-- end

			-- if ghostlerp > 0 then
				-- ang:RotateAroundAxis(ang:Right(), -35 * ghostlerp)
			-- end

			-- return pos, ang
		-- end
	-- end
	-- if SERVER then
		-- wept.Primary.Projectile = "projectile_disc_razor"
	-- end
-- end)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_ripper")

function SWEP:EmitReloadSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/g3sg1/g3sg1_slide.wav", 75, 45, 1, CHAN_WEAPON + 23)
		self:EmitSound("weapons/ump45/ump45_boltslap.wav", 70, 47, 0.85, CHAN_WEAPON + 24)
	end
end

function SWEP:EmitReloadFinishSound()
	if IsFirstTimePredicted() then
		self:EmitSound("weapons/galil/galil_boltpull.wav", 70, 110)
		self:EmitSound("weapons/zs_flak/load1.wav", 75, 100, 0.85, CHAN_WEAPON + 20)
	end
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * 0.25)

	timer.Simple(0.4, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_DRAW)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * 10.5)
		end
	end)

	timer.Simple(0.55, function()
		if IsValid(self) and self:GetOwner() == MySelf and self:Clip1() > 0 then
			self:EmitSound("weapons/zs_flak/load1.wav", 75, 100, 0.85, CHAN_WEAPON + 20)
		end
	end)
end

function SWEP:EmitFireSound(secondary)
	self:EmitSound(secondary and "weapons/stinger_fire1.wav" or "doors/door_metal_thin_close2.wav", 75, secondary and 250 or 70, 0.65)
	self:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, secondary and 105 or 115, 0.55, CHAN_WEAPON + 20)
	self:EmitSound("weapons/zs_flak/shot1.wav", 70, secondary and 65 or 100, 0.65, CHAN_WEAPON + 21)
end

function SWEP:SetLastFired(float)
	self:SetDTFloat(8, float)
end

function SWEP:GetLastFired()
	return self:GetDTFloat(8)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:SetLastFired(CurTime())

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()
	if self:Clip1() <= 1 or not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 1.35)
	self:SetLastFired(CurTime())

	self:EmitFireSound(true)
	self:TakeAmmo(); self:TakeAmmo()

	self.Primary.Projectile = "projectile_flakbomb"
	self.Primary.ProjVelocity = 1000

	self:ShootBullets(self.Primary.Damage, 1, self:GetCone()/2)

	self.Primary.Projectile = "projectile_flak"
	self.Primary.ProjVelocity = 1500

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end
