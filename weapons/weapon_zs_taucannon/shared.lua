DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_xvl1456"))--"'XVL1456' Tau Particle accelerator"
SWEP.Description = (translate.Get("desc_xvl1456"))--"Man, why aren't we using it?! It's much too unpreductable. Don't let it overcharge! Wha...? What d'ya mean overchar...."
SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.HoldType = "physgun"

SWEP.ViewModel = "models/weapons/c_gauss.mdl"
SWEP.WorldModel = "models/weapons/w_gauss_mp.mdl"
SWEP.UseHands = true

SWEP.Primary.KnockbackScale = 1

SWEP.Primary.Sound = Sound("")
SWEP.Primary.Damage = 98
--SWEP.Secondary.Damage = 125
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.HeatBuildShort = 0.045
SWEP.PowerAccumulation = 0.105
SWEP.ChargeAnimSpeed = 1

SWEP.TracerName = "tracer_gauss"

SWEP.ConeMax = 2
SWEP.ConeMin = 1

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.SpinSpeed = 1
SWEP.SpinAng = 0
SWEP.Vent = 0.3
SWEP.Tier = 6
SWEP.MaxStock = 2
SWEP.Primary.HullSize = nil

SWEP.HeadshotMulti = 1.75

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_vanquisher")), (translate.Get("desc_vanquisher")), function(wept)
	wept.HeatBuildShort = wept.HeatBuildShort * 2
	wept.Primary.Damage = wept.Primary.Damage * 2
	wept.Primary.Delay = wept.Primary.Delay * 2

	wept.ConeMin = wept.ConeMin * 2
	wept.ConeMax = wept.ConeMax * 2
	
	wept.Primary.HullSize = 1
	wept.Pierces = 2
	wept.DamageTaper = 0.6
	
	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 2.6)
		self:SetChargePower(self:GetChargePower() + self.HeatBuildShort)--0.023
		self.SpinSpeed = 15
		self:EmitSound("weapons/tau/single0"..math.random(1,3)..".ogg")
		self:TakePrimaryAmmo(6)
		self:ShootBullets(self:TauDamage(false), self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(CurTime() + 1.5)
	end
	wept.Think = function(self)
		local BaseClass = baseclass.Get("weapon_zs_taucannon")
		BaseClass.Think(self)
		if self:GetHeatState() == 0 or self:GetHeatState() == 1 then
			self.SpinSpeed = 7.5
		else
			self.SpinSpeed = self.SpinSpeed
		end
	end	
	wept.SecondaryAttack = function(self) end
end)
branch.Colors = {Color(110, 160, 170), Color(90, 140, 150), Color(70, 120, 130)}
branch.NewNames = {"Powered", "Transfixed", "Decisive"}

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
	
	local owner = self:GetOwner()
	if not self.PostOwner then
		self.PostOwner = owner
	end
	
	local timediff = owner.TauInactiveTime and CurTime() - owner.TauInactiveTime or 0
	self:SetChargePower(math.Clamp((owner.TauHeat or 0) - timediff * self.Vent, 0, 1))
	
	if self:GetChargePower() > 0.5 then
		self:SetHeatState(2)
		self:EmitSound("npc/scanner/scanner_siren1.wav")
	end
	
--	if CLIENT then return true end
--	self:GetOwner():GiveAmmo(self:Clip1(), self.Primary.Ammo)
--	self:SetClip1(0)
	return true
end

