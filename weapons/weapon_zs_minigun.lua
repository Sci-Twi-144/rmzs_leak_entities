AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_bulwark"))
SWEP.Description = (translate.Get("desc_bulwark"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "root"
	SWEP.HUD3DPos = Vector(1.4, -7, -15)
	SWEP.HUD3DAng = Angle(180, 0,  0--[[-15]])
	SWEP.HUD3DScale = 0.04

	local colBG = Color(16, 16, 16, 90)
	local colRed = Color(220, 0, 0, 230)
	local colWhite = Color(220, 220, 220, 230)

    SWEP.VMPos = Vector(0, 0, -1)
    SWEP.VMAng = Vector(2, 1, -6)


	function SWEP:Draw2DHUD()
		local screenscale = BetterScreenScale()

		local wid, hei = 180 * screenscale, 64 * screenscale
		local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
		local spare = self:GetPrimaryAmmoCount()

		draw.RoundedBox(16, x, y, wid, hei, colBG)
		draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function SWEP:Draw3DHUD(vm, pos, ang)
		local wid, hei = 180, 64
		local x, y = wid * -0.6, hei * -0.5
		local spare = self:GetPrimaryAmmoCount()

		cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
			draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
			draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.652, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.301), angle = Angle(0, 0, 75) },
		["ValveBiped.Bip01_L_Ulna"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 45) },
		["block"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/rmzs/gshg/c_gshg_bis.mdl"
SWEP.WorldModel = "models/weapons/rmzs/gshg/w_gshg.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 21
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.21

SWEP.Primary.ClipSize = 150
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Secondary.Automatic = true

SWEP.ConeMax = 6.15
SWEP.ConeMin = 5.25

SWEP.Recoil = 0.21

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.SPEEN1 = 0
SWEP.Heat = 0
SWEP.Time = 0
SWEP.Texturemulti = 0
SWEP.HeatBuildShort = 0
SWEP.Shoot = false
SWEP.Shoot1 = false
SWEP.Shoot2 = false
SWEP.Branch1 = false
SWEP.Branch2 = false

SWEP.HasAbility = false

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.769)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.656)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RECOIL, -0.07, 1)

local texture = Material( "models/weapons/rmzs/gshg/gshg_main.vmt" )
local texture2 = Material( "models/weapons/rmzs/gshg/gshg_bright.vmt" )
local texture3 = Material( "models/weapons/rmzs/gshg/gshg_wheat.vmt" )
local uBarrelOrigin = Vector(0, 0, -1)

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	texture:SetFloat("$detailblendfactor", 0)
	texture2:SetFloat("$detailblendfactor", 0)
	texture3:SetFloat("$detailblendfactor", 0)

	self.ChargeSound = CreateSound(self, "ambient/machines/spin_loop.wav")
end

function SWEP:Think()
	self.BaseClass.Think(self)

	self.SPEEN1 = self.SPEEN1 + 20 * self:GetSpool()

	if CLIENT then
		self.ViewModelBoneMods["block"].angle = Angle(0, 0 - self.SPEEN1, 0)
	end

	self:CheckSpool()

	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if not CLIENT then return end

	if self.Shoot then
		self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(math.random(-0.5, 0.5), -5, -1) )
	else
		self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
	end
	self.Shoot = false
end


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	if not self:GetSpooling() then
		self:SetSpooling(true)
		self:EmitSound("ambient/machines/spinup.wav", 75, 65)
		self:GetOwner():ResetSpeed()

		self:SetNextPrimaryFire(CurTime() + 0.75)
	else
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self.CSRecoilPower = self:GetFireDelay() * 1.5

		self.Shoot = true
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	if not self:GetSpooling() then
		self:SetSpooling(true)
		self:EmitSound("ambient/machines/spinup.wav", 75, 65)
		self:GetOwner():ResetSpeed()

		self:SetNextPrimaryFire(CurTime() + 0.75)
	else
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:TakeAmmo()
	self:TakeCombinedPrimaryAmmo(1)
end

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoCount() <= 0 then
		return false
	end

	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:GetWalkSpeed()
	return self.BaseClass.GetWalkSpeed(self) * (self:GetSpooling() and 0.5 or 1)
