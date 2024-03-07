AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_zombie")

if CLIENT then
	function SWEP:DrawHUD()
		self:DrawAds()

		GAMEMODE:DrawCircleEx(x, y, 17, COLOR_DARKRED, self:GetResource(), self:GetAbstractNumber())

		local time = self:GetChargeStart() + self.ChargeTime - CurTime()
		local is_critical = time <= self.ChargeTime * 0.4 and COLOR_DARKRED or COLOR_GREEN

		if self:GetCooldown() > CurTime() then
			GAMEMODE:DrawCircleEx(x, y, 22, COLOR_GREEN, alt or self:GetCooldown(), self.ChargeTime)
		else
			GAMEMODE:DrawCircleEx(x, y, 22, is_critical, alt or self:GetChargeStart() + self.ChargeTime, self.ChargeTime)
		end

		if GetConVar("crosshair"):GetInt() ~= 1 then return end
		self:DrawCrosshairDot()
	end
end

SWEP.PrintName = "Charger"

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")

SWEP.MeleeDelay = 0.8
SWEP.MeleeDamage = 23
SWEP.BleedDamage = 10
SWEP.MeleeDamageVsProps = 23
SWEP.Primary.Delay = 1.5

SWEP.SwingAnimSpeed = 0.6

SWEP.ChargeDamage = 90
SWEP.ChargeDamageVsPlayerMul = 1.5
SWEP.ChargeReach = 60
SWEP.ChargeSize = 18
SWEP.ChargeStartDelay = 0.35
SWEP.ChargeDelay = 1
SWEP.ChargeRecovery = 0.75
SWEP.ChargeTime = 3
SWEP.ChargeAccel = 2
SWEP.ChargeKnockdown = 250

SWEP.Secondary.Automatic = false

SWEP.NextAllowCharge = 0

SWEP.Taper = 0.69
SWEP.Radius = 75

function SWEP:Think()
	BaseClass.Think(self)

	local curtime = CurTime()
	local owner = self:GetOwner()

	if self.NextAllowJump and self.NextAllowJump <= curtime then
		self.NextAllowJump = nil

		owner:ResetJumpPower()
	end

	if self:IsCharging() then
		if owner:WaterLevel() >= 2 or CurTime() > self:GetChargeStart() + self.ChargeTime  then
			self:StopCharge()
		elseif IsFirstTimePredicted() then
			local dir = owner:GetVelocity()
			dir:Normalize()

			local chargemul = math.min(self:GetCharge(), owner:GetVelocity():LengthSqr() / 193600)
			local traces = owner:CompensatedZombieMeleeTrace(self.ChargeReach, self.ChargeSize, owner:WorldSpaceCenter(), dir)

			local hit = false
			for _, trace in ipairs(traces) do
				if not trace.Hit then continue end

				local ent = trace.Entity
				if trace.HitWorld or (ent and ent:IsValid() and ent:IsBarricadeProp() and not (ent:IsProjectile() or ent.ZombieConstruction or ent.IsShadeShield or ent:IsValidLivingZombie()) ) then

					local effectdata = EffectData()
						effectdata:SetOrigin(owner:GetPos())
					util.Effect("Explosion", effectdata)
					util.Effect("explosion_rocket", effectdata)

					local effectdata = EffectData()
						effectdata:SetOrigin(owner:GetPos())
						effectdata:SetMagnitude(2)
					util.Effect("explosion_chem", effectdata, true)

					for i=1, 3 do
						self:EmitSound("npc/env_headcrabcanister/explosion.wav", 75 + i * 5, 100)
					end

					for i=1, 2 do
						ParticleEffect("dusty_explosion_rockets", owner:GetPos(), angle_zero)
					end
					
					if SERVER then
						local pos = trace.HitPos
						local tapper = 1
						for _, ent in pairs(util.BlastAlloc(self, owner, pos, 160)) do
							if ent:IsBarricadeProp() then
								ent:TakeSpecialDamage(350, DMG_SLASH, owner, self)
							end

							if ent:IsValidLivingHuman() then
								ent:TakeSpecialDamage(100 * tapper, DMG_SLASH, owner, self)
								tapper = tapper * 0.75
							end
						end
					end

					timer.Simple(0, function()
						if owner:IsValidLivingZombie() then
							owner:Kill()
						end
					end)

					hit = true
				end
			end

			if not self.CriticalCharge and self:IsChargeCritical() then
				self:PlayCriticalChargeStartSound()
				self.CriticalCharge = true
			end

			if hit then
				self:PlayChargeHitSound()
				self:StopCharge()
			end
		end
	elseif self:GetChargeStart() > 0 and CurTime() > self:GetChargeStart() then
		self:StartCharge()
	elseif self.m_ViewAngles then
		self.m_ViewAngles = nil
	end

	self:NextThink(curtime)
	return true
end

function SWEP:PlayChargeHitSound()
	self:EmitSound("npc/antlion_guard/shove1.wav")
	self:EmitSound("npc/fast_zombie/wake1.wav", 75, math.random(75, 80), nil, CHAN_AUTO)
end

function SWEP:PlayCriticalChargeStartSound()
	self:EmitSound("npc/zombie_poison/pz_throw3.wav", 75, math.random(85, 90), nil, CHAN_AUTO)
end

