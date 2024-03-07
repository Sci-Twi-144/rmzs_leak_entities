SWEP.ZombieOnly = true
SWEP.IsMelee = true

SWEP.PrintName = "Zombie"

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = ""

SWEP.MeleeDelay = 0.74
SWEP.MeleeReach = 48
SWEP.MeleeSize = 4.5 --1.5
SWEP.MeleeDamage = 32
SWEP.MeleeForceScale = 1
SWEP.MeleeDamageType = DMG_SLASH

SWEP.AlertDelay = 2.5

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.CantSwitchFireModes = true

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:PlayHitSound()
	self:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayMissSound()
	self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", nil, nil, nil, CHAN_AUTO)
end

function SWEP:PlayAttackSound()
	self:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav")
end

function SWEP:Initialize()
	self:HideWorldModel()
end

function SWEP:CheckIdleAnimation()
	local stbl = E_GetTable(self)

	if stbl.IdleAnimation and stbl.IdleAnimation <= CurTime() then
		stbl.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:CheckAttackAnimation()
	local stbl = E_GetTable(self)

	if stbl.NextAttackAnim and stbl.NextAttackAnim <= CurTime() then
		stbl.NextAttackAnim = nil
		self:SendAttackAnim()
	end
end

function SWEP:CheckMeleeAttack()
	local swingend = self:GetSwingEndTime()
	if swingend == 0 or CurTime() < swingend then return end
	self:StopSwinging(0)

	self:Swung()
end

function SWEP:GetTracesNumPlayers(traces)
	local numplayers = 0

	local ent
	for _, trace in pairs(traces) do
		ent = trace.Entity
		if ent and ent:IsValidPlayer() then
			numplayers = numplayers + 1
		end
	end

	return numplayers
end

function SWEP:GetDamage(numplayers, basedamage)
	basedamage = basedamage or self.MeleeDamage

	if numplayers then
		return basedamage * math.Clamp(1.1 - numplayers * 0.1, 0.666, 1)
	end

	return basedamage
end

function SWEP:Swung()
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	local hit = false
	local traces = owner:CompensatedZombieMeleeTrace(stbl.MeleeReach, stbl.MeleeSize)
	local prehit = stbl.PreHit
	if prehit then
		local ins = true
		for _, tr in pairs(traces) do
			if tr.HitNonWorld then
				ins = false
				break
			end
		end

		if ins then
			local eyepos = owner:EyePos()
			if prehit.Entity:IsValid() and not (owner:IsBot() and otbl.IsPlayerAFK) and prehit.Entity:NearestPoint(eyepos):DistToSqr(eyepos) <= stbl.MeleeReach * stbl.MeleeReach then
				table.insert(traces, prehit)
			end
		end
		stbl.PreHit = nil
	end

	local damage = self:GetDamage(self:GetTracesNumPlayers(traces))
	local effectdata = EffectData()
	local ent

	for _, trace in ipairs(traces) do
		if not trace.Hit then continue end

		ent = trace.Entity

		hit = true

		if trace.HitWorld then
			self:MeleeHitWorld(trace)
		elseif ent and ent:IsValid() then
			self:MeleeHit(ent, trace, damage)
		end

		--if IsFirstTimePredicted() then
			effectdata:SetOrigin(trace.HitPos)
			effectdata:SetStart(trace.StartPos)
			effectdata:SetNormal(trace.HitNormal)
			util.Effect("RagdollImpact", effectdata)
			if not trace.HitSky then
				if trace.SurfaceProps then
					effectdata:SetSurfaceProp(trace.SurfaceProps)
				else
					effectdata:SetSurfaceProp(0)
				end

				effectdata:SetDamageType(stbl.MeleeDamageType) --effectdata:SetDamageType(DMG_BULLET)
				effectdata:SetHitBox(trace.HitBox)
				effectdata:SetEntity(ent)
				util.Effect("Impact", effectdata)
			end
		--end
	end

	--if IsFirstTimePredicted() then
		if hit then
			self:PlayHitSound()
		else
			self:PlayMissSound()
		end
	--end

	if stbl.FrozenWhileSwinging then
		owner:ResetSpeed()
	end
