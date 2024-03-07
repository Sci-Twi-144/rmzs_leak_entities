SWEP.Base = "weapon_zs_zombie"

SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.MeleeReach = 52
SWEP.MeleeDelay = 0.36
SWEP.MeleeSize = 4.5
SWEP.MeleeDamage = 24
SWEP.SlowDownScale = 3
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.05

SWEP.Primary.Delay = 0.8

SWEP.NoHitRecovery = 0.75
SWEP.HitRecovery = 1
SWEP.AttackTime = 1.875
SWEP.AttackProcessTime = 1.35

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

AccessorFuncDT(SWEP, "HookTime", "Float", 1)
AccessorFuncDT(SWEP, "AttackStartTime", "Float", 0)
AccessorFuncDT(SWEP, "AttackProcessTime", "Float", 1)

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() then return end

	self:SetNextSecondaryFire(CurTime() + 3.25)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:SetSwingAnimTime(CurTime() + 0.7)

	self:GetOwner():DoReloadEvent()

	self:EmitSound("npc/headcrab_poison/ph_poisonbite3.wav", 75, 46)

	self:SetHookTime(CurTime() + 0.9)
end

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

function SWEP:EmitBiteSound()
	self:GetOwner():EmitSound("NPC_HeadCrab.Bite")
end

function SWEP:Think()
	if self:GetHookTime() > 0 and CurTime() >= self:GetHookTime() then
		self:SetHookTime(0)

		self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(2, 4)..".wav", 72, math.random(70, 83))
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		if SERVER then
			self:ThrowHook()
		end
	end

	local curtime = CurTime()
	local owner = self:GetOwner()

	if self:GetAttackProcessTime() > 0 and curtime >= self:GetAttackProcessTime() then
		self:SetAttackProcessTime(0)

		if SERVER then
			self:ThrowGibs()
		end
	end

	if self:IsAttacking() and curtime > self:GetAttackEndTime() then
		self:SetAttackStartTime(0)
		self:SetAttackProcessTime(0)
	end

	if self:IsPouncing() then
		local delay = owner:GetMeleeSpeedMul()
		if owner:IsOnGround() or 1 < owner:WaterLevel() then
			self:SetPouncing(false)
			self:SetNextPrimaryFire(curtime + self.NoHitRecovery * delay)
		else
			local shootpos = owner:GetShootPos()
			local trace = owner:CompensatedMeleeTrace(8, 12, shootpos, owner:GetForward())
			local ent = trace.Entity

			if trace.Hit then
				self:SetPouncing(false)
				self:SetNextPrimaryFire(curtime + self.HitRecovery * delay)
			end

			if ent:IsValid() then
				self:SetPouncing(false)

				if SERVER then
					self:EmitBiteSound()
				end

				local damage = 5

				if ent:IsPlayer() then
					ent:MeleeViewPunch(damage)
					if SERVER then
						local nearest = ent:NearestPoint(shootpos)
						util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - shootpos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)

						if ent.KnockedDown then
							if not ent.HitCount then
								ent.HitCount = 0
							end

							if ent:Health() > 20 then
								if (ent.HitCount or 0) < 2 then
									ent.HitCount = ent.HitCount + 1
								else
									ent:TakeSpecialDamage(200, DMG_SLASH, owner, self)

									timer.Simple( 1, function()
										if ent and ent:IsValid() then
											ent:SetZombieClassName("Toxic Crab")
											ent:UnSpectateAndSpawn()
											ent:SetPos(owner:GetPos())
											ent.HitCount = 0
										end
									end)
								end
							else
								ent:TakeSpecialDamage(200, DMG_SLASH, owner, self)

								timer.Simple( 1, function()
									if ent and ent:IsValid() then
										ent:SetZombieClassName("Toxic Crab")
										ent:UnSpectateAndSpawn()
										ent:SetPos(owner:GetPos())
										ent.HitCount = 0
									end
								end)
							end								
						end
					end

					owner:AirBrake()
				else
					local phys = ent:GetPhysicsObject()
					if phys:IsValid() and phys:IsMoveable() then
						phys:ApplyForceOffset(damage * 600 * owner:EyeAngles():Forward(), (ent:NearestPoint(shootpos) + ent:GetPos() * 2) / 3)
						ent:SetPhysicsAttacker(owner)
					end
				end

				ent:TakeSpecialDamage(damage, DMG_SLASH, owner, self, trace.HitPos)

				owner:ViewPunch(Angle(math.Rand(-20, 20), math.Rand(-20, 20), math.Rand(-20, 20)))
			elseif trace.HitWorld then
				if SERVER then
					self:EmitHitSound()
				end
			end
		end
	end

	self:NextThink(curtime)
	return true
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if self:IsPouncing() or CurTime() < self:GetNextPrimaryFire() or not owner:IsOnGround() or self:IsAttacking() then return end

	self.PoundAttackStart = CurTime()

	local vel = owner:GetAimVector()
	vel.z = math.max(0.45, vel.z)
	vel:Normalize()

	owner:SetGroundEntity(NULL)
	owner:SetVelocity(vel * 500)
	owner:DoAnimationEvent(ACT_RANGE_ATTACK1)

	if SERVER then
		self:EmitAttackSound()
	end

	self.m_ViewAngles = owner:EyeAngles()

	self:SetPouncing(true)
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if self:IsAttacking() or self:IsPouncing() or not owner:IsOnGround() then return end

	self:SetAttackStartTime(CurTime())
	self:SetAttackProcessTime(CurTime() + self.AttackProcessTime)

	if SERVER then
		self:EmitAttackSound()
	end
end

function SWEP:Reload()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 2)

	if SERVER then
		self:EmitIdleSound()
	end
end

function SWEP:Move(mv)
	if self:IsPouncing() then
		if CurTime() < self.PoundAttackStart + 0.1 then
			local vel = mv:GetVelocity()
			vel.z = 300
			self:GetOwner():SetGroundEntity(NULL)
			mv:SetVelocity(vel)
		end

		mv:SetMaxSpeed(mv:GetMaxSpeed() * 5)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 5)
		return true
	end

	if self:IsAttacking() then
		mv:SetMaxSpeed(16)
		mv:SetMaxClientSpeed(16)
		return true
	end
end

function SWEP:EmitIdleSound()
	local ent = self:GetOwner():CompensatedMeleeTrace(4096, 24).Entity
	if ent:IsValidPlayer() then
		self:GetOwner():EmitSound("npc/headcrab/idle"..math.random(3)..".wav", 75, 60)
	else
		self:GetOwner():EmitSound("npc/headcrab/alert1.wav", 75, 60)
	end
end

function SWEP:EmitAttackSound()
	self:GetOwner():EmitSound("npc/ichthyosaur/attack_growl"..math.random(3)..".wav")
end

function SWEP:IsAttacking()
	return self:GetAttackStartTime() > 0
end

function SWEP:GetAttackEndTime()
	return self:GetAttackStartTime() + self.AttackTime
end

function SWEP:SetPouncing(pouncing)
	if not pouncing then
		self.m_ViewAngles = nil
	end

	self:SetDTBool(8, pouncing)
end

function SWEP:IsPouncing()
	return self:GetDTBool(8)
end
SWEP.GetPouncing = SWEP.IsPouncing
