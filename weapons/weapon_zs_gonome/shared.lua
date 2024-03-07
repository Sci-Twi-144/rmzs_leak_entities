DEFINE_BASECLASS("weapon_zs_zombie")

SWEP.PrintName = "Gonome"

SWEP.MeleeReach = 96
SWEP.MeleeDelay = 0.8
SWEP.MeleeDelay2 = SWEP.MeleeDelay / 2
SWEP.MeleeSize = 4.5
SWEP.MeleeDamage = 47
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.32

SWEP.Primary.Delay = 1.6
SWEP.Secondary.Delay = 4

SWEP.FrozenWhileSwinging = false 

SWEP.PoisonThrowDelay = 1
SWEP.PoisonThrowSpeed = 290

SWEP.PounceDamage = 47
SWEP.PounceDamageVsPlayerMul = 1
SWEP.PounceDamageType = DMG_IMPACT
SWEP.PounceReach = 26
SWEP.PounceSize = 12
SWEP.PounceStartDelay = 0.15
SWEP.PounceDelay = 1.25
SWEP.PounceVelocity = 700

SWEP.MeleeDamageVsProps = 47

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.FlySound = CreateSound(self, "npc/antlion/fly1.wav")
end

function SWEP:SetIsOnGround(ground)
	self:SetDTBool(9, ground)
end

function SWEP:GetIsOnGround()
	return self:GetDTBool(9)
end

SWEP.NextAllowPounce = 0
function SWEP:Think()
	BaseClass.Think(self)

	local time = CurTime()

	if self.NextThrowAnim and time >= self.NextThrowAnim and IsFirstTimePredicted() then
		self.NextThrowAnim = nil

		self:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.random(70, 83))
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self.IdleAnimation = time + self:SequenceDuration()
	end

	if self.NextThrow then
		if time >= self.NextThrow and IsFirstTimePredicted() then
			self.NextThrow = nil

			local owner = self:GetOwner()

			owner.LastRangedAttack = CurTime()

			owner:ResetSpeed()
			owner:RawCapLegDamage(CurTime() + 1.5)

			self:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.random(70, 80))

			if SERVER then
				self:DoThrow()
			end
		end

		self:NextThink(time)
		return true
	end

	local curtime = CurTime()
	local owner = self:GetOwner()

	if self.NextAllowJump and self.NextAllowJump <= curtime then
		self.NextAllowJump = nil

		owner:ResetJumpPower()

		if SERVER then
			owner:AddLegDamage(7)
		end
	end

	if self:GetPouncing() then
		if owner:IsOnGround() or owner:WaterLevel() >= 2 then
			self:StopPounce()
		else
			local dir = owner:GetAimVector()
			dir.z = math.Clamp(dir.z, -0.5, 0.9)
			dir:Normalize()

			local traces = owner:CompensatedZombieMeleeTrace(self.PounceReach, self.PounceSize, owner:WorldSpaceCenter(), dir)
			local damage = self:GetDamage(self:GetTracesNumPlayers(traces), self.PounceDamage)

			local hit = false

			for i=1, #traces do
				local trace = traces[i]
				if not trace then continue end
			--for _, trace in ipairs(traces) do
				if not trace.Hit then continue end

				if trace.HitWorld then
					if trace.HitNormal.z < 0.8 then
						hit = true
						self:MeleeHitWorld(trace)
					end
				else
					local ent = trace.Entity
					if ent and ent:IsValid() then
						hit = true
						self:MeleeHit(ent, trace, damage * (ent:IsPlayer() and self.PounceDamageVsPlayerMul or ent.PounceWeakness or 1), ent:IsPlayer() and 1 or 10)
						if ent:IsPlayer() then
							if SERVER then
								ent:AddLegDamage(16)
							end
						end
					end
				end
			end

			if hit then
				if IsFirstTimePredicted() then
					self:PlayPounceHitSound()
				end

				self:StopPounce()
			end
		end
	elseif self:GetPounceTime() > 0 and curtime >= self:GetPounceTime() then
		self:StartPounce()
	end

	self:CheckMeleeAttack2()
end

