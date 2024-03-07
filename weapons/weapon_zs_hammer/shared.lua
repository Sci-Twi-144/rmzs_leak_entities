SWEP.Base = "weapon_zs_basemelee"

SWEP.PrintName = (translate.Get("wep_hammer"))
SWEP.Description = (translate.Get("desc_hammer"))

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/v_hammer/c_hammer.mdl"
SWEP.WorldModel = "models/weapons/w_hammerfix.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "GaussEnergy"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 16

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"

--SWEP.MeleeDamage = 35 -- Reduced due to instant swing speed
SWEP.MeleeDamage = 15
SWEP.MeleeDamageSaved = SWEP.MeleeDamage
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875

SWEP.MaxStock = 5

SWEP.UseMelee1 = true

SWEP.NoPropThrowing = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HealStrength = 1
SWEP.Repair = 10

SWEP.StaminaConsumption = -1

SWEP.NoHolsterOnCarry = true

SWEP.NoGlassWeapons = true

SWEP.AllowQualityWeapons = true

SWEP.IsBranch = false

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_electrohammer")), (translate.Get("desc_electrohammer")), function(wept)
	wept.MeleeRange = wept.MeleeRange
	wept.Primary.Delay = wept.Primary.Delay

	wept.IsBranch = true

	if CLIENT then
		wept.VElements = {
			["base2"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01", rel = "base", pos = Vector(0, 0, 0), angle = Angle(0, 180, 0), size = Vector(0.08, 0.08, 0.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["base"] = { type = "Model", model = "models/props_lab/powerbox02d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.9, 4.975, -8.412), angle = Angle(5.961, 270, 16.764), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["ss"] = { type = "Sprite", sprite = "sprites/grav_flare", bone = "ValveBiped.Bip01", rel = "base", pos = Vector(-1.338, 2.894, 0.125), size = { x = 5, y = 5 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
			["base2+"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01", rel = "base", pos = Vector(-0.975, -0.263, 0.232), angle = Angle(0, 270, 90), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}

		wept.WElements = {
			["base2"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 0), angle = Angle(0, 180, 0), size = Vector(0.08, 0.08, 0.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["ss"] = { type = "Sprite", sprite = "sprites/grav_flare", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1.338, 2.894, 0.125), size = { x = 5, y = 5 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
			["base"] = { type = "Model", model = "models/props_lab/powerbox02d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -8), angle = Angle(270, 90, 90), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["base2+"] = { type = "Model", model = "models/props_lab/teleportring.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-0.975, -0.263, 0.232), angle = Angle(0, 270, 90), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	end
end)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:MeleeSwing()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if SERVER then
		if stbl.OnForce then
			owner:TakeStamina(9, 4.5)
		end
	end

	self:DoMeleeAttackAnim()

	local heavy = self:IsHeavy()

	local tr = owner:CompensatedMeleeTrace(stbl.MeleeRange * (otbl.MeleeRangeMul or 1), stbl.MeleeSize)

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

function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	local adj = (self.IsBranch and (owner:GetAmmoCount("pulse") >= 2)) and 0.91 or 1
	self:SetNextPrimaryFire(CurTime() + (self.Primary.Delay * (owner.HammerSwingDelayMul or 1) * armdelay) * (adj * (self.OnForce and 0.5 or 1)))
end

SWEP.OnForce = false

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

function SWEP:CallWeaponFunction()
	if not self:GetOwner():IsSkillActive(SKILL_HAMMEREDTTM) then return end
	if self:GetFireMode() == 1 then
		self.OnForce = true
	elseif self:GetFireMode() == 0 then
		self.OnForce = false
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 1.5)
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(4)..".ogg", 75, math.random(110, 115))
end

function SWEP:PlayRepairSound(hitent)
	hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
end