function SWEP:Initialize()
	self.TauChargeSound = CreateSound(self, "weapons/tau/gauss_spinup.wav")
	self.TauChargeSound:SetSoundLevel(60)

	self.TauOverChargeSound = CreateSound(self, "weapons/tau/gauss_overcharging.wav")
	self.TauOverChargeSound:SetSoundLevel(60)
	
	if CLIENT then self.TauVentingSound = CreateSound(self, "weapons/tau/tau_venting.wav") end

	self.BaseClass.Initialize(self)

	local ENTITY = self

	hook.Add("Think", tostring(ENTITY), function() if not IsValid(ENTITY) then return end ENTITY:HolsterThink() end)
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP.BulletCallback(attacker, tr, dmginfo)
	ParticleEffect( "tau_beam_balls_bounce", tr.HitPos, attacker:EyeAngles(), self )
	ParticleEffect( "tau_beam_balls", tr.HitPos, attacker:EyeAngles(), self )
	
	if tr.HitWorld then
		util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
 
	local wep = attacker:GetActiveWeapon()
	local stbl = E_GetTable(wep)
	local dmg = wep:TauDamage(true)

	--[[if wep and wep:IsValid() and wep:GetHolding() then

		if SERVER then
			local ent = ents.Create("projectile_tauball_regular")
			if ent:IsValid() then
				ent:SetPos(tr.HitPos)
				ent:SetAngles(attacker:EyeAngles())
				ent:SetOwner(attacker)
				ent.ProjDamage = dmg * (attacker.ProjectileDamageMul or 1)
				ent.ProjSource = wep
				ent.ProjTaper = wep.Primary.ProjExplosionTaper
				ent.Team = attacker:Team()
				ent:Spawn()
		
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
		
					local angle = attacker:GetAimVector():Angle()
					ent.PreVel = angle:Forward() * 2500 * (attacker.ProjectileSpeedMul or 1)
					phys:SetVelocityInstantaneous(ent.PreVel)
				end
			end
		end
		return {impact = false, ragdoll_impact = false, damage = false}
	end]]
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	local owner = self:GetOwner()
	self.Primary.HullSize = nil
	self.Pierces = 1
	self:SetHolding(false)
	self:TakePrimaryAmmo(3)
	self:EmitSound("weapons/tau/single_overcharged0"..math.random(1,2)..".ogg")
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self.SpinSpeed = 7.5
	self:SetChargePower(self:GetChargePower() + self.HeatBuildShort)--0.023
	self:ShootBullets(self:TauDamage(false), self.Primary.NumShots, self:GetCone())
	owner:SetVelocity(-75 * self.SpinSpeed/5 * owner:GetAimVector())
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:SetNextReload(CurTime() + 1.5)
end

function SWEP:ScaleChargeAnim()
	self:SendWeaponAnim(ACT_GAUSS_SPINCYCLE)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.ChargeAnimSpeed + (self:GetOwner():GetStatus("expertise") and 0.0105 or 0))
end

