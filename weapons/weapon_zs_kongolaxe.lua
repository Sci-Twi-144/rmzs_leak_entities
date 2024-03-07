AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_kongolaxe"))
SWEP.Description = (translate.Get("desc_kongolaxe"))

if CLIENT then
	SWEP.ViewModelFOV = 65
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base2+++"] = { type = "Model", model = "models/props_phx/misc/iron_beam1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-0.519, 14, 0), angle = Angle(0, 90, -90), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
		["base2"] = { type = "Model", model = "models/props_phx/gibs/wooden_wheel2_gib2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(2, 15.074, -1.5), angle = Angle(0, -45, 0), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props/cs_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.299, -4), angle = Angle(0, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base2++++"] = { type = "Model", model = "models/props_phx/construct/metal_angle180.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(0, 15.064, -1), angle = Angle(0, 180, 0), size = Vector(0.2, 0.2, 0.5), color = Color(255, 255, 255, 35), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["base2++"] = { type = "Model", model = "models/props_phx/gibs/wooden_wheel2_gib2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(2.049, 15.064, -1.52), angle = Angle(0, -80, 0), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
		["base2+"] = { type = "Model", model = "models/props_phx/construct/metal_angle180.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(0, 15.064, -1), angle = Angle(0, 180, 0), size = Vector(0.2, 0.2, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props/cs_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.299, -4), angle = Angle(0, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base2+++"] = { type = "Model", model = "models/props_phx/misc/iron_beam1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.519, 14, 0), angle = Angle(0, 90, -90), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
		["base2"] = { type = "Model", model = "models/props_phx/gibs/wooden_wheel2_gib2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.699, 15.074, -1.5), angle = Angle(0, -45, 0), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
		["base2++++"] = { type = "Model", model = "models/props_phx/construct/metal_angle180.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 15.064, -1), angle = Angle(0, 180, 0), size = Vector(0.2, 0.2, 0.5), color = Color(255, 255, 255, 35), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
		["base2++"] = { type = "Model", model = "models/props_phx/gibs/wooden_wheel2_gib2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.75, 15.064, -1.52), angle = Angle(0, -80, 0), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
		["base2+"] = { type = "Model", model = "models/props_phx/construct/metal_angle180.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 15.064, -1), angle = Angle(0, 180, 0), size = Vector(0.2, 0.2, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} }
	}
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self.AbilityMax, nil, "Blast Swing", false, true)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 215
SWEP.MeleeRange = 76
SWEP.MeleeSize = 3.5
SWEP.MeleeKnockBack = 350

SWEP.Primary.Delay = 1.4

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingRotation = Angle(60, 0, -80)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 0.7
SWEP.SwingHoldType = "melee"

SWEP.HitDecal = "Manhackcut"

SWEP.BlockRotation = Angle(0, 15, -40)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.8
SWEP.BlockReduction = 16
SWEP.StaminaConsumption = 15

SWEP.ResourceMul = 1
SWEP.HasAbility = true
SWEP.AbilityMax = 1600
--SWEP.SpecAtribute = true

SWEP.Tier = 4

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.13)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_kongolaxe_bounty")), (translate.Get("desc_kongolaxe_bounty")), function(wept)
	if CLIENT then
		wept.PostDrawViewModel = function(self, vm)
			self.VElements["base2+++"].color = Color(135, 115, 255)
			self.VElements["base2"].color = Color(135, 115, 255)
			self.VElements["base"].color = Color(135, 115, 255)
			self.VElements["base2++++"].color = Color(135, 115, 255)
			self.VElements["base2++"].color = Color(135, 115, 255)
			self.VElements["base2+"].color = Color(135, 115, 255)
			self.BaseClass.PostDrawViewModel(self, vm)
		end
	end

	wept.AbilityMax = 1600
	wept.MeleeDamage = wept.MeleeDamage * 0.8
	wept.Primary.Delay = wept.Primary.Delay * 1.2
	wept.InnateBounty = true
	wept.BountyDamage = 0.65
end)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(40, 45))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf_club/golf_hit-0"..math.random(4)..".ogg", 75, math.random(70, 75))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_bloody_break.wav", 80, math.random(95, 105))
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
function SWEP:MeleeSwing()
	if not self:GetTumbler() then self.BaseClass.MeleeSwing(self) return end

	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if SERVER then
		if not stbl.ZombieOnly then
			owner:TakeStamina(stbl.StaminaConsumption, 2.5)
		end
	end

	owner:DoAttackEvent()
	if stbl.MissAnim then
		self:SendWeaponAnim(stbl.MissAnim)
	end
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	local hit = false
	local tr = owner:CompensatedPenetratingMeleeTrace(stbl.MeleeRange * (otbl.MeleeRangeMul or 1), stbl.MeleeSize)
	local ent

	local damagemultiplier = (owner:Team() == TEAM_HUMAN and (otbl.MeleeDamageMultiplier or 1)) or 1
	damagemultiplier = owner:GetStatus("laststand") and 1.33 or 1

	if self:IsHeavy() then
		damagemultiplier = damagemultiplier * 1.45
		if owner:GetInfo("zs_noheavyviewpunch") == "0" and IsFirstTimePredicted() then
			local r = math.Rand(0.8, 1) * 3
			owner:ViewPunch(Angle(-1 * r, 0, r * (math.random(2) == 1 and -1 or 1)))
		end
		
		self:OnHeavy()
	end

	damagemultiplier = self:BeforeSwing(damagemultiplier)

	local damage = self:GetDamage(self:GetTracesNumPlayers(tr), stbl.MeleeDamage * damagemultiplier)

	for _, trace in ipairs(tr) do
		if not trace.Hit then continue end

		ent = trace.Entity

		hit = true

		local hitflesh = trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH

		if hitflesh then
			util.Decal(stbl.BloodDecal, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)

			if SERVER then
				self:ServerHitFleshEffects(ent, trace, damagemultiplier)
			end

		end

		if ent and ent:IsValid() then
			if SERVER then
				self:ServerMeleeHitEntity(trace, ent, damagemultiplier)
			end

			self:MeleeHitEntityPenetrating(trace, ent, damagemultiplier, damage)

			if SERVER then
				self:ServerMeleePostHitEntity(trace, ent, damagemultiplier)
			end

			if otbl.GlassWeaponShouldBreak then break end
		end
	end

	if hit then
		self:PlayHitSound()

		self:SetTumbler(false)
		self:SetResource(0)
	else
		self:PlaySwingSound()

		if otbl.MeleePowerAttackMul and otbl.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end

	self:AfterSwing()
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
		return basedamage * math.Clamp(1.25 - numplayers * 0.25, 0.5, 1)
	end

	return basedamage
