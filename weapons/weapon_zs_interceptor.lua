AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_interceptor"))
SWEP.Description = (translate.Get("desc_interceptor"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70
	
	SWEP.HUD3DBone = "PPP"
	SWEP.HUD3DPos = Vector(1, -5, -1.5)
	SWEP.HUD3DAng = Angle(0, 180, 180)
	SWEP.HUD3DScale = 0.02

	SWEP.VMPos = Vector(0.5, -3, -0.7)
    SWEP.VMAng = Vector(2, 1, 0)
	
	function SWEP:PreDrawViewModel(vm)
		vm:SetSkin(1)
		--BaseClass.PreDrawViewModel(self, vm)
	end

	function SWEP:DrawWorldModel()
		self:SetSkin(1)
		--BaseClass.DrawWorldModel(self)
	end
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "AUTO"
		elseif self:GetFireMode() == 1 then
			return "CHRG"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Auto"
		elseif self:GetFireMode() == 1 then
			return "Charged Shot"
		end
	end
	--local viewmodel = self:GetOwner():GetViewModel()
end

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/interceptor/c_interceptor_v2.mdl"
SWEP.WorldModel = "models/weapons/interceptor/w_interceptor_v2.mdl"
SWEP.UseHands = true

--SWEP.Primary.Sound = Sound(")weapons/interceptor/interceptor001.wav")
SWEP.Primary.Damage = 80
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.35

SWEP.ResistanceBypass = 0.1
--SWEP.HeadshotMulti = 1.5

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "chemical"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.65
SWEP.ConeMin = 1.275

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.MaxCharge = 10
SWEP.ChargeTime = 0.35
SWEP.ProjectileDamageType = DMG_BULLET
SWEP.IronSightsPos = Vector(-6.15, 0, 0.6)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.08, 1)

SWEP.Recoil = 1.5

SWEP.Primary.Projectile = "projectile_chemball_generic"
SWEP.Primary.ProjVelocity = 1200

function SWEP:Initialize()
	BaseClass.Initialize(self)
	--self:SetLastChargeTime(CurTime())
	self.ChargeSound = CreateSound(self, "ambient/levels/citadel/extract_loop33.wav")
end

function SWEP:EmitFireSound()
	self:EmitSound("^weapons/interceptor/interceptor001.wav", 70, math.random(88, 92), 0.65)
	self:EmitSound("npc/barnacle/barnacle_gulp2.wav", 70, 70, 0.85, CHAN_AUTO + 20)
end

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_interceptor_hot")), (translate.Get("desc_interceptor_hot")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.83
	wept.ProjectileDamageType = DMG_BURN

	wept.EmitFireSound = function(self)
		self:EmitSound("^weapons/interceptor/interceptor001.wav", 70, math.random(112, 128), 0.45)
		self:EmitSound("npc/barnacle/barnacle_gulp2.wav", 70, 70, 0.85, CHAN_AUTO + 20)
	end

	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTInt(5, 1)
		end
	else
		wept.PreDrawViewModel = function(self, vm)
			vm:SetSkin(2)
		end

		wept.DrawWorldModel = function(self)
			self:SetSkin(2)
		end
	end
end)
branch.Colors = {Color(255, 160, 50), Color(215, 120, 50), Color(175, 100, 40)}
branch.NewNames = {"Hot", "Searing", "Torching"}

branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_interceptor_cold")), (translate.Get("desc_interceptor_cold")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.74

	if SERVER then
		wept.EntModify = function(self, ent)
			ent:SetDTInt(5, 2)
		end
	else
		wept.PreDrawViewModel = function(self, vm)
			vm:SetSkin(3)
		end

		wept.DrawWorldModel = function(self)
			self:SetSkin(3)
		end
	end
end)
branch.Colors = {Color(50, 160, 255), Color(50, 130, 215), Color(40, 115, 175)}
branch.NewNames = {"Cold", "Arctic", "Glacial"}