function SWEP.HolsterThink(ENTITY)
	if not ENTITY:GetOwner() then hook.Remove("Think", tostring(ENTITY)) return end

	if ENTITY:GetOwner() and ENTITY:GetOwner():IsValid() then
		if not ENTITY:GetCharging() then
			ENTITY.TauChargeSound:Stop()
		end
		if ENTITY:GetCharging() then
			ENTITY.TauChargeSound:PlayEx(1, 100 + CurTime() % 1)
			ENTITY:SetChargePower(ENTITY:GetChargePower() + FrameTime() * (ENTITY.PowerAccumulation + (ENTITY:GetOwner():GetStatus("expertise") and 0.0105 or 0))) --0.105
			--print(ENTITY:GetChargePower()*100 ,"charge pecent")
			
			if ENTITY:GetChargePower() >= 0.2 then
				ENTITY:SetAmmoTaken(ENTITY:GetAmmoTaken() + 1)
				if ENTITY:GetAmmoTaken() < 17 and ENTITY:GetPrimaryAmmoCountNoClip() ~= 0 then
					ENTITY:TakeAmmo()
				end
			end
			if ENTITY:GetChargePower() == 1 then
				if CLIENT then
					ENTITY:EmitSound("weapons/tau/gauss_overcharged.ogg")
				end
			end
		else
			if ENTITY:GetChargePower() <= 0.0 then ENTITY:SetHolding(false) ENTITY:SetHeatState(1) ENTITY:SetAmmoTaken(0) ENTITY:SetPower(0) end 
			--if (ENTITY:GetNextPrimaryFire()<CurTime()-1.1) then
				ENTITY:SetChargePower(ENTITY:GetChargePower() - FrameTime() * 0.01)
				
			--end
		end
		
		if ENTITY:GetHeatState() == 2 then
			local frametimeadj = FrameTime() * ENTITY:GetReloadSpeedMultiplier()
			ENTITY:SetChargePower(ENTITY:GetChargePower() - frametimeadj * ENTITY.Vent)
			if CLIENT then
				ENTITY.TauVentingSound:PlayEx(1, 150 + CurTime() % 1)
				ENTITY.SpinSpeed = ENTITY.SpinSpeed - 1.5 * (ENTITY:GetChargePower() * 20)
				if not DoOnce then
					local vm = ENTITY:GetOwner():GetViewModel()
					ParticleEffectAttach("tau_beam_balls", PATTACH_POINT_FOLLOW, vm, 4)
					ParticleEffectAttach("tau_beam_balls_bounce", PATTACH_POINT_FOLLOW, vm, 5)
					
					ParticleEffectAttach("tau_beam_balls", PATTACH_POINT_FOLLOW, vm, 2)
					DoOnce = true

					timer.Simple(1, function() if IsValid(ENTITY) then DoOnce = false end end)
				end
			end
		end
		
		if ENTITY.SpinSpeed <= ENTITY:GetChargePower() * 20 and ENTITY:GetCharging() then
			ENTITY.SpinSpeed = ENTITY:GetChargePower() * 20
		end
		
		if ENTITY:GetCharging() and ENTITY:GetChargePower() >= 0.5 then
			ENTITY.TauOverChargeSound:PlayEx(1, 100 + CurTime() % 1)
		else
			ENTITY.TauOverChargeSound:Stop()
		end
	end
end

function SWEP:GetPrimaryAmmoCountNoClip()
	return self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetHeatState() ~= 1 then return false end
	return not self:GetCharging() and self:GetNextPrimaryFire() <= CurTime() and self:GetPrimaryAmmoCountNoClip() >= 2
end 

function SWEP:CanSecondaryAttack()
	if self:GetPrimaryAmmoCountNoClip() <= 0 then
		return false
	end

	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetHeatState() ~= 1 then return false end

	return self:GetNextPrimaryFire() <= CurTime() and self:GetPrimaryAmmoCountNoClip() >= 18 -- cancer
end

function SWEP:StopTauSounds()
	self.TauOverChargeSound:Stop()
	self.TauChargeSound:Stop()
	if CLIENT then self.TauVentingSound:Stop() end
end

function SWEP:Reload()
	if self:GetNextReload() <= CurTime() and (self:GetHeatState() == 0 or self:GetHeatState() == 1) and not self:GetCharging() then
		self:SetHeatState(2)
		self.SpinSpeed = 1
	end
end

function SWEP:TakeAmmo()
	num = 1
	self:TakeCombinedPrimaryAmmo(num)
	self:SetPower(self:GetPower() + num)
end

