AddCSLuaFile()

SWEP.PrintName = "Fists"

if CLIENT then
	function SWEP:DrawConditions() -- fuck you
		--local fulltime = self.Primary.Delay * (self:GetOwner().UnarmedDelayMul or 1) * self:GetOwner():GetMeleeSpeedMul()
		--local timeoffset = (self.Primary.Delay / 3) * (self:GetOwner().MeleeSwingDelayMul or 1) * self:GetOwner():GetMeleeSpeedMul()
		--local time = self:GetTime() + self:GetNextMeleeAttack()
		
		--GAMEMODE:DrawCircleEx(x, y, 17, self:IsHeavy() and COLOR_YELLOW or COLOR_DARKRED, time, fulltime + timeoffset)	
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= ""
SWEP.UseHands = true

SWEP.HoldType = "fist"

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.OldWalkSpeed = 0

SWEP.MeleeDamage = 15
SWEP.DamageType = DMG_CLUB
SWEP.UppercutDamageMultiplier = 2 -- 3 МНОГО
SWEP.HitDistance = 49
SWEP.MeleeRange = SWEP.HitDistance
SWEP.MeleeKnockBack = 0

SWEP.ViewModelFOV = 52

SWEP.AutoSwitchFrom = true

SWEP.Unarmed = true

SWEP.Undroppable = true
SWEP.NoPickupNotification = true
SWEP.NoDismantle = true
SWEP.NoGlassWeapons = true

SWEP.Primary.Delay = 0.4

SWEP.AIRating = 0.1
SWEP.Weight = 2 -- This is the second crappiest weapon you could hope for, besides food
SWEP.SlotPos = 100

SWEP.StaminaConsumption = 3
SWEP.BlockStability = 1

SWEP.IsFistWeapon = true
SWEP.SwingSound = Sound( "weapons/slam/throw.wav" )
SWEP.HitSound = Sound( "Flesh.ImpactHard" )

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:PreDrawViewModel(vm, wep, pl)
	vm:SetMaterial("engine/occlusionproxy")
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextMeleeAttack")
	self:NetworkVar("Float", 1, "NextIdle")
	self:NetworkVar("Float", 2, "NextIdleHoldType")
	self:NetworkVar("Int", 1, "Combo")
	--self:NetworkVar("Bool", 0, "HitPrevious")
	self:NetworkVar("Int", 0, "PowerCombo")
end

function SWEP:UpdateNextIdle()
	local vm = self:GetOwner():GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
end

SWEP.LastSwingHit = 0
SWEP.LastSwingStart = 0

function SWEP:PrimaryAttack(right)
	local owner = self:GetOwner()

	if owner:IsHolding() or owner:GetBarricadeGhosting() or (owner:GetStamina() == 0) then return false end

	local time = CurTime()

	self:SetNextIdleHoldType(time + 1.5)
	owner:SetAnimation(PLAYER_ATTACK1)
	self.OldWalkSpeed = math.max(self.OldWalkSpeed, self.WalkSpeed)
	if not owner:IsSkillActive(SKILL_KNUCKLEMASTER) and self.Unarmed then
		self.WalkSpeed = 165
		owner:ResetSpeed()
	end

	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	if ( self:GetCombo() >= 2 ) then
		anim = "fists_uppercut"
	end

	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( self.SwingSound )

	self:UpdateNextIdle()

	local armdelay = owner:GetMeleeSpeedMul()
	local hitdelay = self.Primary.Delay / 3 * (owner.MeleeSwingDelayMul or 1) * armdelay
	owner:GetViewModel():SetPlaybackRate(1 / armdelay)
	if time < self.LastSwingStart + 1 and owner:IsSkillActive(SKILL_COMBOKNUCKLE) then
		if time < self.LastSwingHit + 0.75 then --if self:GetHitPrevious() then
			hitdelay = hitdelay / 2
			owner:GetViewModel():SetPlaybackRate(2 / armdelay)
		else
			hitdelay = hitdelay * 2
			owner:GetViewModel():SetPlaybackRate(0.5 / armdelay)
		end
	end

	self:SetNextMeleeAttack( time + hitdelay )

	self:SetTime(time + self.Primary.Delay * armdelay)

	self:SetNextPrimaryFire( time + self.Primary.Delay * armdelay )
	self:SetNextSecondaryFire( time + self.Primary.Delay * armdelay )

	self.LastSwingStart = time
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack( true )
end

function SWEP:GenerateDamageInfo(damage, hitpos)
	local dmginfo = DamageInfo()
	dmginfo:SetAttacker(self:GetOwner())
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(self.DamageType)
	dmginfo:SetDamagePosition(hitpos)
	dmginfo:SetDamageForce(Vector(0,0,1))
	dmginfo:SetDamage(damage)
	return dmginfo
end

