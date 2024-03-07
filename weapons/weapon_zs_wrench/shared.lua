SWEP.PrintName = (translate.Get("wep_wrench"))
SWEP.Description = (translate.Get("desc_wrench"))

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_c17/tools_wrench01a.mdl"
SWEP.ModelScale = 1.5
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.8
SWEP.MeleeDamage = 28
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875

SWEP.MaxStock = 5

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingTime = 0.19
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "grenade"

SWEP.Repair = 13

SWEP.AllowQualityWeapons = true
SWEP.IsTool = true
SWEP.IsWrench = true

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3, 1)

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(4)..".ogg", 75, math.random(120, 125))
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Think()
	local stbl = E_GetTable(self)

	if stbl.IdleAnimation and stbl.IdleAnimation <= CurTime() then
		stbl.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	local owner = self:GetOwner()
	local swinging = self:IsSwinging()
	local winding = self:IsWinding()

	local windend = CurTime() - self:GetWindStart() > stbl.Primary.Delay * 0.5
	if winding and (not windend or stbl.Primary.Delay < 0.55 or stbl.NoWind) then
		self:SetHeavy(CurTime() - self:GetWindStart() > stbl.Primary.Delay * 0)
		self:StopWind()
		self:StartSwinging()
		self:SetNextAttack()
	end

	if swinging and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()
		self:MeleeSwing()
		self:SetHeavy(false)
	end
end

function SWEP:MeleeSwing()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:DoMeleeAttackAnim()

	local heavy = self:IsHeavy()

	local tr = owner:CompensatedMeleeTrace(stbl.MeleeRange * (otbl.MeleeRangeMul or 1), stbl.MeleeSize, nil, nil, false, true)

	if not tr.Hit then
		if stbl.MissAnim then
			self:SendWeaponAnim(stbl.MissAnim)
		end
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		self:PlaySwingSound()

		if otbl.MeleePowerAttackMul and otbl.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end

		if stbl.PostOnMeleeMiss then self:PostOnMeleeMiss(tr) end

		return
	end

	local damagemultiplier = (owner:Team() == TEAM_HUMAN and (otbl.MeleeDamageMultiplier or 1)) or 1
	if owner:GetStatus("laststand") then
		damagemultiplier = damagemultiplier * 1.33
	end

	if heavy then
		damagemultiplier = damagemultiplier * 1.45
		if owner:GetInfo("zs_noheavyviewpunch") == "0" and IsFirstTimePredicted() then
			local r = math.Rand(0.8, 1) * 3
			owner:ViewPunch(Angle(-1 * r, 0, r * (math.random(2) == 1 and -1 or 1)))
		end

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