AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_p_shutter"))
SWEP.Description = (translate.Get("desc_p_shutter"))

if CLIENT then
	SWEP.ViewModelFOV = 65

	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self.AbilityMax, nil, "Special Attack", false, true)
	end

	SWEP.VMPos = Vector(0, 2, -3)
	SWEP.VMAng = Angle(0, 0, 0)

	SWEP.VertsTable = {}
	SWEP.NextRandom = 0
	SWEP.PointsToDraw = {}
	SWEP.InstantBone = {}
	SWEP.PointMatrices = {}

	local beam1mat = Material("trails/physbeam", "smooth")

	local matBeam = Material("trails/electric")
	local glowmat = Material("sprites/glow04_noz")
	
	function SWEP:DrawLightning(startpos, endpos, iteration, sizable, randomdivides)
		local pi = math.pi
		local dir = endpos - startpos
		local dirnorm = dir:GetNormalized()
		local life = 0.25
		
		local function Dir()
			local ang = dir:Angle()
			local forward = ang:Forward()
			ang:RotateAroundAxis(forward, math.random(360))
			return ang:Up()
		end
		
		if not self.PointMatrices[iteration] or self.PointMatrices[iteration][2] < CurTime() then
			local points = randomdivides and math.random(35, 60) or 16
			self.PointMatrices[iteration] = {}
			self.PointMatrices[iteration][1] = {}
			for i = 1, points do
				table.insert(self.PointMatrices[iteration][1], i, Dir())
			end
			self.PointMatrices[iteration][2] = CurTime() + life
		end
		if self.PointMatrices[iteration] then
			render.SetMaterial(beam1mat)
			local ldelta = math.Clamp((self.PointMatrices[iteration][2] - CurTime())/life, 0, 1)
			local count = #self.PointMatrices[iteration][1]
			local tbl = self.PointMatrices[iteration][1]
			local between = dir:LengthSqr()^0.5 / (count - 1)
			render.StartBeam(count)
				for i=1, count do
					local sinmod = math.sin(i/count * pi)
					local heading = Vector(0,0,0) --VectorRand()
					heading:Normalize()
					local up = Vector(0,0,1) * 5
					render.AddBeam(startpos + dirnorm * between * (i - 1) + tbl[i] * 0.1 * (2 - ldelta) + heading * 0.2 * sinmod + up * sinmod * (1-ldelta), 2 * sinmod, 1, Color(255, 255, 255, 255 * ldelta))
				end
			render.EndBeam()
		end
	end
	
	function SWEP:DrawVertices(vm)
	
		local boneid = vm:LookupBone("ValveBiped.Bip01_Spine4")
		local matrix = vm:GetBoneMatrix(boneid)
		
		if not matrix then return end
				
		if #self.VertsTable < 1 then
			local shitone, shittwo = util.GetModelMeshes(self.ViewModel)
			for a, b in pairs(shitone) do
				for i = 1, #b["verticies"] do
					table.insert(self.VertsTable, 1, {b["verticies"][i].pos, b["verticies"][i].weights[1].bone})
				end
			end
			for c, d in pairs(shittwo) do
				table.insert(self.InstantBone, c, d.matrix)
			end
		end	
		
		local tablesize = #self.VertsTable
		if self.NextRandom <= CurTime() then
			self.NextRandom = CurTime() + 0.33
			self.PointsToDraw = {}
			for s = 1, 10 do
				local desired = math.random(tablesize)
				local vec = self.VertsTable[desired][1]
				table.insert(self.PointsToDraw, 1, {vec, self.VertsTable[desired][2]})
			end
		end
		
		local mypos = vm:GetPos()
		local clr = Color(255, 255, 255)
		local boneMatrices = {}
		for i = 0, vm:GetBoneCount() - 1 do
			boneMatrices[i] = vm:GetBoneMatrix(i)
		end
		
		for a = 1, #self.PointsToDraw/2 do
			if a == #self.PointsToDraw then return end
			local z = (a == 1) and 1 or (a * 2 -1)
			local coord, bone = self.PointsToDraw[z][1], self.PointsToDraw[z][2]
			local boneMatrix = boneMatrices[bone]
			local newmatrix = boneMatrix * self.InstantBone[bone]
			local coord1, bone1 = self.PointsToDraw[z+1][1], self.PointsToDraw[z+1][2]
			local boneMatrix1 = boneMatrices[bone1]
			local newmatrix1 = boneMatrix1 * self.InstantBone[bone1]

			self:DrawLightning(newmatrix * coord, newmatrix1 * coord1, 10, false, true)		
		end
	end
	
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/rmzs/weapons/pulse_shatterer/c_pulse_shatterer.mdl"
SWEP.WorldModel = "models/rmzs/weapons/pulse_shatterer/w_pulse_shatterer.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 110
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 66
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 110

