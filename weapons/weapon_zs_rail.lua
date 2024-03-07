AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_rail"))
SWEP.Description = (translate.Get("desc_rail"))
SWEP.AbilityMax = 700

if CLIENT then
	SWEP.ViewModelFOV = 75
	SWEP.ViewModelFlip = false

	SWEP.VMPos = Vector(3, -3, -1)
	SWEP.VMAng = Angle(0, 0, 3)

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 21.532, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -3.022, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.003, 73.867, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 7.349, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 33.868, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 32.353, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 11.284, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 18.393, 0) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 56.358, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 18.114, 0) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-40.083, 32.165, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(8.317, 10.201, -0.036) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 1.43, -1.701), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 22.915, 0) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 63.059, 0) },
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5.362, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 9.492, 0) },
		["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 71.029, 0) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 11.213, 0) },
		["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 63.591, 0) },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 4.508, 0) },
		["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-25.466, 71.131, 13.716) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.067, 0.509, -6.895) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(2.379, -3.186, -0.216), angle = Angle(0, 0, 0) }
	}

	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource() , self.AbilityMax, col, "Cleave", false)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/rmzs/c_rail_lol.mdl"
SWEP.WorldModel = "models/weapons/rmzs/w_rail_lol.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 570
SWEP.MeleeRange = 98
SWEP.MeleeSize = 6
SWEP.MeleeKnockBack = 650

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Primary.Delay = 2
SWEP.SwingTime = 0.6
--SWEP.SwingRotation = Angle(0, -20, -40)
--SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee"

SWEP.SPMultiplier = 1.25
SWEP.SwingTimeSP = 0.47

SWEP.BlockRotation = Angle(0, -15, 25)
SWEP.BlockOffset = Vector(3, 0, 0)

SWEP.AllowQualityWeapons = true

SWEP.CanBlocking = true
SWEP.BlockReduction = 22
SWEP.BlockStability = 1
SWEP.StaminaConsumption = 20

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.Tier = 6
SWEP.MaxStock = 2
SWEP.DisableHeavy = true

SWEP.HasAbility = true
SWEP.ResourceMul = 0.75

SWEP.AllowQualityWeapons = true

SWEP.WalkSpeed = SPEED_SLOWEST

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

SWEP.AttackACTs = {
	--ACT_VM_PRIMARYATTACK
	--ACT_VM_PRIMARYATTACK_1
	ACT_VM_PRIMARYATTACK_2
	--ACT_VM_HITLEFT
}

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:MeleeSwing() -- надо бы это дерьмо как нить переделать что в будущем не дублировать это дело в каждой пушке
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

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
		end
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		self:PlaySwingSound()

		if otbl.MeleePowerAttackMul and otbl.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end

		if heavy then
			self:OnHeavyCharge()
			--[[
			if SERVER then
				self:UtilShockWave()
			end
			]]
		end
		
		if self.SpecAtribute then
			self:MissHitSpecial()
		end
		
		self:SetTumbler(false)

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
		--util.Decal(self.HitDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		self:PlayHitSound()
	end

	if stbl.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr) then
		return
	end

	if SERVER then
		self:ServerMeleeHitEntity(tr, hitent, damagemultiplier)
	end
	if not self:GetTumbler() then
		self:MeleeHitEntity(tr, hitent, damagemultiplier)
	else
		self:DoThing(tr, hitent, damagemultiplier)
	end

	if stbl.PostOnMeleeHit then self:PostOnMeleeHit(hitent, hitflesh, tr) end

	if SERVER then
		self:ServerMeleePostHitEntity(tr, hitent, damagemultiplier)
	end

	self:AfterSwing()
end


function SWEP:DoThing(tr, hitent, damagemultiplier) -- надо будет поделить на сервер/клиент
	if SERVER then
		local owner = self:GetOwner()
		owner:RawCapLegDamage(CurTime() + 2)

		local damage = (self.MeleeDamage + (owner.MeleeDamageAds or 0)) * damagemultiplier
		local knockback = self.MeleeKnockBack * (owner.MeleeKnockbackMultiplier or 1)
			

		local range = (self.MeleeRange + (owner.MeleeRangeAds or 0)) * (owner.MeleeRangeMul or 1)
		local pos = tr.StartPos
		local dir = tr.Normal
		local angle = math.cos(math.rad(75))
		local startPos = tr.StartPos

		for _, ent in pairs(ents.FindInCone(startPos, dir, range, angle )) do
			if ent:IsValidLivingZombie() and WorldVisible(pos, ent:NearestPoint(pos))  then
				local nearest = ent:NearestPoint(pos)
				if knockback > 0 then
					ent:ThrowFromPositionSetZ(startPos, knockback, nil, true)
				end

				local sdamage = (1 - (0.25 * (owner.BuffEffectiveness or 1)))
				ent:ApplyZombieDebuff("zombiedartdebuff", 3 * (owner.BuffDuration or 1), {Applier = owner, Damage = sdamage}, true, 37, self)

				ent:TakeSpecialDamage((((range ^ 2) - nearest:DistToSqr(pos)) / (range ^ 2)) * damage, DMG_SLASH, owner, self)

				self:DoSpecialEffect(ent)
			end
		end
	end
end

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if self:GetTumbler() then
		self:SendWeaponAnim(ACT_VM_SWINGHARD)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	elseif not owner:KeyDown(IN_ATTACK) or stbl.DisableHeavy then
		self:PlayStartSwingSound()
		self:SendWeaponAnim(self.AttackACTs[math.random(#self.AttackACTs)])
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	local time = self:GetTumbler() and stbl.SwingTimeSP or stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5) -- we dont want over 2x attack penalty, right?
	local condition = not self:GetTumbler() and clamped or 1
	self:SetSwingEnd(CurTime() + time * condition)

	if not self:GetTumbler() then
		--self:GetOwner():GetViewModel():SetPlaybackRate(1 - ((clamped) - 1))
		self:GetOwner():GetViewModel():SetPlaybackRate(self.SwingTime * 1)
	end
end

function SWEP:OnHeavyCharge()
	self:SendWeaponAnim(self.AttackACTs[math.random(#self.AttackACTs)])
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:OnHeavy()
	self:SendWeaponAnim(self.AttackACTs[math.random(#self.AttackACTs)])
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:CanReload()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetResource() < 700 then return false end
	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:Reload()
	if not self:CanReload() then return end
	self:ProcessSpecialAttack()
end

function SWEP:ProcessSpecialAttack()
	if self:GetResource() >= 700 then
		self:StopWind()
		self:SetTumbler(true)
		self:StartWinding()
		self:SetNextAttack()
		self:SetResource(0)
	end
end

function SWEP:AfterSwing()
	if self:GetTumbler() then
		self:SetTumbler(false)
	end
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(25, 35))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(70, 74))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90))
	self:EmitSound("physics/flesh/flesh_impact_hard"..math.random(2, 3)..".wav", 75, math.Rand(80, 84))
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and hitent:IsHeadcrab() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
	end
end

if SERVER then
	function SWEP:OnMeleeHit(hitent, hitflesh, tr)
		self:DoSpecialEffect(hitent, hitflesh, tr)
	end

	function SWEP:DoSpecialEffect(hitent, hitflesh, tr)
		if hitent:IsValid() and hitent:IsPlayer() and CurTime() >= (hitent._NextLeadPipeEffect or 0) and (hitent:GetBossTier() <= 2) then
			hitent._NextLeadPipeEffect = CurTime() + 1.5

			--hitent:GiveStatus("disorientation")
			local x = math.Rand(0.75, 1)
			x = x * (math.random(2) == 2 and 1 or -1)

			local ang = Angle(1 - x, x, 0) * 50
			hitent:ViewPunch(ang)

			local eyeangles = hitent:EyeAngles()
			eyeangles:RotateAroundAxis(eyeangles:Up(), ang.yaw)
			eyeangles:RotateAroundAxis(eyeangles:Right(), ang.pitch)
			eyeangles.pitch = math.Clamp(ang.pitch, -89, 89)
			eyeangles.roll = 0
			hitent:SetEyeAngles(eyeangles)
		end
	end
end