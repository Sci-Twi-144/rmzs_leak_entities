SWEP.ViewModel = "models/weapons/v_axe/v_axe.mdl"
SWEP.WorldModel = "models/weapons/w_axe.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1

SWEP.MeleeHeadshotMulti = 1.6

SWEP.MeleeDamage = 30
SWEP.MeleeRange = 65
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = -1

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"
SWEP.Secondary.Automatic = true

SWEP.WalkSpeed = SPEED_FAST

SWEP.IsMelee = true
SWEP.MeleeFlagged = false

SWEP.HoldType = "melee"
SWEP.SwingHoldType = "grenade"
SWEP.BlockHoldType = "revolver"

SWEP.DamageType = DMG_SLASH

SWEP.BloodDecal = "Blood"
SWEP.HitDecal = "Impact.Concrete"

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER
SWEP.AltBashAnim = false

SWEP.SwingTime = 0
SWEP.SwingRotation = Angle(0, 0, 0)
SWEP.SwingOffset = Vector(0, 0, 0)

SWEP.SwingRotationSP = Angle(0, 0, 0)
SWEP.SwingOffsetSP = Vector(0, 0, 0)

SWEP.BlockRotation = Angle(0, 0, 0)
SWEP.BlockOffset = Vector(0, 0, 0)

SWEP.CanBlocking = nil
SWEP.BlockReduction = nil

SWEP.BashDelay = 1
SWEP.BashMaximum = 305
SWEP.BashAdd = 160

SWEP.ShieldBlock = false
SWEP.BlockBashDamage = 50
SWEP.BlockStability = nil

SWEP.StaminaConsumption = 12

SWEP.CantSwitchFireModes = true

SWEP.AllowQualityWeapons = false

SWEP.Tier = 1
SWEP.Weight = 4

SWEP.NoHeavy = nil -- Конвар на отключение сильных ударов
SWEP.DisableHeavy = nil
SWEP.HeavyNoOffsetSwing = nil -- Отключить смещение модели когда происходит уже удар
SWEP.IsPenetratingMelee = false

local MAT_FLESH = MAT_FLESH
local MAT_BLOODYFLESH = MAT_BLOODYFLESH
local MAT_ANTLION = MAT_ANTLION
local MAT_ALIENFLESH = MAT_ALIENFLESH

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	local stbl = E_GetTable(self)

	GAMEMODE:DoChangeDeploySpeed(self)
	self:SetWeaponHoldType(stbl.HoldType)
	self:SetWeaponSwingHoldType(stbl.SwingHoldType)
	self:SetWeaponBlockHoldType(stbl.BlockHoldType)

	if CLIENT then
		self:Anim_Initialize()
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "PowerCombo")
end

function SWEP:SetWeaponSwingHoldType(t)
	local stbl = E_GetTable(self)

	local old = stbl.ActivityTranslate
	self:SetWeaponHoldType(t)
	local new = stbl.ActivityTranslate
	stbl.ActivityTranslate = old
	stbl.ActivityTranslateSwing = new
end

function SWEP:SetWeaponBlockHoldType(t)
	local stbl = E_GetTable(self)

	local old = stbl.ActivityTranslate
	self:SetWeaponHoldType(t)
	local new = stbl.ActivityTranslate
	stbl.ActivityTranslate = old
	stbl.ActivityTranslateBlock = new
end