function SWEP:StartPounce()
	if self:IsPouncing() then return end

	self:SetPounceTime(0)

	local owner = self:GetOwner()
	if owner:IsOnGround() then
		self:SetPouncing(true)

		self.m_ViewAngles = owner:EyeAngles()

		if IsFirstTimePredicted() then
			self:PlayPounceSound()
		end

		local punceVel = (1 - 0.5 * (owner:GetLegDamage() / GAMEMODE.MaxLegDamage)) * self.PounceVelocity
		local dir = owner:GetAimVector()
		if owner:IsBot() then
			if rawget(BOT_LeapPathTimer, owner) and rawget(BOT_LeapPathTimer, owner) > CurTime() then
				dir.z = dir.z+0.4
			else
				dir = owner:AdjustAim({start=owner:GetPos(),speed=punceVel,Toss=true})
			end
		end
		dir.z = math.max(0.5, dir.z)
		dir:Normalize()
		
		local ang = owner:EyeAngles()
		ang.pitch = math.min(-20, ang.pitch)

		owner:SetGroundEntity(NULL)
		owner:SetVelocity(punceVel * dir)
		--owner:SetAnimation(PLAYER_JUMP)
	else
		self:SetNextSecondaryFire(CurTime())
		self.m_ViewAngles = nil
		self.NextAllowJump = CurTime()
		self.NextAllowPounce = CurTime() + self.PounceDelay
		self:SetNextPrimaryFire(CurTime() + 0.1)
		self:GetOwner():ResetJumpPower()
	end
end
local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:PrimaryAttack()
	if self:IsPouncing() or self:GetPounceTime() > 0 then return end
	if not self.NextThrow then
		BaseClass.PrimaryAttack(self)
	end
end

function SWEP:StartSwinging()
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()
	local stbl = E_GetTable(self)
	local armdelay = owner:GetMeleeSpeedMul()

	stbl.MeleeAnimationMul = 1 / armdelay
	if stbl.MeleeAnimationDelay then
		self.NextAttackAnim = CurTime() + stbl.MeleeAnimationDelay * armdelay
	else
		self:SendAttackAnim()
	end

	self:DoSwingEvent()

	self:PlayAttackSound()

	if stbl.FrozenWhileSwinging then
		self:GetOwner():SetSpeed(1)
	end
	
	if SERVER then
		owner:AddLegDamage(18)
	end
	

	if stbl.MeleeDelay2 > 0 then
		self:SetSwingStartTime(CurTime())
		self:SetSwingEndTime2(CurTime() + stbl.MeleeDelay2 * armdelay)

		local trace = owner:CompensatedMeleeTrace(stbl.MeleeReach, stbl.MeleeSize)
		if trace.HitNonWorld and not trace.Entity:IsPlayer() then
			trace.IsPreHit = true
			stbl.PreHit = trace
		end

		stbl.IdleAnimation = CurTime() + (self:SequenceDuration() + (stbl.MeleeAnimationDelay or 0)) * armdelay
	else
		self:Swung()
	end

	if stbl.MeleeDelay > 0 then
		self:SetSwingStartTime(CurTime())
		self:SetSwingEndTime(CurTime() + stbl.MeleeDelay * armdelay)

		local trace = owner:CompensatedMeleeTrace(stbl.MeleeReach, stbl.MeleeSize)
		if trace.HitNonWorld and not trace.Entity:IsPlayer() then
			trace.IsPreHit = true
			stbl.PreHit = trace
		end

		stbl.IdleAnimation = CurTime() + (self:SequenceDuration() + (stbl.MeleeAnimationDelay or 0)) * armdelay
	else
		self:Swung()
	end
end

function SWEP:CheckMeleeAttack2()
	local swingend = self:GetSwingEndTime2()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopSwinging2(0)

	self:Swung()
end