end

function SWEP:MeleeHitEntity(tr, hitent, damagemultiplier)
	self.BaseClass.MeleeHitEntity(self, tr, hitent, damagemultiplier)
	if self:GetResource() >= self.AbilityMax then
		self:SetResource(self.AbilityMax)
		self:SetTumbler(true)
	end
end

function SWEP:MeleeHitEntityPenetrating(tr, hitent, damagemultiplier, damage)
	local stbl = E_GetTable(self)
	local otbl = E_GetTable(owner)

	if not IsFirstTimePredicted() then return end

	if stbl.MeleeFlagged then stbl.IsMelee = true end

	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)

	damage = damage * damagemultiplier

	if SERVER and hitent:IsPlayer() and not stbl.NoGlassWeapons and owner:IsSkillActive(SKILL_GLASSWEAPONS) then
		damagemultiplier = damagemultiplier * 3.5
		otbl.GlassWeaponShouldBreak = not otbl.GlassWeaponShouldBreak
	end

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetAttacker(owner)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(stbl.DamageType)
	if hitent:IsPhysicsProp() and not owner:IsValidLivingZombie() then
		dmginfo:SetDamage(0)
	else
		if hitent:IsValidLivingZombie() and hitent:GetStatus("freeze") and self:IsHeavy() then
			dmginfo:SetDamage(self:CheckShatter(hitent, damage, tr.HitPos))
		else
			local headshot = (SERVER and (tr.HitGroup == HITGROUP_HEAD) and not stbl.ZombieOnly) and 1.6 or 1
			dmginfo:SetDamage(damage * headshot)
		end
	end
	dmginfo:SetDamageForce(math.min(stbl.MeleeDamage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then
		self:PlayerHitUtil(owner, damage, hitent, dmginfo)

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