function SWEP:Deploy()
	local stbl = E_GetTable(self)

	if SERVER then
		stbl.NoHeavy = tobool(self:GetOwner():GetInfo("zs_nomeleehavy"))
	else
		stbl.NoHeavy = tobool(GetConVar("zs_nomeleehavy"))
	end

	local blocking = self:IsBlocking()
	if blocking then
		local owner = self:GetOwner()
		owner:ResetSpeed()
	end

	gamemode.Call("WeaponDeployed", self:GetOwner(), self)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:Think()
	local stbl = E_GetTable(self)

	if stbl.IdleAnimation and stbl.IdleAnimation <= CurTime() then
		stbl.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	local owner = self:GetOwner()
	local noheavy = (stbl.NoHeavy or stbl.DisableHeavy)
	local holdingleft = owner:KeyDown(IN_ATTACK) and not noheavy
	local swinging = self:IsSwinging()
	local winding = self:IsWinding()

	local windend = CurTime() - self:GetWindStart() > stbl.Primary.Delay * 0.5
	if winding and (not holdingleft or windend or stbl.Primary.Delay < 0.55 or stbl.NoWind) then
		self:SetHeavy(CurTime() - self:GetWindStart() > stbl.Primary.Delay * 0.4)
		self:StopWind()
		self:StartSwinging()
		self:SetNextAttack()
	end

	if swinging and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()
		self:MeleeSwing()
		self:SetHeavy(false)
	end
	
	if swinging or winding then -- bad but ok
		if SERVER then
			owner:SetStaminaRegenDelay(2.5)
		end
	end

	self:ThinkExt()

	if not stbl.CanBlocking then return end -- hm...

	local consume = math.ceil(self.StaminaConsumption * 1.5)
	local canblock = (owner:GetStamina() < consume)
	local blocking = self:IsBlocking()
	local checkguardbreak = math.ceil(owner:GetGuardBreak() - CurTime())
	local holdingright = (owner:KeyDown(IN_ATTACK2) and not canblock and not (checkguardbreak >= 0) and not owner:GetBarricadeGhosting())
	local canattack = self:GetNextPrimaryFire() - 0.3 <= CurTime()

	if stbl.CanBlocking then
		local timesincelast = math.Clamp(self:GetBlockEnd() - CurTime(), 0, 0.5)

		if (swinging or not canattack or not holdingright) and blocking then
			self:SetBlocking(false)
			self:SetBlockEnd(CurTime() + (0.3 - timesincelast))
			owner:ResetSpeed()
		elseif (CurTime() < self:GetSwingEnd() or canattack) and holdingright and not blocking then
			self:SetBlocking(true)
			self:SetBlockEnd(CurTime() + (0.3 - timesincelast))

			owner:ResetSpeed()
			self:OnStartBlocking()

			if self:IsSwinging() then
				self:StopSwinging()
				self:SetHeavy(false)
				self:SetNextPrimaryFire(CurTime())
			end
		end
	end
end

function SWEP:ThinkExt()
end

function SWEP:GetWalkSpeed()
	return E_GetTable(self).WalkSpeed
end

function SWEP:OnStartBlocking()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or (self:GetOwner():GetStamina() == 0) then return false end

	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
end

function SWEP:PlayStartSwingSound()
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf_club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	if self:IsBlocking() then
		self:Bash()
	else
		if E_GetTable(self).SwingTime == 0 then
			self:MeleeSwing()
		else
			self:StartWinding()
		end

		self:SetNextAttack()
	end
end

function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()

	self:SetNextPrimaryFire(CurTime() + E_GetTable(self).Primary.Delay * armdelay)
end

function SWEP:Holster()
	if CurTime() >= self:GetSwingEnd() then
		if CLIENT then
			self:Anim_Holster()
		end

		return true
	end

	return false
end

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if stbl.StartSwingAnimation then
		self:SendWeaponAnim(stbl.StartSwingAnimation)
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	self:PlayStartSwingSound()

	local armdelay = owner:GetMeleeSpeedMul()
	self:SetSwingEnd(CurTime() + stbl.SwingTime * (otbl.MeleeSwingDelayMul or 1) * armdelay)
end

function SWEP:StartWinding()
	self:SetWindStart(CurTime())
end

function SWEP:DoMeleeAttackAnim()
	self:GetOwner():DoAttackEvent()
end

