AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_crackler"))
SWEP.Description = (translate.Get("desc_crackler"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "v_weapon.famas"
	SWEP.HUD3DPos = Vector(1.1, -3.5, 10)
	SWEP.HUD3DScale = 0.02

	SWEP.VMPos = Vector(-1, -3, 0)
	SWEP.VMAng = Vector(0, 0, 0)
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "AUTO"
		elseif self:GetFireMode() == 1 then
			return "BURST"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Auto"
		elseif self:GetFireMode() == 1 then
			return "3 Round-Burst"
		end
	end
end

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_FAMAS.Clipout")

SWEP.SoundFireVolume = 1
SWEP.SoundPitchMin = 100
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = ")weapons/famas/famas-1.wav"
SWEP.Primary.Damage = 17.35
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.16

SWEP.Primary.ClipSize = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ResistanceBypass = 0.8

SWEP.ConeMax = 2.6
SWEP.ConeMin = 1.3

SWEP.ReloadSpeed = 1.1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-2, 1, 1)

SWEP.CantSwitchFireModes = false
SWEP.Primary.BurstShots = 3
SWEP.SetUpFireModes = 1
SWEP.PushFunction = true

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.375, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.2, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_crackler_combat")), (translate.Get("desc_crackler_combat")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 1.2
	wept.Primary.Delay = wept.Primary.Delay * 2
	wept.Primary.BurstShots = 1
	wept.Primary.ClipSize = 15
	wept.ConeMin = wept.ConeMin * 0.7
	wept.ConeMax = wept.ConeMax * 0.7
	wept.InnateBounty = true
	wept.BountyDamage = 0.52
	wept.Primary.Automatic = false
	wept.CantSwitchFireModes = true
end)

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, "'Dubler' Assault Rifle", "Имеет пониженный урон, но стреляет по 2 пули сразу", function(wept)
	wept.Primary.Sound = ""
	wept.Primary.Damage = wept.Primary.Damage * 0.583
	wept.Primary.BurstShots = 1
	wept.Primary.Delay = wept.Primary.Delay * 1.25
	wept.Primary.NumShots = 2
	wept.Primary.ClipSize = 19
	wept.ConeMin = wept.ConeMin * 1.5
	wept.ConeMax = wept.ConeMax * 1.31
	wept.Primary.Automatic = true
	wept.CantSwitchFireModes = true
	wept.CSRecoilMul = 1
	
	wept.IronSightsPos = Vector(-2, 1, 1)
	wept.IronSightsAng = Vector(0, 0, 0)
	
	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/famas/famas-1.wav", 75, math.random(120, 135), 0.8)
		self:EmitSound("npc/sniper/echo1.wav", 75, math.random(81, 85), 1, CHAN_WEAPON+20)
	end
	
	if CLIENT then
	
		wept.VMPos = Vector(-1, -3, 0)
		wept.VMAng = Angle(0, 0, 0)
		local uBarrelOrigin = wept.VMPos
		local lBarrelOrigin = Vector(0, 0, 0)
		local BarAngle = Angle(0, 0, 0)
		wept.Think = function(self)
			BaseClass.Think(self)
			 if (self.IsShooting >= CurTime()) and self:GetIronsights() then
				self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(0, 0, 0) )
				self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -3, 0) )
			else
				self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
				self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
			end
		end	
	
		wept.VElements = {
			["underside"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 5.438, 8.074), angle = Angle(0, 0, 88), size = Vector(0.024, 0.021, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scope"] = { type = "Model", model = "", bone = "v_weapon.famas", rel = "", pos = Vector(0.082, -5.666, 9.55), angle = Angle(0, 0, 1.254), size = Vector(0.025, 0.025, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["back"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.104, -1.573, 10.755), angle = Angle(90, 90.005, 0), size = Vector(0.361, 0.476, 0.597), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["midsection"] = { type = "Model", model = "models/props_combine/eli_pod_inner.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 3.048, 13.31), angle = Angle(0.15, 90, 180), size = Vector(0.15, 0.107, 0.194), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["dulo"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_short.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.269, -1.272, 26.5), angle = Angle(0.929, -16.264, 90.489), size = Vector(0.13, 0.2, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, bonemerge = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["dulo+"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_short.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.286, -0.393, 26.521), angle = Angle(0.929, -16.264, 90.489), size = Vector(0.13, 0.2, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, bonemerge = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["collimator"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.085, -4.926, 11.99), angle = Angle(-0.063, 0.236, -89.618), size = Vector(0.037, 0.611, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, bonemerge = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/hunter/blocks/cube075x1x025.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.173, -5.418, 11.837), angle = Angle(-1.136, -1.192, -2.672), size = Vector(0.02, 0.02, 0.02), color = Color(255, 255, 255, 255), surpresslightning = false, bonemerge = false, material = "models/weapons/v_smg1/texture5", skin = 0, bodygroup = {} },
			["plaster"] = { type = "Model", model = "models/hunter/blocks/cube025x150x025.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.697, -3.837, 11.968), angle = Angle(-0.255, 0.835, -89.115), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, bonemerge = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["plaster+"] = { type = "Model", model = "models/hunter/blocks/cube025x150x025.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.702, -3.727, 18.168), angle = Angle(-0.255, 0.835, -89.115), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, bonemerge = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["plaster++"] = { type = "Model", model = "models/hunter/blocks/cube025x150x025.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.705, -3.017, 22.352), angle = Angle(-0.481, 0.843, -0.102), size = Vector(0.1, 0.05, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, bonemerge = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
		}

		wept.WElements = {
			["underside"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 6.301, 10.373), angle = Angle(0, 0, 88), size = Vector(0.025, 0.027, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_c17/playground_teetertoter_stan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0.8, 1.815), angle = Angle(0, 0, -90), size = Vector(0.024, 0.239, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scope"] = { type = "Model", model = "", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.99, 0.794, -8.33), angle = Angle(0, -90, -99.326), size = Vector(0.025, 0.025, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["back"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 4.708, 1.435), angle = Angle(90, 90.005, 0), size = Vector(0.361, 0.583, 0.708), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["midsection"] = { type = "Model", model = "models/props_combine/eli_pod_inner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 3.368, 17.281), angle = Angle(0.15, 90, 180), size = Vector(0.185, 0.151, 0.245), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
		}

		wept.HUD3DBone = "v_weapon.famas"
		wept.HUD3DPos = Vector(-0.2, -4, 8.6)
		wept.HUD3DAng = BaseClass.HUD3DAng
	end
end)

local branch2 = GAMEMODE:AddNewRemantleBranch(SWEP, 3, (translate.Get("wep_bastard")), (translate.Get("desc_bastard")), "weapon_zs_bastard")
branch2.NewNames = {"Fixed", "Modified", "Сompleted"}

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	if self:GetFireMode() == 0 then
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	elseif self:GetFireMode() == 1 then
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 3.4)
		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)
		self:EmitFireSound()
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
	BaseClass.Think(self)
	if self:GetFireMode() == 1 then
		self:ProcessBurstFire(3)
	elseif self:GetFireMode() == 2 then
		self:ProcessCharge()
	end
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.ConeMin = self.ConeMinSave
		self.ConeMax = self.ConeMaxSave
		self:EmitSound("Weapon_SMG1.Special1")
		self:RecalculateCSBurstFire(false)
	elseif self:GetFireMode() == 1 then
		self.ConeMin = self.ConeMinSave * 0.95
		self.ConeMax = self.ConeMaxSave * 0.9
		self:EmitSound("Weapon_SMG1.Special1")
		self:RecalculateCSBurstFire(true)
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
end