SWEP.Primary.Delay = 1

SWEP.Tier = 4

SWEP.SwingTime = 0.5
SWEP.SwingHoldType = "grenade"

SWEP.BlockOffset = Vector(5, 0, 0)
--SWEP.BlockRotation = Angle(-3.0, 7.0, -50)

SWEP.CanBlocking = true
SWEP.BlockReduction = 15
SWEP.BlockStability = 0.08
SWEP.StaminaConsumption = 9

SWEP.ResourceMul = 1
SWEP.AbilityMax = 20
SWEP.HasAbility = true
SWEP.SpecificCond = true

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.InnateTrinket = "trinket_pulse_attachement"
SWEP.LegDamageMul = 1.2
SWEP.InnateLegDamage = true

SWEP.AllowQualityWeapons = true
SWEP.Timer = 0
SWEP.MaxTMulti = 0.2
SWEP.MaxTMultiHot = 0
SWEP.CurTMulti = 0
SWEP.CurTMultiHot = 0
SWEP.LastOverclock = 0

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

if CLIENT then
	function SWEP:PostDrawViewModel(vm)
		self.BaseClass.PostDrawViewModel(self, vm)
		
		if self:GetTumbler() then
			self:DrawVertices(vm)
		end
	end
end

local material = Material("models/rmzs/weapons/pulse_shatter/pulse_shatter_core.vmt")
local material2 = Material("models/rmzs/weapons/pulse_shatter/pulse_shatter_panels.vmt")

local material1hot = Material("models/rmzs/weapons/pulse_shatter/pulse_shatter_panels_main.vmt")
local material2hot = Material("models/rmzs/weapons/pulse_shatter/pulse_shatter_panels_tube.vmt")
local material3hot = Material("models/rmzs/weapons/pulse_shatter/pulse_shatter_panels.vmt")
local material4hot = Material("models/rmzs/weapons/pulse_shatter/pulse_shatter_main.vmt")

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.ChargeSound = CreateSound(self, "ambient/machines/electric_machine.wav")
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
	self:EmitSound("weapons/metal_melee/bat_deploy_1.wav")
	return true
end

function SWEP:Holster()
	self.BaseClass.Holster(self)
	self.ChargeSound:Stop()
	return true
end

function SWEP:CanReload()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetResource() < self.AbilityMax then return false end
	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:Reload()
	if not self:CanReload() then return end
	self:ProcessSpecialAttack()
end