end

function SWEP:Think()
	self:CheckIdleAnimation()
	self:CheckAttackAnimation()
	self:CheckMeleeAttack()
end

function SWEP:MeleeHitWorld(trace)
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	local owner = self:GetOwner()
	local radius = 75
	local chembuff = (owner.ChemBuffZombie and owner.ChemBuffZombie.DieTime >= CurTime())
	if chembuff then
		local name = owner:GetZombieClassTable().Name
		local breacher, charger, destroyer = "Chem Breacher", "Chem Charger", "Chem Destroyer"
		if (name ~= (breacher or charger or destroyer)) then
			if not ent:IsPlayer() then
				if SERVER then
					local pos = trace.HitPos

					for _, hitent in pairs(util.BlastAlloc(self, owner, pos, radius)) do
						if hitent:IsBarricadeProp() then
							local nearest = ent:NearestPoint(pos)
							
							damage = damage * 0.75
							hitent:TakeSpecialDamage((((radius ^ 2) - nearest:DistToSqr(pos)) / (radius ^ 2)) * damage, DMG_SLASH, owner, self)
						end
					end
				end
			end
		end
	end
	
	if ent:IsPlayer() then
		self:MeleeHitPlayer(ent, trace, damage, forcescale)
	else
		self:MeleeHitEntity(ent, trace, damage, forcescale)
	end

	self:ApplyMeleeDamage(ent, trace, damage)
end

function SWEP:MeleeHitEntity(ent, trace, damage, forcescale)
	local stbl = E_GetTable(self)

	local phys = ent:GetPhysicsObject()
	if phys:IsValid() and phys:IsMoveable() then
		if trace.IsPreHit then
			phys:ApplyForceOffset(damage * 750 * (forcescale or stbl.MeleeForceScale) * self:GetOwner():GetAimVector(), (ent:NearestPoint(self:GetOwner():EyePos()) + ent:GetPos() * 5) / 6)
		else
			phys:ApplyForceOffset(damage * 750 * (forcescale or stbl.MeleeForceScale) * trace.Normal, (ent:NearestPoint(trace.StartPos) + ent:GetPos() * 2) / 3)
		end

		ent:SetPhysicsAttacker(self:GetOwner())
	end
end

function SWEP:MeleeHitPlayer(ent, trace, damage, forcescale)
	local stbl = E_GetTable(self)

	ent:ThrowFromPositionSetZ(self:GetOwner():GetPos(), damage * 2.5 * (forcescale or stbl.MeleeForceScale))
	ent:MeleeViewPunch(damage)
	local nearest = ent:NearestPoint(trace.StartPos)
	util.Blood(nearest, math.Rand(damage * 0.5, damage * 0.75), (nearest - trace.StartPos):GetNormalized(), math.Rand(damage * 5, damage * 10), true)
end