--[[
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_crackler_burst")), (translate.Get("desc_crackler_burst")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 1.06
	wept.Primary.Delay = wept.Primary.Delay * 6
	wept.Primary.BurstShots = 3
	wept.ConeMin = wept.ConeMin * 0.5
	wept.ConeMax = wept.ConeMax * 0.7
	wept.Primary.ClipSize = 18

	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitFireSound()

		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	wept.Think = function(self)
		BaseClass.Think(self)

		self:ProcessBurstFire()
	end

	wept.ViewModel = "models/weapons/cstrike/c_rif_famas.mdl"
	wept.WorldModel = "models/weapons/w_rif_famas.mdl"

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/famas/famas-1.wav", 75, math.random(80, 85), 0.8)
	end

	if CLIENT then
		wept.VElements = {
			["underside"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 5.438, 8.074), angle = Angle(0, 0, 88), size = Vector(0.024, 0.021, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scopeback+"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0, 4.012), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["mid"] = { type = "Model", model = "models/props_phx/trains/double_wheels.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0.726, 0.008, 1.82), angle = Angle(90, 90, -90), size = Vector(0.02, 0.02, 0.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_borealis/mooring_cleat01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0, 1.815), angle = Angle(0, 0, -90), size = Vector(0.048, 0.039, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scopeback"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0, -0.29), angle = Angle(180, 0, 0), size = Vector(0.025, 0.025, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["glass"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0, -0.285), angle = Angle(90, 0, 0), size = Vector(0.123, 0.023, 0.023), color = Color(0, 0, 115, 255), surpresslightning = false, material = "models/props/cs_office/snowmana", skin = 0, bodygroup = {} },
			["scope"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.082, -5.666, 9.55), angle = Angle(0, 0, 1.254), size = Vector(0.025, 0.025, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["back"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.104, -1.573, 10.755), angle = Angle(90, 90.005, 0), size = Vector(0.361, 0.476, 0.597), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["hold"] = { type = "Model", model = "models/props_c17/playgroundTick-tack-toe_post01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 0.694, 1.85), angle = Angle(0, 0, -90), size = Vector(0.152, 0.041, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["midsection"] = { type = "Model", model = "models/props_combine/eli_pod_inner.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scope", pos = Vector(0, 3.048, 13.31), angle = Angle(0.15, 90, 180), size = Vector(0.15, 0.107, 0.194), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
		}
		wept.WElements = {
			["underside"] = { type = "Model", model = "models/props_combine/combine_train02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 6.301, 10.373), angle = Angle(0, 0, 88), size = Vector(0.025, 0.027, 0.01), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scopeback+"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, 4.012), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["mid"] = { type = "Model", model = "models/props_phx/trains/double_wheels.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0.811, -0.03, 1.82), angle = Angle(90, 90, -90), size = Vector(0.02, 0.02, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["top"] = { type = "Model", model = "models/props_borealis/mooring_cleat01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, 1.815), angle = Angle(0, 0, -90), size = Vector(0.048, 0.039, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["scopeback"] = { type = "Model", model = "models/props_wasteland/laundry_basket001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, -0.29), angle = Angle(180, 0, 0), size = Vector(0.025, 0.025, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["glass"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, -0.424), angle = Angle(90, 0, 0), size = Vector(0.123, 0.023, 0.023), color = Color(0, 0, 115, 255), surpresslightning = false, material = "models/props/cs_office/snowmana", skin = 0, bodygroup = {} },
			["scope"] = { type = "Model", model = "models/hunter/tubes/tube1x1x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.99, 0.794, -8.33), angle = Angle(0, -90, -99.326), size = Vector(0.025, 0.025, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["back"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 4.708, 1.435), angle = Angle(90, 90.005, 0), size = Vector(0.361, 0.583, 0.708), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["hold"] = { type = "Model", model = "models/props_c17/playgroundTick-tack-toe_post01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0.694, 1.85), angle = Angle(0, 0, -90), size = Vector(0.152, 0.041, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["midsection"] = { type = "Model", model = "models/props_combine/eli_pod_inner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 3.368, 17.281), angle = Angle(0.15, 90, 180), size = Vector(0.185, 0.151, 0.245), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
			["glass+"] = { type = "Model", model = "models/XQM/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(0, 0, 4.243), angle = Angle(90, 0, 0), size = Vector(0.123, 0.023, 0.023), color = Color(0, 0, 115, 255), surpresslightning = false, material = "models/props/cs_office/snowmana", skin = 0, bodygroup = {} }
		}

		wept.HUD3DBone = "v_weapon.famas"
		wept.HUD3DPos = Vector(-0.2, -4, 8.6)
		wept.HUD3DAng = BaseClass.HUD3DAng

		wept.IronsightsMultiplier = 0.25

		wept.GetViewModelPosition = function(self, pos, ang)
			if GAMEMODE.DisableScopes then return end

			if self:IsScoped() then
				return pos + ang:Up() * 256, ang
			end

			return BaseClass.GetViewModelPosition(self, pos, ang)
		end

		wept.DrawHUDBackground = function(self)
			if GAMEMODE.DisableScopes then return end

			if self:IsScoped() then
				self:DrawRegularScope()
			end
		end
	end
end)
branch.Colors = {Color(110, 160, 170), Color(90, 140, 150), Color(70, 120, 130)}
branch.NewNames = {"Focused", "Transfixed", "Orphic"}
branch.Killicon = "weapon_zs_battlerifle"
]]

--[[
function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end
]]