function SWEP:ProcessSpecialAttack()
	local vm = self:GetOwner():GetViewModel()
	if self:GetResource() >= self.AbilityMax then
		local stbl = E_GetTable(self)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetResource(0)
		self:SetTumbler(true)
		self:EmitSound("weapons/rmzs/fusion_breaker/fusion_startup.ogg", 75, math.Rand(86, 90))
		if CLIENT then
			self.MaxTMulti = 1
		end
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if not self:GetTumbler() and self.Timer <= CurTime() then
		self.Timer = CurTime() + 1
		self:SetResource(self:GetResource() + 1)
		if self:GetOverHeat() > 0 then
			self:SetOverHeat(math.max(0, self:GetOverHeat() - 1))
			if CLIENT then
				self.MaxTMultiHot = self:GetOverHeat() / 8
			end
		end
	end

	if (self.LastOverclock < CurTime()) and not (self.LegDamageMul == 1.2) then
		self:EmitSound("ambient/energy/zap".. math.random(3) ..".wav", 75)
		self.LegDamageMul = 1.2
		if CLIENT then
			self.MaxTMulti = 0.2
		end
	end

	if self:GetTumbler() then
		self.ChargeSound:PlayEx(1, 100)
	end

	if (self.MaxTMulti ~= self.CurTMulti) or (self.CurTMultiHot ~= self.MaxTMultiHot) and CLIENT then
		self.CurTMulti = math.min(self.CurTMulti + 0.05, self.MaxTMulti)
		self.CurTMultiHot = math.max(self.CurTMultiHot - 0.003, self.MaxTMultiHot)

		material:SetFloat("$emissiveblendstrength", self.CurTMulti)
		material2:SetFloat("$emissiveblendstrength", self.CurTMulti)

		material1hot:SetFloat("$detailblendfactor", self.CurTMultiHot)
		material2hot:SetFloat("$detailblendfactor", self.CurTMultiHot)
		material3hot:SetFloat("$detailblendfactor", self.CurTMultiHot)
		material4hot:SetFloat("$detailblendfactor", self.CurTMultiHot / 2)
	end
end

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	local num = math.random(3)
	local anim = (num == 1 and ACT_VM_SWINGHARD) or (num == 2 and ACT_VM_HITLEFT) or (num == 3 and ACT_VM_HITRIGHT)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.SwingTime * (1 + (1 - (otbl.MeleeSwingDelayMul or 1))))
	self:SendWeaponAnim((self:GetTumbler() or self:IsHeavy()) and ACT_VM_SECONDARYATTACK or anim)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, time * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5)
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
end

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

	local damage = ((stbl.MeleeDamage + (otbl.MeleeDamageAds or 0)) * damagemultiplier) * ((self:GetTumbler() and 2.5) or 1) * (1 + ((tobool(self:GetOverHeat() ~= 0) and (self:GetOverHeat() / 8)) or 0))
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
			dmginfo:SetDamage(damage)
		end
	end
	dmginfo:SetDamageForce(math.min(stbl.MeleeDamage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then
		self:PlayerHitUtil(owner, damage, hitent, dmginfo)

		// stick shit
		if SERVER then
			if self:GetTumbler() and hitent:IsValidLivingZombie() and not SpawnProtection[hitent] then
				local pulsedamage = damage * 0.02
				hitent:AddLegDamageExt((tobool(hitent:GetBossTier() < 1) and pulsedamage) or 0, owner, self, SLOWTYPE_PULSE)
				local taper = 1
				local count = 0
				for _, enc in pairs(util.BlastAlloc(self, owner, tr.HitPos, 74 * (owner.ExpDamageRadiusMul or 1))) do
					if enc:IsValidLivingZombie() and not (enc == hitent) and not SpawnProtection[enc] then
						enc:TakeSpecialDamage((damage / 2.1) * taper, DMG_CLUB, owner, self, tr.HitPos)
						enc:AddLegDamageExt((tobool(enc:GetBossTier() < 1) and pulsedamage) or 0, owner, self, SLOWTYPE_PULSE)
						local eData = EffectData()
							eData:SetEntity( enc )
							eData:SetMagnitude(5)
							eData:SetScale(10)
						util.Effect( "TeslaHitboxes", eData, true, true )
						taper = taper * 0.95
						if count >= 5 then break end
						count = count + 1
					end
				end

				self:SetTumbler(false)
				self:SetOverHeat(8)
				
				self.ChargeSound:Stop()
				hitent:EmitSound("npc/roller/mine/rmine_explode_shock1.wav", 100, 100)

				stbl.LastOverclock = CurTime() + 8
				stbl.LegDamageMul = 0

				if CLIENT then
					stbl.MaxTMulti = 0
					stbl.MaxTMultiHot = 1
				end
			end
		end

		//

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

function SWEP:SetOverHeat(heat)
	self:SetDTFloat(19, heat)
end

function SWEP:GetOverHeat()
	return self:GetDTFloat(19)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/metal_melee/bat_swing_miss"..math.random(2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/metal_melee/bat_impact_world"..math.random(2)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/metal_melee/melee_cricket_bat_0"..math.random(3)..".wav")
end