function SWEP:StopSwinging2()
	self:SetSwingEndTime2(0)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()
	local div = (owner.PoisonBuffZombie.DieTime >= CurTime() and 0.5) or 1
	local time = CurTime()
	if time < self:GetNextPrimaryFire() or time < self:GetNextSecondaryFire() then return end

	owner:DoAnimationEvent(ACT_GESTURE_RANGE_ATTACK1)
	owner:SetSpeed(60)

	self:EmitSound("npc/Zassassin/slime_zombie_emerge.wav", 75, 80, nil, CHAN_WEAPON + 21)
	self:EmitSound("npc/Zassassin/beast_bebcrabs_birth"..math.random(1, 3)..".wav", 75, 80, nil, CHAN_AUTO)

	self:SetNextSecondaryFire(time + self.Secondary.Delay * div)
	self:SetNextPrimaryFire(time + self.Primary.Delay)

	self.NextThrow = time + self.PoisonThrowDelay
	self.NextThrowAnim = self.NextThrow - 0.4

	local SCD = self:GetNextSecondaryFire() - CurTime()
	self:SetMaxCooldown(SCD)
	self:SetCooldown(SCD)
end

function SWEP:Reload()
	if self:IsPouncing() or self:GetPounceTime() > 0 then return end

	if self:GetOwner():IsOnGround() then
		if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or CurTime() < self.NextAllowPounce then return end

		self:SetNextPrimaryFire(math.huge)
		self:SetPounceTime(CurTime() + self.PounceStartDelay)

		self:GetOwner():ResetJumpPower()

		if IsFirstTimePredicted() then
			self:PlayPounceStartSound()
		end
	end
end

function SWEP:OnRemove()
	self.Removing = true

	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		self:StopSwingingSound()
		owner:ResetJumpPower()
	end

	BaseClass.OnRemove(self)
end

function SWEP:Holster()
	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		self:StopSwingingSound()
		owner:ResetJumpPower()
	end

	BaseClass.Holster(self)
end

function SWEP:StopSwingingSound()
	self:StopSound("NPC_FastZombie.Gurgle")
end

function SWEP:Move(mv)
	if self:IsPouncing() or self:GetPounceTime() > 0 then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)
	elseif self:GetSwinging() then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.6666)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.6666)
	elseif self:IsSlowSwinging() then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.85)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.85)
	end
end

function SWEP:StopPounce()
	if not self:IsPouncing() then return end

	self:SetPouncing(false)
	self:SetNextSecondaryFire(CurTime())
	self.m_ViewAngles = nil
	self.NextAllowJump = CurTime() + 0.25
	self.NextAllowPounce = CurTime() + self.PounceDelay
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:GetOwner():ResetJumpPower()
	self:GetOwner():DoAnimationEvent(ACT_LAND)
	if SERVER then
		self:PoundAttackProcess()
	end
end

function SWEP:ResetJumpPower(power)
	if self.Removing then return end

	if self.NextAllowJump and CurTime() < self.NextAllowJump or self:IsPouncing() or self:GetPounceTime() > 0 then
		return 1
	end
end

function SWEP:SetPouncing(pouncing)
	if not pouncing then
		self.m_ViewAngles = nil
	end

	self:SetDTBool(8, pouncing)
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = self.MeleeDamageVsProps
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:SetPounceTime(time)
	self:SetDTFloat(16, time)
end

function SWEP:GetPounceTime()
	return self:GetDTFloat(16)
end

function SWEP:SetPounceTime(time)
	self:SetDTFloat(16, time)
end

function SWEP:IsPouncing()
	return self:GetDTBool(8)
end
SWEP.GetPouncing = SWEP.IsPouncing

function SWEP:PlayPounceHitSound()
	self:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
	self:EmitSound("npc/fast_zombie/wake1.wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayPounceStartSound()
	self:EmitSound("npc/Zassassin/beast_attack1.wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayPounceSound()
	self:EmitSound("npc/Zassassin/beast_berserk.wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayHitSound()
	self:EmitSound("npc/Zassassin/beast_claw_strike"..math.random(1, 3)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
--	self:EmitSound("NPC_PoisonZombie.ThrowWarn")
	self:EmitSound("npc/Zassassin/beast_attack1.wav", 75, 80, nil, CHAN_AUTO)
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/Zassassin/beast_idle1"..math.random(1,4)..".wav", 75, 80, nil, CHAN_AUTO)
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:SetSwinging(swinging)
	self:SetDTBool(9, swinging)
end

function SWEP:GetSwinging()
	return self:GetDTBool(9)
end

function SWEP:SetSwingEndTime2(time)
	self:SetDTFloat(17, time)
end

function SWEP:GetSwingEndTime2()
	return self:GetDTFloat(17)
end