function SWEP:Think()
	self.BaseClass.Think(self)
	local owner = self:GetOwner()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
	if CLIENT then
		self:DoSpin()
	end

	if owner:IsHolding() or owner:GetBarricadeGhosting() then 
		self:SendWeaponAnim(ACT_VM_IDLE)
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 3)
		self:SetCharging(false)
		return 
	end

	if not owner:KeyDown(IN_ATTACK2) and self:GetCharging() then
		self:SetCharging(false)
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if not self:GetHeatState() ~= 1 and self:GetHolding() and not self:GetCharging() and self:CanSecondaryAttack() and self:GetChargePower() >= 0.2 then -- When key has released so tau will the animation to alt attack.
		if self:GetChargePower() >= 0.5 then
			self:SendWeaponAnim(ACT_VM_RELEASE)
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self:EmitSound("weapons/tau/single_overcharged0"..math.random(1,2)..".ogg")
		else
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self:EmitSound("weapons/tau/single0"..math.random(1,3)..".ogg")
		end

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * self:GetChargePower()) 
		self:SetCharging(false)
		self.Primary.HullSize = 20
		self.Pierces = 20
		self:ShootBullets(self:TauDamage(true), self.Primary.NumShots, self:GetCone() * 0)
		--if SERVER then
		--	self:ShootBall(self:TauDamage(true))
		--end
		self:SetNextReload(CurTime() + 3)
		owner:ViewPunch(12 * self.SpinSpeed * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))
		owner:SetVelocity(-75 * self.SpinSpeed/1.5 * owner:GetAimVector())

		self:SetHeatState(0)
		self:SetCharging(false)
	end

	if self:GetHolding() and self:GetCharging() and self:GetChargePower() >= 1 and IsValid(owner) and not self.Exploded then
		self:SetChargePower(self:GetChargePower() and 1 or 0)
		self:SetCharging(false)
		self:SendWeaponAnim(ACT_VM_RELEASE)
		
		if SERVER then
			owner:TakeSpecialDamage(80, DMG_DIRECT, owner, self)
		end

		self.Exploded = true
		timer.Simple(1, function() if IsValid(self) then self.Exploded = false end end)
	end
end

function SWEP:TauDamage(cha)
	local dmg = self.Primary.Damage
	if cha then
		dmg = dmg * ((1.35 + (self:GetPower() / 75)) + self:GetChargePower())
	end
	return dmg
end

--[[
function SWEP:TauDamage(cha)
	local dmg = self.Primary.Damage
	if cha then
		dmg = dmg * self:GetChargePower() * self:GetPower() / 1.8
	end
	return dmg
end
]]
function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	if not self:GetCharging() and self:GetChargePower() <= 0 then
		self:ScaleChargeAnim()
		self:SetCharging(true)
		self:SetHolding(true)
		self:TakeAmmo()
	end
end

function SWEP:CheckTauState()
	local owner = self.PostOwner or self:GetOwner()
	if owner:IsValid() then
		owner.TauHeat = self:GetChargePower()
		owner.TauInactiveTime = CurTime()
	end
end

function SWEP:OnRemove()
	self:StopTauSounds()
	self:CheckTauState()

	local ENTITY = self

	hook.Remove("Think", tostring(ENTITY))
end

function SWEP:Holster()
	self:CheckTauState()
	self:SetCharging(false)
	self:SetHolding(false)
	self:StopTauSounds()

	return not self:GetCharging()
end

function SWEP:SendWeaponAnimation()
end

function SWEP:GetChargePower()
	return math.Clamp(self:GetDTFloat(9), 0.0, 1.0)	
end

function SWEP:SetChargePower(num)
	if num > 1.0 then
		self:SetHeatState(0)
	end
	return self:SetDTFloat(9,num)	
end

function SWEP:GetHeatState(state)
	return self:GetDTInt(7)
end

function SWEP:SetHeatState(state)
	self:SetDTInt(7, state)
end

function SWEP:GetAmmoTaken(num)
	return self:GetDTInt(8)
end

function SWEP:SetAmmoTaken(num)
	self:SetDTInt(8, num)
end

function SWEP:GetPower()
	return self:GetDTInt(11)
end

function SWEP:SetPower(num)
	return self:SetDTInt(11,num)	
end

function SWEP:GetHolding()
	return self:GetDTBool(13)
end

function SWEP:SetHolding(state)
	self:SetDTBool(13, state)
end

function SWEP:GetCharging()
	return self:GetDTBool(12)
end

function SWEP:SetCharging(charge)
	self:SetDTBool(12, charge)
end