function SWEP:MeleeSwingPenenetrating()
	local owner = self:GetOwner()

	if SERVER then
		if not stbl.ZombieOnly then
			owner:TakeStamina(stbl.StaminaConsumption, 2.5)
		end
	end

	owner:DoAttackEvent()
	if self.MissAnim then
		self:SendWeaponAnim(self.MissAnim)
	end
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local hit = false
	local tr = owner:CompensatedPenetratingMeleeTrace(self.MeleeRange * (owner.MeleeRangeMul or 1), self.MeleeSize)
	local ent

	local damagemultiplier = (owner:Team() == TEAM_HUMAN and (owner.MeleeDamageMultiplier or 1)) or 1
	damagemultiplier = owner:GetStatus("laststand") and 1.33 or 1

	if self:IsHeavy() then
		damagemultiplier = damagemultiplier * 1.45
		self:OnHeavy()
    end

	damagemultiplier = self:BeforeSwing(damagemultiplier)

    local damage = self:GetDamage(self:GetTracesNumPlayers(tr), self.MeleeDamage * damagemultiplier)

	for _, trace in ipairs(tr) do
		if not trace.Hit then continue end

		ent = trace.Entity

		hit = true

		local hitflesh = trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH

		if hitflesh then
			util.Decal(self.BloodDecal, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)

			if SERVER then
				self:ServerHitFleshEffects(ent, trace, damagemultiplier)
			end

		end

		if ent and ent:IsValid() then
			if SERVER then
				self:ServerMeleeHitEntity(trace, ent, damagemultiplier)
			end

			self:MeleeHitEntity(trace, ent, damagemultiplier, damage)

			if SERVER then
				self:ServerMeleePostHitEntity(trace, ent, damagemultiplier)
			end

			if owner.GlassWeaponShouldBreak then break end
		end
	end

	if hit then
		self:PlayHitSound()
	else
		self:PlaySwingSound()

		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end

	self:AfterSwing()
end