function SWEP:ApplyMeleeDamage(hitent, tr, damage)
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()
	local stbl = E_GetTable(self)

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetAttacker(owner)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(stbl.MeleeDamageType)
	dmginfo:SetDamage(damage)
	dmginfo:SetDamageForce(math.min(damage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then
		if SERVER then
			hitent:SetLastHitGroup(tr.HitGroup)
			if tr.HitGroup == HITGROUP_HEAD then
				hitent:SetWasHitInHead()
			end

			if hitent:WouldDieFrom(damage, tr.HitPos) then
				dmginfo:SetDamageForce(math.min(damage, 50) * 400 * owner:GetAimVector())
			end
		end

		vel = hitent:GetVelocity()
	end

	if hitent:IsValid() then
		hitent:TakeDamageInfo(dmginfo)
	end

	-- No knockback vs. players
	if vel then
		hitent:SetLocalVelocity(vel)
	end

	--[[if hitent:IsPlayer() then
		local vel = hitent:GetVelocity()
		hitent:TakeSpecialDamage(damage, self.MeleeDamageType, self:GetOwner(), self, tr.HitPos)
		hitent:SetLocalVelocity(vel)
	else
		local dmgtype, owner, hitpos = self.MeleeDamageType, self:GetOwner(), tr.HitPos
		timer.Simple(0, function() -- Avoid prediction errors.
			if hitent:IsValid() and self:IsValid() and owner:IsValid() then
				hitent:TakeSpecialDamage(damage, dmgtype, owner, self, hitpos)
			end
		end)
	end]]
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or IsValid(FeignDeath[self:GetOwner()]) then return end

	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()

	local ACD = E_GetTable(self).Primary.Delay * armdelay

	self:SetNextPrimaryFire(CurTime() + ACD)
	self:SetNextSecondaryFire(self:GetNextPrimaryFire() + 0.5)

	self:SetAbstractNumber(ACD)
	self:SetTime(ACD)

	self:StartSwinging()
end

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() or IsValid(FeignDeath[self:GetOwner()]) then return end

	self:SetNextSecondaryFire(CurTime() + E_GetTable(self).AlertDelay)

	local SCD = self:GetNextSecondaryFire() - CurTime()
	self:SetMaxCooldown(SCD)
	self:SetCooldown(SCD)
	

	self:DoAlert()
end

function SWEP:DoAlert()
	self:GetOwner():DoReloadEvent()

	if SERVER then
		local ent = self:GetOwner():CompensatedMeleeTrace(4096, 24).Entity
		if ent:IsValidPlayer() then
			self:PlayAlertSound()
			--[[
			if self:GetOwner():Health() < self:GetOwner():GetMaxHealth() then
				self:DoRegen()
			end
			]]
		else
			self:PlayIdleSound()
		end
	end
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_alert"..math.random(3)..".wav")
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_voice_idle"..math.random(14)..".wav")
end

function SWEP:SendAttackAnim()
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	local armdelay = stbl.MeleeAnimationMul

	if stbl.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	stbl.SwapAnims = not stbl.SwapAnims
	if stbl.SwingAnimSpeed then
		owner:GetViewModel():SetPlaybackRate(stbl.SwingAnimSpeed * armdelay)
	else
		owner:GetViewModel():SetPlaybackRate(1 * armdelay)
	end
end

function SWEP:DoSwingEvent()
	self:GetOwner():DoZombieEvent()
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

function SWEP:StopSwinging()
	self:SetSwingEndTime(0)
end

function SWEP:KnockedDown(status, exists)
	self:StopSwinging()
end

function SWEP:Deploy()
	local stbl = E_GetTable(self)

	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	if stbl.DelayWhenDeployed and stbl.Primary.Delay > 0 then
		self:SetNextPrimaryFire(CurTime() + stbl.Primary.Delay)
		self:SetNextSecondaryFire(self:GetNextPrimaryFire() + 0.5)
	end

	return true
end
function SWEP:OnRemove()

end
SWEP.Holster = SWEP.OnRemove

function SWEP:SetSwingEndTime(time)
	self:SetDTFloat(7, time)
end

function SWEP:GetSwingEndTime()
	return self:GetDTFloat(7)
end

function SWEP:IsSwinging()
	return self:GetSwingEndTime() > 0
end

function SWEP:SetCooldown(time)
	self:SetDTFloat(8, CurTime() + time)
end

function SWEP:SetTime(time) -- okay
	self:SetDTFloat(18, CurTime() + time)
end

function SWEP:GetCooldown()
	return self:GetDTFloat(8)
end

function SWEP:GetTime()
	return self:GetDTFloat(18)
end

function SWEP:SetMaxCooldown(time)
	self:SetDTFloat(9, time)
end

function SWEP:GetMaxCooldown()
	return self:GetDTFloat(9)
end

function SWEP:SetSwingStartTime(time)
	self:SetDTFloat(10, time)
end

function SWEP:GetSwingStartTime()
	return self:GetDTFloat(10)
end
SWEP.IsAttacking = SWEP.IsSwinging