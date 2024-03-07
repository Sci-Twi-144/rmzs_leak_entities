AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_fusionsword"))
SWEP.Description = (translate.Get("desc_fusionsword"))

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["element_name4"] = { type = "Model", model = "models/props_combine/combine_barricade_bracket02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.264, -0.724, -6.337), angle = Angle(-90, -91.817, 0.078), size = Vector(0.248, 0.151, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name5++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.148, 0.009, 1.289), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/door_klab01", skin = 0, bodygroup = {} },
		["element_name1"] = { type = "Model", model = "models/Mechanics/robotics/a1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.016, 1.514, -0.848), angle = Angle(98.297, 0, 0), size = Vector(0.414, 0.133, 0.337), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["element_name5+++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/props_combine/portalball001_sheet", skin = 0, bodygroup = {} },
		["element_name2"] = { type = "Model", model = "models/props_phx/gears/bevel12.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(4.721, -0.068, 0.054), angle = Angle(-87.707, -9.733, -9.974), size = Vector(0.15, 0.125, 0.616), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props/CS_militia/milceil001", skin = 0, bodygroup = {} },
		["element_name7"] = { type = "Model", model = "models/props_phx/wheels/magnetic_large_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.044, 0.992, -0.09), angle = Angle(0, -0.7, -85), size = Vector(0.136, 0.136, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/introomarea_sheet", skin = 0, bodygroup = {} },
		["element_name5+++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(0, 0, 255, 230), surpresslightning = true, material = "models/shadertest/shader1_dudv", skin = 0, bodygroup = {} },
		["element_name4+"] = { type = "Model", model = "models/props_combine/combine_barricade_bracket01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.106, 0.476, 6.309), angle = Angle(90, -91.817, 0.078), size = Vector(0.248, 0.151, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name5++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/props_combine/portalball001_sheet", skin = 0, bodygroup = {} },
		["element_name6+"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-6.312, -0.12, -1.65), angle = Angle(3, 90, -89.421), size = Vector(0.068, 0.086, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name6"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-6.073, -0.121, 1.858), angle = Angle(3.188, 90, -85), size = Vector(0.083, 0.076, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name3"] = { type = "Model", model = "models/props_phx/gears/bevel90_24.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(5.087, -0.003, 0.245), angle = Angle(92.072, 0, 0), size = Vector(0.122, 0.057, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props/CS_militia/milceil001", skin = 0, bodygroup = {} },
		["element_name5++++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/props_combine/portalball001_sheet", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["element_name4"] = { type = "Model", model = "models/props_combine/combine_barricade_bracket02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9, 1.7, -4.7), angle = Angle(-1, -19, 97), size = Vector(0.248, 0.151, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name5++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.148, 0.009, 1.289), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/door_klab01", skin = 0, bodygroup = {} },
		["element_name1"] = { type = "Model", model = "models/Mechanics/robotics/a1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.016, 1.514, -0.848), angle = Angle(98.297, 0, 0), size = Vector(0.414, 0.133, 0.337), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["element_name5+++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(0, 0, 255, 255), surpresslightning = true, material = "effects/combineshield/comshieldwall", skin = 0, bodygroup = {} },
		["element_name5++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(0, 103, 255, 255), surpresslightning = true, material = "effects/combineshield/comshieldwall", skin = 0, bodygroup = {} },
		["element_name7"] = { type = "Model", model = "models/props_phx/wheels/magnetic_large_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.044, 0.992, -0.09), angle = Angle(0, -0.7, -85), size = Vector(0.136, 0.136, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/introomarea_sheet", skin = 0, bodygroup = {} },
		["element_name4+"] = { type = "Model", model = "models/props_combine/combine_barricade_bracket01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.106, 0.476, 6.309), angle = Angle(90, -91.817, 0.078), size = Vector(0.248, 0.151, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name2"] = { type = "Model", model = "models/props_phx/gears/bevel12.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(4.721, -0.068, 0.054), angle = Angle(-87.707, -9.733, -9.974), size = Vector(0.15, 0.125, 0.616), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props/CS_militia/milceil001", skin = 0, bodygroup = {} },
		["element_name6+"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-6.312, -0.12, -1.65), angle = Angle(3, 90, -89.421), size = Vector(0.068, 0.086, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name6"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-6.073, -0.121, 1.858), angle = Angle(3.188, 90, -85), size = Vector(0.083, 0.076, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name3"] = { type = "Model", model = "models/props_phx/gears/bevel90_24.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(5.087, -0.003, 0.245), angle = Angle(92.072, 0, 0), size = Vector(0.122, 0.057, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props/CS_militia/milceil001", skin = 0, bodygroup = {} },
		["element_name5+++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(0, 0, 255, 255), surpresslightning = true, material = "effects/combineshield/comshieldwall", skin = 0, bodygroup = {} }
	}

end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.MeleeHeadshotMulti = 1

SWEP.MeleeDamage = 160
SWEP.MeleeRange = 80
SWEP.MeleeSize = 3.5

SWEP.InnateTrinket = "trinket_pulse_attachement"
SWEP.LegDamageMul = 1

SWEP.Primary.Delay = 1.4

SWEP.Tier = 5
SWEP.MaxStock = 2

SWEP.WalkSpeed = SPEED_SLOW

SWEP.SwingRotation = Angle(30, -20, 10)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 0.8
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 15, -40)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.6
SWEP.BlockReduction = 19
SWEP.StaminaConsumption = 15

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/eblade/eblade_swing_0"..math.random(3)..".wav", 100, math.random(85, 100))
	--self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 85))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/eblade/eblade_shock_0"..math.random(2)..".wav", nil, CHAN_AUTO)
	--self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 75)
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

function SWEP:MeleeSwing()
	local owner = self:GetOwner()

	if SERVER then
		owner:TakeStamina(self.StaminaConsumption, 2.5)
	end

	owner:DoAttackEvent()
	self:SendWeaponAnim(self.MissAnim)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local hit = false
	local tr = owner:CompensatedPenetratingMeleeTrace(self.MeleeRange * (owner.MeleeRangeMul or 1), self.MeleeSize)
	--local tr = owner:CompensatedMeleeTrace((self.MeleeRange + (owner.MeleeRangeAds or 0)) * (owner.MeleeRangeMul or 1), self.MeleeSize)
	local ent

	local damagemultiplier = (owner:Team() == TEAM_HUMAN and (owner.MeleeDamageMultiplier or 1)) or 1
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
end

function SWEP:MeleeHitEntity(tr, hitent, damagemultiplier, damage)
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()

	if SERVER and hitent:IsPlayer() and owner:IsSkillActive(SKILL_GLASSWEAPONS) then
		damagemultiplier = damagemultiplier * 3.5
		owner.GlassWeaponShouldBreak = not owner.GlassWeaponShouldBreak
	end

	damage = damage * damagemultiplier

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetAttacker(owner)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(self.DamageType)
	if hitent:IsPhysicsProp() and not owner:IsValidLivingZombie() then
		dmginfo:SetDamage(0)
	else
		local headshot = (SERVER and (tr.HitGroup == HITGROUP_HEAD) and not stbl.ZombieOnly) and 1.6 or 1
		dmginfo:SetDamage(damage * headshot)
	end
	dmginfo:SetDamageForce(math.min(self.MeleeDamage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
		hitent:AddLegDamageExt(3.5, self:GetOwner(), self, SLOWTYPE_PULSE)

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
			damage = damage * 1.4
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
