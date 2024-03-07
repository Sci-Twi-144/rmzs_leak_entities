SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0.22
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.PounceDamage = 14
SWEP.PounceDamageType = DMG_SLASH

SWEP.NoHitRecovery = 0.75
SWEP.HitRecovery = 1

SWEP.PoundAttackStart = 0

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

if SERVER then SWEP.NextHeal = 0 end
function SWEP:Think()
	local curtime = CurTime()
	local owner = self:GetOwner()

	if self:IsPouncing() then
		local delay = owner:GetMeleeSpeedMul()
		if owner:IsOnGround() or 1 < owner:WaterLevel() then
			self:SetPouncing(false)
			self:SetNextPrimaryFire(curtime + self.NoHitRecovery * delay)
		else
			local shootpos = owner:GetShootPos()
			local trace = owner:CompensatedMeleeTrace(24, 36, shootpos, owner:GetForward())
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

				local damage = self.PounceDamage

				if ent:IsPlayer() then
					ent:MeleeViewPunch(damage)
					if SERVER then
						local nearest = ent:NearestPoint(shootpos)
						util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - shootpos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)

						if ent:Health() < 26 then
							ent:TakeSpecialDamage(200, DMG_SLASH, owner, self)
								timer.Simple( 0.1, function()
								local curclass = ent.DeathClass or ent:GetZombieClass()
								if ent and ent:IsValid() then
									ent:SetZombieClassName("Infector")
									ent.DeathClass = nil
									ent:UnSpectateAndSpawn()
									ent.DeathClass = curclass
									ent:SetPos(owner:GetPos() + owner:GetUp() * 8)
								end
							end)
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

				if ent:IsNailed() or ent:IsPhysicsProp() then
					ent:TakeSpecialDamage(damage * 3, DMG_SLASH, owner, self, trace.HitPos)
				else
					ent:TakeSpecialDamage(damage, DMG_SLASH, owner, self, trace.HitPos)
				end

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
	if self:GetPouncing() or CurTime() < self:GetNextPrimaryFire() or not owner:IsOnGround() then return end -- or self:IsBurrowing() then return end

	self.PoundAttackStart = CurTime()
	local vel = owner:GetAimVector()
	vel.z = math.max(0.45, vel.z)
	vel:Normalize()

	owner:SetGroundEntity(NULL)
	owner:SetLocalVelocity(vel * 500)
	owner:DoAnimationEvent(ACT_RANGE_ATTACK1)

	if SERVER then
		self:EmitAttackSound()
	end

	self.m_ViewAngles = owner:EyeAngles()

	self:SetPouncing(true)
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 2)

	if SERVER then
		self:EmitIdleSound()
	end
end

SWEP.Reload = SWEP.SecondaryAttack

--[[
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
end]]

function SWEP:EmitBiteSound()
	self:GetOwner():EmitSound("NPC_HeadCrab.Bite")
end

function SWEP:EmitHitSound()
	self:GetOwner():EmitSound("physics/concrete/concrete_break3.wav", 77, 70)
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

function SWEP:SetPouncing(pouncing)
	if not pouncing then
		self.m_ViewAngles = nil
	end

	self:SetDTBool(8, pouncing)
end

function SWEP:GetPouncing()
	return self:GetDTBool(8)
end
SWEP.IsPouncing = SWEP.GetPouncing


util.PrecacheSound("npc/antlion/digdown1.wav")
util.PrecacheSound("npc/antlion/digup1.wav")