function SWEP:Move(mv)
	local charge = self:GetCharge()

	if self:GetChargeStart() > 0 and charge <= 0 then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)
	elseif charge > 0 then
		mv:SetForwardSpeed(10000)
		mv:SetSideSpeed(mv:GetSideSpeed() * 0.1)

		local mul = 1 + charge * 1 + (self:IsChargeCritical() and 0.5 or 0)
		mv:SetMaxSpeed(mv:GetMaxSpeed() * mul)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * mul)
	end
end

function SWEP:PrimaryAttack()
	if self:IsCharging() or self:GetChargeStart() > 0 then return end

	BaseClass.PrimaryAttack(self)
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() and not (self:IsCharging() or self:GetChargeStart() > 0) then
		damage = self.MeleeDamageVsProps
	end
	local owner = self:GetOwner()
	local radius = self.Radius
	if SERVER then 
		local pos = trace.HitPos

		for _, hitent in pairs(util.BlastAlloc(self, owner, pos, radius)) do
			if hitent:IsBarricadeProp() then
				local nearest = ent:NearestPoint(pos)
					
				damage = damage * self.Taper
				hitent:TakeSpecialDamage((((radius ^ 2) - nearest:DistToSqr(pos)) / (radius ^ 2)) * damage, DMG_SLASH, owner, self)
			end
		end
	end
	BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() and not (self:IsCharging() or self:GetChargeStart() > 0) then
		local bleed = ent:GiveStatus("bleed")
		if bleed and bleed:IsValid() then
			bleed:AddDamage(self.BleedDamage)
			bleed.Damager = self:GetOwner()
		end
	end

	BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:SecondaryAttack()
	if self:IsCharging() or self:GetChargeStart() > 0 then return end

	if self:GetOwner():IsOnGround() then
		if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or CurTime() < self.NextAllowCharge then return end

		self:SetNextPrimaryFire(math.huge)
		self:SetChargeStart(CurTime() + self.ChargeStartDelay)

		self:GetOwner():ResetJumpPower()
		if IsFirstTimePredicted() then
			self:PlayChargeStartSound()
		end
	end
end

function SWEP:StartCharge()
	if self:IsCharging() then return end

	local owner = self:GetOwner()
	if SERVER then owner:Say( "qallahuakbar" ) end

	if owner:IsOnGround() then
		self:SetCharging(true)

		self.m_ViewAngles = owner:EyeAngles()

		if IsFirstTimePredicted() then
			self:PlayChargeSound()
		end
		owner:SetAnimation(PLAYER_JUMP)
	else
		self:SetNextSecondaryFire(CurTime())
		self.m_ViewAngles = nil
		self.NextAllowJump = CurTime()
		self.NextAllowCharge = CurTime() + self.ChargeDelay
		self:SetNextPrimaryFire(CurTime() + self.ChargeRecovery)
		self:GetOwner():ResetJumpPower()
	end
end

function SWEP:PlayChargeSound()
	self:EmitSound("npc/ichthyosaur/attack_growl1.wav", 75, math.random(100,116), nil, CHAN_AUTO)
end

function SWEP:PlayChargeStartSound()
	self:EmitSound("npc/fast_zombie/leap1.wav", 75, math.random(75,80), nil, CHAN_AUTO)
end

function SWEP:StopCharge()
	if not self:IsCharging() then return end

	self:SetChargeStart(0)
	self:SetCharging(false)
	self:SetNextSecondaryFire(CurTime())
	self.m_ViewAngles = nil
	self.NextAllowJump = CurTime() + 0.25
	self.NextAllowCharge = CurTime() + self.ChargeDelay
	self:SetNextPrimaryFire(CurTime() + self.ChargeRecovery)
	self:GetOwner():ResetJumpPower()
	self.CriticalCharge = nil
end

function SWEP:Reload()
	BaseClass.SecondaryAttack(self)
end

function SWEP:OnRemove()
	self.Removing = true

	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		owner:ResetJumpPower()
	end

	BaseClass.OnRemove(self)
end

function SWEP:Holster()
	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		owner:ResetJumpPower()
	end

	BaseClass.Holster(self)
end

function SWEP:ResetJumpPower(power)
	if self.Removing then return end

	if self.NextAllowJump and CurTime() < self.NextAllowJump or self:IsCharging() or self:GetChargeStart() > 0 then
		return 1
	end
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav")
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_alert"..math.random(1,3)..".wav", 75, math.random(80,85))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:SetChargeStart(time)
	self:SetDTFloat(17, time)
end

function SWEP:GetChargeStart()
	return self:GetDTFloat(17)
end

function SWEP:GetCharge()
	if self:GetChargeStart() == 0 then return 0 end

	return math.Clamp((CurTime() - self:GetChargeStart()) / self.ChargeAccel, 0, 1)
end

function SWEP:IsChargeCritical()
	if not self:IsCharging() then return false end

	return CurTime() >= self:GetChargeStart() + self.ChargeTime * 0.6
end

function SWEP:SetCharging(charging)
	self:SetDTBool(9, charging)
end

function SWEP:GetCharging()
	return self:GetDTBool(9)
end
SWEP.IsCharging = SWEP.GetCharging

if not CLIENT then return end

SWEP.ViewModelFOV = 48

function SWEP:ViewModelDrawn()
	render.SetColorModulation(1, 1, 1)
end

function SWEP:PreDrawViewModel(vm)
	render.SetColorModulation(0.17, 0.7, 0)
end