branch = GAMEMODE:AddNewRemantleBranch(SWEP, 3, (translate.Get("wep_interceptor_tri")), (translate.Get("desc_interceptor_tri")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.36
	wept.Primary.NumShots = 3
	wept.ResistanceBypass = 0.7
	wept.Primary.ClipSize = 40
	wept.RequiredClip = 2

	wept.EmitFireSound = function(self)
		self:EmitSound("^weapons/interceptor/interceptor002.wav", 70, math.random(112, 128), 0.45)
		self:EmitSound("npc/barnacle/barnacle_gulp2.wav", 70, 70, 0.85, CHAN_AUTO + 20)
	end

	if SERVER then
		wept.ShootBullets = function(self, damage, numshots, cone)
			local special = self:GetGunCharge() > 1 and true or false
			local count = self:GetGunCharge()
			local owner = self:GetOwner()
			self:SendWeaponAnimation()
			owner:DoAttackEvent()

			if self.Recoil > 0 then
				local r = math.Rand(0.8, 1)
				owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
			end

			for i = 0,numshots-1 do
				local ent = ents.Create(self.Primary.Projectile)
				if ent:IsValid() then
					ent:SetPos(owner:GetShootPos())
					ent:SetAngles(owner:EyeAngles())
					ent:SetOwner(owner)
					ent.ProjDamage = damage or self.Primary.Damage * (owner.ProjectileDamageMul or 1)
					ent.ProjSource = self
					ent.ShotMarker = i
					ent.Team = owner:Team()
					ent.Special = special or false
					ent.ChargeCount = count or 0
						
					ent:SetDTInt(5, (numshots - 1) -i)
						
					self:EntModify(ent)
					ent:Spawn()

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:Wake()

						local angle = owner:GetAimVector():Angle()
						if (numshots -i) == 3 then
							angle:RotateAroundAxis(angle:Right(), 1)
						elseif (numshots -i) == 2 then
							angle:RotateAroundAxis(angle:Up(), 1)
						elseif (numshots -i) == 1 then
							angle:RotateAroundAxis(angle:Up(), -1)
						end

						ent.PreVel = angle:Forward() * self.Primary.ProjVelocity * (owner.ProjectileSpeedMul or 1)
						phys:SetVelocityInstantaneous(ent.PreVel)

						self:PhysModify(phys)
					end
				end
			end
		end
	else
		wept.PreDrawViewModel = function(self, vm)
			vm:SetSkin(4)
		end

		wept.DrawWorldModel = function(self)
			self:SetSkin(4)
		end
	end
end)
branch.Colors = {Color(50, 160, 255), Color(50, 130, 215), Color(40, 115, 175)}
branch.NewNames = {"Focused", "Powerful", "Incredible"}

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end
	if self:GetCharging() then return end
	
	local stbl = E_GetTable(self)

	if (self:Clip1() < stbl.RequiredClip) and self:CanReload() then
		self:Reload()
		return false
	end

	if self:Clip1() < stbl.RequiredClip then
		self:EmitSound(stbl.DryFireSound, 75, 100, 0.7, CHAN_WEAPON)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, stbl.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	if self:GetFireMode() == 0 then
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	elseif self:GetFireMode() == 1 then
		self:SetGunCharge(1)
		self:SetLastChargeTime(CurTime())
		self:SetCharging(true)
		self:TakeAmmo()
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:CallWeaponFunction()
	if self:GetFireMode() == 1 then
		self.Primary.Automatic = false
	elseif self:GetFireMode() == 0 then
		self.Primary.Automatic = true
	end
	self:SetNextPrimaryFire(CurTime() + self:GetReloadTime())
end

--if SERVER then
	function SWEP:ShootBullets(damage, numshots, cone)
		local special = self:GetGunCharge() > 1 and true or false
		local count = self:GetGunCharge()
		local owner = self:GetOwner()
		self:SendWeaponAnimation()
		owner:DoAttackEvent()
		
		if self.Recoil > 0 then
			local r = math.Rand(0.8, 1)
			owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
		end

		local ssfw, ssup
		if self.SameSpread then
			ssfw, ssup = math.Rand(0, 360), math.Rand(-cone, cone)
		end

		for i = 0,(numshots)-1 do
			if SERVER then
				local ent = ents.Create(self.Primary.Projectile)
				if ent:IsValid() then
					ent:SetPos(owner:GetShootPos())
					ent:SetAngles(owner:EyeAngles())
					ent:SetOwner(owner)
					ent.ProjDamage = damage or self.Primary.Damage * (owner.ProjectileDamageMul or 1)
					ent.ProjSource = self
					ent.ShotMarker = i
					ent.Team = owner:Team()
					ent.Special = special or false
					ent.ChargeCount = count or 0

					self:EntModify(ent)
					ent:Spawn()

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:Wake()

						local angle = owner:GetAimVector():Angle()
						angle:RotateAroundAxis(angle:Forward(), ssfw or math.Rand(0, 360))
						angle:RotateAroundAxis(angle:Up(), ssup or math.Rand(-cone, cone))

						ent.PreVel = angle:Forward() * self.Primary.ProjVelocity * (owner.ProjectileSpeedMul or 1)
						phys:SetVelocityInstantaneous(ent.PreVel)

						self:PhysModify(phys)
					end
				end
			end
		end
	end
--end

function SWEP:ProcessCharge()
	if self:GetCharging() then
		if not self:GetOwner():KeyDown(IN_ATTACK) then
			self:EmitFireSound()
			self:ShootBullets(self.Primary.Damage + (self.Primary.Damage * self:GetGunCharge()/10), self.Primary.NumShots, self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()

			self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
			self:SetCharging(false)
			self:SetLastChargeTime(CurTime())
			self:SetGunCharge(0)
		elseif self:GetGunCharge() < self.MaxCharge and self:Clip1() ~= 0 and (self:GetLastChargeTime() + self.ChargeTime) < CurTime() then
			self:SetGunCharge(self:GetGunCharge() + 1)
			self:SetLastChargeTime(CurTime())
			self:TakeAmmo()
		end

		self.ChargeSound:PlayEx(1, math.min(255, 165 + self:GetGunCharge() * 18))
	else
		self.ChargeSound:Stop()
	end
end

function SWEP:Think()
	BaseClass.Think(self)
	if self:GetFireMode() == 1 then
		self:ProcessCharge()
	end
end

sound.Add({
	name = 			"Interceptor.Shoot",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/interceptor/interceptor001.wav"
})

sound.Add({
	name = 			"Interceptor.SlidePull",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/interceptor/slidepull.wav"
})

sound.Add({
	name = 			"Interceptor.SlideBack",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/interceptor/slideback.wav"
})

sound.Add({
	name = 			"Interceptor.ClipIn",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/interceptor/clipin.wav"
})

sound.Add({
	name = 			"Interceptor.ClipOut",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/interceptor/clipout.wav"
})

sound.Add({
	name = 			"Interceptor.Inner",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/interceptor/inner.wav"
})

sound.Add({
	name = 			"Interceptor.Outter",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/interceptor/outter.wav"
})