end

function SWEP:EmitFireSound()
	if self.Branch2 then
		self:EmitSound("weapons/gshg/gshg_auto.wav", 85, 100, 1, CHAN_WEAPON + 20)
	elseif self.Branch1 then
		if self:GetTumbler() then
			self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 75, math.random(50, 55), 0.6, CHAN_WEAPON + 20)
			self:EmitSound("weapons/m249/m249-1.wav", 75, math.random(50, 55), 0.65, CHAN_WEAPON + 20)
		else
			self:EmitSound("weapons/robotnik_bo1_psg1/fire.wav", 60, math.random(100, 125), 0.6, CHAN_WEAPON + 20)
		end
	else
		self:EmitSound("weapons/m249/m249-1.wav", 75, math.random(86, 89), 0.65)
		self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 75, math.random(122, 125), 0.6, CHAN_WEAPON + 20)
	end
end

function SWEP:CheckSpool()
	if self:GetSpooling() then
		if not self:GetOwner():KeyDown(IN_ATTACK) and not self:GetOwner():KeyDown(IN_ATTACK2) then
			self:SetSpooling(false)
			self:GetOwner():ResetSpeed()
			self:SetNextPrimaryFire(CurTime() + 0.75)
			self:EmitSound("ambient/machines/spindown.wav", 75, 150)
		else
			self:SetSpool(math.min(self:GetSpool() + FrameTime() * 0.12, 1))
		end

		self.ChargeSound:PlayEx(1, math.min(255, 65 + self:GetSpool() * 25))
	else
		self:SetSpool(math.max(0, self:GetSpool() - FrameTime() * 0.36))
		self.ChargeSound:Stop()
	end
end

function SWEP:Reload()
end

function SWEP:Holster()
	self.ChargeSound:Stop()

	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self.ChargeSound:Stop()
end

function SWEP:OnZombieKilled()
	if self.Branch2 then
		self:SetHeat(math.max(self:GetHeat() - 0.0085, 0))
	end
end

function SWEP:GetFireDelay()
	return self.BaseClass.GetFireDelay(self) - (self:GetSpool() * 0.15)
end

--based bulwark
function SWEP:SetSpool(spool)
	self:SetDTFloat(9, spool)
end

function SWEP:GetSpool()
	return self:GetDTFloat(9)
end

function SWEP:SetSpooling(isspool)
	self:SetDTBool(8, isspool)
end

function SWEP:GetSpooling()
	return self:GetDTBool(8)
end

-- branches
function SWEP:SetHeat(heat)
	self:SetDTFloat(10, heat)
end

function SWEP:GetHeat()
	return self:GetDTFloat(10)
end

function SWEP:SetValMulti(value)
	self:SetDTFloat(11, value)
end

function SWEP:GetValMulti()
	return self:GetDTFloat(11)
end
--