function SWEP:MeleeSwing()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if stbl.IsPenetratingMelee then self:MeleeSwing() return end

	if SERVER then
		if not stbl.ZombieOnly then
			owner:TakeStamina(stbl.StaminaConsumption, 2.5)
		end
	end

	self:DoMeleeAttackAnim()

	local heavy = self:IsHeavy()

	local tr = owner:CompensatedMeleeTrace((stbl.MeleeRange + (owner.MeleeRangeAds or 0)) * (otbl.MeleeRangeMul or 1), stbl.MeleeSize)

	if not tr.Hit then
		if stbl.MissAnim then
			self:SendWeaponAnim(stbl.MissAnim)
			stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		end
		self:PlaySwingSound()

		if otbl.MeleePowerAttackMul and otbl.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end

		if heavy then
			self:OnHeavyCharge()
		end
		
		if self.SpecAtribute then
			self:MissHitSpecial()
		end
	
		if stbl.PostOnMeleeMiss then self:PostOnMeleeMiss(tr) end

		return
	end

	local tiervalid = (stbl.Tier or 1) <= 5
	local damagemultiplier = (owner:Team() == TEAM_HUMAN and (otbl.MeleeDamageMultiplier or 1)) or 1 --+ ((tiervalid and owner:HasTrinket("trinket_sharpstone")) and 0.35 / (stbl.Tier or 1) or 0) or 1)
	--damagemultiplier = owner:GetStatus("laststand") and 1.33 or 1
	if owner:GetStatus("laststand") then
		damagemultiplier = damagemultiplier * 1.33
	end

	damagemultiplier = self:GetTumbler() and stbl.SPMultiplier or damagemultiplier

	if heavy then
		damagemultiplier = damagemultiplier * 1.45
		self:OnHeavy()
	end

	damagemultiplier = self:BeforeSwing(damagemultiplier)

	local hitent = tr.Entity
	local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH

	if stbl.HitAnim then
		self:SendWeaponAnim(stbl.HitAnim)
	end
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	if hitflesh then
		util.Decal(stbl.BloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		self:PlayHitFleshSound()

		if SERVER then
			self:ServerHitFleshEffects(hitent, tr, damagemultiplier)
		end

		if not stbl.NoHitSoundFlesh then
			self:PlayHitSound()
		end
	else
		--util.Decal(self.HitDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		self:PlayHitSound()
	end

	if stbl.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr) then
		return
	end

	if SERVER then
		self:ServerMeleeHitEntity(tr, hitent, damagemultiplier)
	end

	self:MeleeHitEntity(tr, hitent, damagemultiplier)

	if stbl.PostOnMeleeHit then self:PostOnMeleeHit(hitent, hitflesh, tr) end

	if SERVER then
		self:ServerMeleePostHitEntity(tr, hitent, damagemultiplier)
	end

	self:AfterSwing()
end

function SWEP:OnHeavy()
end

function SWEP:OnHeavyCharge()
end

function SWEP:AfterSwing()
end

function SWEP:BeforeSwing(damagemultiplier)
	local owner = self:GetOwner()

	local pct = math.max( 1 - owner:GetStamina() / math.min((owner.MaxStamina or GAMEMODE.BaseStamina) * 0.5, GAMEMODE.BaseStamina * 0.5), 0)
	local dmg = damagemultiplier - pct * 0.32
	return dmg
end

function SWEP:PlayerHitUtil(owner, damage, hitent, dmginfo)
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if otbl.MeleePowerAttackMul and otbl.MeleePowerAttackMul > 1 then -- Тринкет Рукав Силы
		self:SetPowerCombo(self:GetPowerCombo() + 1)

		damage = damage + damage * (otbl.MeleePowerAttackMul - 1) * (self:GetPowerCombo()/4)
		dmginfo:SetDamage(damage)

		if self:GetPowerCombo() >= 4 then
			self:SetPowerCombo(0)
			if SERVER then
				local pitch = math.Clamp(math.random(90, 110) + 15 * (1 - damage/45), 50 , 200)
				owner:EmitSound("npc/strider/strider_skewer1.wav", 75, pitch)
			end
		end
	end

	hitent:MeleeViewPunch((damage / 2) * (stbl.MeleeViewPunchScale or 1))
	if hitent:IsHeadcrab() then
		damage = damage * 1.4
		dmginfo:SetDamage(damage)
	end
end


function SWEP:PostHitUtil(owner, hitent, dmginfo, tr, vel)
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if stbl.PointsMultiplier then
		POINTSMULTIPLIER = stbl.PointsMultiplier
	end
	if hitent:IsValid() then
		hitent:TakeDamageInfo(dmginfo)
	end
	if stbl.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end

	if vel then
		hitent:SetLocalVelocity(vel)
	end

	-- Perform our own knockback vs. players
	if hitent:IsPlayer() then
		local knockback = stbl.MeleeKnockBack * (otbl.MeleeKnockbackMultiplier or 1)
		if knockback > 0 then
			hitent:ThrowFromPositionSetZ(tr.StartPos, knockback, nil, true)
		end

		if otbl.MeleeLegDamageAdd and otbl.MeleeLegDamageAdd > 0 then
			hitent:AddLegDamage(otbl.MeleeLegDamageAdd)
		end
	end

	local effectdata = EffectData()
	effectdata:SetOrigin(tr.HitPos)
	effectdata:SetStart(tr.StartPos)
	effectdata:SetNormal(tr.HitNormal)
	util.Effect("RagdollImpact", effectdata)
	if not tr.HitSky then
		effectdata:SetSurfaceProp(tr.SurfaceProps)
		effectdata:SetDamageType(stbl.DamageType)
		effectdata:SetHitBox(tr.HitBox)
		effectdata:SetEntity(hitent)
		util.Effect("Impact", effectdata)
	end

	if stbl.MeleeFlagged then stbl.IsMelee = nil end
end

function SWEP:CheckShatter(target, inputdamage, hitpos)
	local curhp, maxhp = target:Health(), target:GetMaxHealthEx()
	local bossmul = target:GetBossTier() >= 2 and 0.08 or target:GetBossTier() > 0 and 0.15 or 0.7
	local damage = inputdamage >= (bossmul * maxhp) and inputdamage or bossmul * maxhp
	return damage
end

SWEP.MeleeHeadShotMulti = 1.4

function SWEP:MeleeHitEntity(tr, hitent, damagemultiplier)
	local stbl = E_GetTable(self)

	if not IsFirstTimePredicted() then return end

	if stbl.MeleeFlagged then stbl.IsMelee = true end

	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)

	if SERVER and hitent:IsPlayer() and not stbl.NoGlassWeapons and owner:IsSkillActive(SKILL_GLASSWEAPONS) then
		damagemultiplier = damagemultiplier * 3.5
		otbl.GlassWeaponShouldBreak = not otbl.GlassWeaponShouldBreak
	end

	local damage = (stbl.MeleeDamage + (otbl.MeleeDamageAds or 0)) * damagemultiplier

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetAttacker(owner)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(stbl.DamageType)
	if hitent:IsPhysicsProp() and not owner:IsValidLivingZombie() then
		dmginfo:SetDamage(0)
	else
		local headshot = (SERVER and (tr.HitGroup == HITGROUP_HEAD) and not stbl.ZombieOnly) and stbl.MeleeHeadShotMulti or 1
		if hitent:IsValidLivingZombie() and hitent:GetStatus("freeze") and self:IsHeavy() then
			dmginfo:SetDamage(self:CheckShatter(hitent, damage, tr.HitPos))
		else
			dmginfo:SetDamage(damage * headshot)
		end
	end
	dmginfo:SetDamageForce(math.min(stbl.MeleeDamage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then
		self:PlayerHitUtil(owner, damage, hitent, dmginfo)

		if SERVER then
			hitent:SetLastHitGroup(tr.HitGroup)
			if tr.HitGroup == HITGROUP_HEAD then
				hitent:SetWasHitInHead()
			end

			if hitent:WouldDieFrom(damage, tr.HitPos) then
				dmginfo:SetDamageForce(math.min(stbl.MeleeDamage, 50) * 400 * owner:GetAimVector())
				if SERVER and hitent:GetStatus("freeze") and self:IsHeavy() then
					local effectdata = EffectData()
						effectdata:SetOrigin(tr.HitPos)
						effectdata:SetNormal(owner:GetShootPos())
					util.Effect("hit_ice", effectdata, nil, true)
				end
			end
		end

		vel = hitent:GetVelocity()
	else
		if otbl.MeleePowerAttackMul and otbl.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end

	self:PostHitUtil(owner, hitent, dmginfo, tr, vel)
end

function SWEP:MeleeHitEntityPenetrating(tr, hitent, damagemultiplier, damage)
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()

	damage = damage * damagemultiplier

	if SERVER and hitent:IsPlayer() and not stbl.NoGlassWeapons and owner:IsSkillActive(SKILL_GLASSWEAPONS) then
		damagemultiplier = damagemultiplier * 3.5
		otbl.GlassWeaponShouldBreak = not otbl.GlassWeaponShouldBreak
	end

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetAttacker(owner)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(self.DamageType)
	if hitent:IsPhysicsProp() and not owner:IsValidLivingZombie() then
		dmginfo:SetDamage(0)
	else
		dmginfo:SetDamage(damage)
	end
	dmginfo:SetDamageForce(math.min(self.MeleeDamage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then

		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(self:GetPowerCombo() + 1)

			damage = damage + damage * (owner.MeleePowerAttackMul - 1) * (self:GetPowerCombo()/4)
			dmginfo:SetDamage(damage)

			if self:GetPowerCombo() >= 4 then
				self:SetPowerCombo(0)
				if SERVER then
					local pitch = math.Clamp(math.random(90, 110) + 15 * (1 - damage/45), 50 , 200)
					owner:EmitSound("npc/strider/strider_skewer1.wav", 75, pitch)
				end
			end
		end

		hitent:MeleeViewPunch(damage)
		if hitent:IsHeadcrab() then
			damage = damage * 2
			dmginfo:SetDamage(damage)
		end

		if SERVER then
			hitent:SetLastHitGroup(tr.HitGroup)
			if tr.HitGroup == HITGROUP_HEAD then
				hitent:SetWasHitInHead()
			end

			if hitent:WouldDieFrom(damage, tr.HitPos) then
				dmginfo:SetDamageForce(math.min(self.MeleeDamage, 50) * 400 * owner:GetAimVector())
			end
		end

		vel = hitent:GetVelocity()
	else
		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end

	--if not hitent.LastHeld or CurTime() >= hitent.LastHeld + 0.1 then -- Don't allow people to shoot props out of their hands
		if self.PointsMultiplier then
			POINTSMULTIPLIER = self.PointsMultiplier
		end

		if hitent:IsValid() then
			hitent:TakeDamageInfo(dmginfo)
		end

		if self.PointsMultiplier then
			POINTSMULTIPLIER = nil
		end

		-- Invalidate the engine knockback vs. players
		if vel then
			hitent:SetLocalVelocity(vel)
		end
	--end

	-- Perform our own knockback vs. players
	if hitent:IsPlayer() then
		local knockback = self.MeleeKnockBack * (owner.MeleeKnockbackMultiplier or 1)
		if knockback > 0 then
			hitent:ThrowFromPositionSetZ(tr.StartPos, knockback, nil, true)
		end

		if owner.MeleeLegDamageAdd and owner.MeleeLegDamageAdd > 0 then
			hitent:AddLegDamage(owner.MeleeLegDamageAdd)
		end
	end

	local effectdata = EffectData()
	effectdata:SetOrigin(tr.HitPos)
	effectdata:SetStart(tr.StartPos)
	effectdata:SetNormal(tr.HitNormal)
	util.Effect("RagdollImpact", effectdata)
	if not tr.HitSky then
		effectdata:SetSurfaceProp(tr.SurfaceProps)
		effectdata:SetDamageType(self.DamageType)
		effectdata:SetHitBox(tr.HitBox)
		effectdata:SetEntity(hitent)
		util.Effect("Impact", effectdata)
	end
end

function SWEP:CallWeaponBlock(ent)
end

function SWEP:Bash()
	if CurTime() < self:GetBashEnd() then return end

	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	local consume = math.ceil((stbl.StaminaConsumption * 1.37) * (otbl.StaminaBashCost or 1))
	if owner:GetStamina() < consume then return end

	local parry = owner:IsSkillActive(SKILL_PARRY)
	if SERVER then
		local delays = GAMEMODE.StaminaDelayOnHit * (otbl.StaminaDelayBashMul or 1)

		owner:TakeStamina((parry and consume * 2 or consume), delays)
	end

	local impetus = owner:IsSkillActive(SKILL_IMPETUS)
	local armdelay = owner:GetMeleeSpeedMul()
	self:SetBashEnd(CurTime() + stbl.BashDelay * armdelay * (impetus and 2 or 1))
	if stbl.MissAnim then
		self:SendWeaponAnim(stbl.MissAnim)
	end

	if stbl.AltBashAnim then
		self:SendWeaponAnim(stbl.AltBashAnim)
	end

	stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(43, 46))

	owner:MeleeViewPunch(15)
	owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND, true)

	local tr = owner:CompensatedMeleeTrace(61, math.min(12, stbl.MeleeSize * 3))

	if tr.Hit and tr.Entity:IsValidLivingZombie() then
		local hitent = tr.Entity
		hitent:EmitSound("npc/antlion_guard/shove1.wav", 75, 245, 1, CHAN_WEAPON + 1)

		local knockback = math.min(stbl.BashMaximum, stbl.MeleeKnockBack + stbl.BashAdd) * (otbl.BashForceMul or 1) * (otbl.MeleeKnockbackMultiplier or 1)
		hitent:ThrowFromPositionSetZ(tr.StartPos, knockback, nil, true)
		hitent:AddLegDamage(7 * (otbl.BashForceMul or 1))
		
		if owner.TrinketBusher then
			hitent.StaminaForKill = CurTime() + 5
		end
		
		if impetus then
			local zdb = hitent:GiveStatus("zombiestrdebuff")
			if zdb and IsValid(zdb) then
				zdb.DieTime = CurTime() + 3
				zdb.Applier = owner
				zdb:SetDamage(1.2)
			end
			--hitent.BashedRecently = CurTime() + 3
			--hitent.BashedWeapon = self
		end

		if (otbl.BlockBashDamage or 1) > 0 and stbl.ShieldBlock then
			hitent:TakeSpecialDamage(otbl.BlockBashDamage or 50, DMG_SLASH, owner, self)
		end

		if not stbl.ShieldBlock and owner:IsSkillActive(SKILL_DEADLY_BASH) then
			local damagemultiplier = (owner:Team() == TEAM_HUMAN and (otbl.MeleeDamageMultiplier or 1))
			local damage = (stbl.MeleeDamage + (otbl.MeleeDamageAds or 0)) * damagemultiplier
			hitent:TakeSpecialDamage(damage * 0.50, DMG_SLASH, owner, self)
		end

		if parry and not stbl.ShieldBlock then
			local wep = hitent:GetActiveWeapon()
			if wep and wep:IsValid() and wep.GetSwingEndTime then
				local endtime = wep:GetSwingEndTime()
				local curtime = CurTime()

				local window = math.max(0, (1.7 - (stbl.BlockStability or 1)) * 0.05) + 0.08

				if curtime > (endtime - window) and curtime < endtime then
					if SERVER then
						hitent:EmitSound("npc/roller/blade_out.wav", 75, 65)
						local maxstamina = otbl.MaxStamina or GAMEMODE.BaseStamina
						owner:SetStamina(math.min(maxstamina, owner:GetStamina() + maxstamina * 0.25))
						owner:ApplyHumanBuff("strengthdartboost", 5, {Applier = owner, Damage = 0.5})

						hitent:AddArmDamage(24)
						hitent:AddLegDamage(24)
					end

					if wep.StopSwinging then
						wep:StopSwinging()
					end

					for i = 0, 10 do
						timer.Simple(i * 0.01, function()
							hitent:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, 1 - i * 0.07)
						end)
					end
				end
			end
		end

		self:BashEffect(tr, hitent)
	end
end

function SWEP:RollMelee()

	local qualities = {
	{"Common", 1.2},
	{"Rare", 1.4},
	{"Epic", 1.6},
	{"Heroic", 1.8},
	{"Legendary", 2}
	}
	
	local dql = math.random(5)
	
	local quality, qualitynum = qualities[dql][1], qualities[dql][2]

	print(quality, qualitynum)
	
	local function RollNum()
		local val = (math.random() + 0.8) * qualitynum
		print(val)
		return val
	end
	
	self.PrintName = quality .. (self.PrintName or "Shit")
	self.MeleeDamage = self.MeleeDamage * RollNum()
	self.Primary.Delay = math.max(self.Primary.Delay / RollNum(), 0.1)
	self.MeleeRange = math.ceil(self.MeleeRange * RollNum())
	self.BlockStability = self.BlockStability * RollNum()
	self.BlockReduction = self.BlockReduction * RollNum()
	self.StaminaConsumption = math.max(self.StaminaConsumption / RollNum(), 0.1)
end

function SWEP:BashEffect(tr, ent)
end

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
function SWEP:GetIronsights()
	return false
end

function SWEP:StopSwinging()
	self:SetSwingEnd(0)
end

function SWEP:IsSwinging()
	return self:GetSwingEnd() > 0
end

function SWEP:SetSwingEnd(swingend)
	self:SetDTFloat(7, swingend)
end

function SWEP:GetSwingEnd()
	return self:GetDTFloat(7)
end

function SWEP:StopWind()
	self:SetWindStart(0)
end

function SWEP:IsWinding()
	return self:GetWindStart() > 0
end

function SWEP:SetWindStart(windstart)
	self:SetDTFloat(15, windstart)
end

function SWEP:GetWindStart()
	return self:GetDTFloat(15)
end

function SWEP:SetTime(time)
	self:SetDTFloat(18, time)
end

function SWEP:GetTime()
	return self:GetDTFloat(18)
end

function SWEP:SetBlockEnd(swingend)
	self:SetDTFloat(17, swingend)
end

function SWEP:GetBlockEnd()
	return self:GetDTFloat(17)
end

function SWEP:SetBashEnd(swingend)
	self:SetDTFloat(16, swingend)
end

function SWEP:GetBashEnd()
	return self:GetDTFloat(16)
end

function SWEP:IsBlocking()
	return self:GetDTBool(10)
end

function SWEP:SetBlocking(block)
	self:SetDTBool(10, block)
end

function SWEP:IsHeavy()
	return self:GetDTBool(11)
end

function SWEP:SetHeavy(heavy)
	self:SetDTBool(11, heavy)
end

local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]      	= ACT_HL2MP_IDLE_DUEL,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA
}

function SWEP:SetWeaponHoldType( t )
	t = string.lower( t )
	local index = ActIndex[ t ]

	if ( index == nil ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set! (defaulting to normal)\n" )
		t = "normal"
		index = ActIndex[ t ]
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= index
	self.ActivityTranslate [ ACT_MP_WALK ] 						= index+1
	self.ActivityTranslate [ ACT_MP_RUN ] 						= index+2
	self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= index+3
	self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= index+4
	self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= index+5
	self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index+5
	self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_JUMP ] 						= index+7
	self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM_IDLE ] 				= index+8
	self.ActivityTranslate [ ACT_MP_SWIM ] 						= index+9

    -- "normal" jump animation doesn't exist
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
end

SWEP:SetWeaponHoldType("melee")

function SWEP:TranslateActivity( act )
	if self:GetSwingEnd() ~= 0 or self:IsWinding() and self.ActivityTranslateSwing and self.ActivityTranslateSwing[act] then
		return self.ActivityTranslateSwing[act] or -1
	end

	if self:IsBlocking() and self.ActivityTranslateBlock[act] then
		return self.ActivityTranslateBlock[act] or -1
	end

	return self.ActivityTranslate and self.ActivityTranslate[act] or -1
end