AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_surefire"))
SWEP.Description = (translate.Get("desc_surefire"))
SWEP.Slot = 3
SWEP.SlotPos = 0

-- Ивент оружие, аналог рельсотрона из Awesome Strike Source, имеет такой же недостаток, как и у ивентового медлуча
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(1.5, 1.6, 0)
	SWEP.HUD3DAng = Angle(0, 90, 90)
	SWEP.HUD3DScale = 0.017

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
SWEP.Primary.Damage = 45
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.ReloadDelay = 1

SWEP.Primary.ClipSize = 40
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 40

SWEP.TracerName = "tracer_surefire"
SWEP.Tracer = 50

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.Tier = 6
SWEP.ResistanceBypass = 0.4

SWEP.ChargeDelay = 0.12

SWEP.Primary.ProjExplosionRadius = 144
SWEP.Primary.ProjExplosionTaper = 0.85

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, -1, 0)

SWEP.WalkSpeed = SPEED_SLOWER

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.135)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.09, 1)

local texture = Material("models/weapons/v_smg1_new/plasma_collector")

function SWEP:Initialize()
	if CLIENT then
		texture:SetFloat("$emissiveblendtint", 0)
	end
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "weapons/gauss/chargeloop.wav")
end

function SWEP:Think()

	--self:CheckCharge()
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
	if CLIENT then
		texture:SetFloat("$emissiveblendtint", (self:GetGunCharge()))
	end
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	if self.Recoil > 0 then
		local r = math.Rand(0.8, 1)
		owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
	end

	if self.PointsMultiplier then
		POINTSMULTIPLIER = self.PointsMultiplier
	end

	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)

	if self.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = attacker:GetActiveWeapon()
	if SERVER then
		local ent = tr.Entity
		local pos = tr.HitPos
			timer.Simple(0.06, function()
			util.BlastDamageExAlloc(attacker:GetActiveWeapon(), attacker, pos, 144, dmginfo:GetDamage() * 0.5, DMG_ALWAYSGIB)
			end)
	end
	
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("hit_surefire", effectdata)
	return {impact = false}
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		return false
	end

	if self:GetCharging() or self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() or self:GetCharging() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	
	self:SetCharging(true)
end

function SWEP:CheckCharge()
	if self:GetCharging() then
		local owner = self:GetOwner()
		if not owner:KeyDown(IN_ATTACK) then
			self:EmitFireSound()

			self.FireAnimSpeed = 0.3
			self:ShootBullets(self.Primary.Damage * self:GetGunCharge() * 0.6 , self.Primary.NumShots, self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self.FireAnimSpeed = 1

			self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 1)
			self:SetCharging(false)
			self:SetLastChargeTime(CurTime())
			self:SetGunCharge(0)
		elseif self:GetGunCharge() < 4 and self:Clip1() > 0 and self:GetLastChargeTime() + self.ChargeDelay < CurTime() then
			-- self.Owner:GiveStatus("surefire")
			-- local ent = ents.Create("ent_railgun")
			self:SetGunCharge(self:GetGunCharge() + 1)
			self:SetLastChargeTime(CurTime())
			self:TakeAmmo()
		end
		self.ChargeSound:PlayEx(1, math.min(255, 47 + self:GetGunCharge() * 16))
		else
		self.ChargeSound:Stop()
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