local branch1 = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_bulwark")), (translate.Get("desc_bulwark2")), function(wept)
	if CLIENT then
		local colBG = Color(16, 16, 16, 90)
		local colRed = Color(220, 0, 0, 230)
		local colWhite = Color(220, 220, 220, 230)

		wept.Draw2DHUD = function(self)
			local screenscale = BetterScreenScale()

			local wid, hei = 180 * screenscale, 64 * screenscale
			local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
			local spare = self:GetPrimaryAmmoCount()

			self:DrawAbilityBar2D(x, y, hei, wid, Color(255, 0, 0), self:GetHeat(), 1, self:GetTumbler() and "OVERHEAT" or "HEAT")

			draw.RoundedBox(16, x, y, wid, hei, colBG)
			draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		wept.Draw3DHUD = function(self, vm, pos, ang)
			local wid, hei = 180, 64
			local x, y = wid * -0.6, hei * -0.5
			local spare = self:GetPrimaryAmmoCount()

			cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
				self:DrawAbilityBar3D(x, y - 30, hei, wid, Color(255, 0, 0), self:GetHeat(), 1, self:GetTumbler() and "OVERHEAT" or "HEAT")

				draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
				draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end

	wept.Primary.Damage = 19
	wept.Primary.NumShots = 1
	wept.Primary.Delay = 0.033
	wept.HeatBuildShort = 0.07

	wept.HasAbility = true
	wept.Branch1 = true

	wept.ResistanceBypass = 1

	wept.WalkSpeed = SPEED_SLOWEST
	wept.CSRecoilMul = 1.3

	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_SHORT_TEAM_HEAT, -0.01, 3, branch1)

	wept.SecondaryAttack = function(self)
	end

	wept.BulletCallback = function(attacker, tr, dmginfo)
		local wep = dmginfo:GetInflictor()
	
		if SERVER and ent:IsValidLivingZombie() and wep:IsValid() then
			local owner = wep:GetOwner()
			if wep:GetTumbler() then
				local pos = tr.HitPos
					util.BlastDamagePlayer(dmginfo:GetInflictor(), owner, pos, 48, dmginfo:GetDamage() * 2.5, DMG_ALWAYSGIB, 0.8)
				for _, ent2 in pairs(util.BlastAlloc(self, owner, pos, 48)) do
					if ent2:IsValidLivingZombie () then
						ent2:ApplyZombieDebuff("zombiestrdebuff", 5, {Applier = owner, Damage = 1.25}, true, 35)
					end
				end
			end
		end
	end
	
	wept.AddCSTimers = function(self)
		local flatcsrecoil = math.max(self:GetDTFloat(26) - CurTime(), 0)
		local csrecoil = self:GetCSRecoil()
		local minigunshit = (self:GetTumbler() and 0.25 or (self:GetFireDelay() + self:GetHeat()/20))/self.Primary.Delay
		self:SetCSRecoil(math.min(csrecoil + self.CSRecoilPower * minigunshit, 1 + self.Primary.Delay * minigunshit))
	end

	wept.Think = function(self)
		self.BaseClass.Think(self)
	
		self.SPEEN1 = self.SPEEN1 + 20 * self:GetValMulti()
	
		if self:GetTumbler() or (CurTime() > self.Time and self.Shoot) then
			local heatcountd = self:GetTumbler() and 0.010 or 0.015
	
			self:SetHeat(math.max(self:GetHeat() - heatcountd, 0))
			self:SetValMulti(math.max(self:GetValMulti() - 0.02, 0))
	
			if self:GetHeat() <= 0 and self:GetValMulti() <= 0 then
				self.Shoot = false
				self:SetHeat(0)
				self:SetValMulti(1)
				self.ResistanceBypass = 1
			end
	
			if self:GetHeat() <= 0 then
				self:SetTumbler(false)
				self.Recoil = 0
				self.TracerName = "Tracer"
			end
		end
	
		if CLIENT and self.Shoot then
			self.ViewModelBoneMods["block"].angle = Angle(0, 0 - self.SPEEN1, 0)
		end
	
		if self.IdleAnimation and self.IdleAnimation <= CurTime() then
			self.IdleAnimation = nil
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	
		self.Texturemulti = self:GetHeat()
		texture:SetFloat("$detailblendfactor", self.Texturemulti)
		texture2:SetFloat("$detailblendfactor", self.Texturemulti)
		texture3:SetFloat("$detailblendfactor", self.Texturemulti)
	
		if not CLIENT then return end
	
		if self.Shoot2 then
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(math.random(-0.5, 0.5), -5, -1) )
		else
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
		end
		self.Shoot2 = false
	end
	
	
	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end
	
		self.Time = CurTime() + 1
		if not self:GetTumbler() then
			self:SetHeat(math.min(self:GetHeat() + self.HeatBuildShort/25, 1))
		end
		self:SetValMulti(1)
	
		local rvalue = self:GetHeat() / 20 --((self:GetHeat() < 0.82) and 22 or 14)
	
		if self:GetHeat() >= 1 then
			self:SetTumbler(true)
			self.Recoil = 3
			self.TracerName = "tracer_firebullet"
		end
	
		self.ResistanceBypass = math.max(1 - self:GetHeat(), .5)
		self.Shoot = true
		self.Shoot2 = true
		self:SetNextPrimaryFire(CurTime() + (self:GetTumbler() and 0.25 or self:GetFireDelay() + rvalue))
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end)
branch1.Colors = {Color(130, 205, 240), Color(86, 136, 160), Color(43, 68, 80)}

