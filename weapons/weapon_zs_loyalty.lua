AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_loyalty")) -- 'Loyalty' Railgun
SWEP.Description = (translate.Get("desc_loyalty")) -- Экспериментальное оружие, способная заряжать выстрел, при полном заряде наносит урон в радиусе
SWEP.Slot = 3
SWEP.SlotPos = 0

-- Ивент оружие, аналог рельсотрона из Awesome Strike Source, имеет такой же недостаток, как и у ивентового медлуча
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(1.5, 1.6, 0)
	SWEP.HUD3DAng = Angle(0, 90, 90)
	SWEP.HUD3DScale = 0.024

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/rmzs/weapons/mp7/c_surefire.mdl"
SWEP.WorldModel = "models/rmzs/weapons/mp7/w_surefire.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")npc/strider/fire.wav"
SWEP.Primary.Damage = 185
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.ReloadDelay = 1

SWEP.Primary.ClipSize = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 60

SWEP.TracerName = "tracer_railgunhit"

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.Tier = 6
SWEP.ResistanceBypass = 0.1

SWEP.ChargeDelay = 0.12

SWEP.Primary.ProjExplosionRadius = 144
SWEP.Primary.ProjExplosionTaper = 0.85

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, -1, 0)

SWEP.WalkSpeed = SPEED_SLOWER

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09, 1)

function SWEP:TakeAmmo()
	self:TakeCombinedPrimaryAmmo(10)
end

function SWEP:TakeAmmo2()
	self:TakeCombinedPrimaryAmmo(1)
end

function SWEP:Think()
	self:CheckCharge()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end
	elseif self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(self.IdleActivity)
	end
	-- print(self:GetGunCharge())
end

function SWEP:Holster()
	local owner = self.Owner
	if owner and owner:IsValid() then
		owner:RemoveStatus("railgun", false, true)
	end
	return true
end

function SWEP:Reload()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity
	if SERVER and attacker:IsValidLivingHuman() and wep:GetGunCharge() >= 10 then
		local ent = tr.Entity
		local pos = tr.HitPos
		local dmgs = dmginfo:GetDamage() * 0.5
			timer.Simple(0.06, function()
			util.BlastDamagePlayer(dmginfo:GetInflictor(), attacker, tr.HitPos, 192 * (attacker.ExpDamageRadiusMul or 1), dmgs, DMG_ALWAYSGIB)	
			end)
	end
	
	if wep:GetGunCharge() >= 10 then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("explosion_railgun_boom", effectdata)
	end
	return {impact = false}
end

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoCount() <= 0 then
		return false
	end

	if self:GetCharging() or self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() or self:GetCharging() then return end
	if self:GetPrimaryAmmoCount() <= 19 then
		return false
	end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:SetLastChargeTime(CurTime())
	self:TakeAmmo()
	self:SetCharging(true)
end

function SWEP:CheckCharge()
	if self:GetCharging() then
		local owner = self:GetOwner()
		if not owner:KeyDown(IN_ATTACK2) then
			self:EmitFireSound()

			self.FireAnimSpeed = 0.3
			self:ShootBullets(self.Primary.Damage * self:GetGunCharge() * 0.6 , self.Primary.NumShots, self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self.FireAnimSpeed = 1

			self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 1)
			self:SetCharging(false)
			self:SetLastChargeTime(CurTime())
			self:SetGunCharge(0)
		elseif self:GetGunCharge() < 10 and self:GetPrimaryAmmoCount() > 9 and self:GetLastChargeTime() + self.ChargeDelay < CurTime() then
			self.Owner:GiveStatus("railgun")
			self:SetGunCharge(self:GetGunCharge() + 1)
			self:SetLastChargeTime(CurTime())
			self:TakeAmmo2()
		end
	end
end

function SWEP:SetLastChargeTime(lct)
	self:SetDTFloat(1, lct)
end

function SWEP:GetLastChargeTime()
	return self:GetDTFloat(1)
end

function SWEP:SetGunCharge(charge)
	self:SetDTInt(1, charge)
end

function SWEP:GetGunCharge(charge)
	return self:GetDTInt(1)
end

function SWEP:SetCharging(charge)
	self:SetDTBool(1, charge)
end

function SWEP:GetCharging()
	return self:GetDTBool(1)
end

local colBG = Color(16, 16, 16, 90)
local colRed = Color(220, 0, 0, 230)
local colWhite = Color(220, 220, 220, 230)

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