function SWEP:DealDamage()
	local owner = self:GetOwner()
	local aimvector = owner:GetAimVector()
	local anim = self:GetSequenceName(owner:GetViewModel():GetSequence())
	local time = CurTime()

	if SERVER then
		owner:TakeStamina(self.StaminaConsumption, 2.5)
	end

	local tr = owner:CompensatedMeleeTrace((self.HitDistance + (owner.MeleeRangeAds or 0)) * (owner.MeleeRangeMul or 1), 3)

	local hitent = tr.Entity

	-- We need the second part for single player because SWEP:Think is ran shared in SP.
	if tr.Hit and not ( game.SinglePlayer() and CLIENT ) then
		self:EmitSound( self.HitSound, 75, 100, 1, CHAN_WEAPON + 1)
	end

	if self.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr) then
		return
	end

	local armdelay = owner:GetMeleeSpeedMul()
	local delay = self.Primary.Delay * (owner.UnarmedDelayMul or 1) * armdelay
	if tr.Hit then
		self.LastSwingHit = time
		if owner:IsSkillActive(SKILL_COMBOKNUCKLE) then
			delay = delay / 2
		end
	else
		if owner:IsSkillActive(SKILL_COMBOKNUCKLE) then
			delay = delay * 2
		end

		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end
	self:SetNextPrimaryFire(time + delay)
	self:SetNextSecondaryFire(time + delay)

	if hitent:IsValid() then
		local damagemultiplier = owner:GetTotalAdditiveModifier("UnarmedDamageMul", "MeleeDamageMultiplier")
		if owner:GetStatus("laststand") then
			damagemultiplier = damagemultiplier * 1.33
		end

		if SERVER and hitent:IsPlayer() and not self.NoGlassWeapons and owner:IsSkillActive(SKILL_GLASSWEAPONS) then
			damagemultiplier = damagemultiplier * 3.5
			owner.GlassWeaponShouldBreak = not owner.GlassWeaponShouldBreak
		end

		if anim == "fists_uppercut" then
			damagemultiplier = damagemultiplier * self.UppercutDamageMultiplier
		end

		local damage = (self.MeleeDamage + (owner.UnarmedDamageAds or 0)) * damagemultiplier
		local dmginfo = self:GenerateDamageInfo(damage, tr.HitPos)

		local vel
		if hitent:IsPlayer() then
			self:PlayerHitUtil(owner, damage, hitent, dmginfo)
			
			if anim ~= "fists_uppercut" then
				self:SetCombo( self:GetCombo() + 1 )
			else
				self:SetCombo( 0 )
			end

			if SERVER then
				hitent:SetLastHitGroup(tr.HitGroup)
				if tr.HitGroup == HITGROUP_HEAD then
					hitent:SetWasHitInHead()
				end

				if hitent:WouldDieFrom(dmginfo:GetDamage(), dmginfo:GetDamagePosition()) then
					if anim == "fists_left" then
						dmginfo:SetDamageForce(owner:GetRight() * 4912 + owner:GetForward() * 9998)
					elseif anim == "fists_right" then
						dmginfo:SetDamageForce(owner:GetRight() * -4912 + owner:GetForward() * 9989)
					elseif anim == "fists_uppercut" then
						dmginfo:SetDamageForce(owner:GetUp() * 5158 + owner:GetForward() * 10012)
					end
				else
					if owner:IsSkillActive(SKILL_CRITICALKNUCKLE) then
						hitent:ThrowFromPositionSetZ(tr.StartPos, 240 * (owner.MeleeKnockbackMultiplier or 1), nil, true)
					end

					--if owner.BoxingTraining then
						self:SetDTInt(12, self:GetDTInt(12) + 1)

						if self:GetDTInt(12) >= 5 then
							self:SetDTInt(12, 0)

							hitent:AddLegDamage(18)
							hitent:AddArmDamage(18)
							hitent:EmitSound("weapons/crowbar/crowbar_impact1.wav", 75, math.random(60, 65))
						end
					--end
				end
			end

			vel = hitent:GetVelocity()
		else
			if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
				self:SetPowerCombo(0)
			end
		end

		if IsFirstTimePredicted() then
			self:PostHitUtil(owner, hitent, dmginfo, tr, vel)
		end

		if SERVER and hitent:GetMoveType() == MOVETYPE_VPHYSICS then
			local phys = hitent:GetPhysicsObject()
			if phys and phys:IsValid() then
				phys:ApplyForceOffset( aimvector * 2000, tr.HitPos )
				hitent:SetPhysicsAttacker(owner)
			end
		end
	end

	--[[if SERVER then
		if hitplayer and anim ~= "fists_uppercut" then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end]]

	if SERVER then
		self:ServerMeleePostHitEntity(tr, hitent, damagemultiplier)
	end
end

function SWEP:OnRemove()
	if CLIENT and self:GetOwner():IsValid() and self:GetOwner():IsPlayer() then
		local vm = self:GetOwner():GetViewModel()
		if IsValid(vm) then vm:SetMaterial("") end
	end
end

function SWEP:Holster(wep)
	--if CurTime() >= self:GetNextPrimaryFire() then
		self:OnRemove()
		if CLIENT then
			self:Anim_Holster()
		end

		return true
	--end

	--return false
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))

	self:UpdateNextIdle()

	local time = CurTime()

	self:SetNextPrimaryFire( time + 1 )
	self:SetNextSecondaryFire( time + 1 )

	if SERVER then
		self:SetCombo(0)
	end
	self:GetOwner():ResetSpeed()
	return true
end

function SWEP:Think()
	local idletime = self:GetNextIdle()
	local idle_holdtype_time = self:GetNextIdleHoldType()

	if idle_holdtype_time > 0 and CurTime() >= idle_holdtype_time then
		--self:SetWeaponHoldType("normal")
		self:SetNextIdleHoldType(0)
		self.WalkSpeed = self.OldWalkSpeed
		self:GetOwner():ResetSpeed()
	end

	if idletime > 0 and CurTime() >= idletime then
		local vm = self:GetOwner():GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence("fists_idle_0"..math.random(2)))

		self:UpdateNextIdle()
	end

	local meleetime = self:GetNextMeleeAttack()

	if meleetime > 0 and CurTime() >= meleetime then
		self:DealDamage()
		self:SetNextMeleeAttack( 0 )
	end

	if SERVER and CurTime() >= self:GetNextPrimaryFire() + 0.5 then
		self:SetCombo(0)
	end
end

function SWEP:TranslateActivity( act )
	return self.ActivityTranslate and self.ActivityTranslate[act] or -1
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

function SWEP:GetViewModelPosition(pos, ang)
	pos = pos - ang:Up() * 3

	return pos, ang
end