local branch2 = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_bulwark2")), (translate.Get("desc_bulwark3")), function(wept)
	if CLIENT then
		local colBG = Color(16, 16, 16, 90)
		local colRed = Color(220, 0, 0, 230)
		local colWhite = Color(220, 220, 220, 230)

		wept.Draw2DHUD = function(self)
			local screenscale = BetterScreenScale()

			local wid, hei = 180 * screenscale, 64 * screenscale
			local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
			local spare = self:GetPrimaryAmmoCount()

			self:DrawAbilityBar2D(x, y, hei, wid, Color(255, 0, 0), self:GetHeat(), 1, self:GetTumbler() and "OVERHEAT" or "HEAT")

			draw.RoundedBox(16, x, y, wid, hei, colBG)
			draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		wept.Draw3DHUD = function(self, vm, pos, ang)
			local wid, hei = 180, 64
			local x, y = wid * -0.6, hei * -0.5
			local spare = self:GetPrimaryAmmoCount()

			cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
				self:DrawAbilityBar3D(x, y - 30, hei, wid, Color(255, 0, 0), self:GetHeat(), 1, self:GetTumbler() and "OVERHEAT" or "HEAT")

				draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
				draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end

	wept.Primary.Damage = 21 / 3
	wept.Primary.NumShots = 3
	wept.Primary.Delay = 0.0610
	wept.HeatBuildShort = 0.17

	wept.ConeMax = 6.15 * 1.1
	wept.ConeMin = 5.25 * 1.1

	wept.HasAbility = true
	wept.Branch2 = true

	wept.WalkSpeed = SPEED_SLOWEST

	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_SHORT_TEAM_HEAT, -0.02, 3, branch2)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_MAX_SPREAD, -0.350, 2, branch2)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_MIN_SPREAD, -0.325, 2, branch2)

	wept.SecondaryAttack = function(self)
	end

	wept.Think = function(self)
		self.BaseClass.Think(self)
	
		self.SPEEN1 = self.SPEEN1 + 20 * self:GetValMulti()
	
		if self:GetTumbler() or (CurTime() > self.Time and self.Shoot) then
			local heatcountd = self:GetTumbler() and 0.008 or 0.015
	
			self:SetHeat(math.max(self:GetHeat() - heatcountd, 0))
			self:SetValMulti(math.max(self:GetValMulti() - 0.02, 0))
	
			if self:GetHeat() <= 0 and self:GetValMulti() <= 0 then
				self.Shoot = false
				self:SetHeat(0)
				self:SetValMulti(1)
			end
	
			if self:GetHeat() <= 0 then
				self:SetTumbler(false)
			end
		end

		if CLIENT and self.Shoot then
			self.ViewModelBoneMods["block"].angle = Angle(0, 0 - self.SPEEN1, 0)
		end

		if self.IdleAnimation and self.IdleAnimation <= CurTime() then
			self.IdleAnimation = nil
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	
		self.Texturemulti = self:GetHeat()
		texture:SetFloat("$detailblendfactor", self.Texturemulti)
		texture2:SetFloat("$detailblendfactor", self.Texturemulti)
		texture3:SetFloat("$detailblendfactor", self.Texturemulti)
	
		if not CLIENT then return end
	
		if self.Shoot2 then
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(math.random(-0.5, 0.5), -5, -1) )
		else
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
		end
		self.Shoot2 = false
	end

	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() or self:GetTumbler() then return end
	
		self.Time = CurTime() + 1
		self:SetHeat(math.min(self:GetHeat() + self.HeatBuildShort/25, 1))
		self:SetValMulti(1)
		local owner = self:GetOwner()
		if self:GetHeat() >= 1 then
			self:SetTumbler(true)
			self:EmitSound("npc/scanner/scanner_siren1.wav", 75)
			if SERVER then 
				owner:TakeDamage(25 * (owner.SelfDamageMul or 0)) 
			end
		end
	
		self.Shoot = true
		self.Shoot2 = true
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end)
branch2.Colors = {Color(200, 0, 0), Color(150, 0, 0), Color(100, 0, 0)}