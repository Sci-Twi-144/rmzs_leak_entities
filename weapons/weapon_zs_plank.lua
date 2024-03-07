AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_plank"))
SWEP.Description = (translate.Get("desc_plank"))

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_debris/wood_chunk03a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.363, 1.363, -11.365), angle = Angle(180, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_debris/wood_chunk03a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.273, 1.363, -12.273), angle = Angle(180, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_debris/wood_chunk03a.mdl"
SWEP.ModelScale = 0.5
SWEP.UseHands = true
SWEP.BoxPhysicsMin = Vector(-0.5764, -2.397225, -20.080572) * SWEP.ModelScale
SWEP.BoxPhysicsMax = Vector(0.70365, 2.501825, 19.973375) * SWEP.ModelScale

SWEP.MeleeDamage = 23
SWEP.MeleeRange = 58
SWEP.MeleeSize = 1.5
SWEP.Primary.Delay = 0.37

SWEP.BlockRotation = Angle(0, 15, -40)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.1
SWEP.BlockReduction = 4
SWEP.StaminaConsumption = 2

SWEP.WalkSpeed = SPEED_FASTER

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_keyboard")), (translate.Get("desc_keyboard")), "weapon_zs_keyboard")
GAMEMODE:AddNewRemantleBranch(SWEP, 3, (translate.Get("wep_ladel")), (translate.Get("desc_ladel")), "weapon_zs_ladel")
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_nailplank")), (translate.Get("desc_nailplank")), function(wept)
	wept.MeleeDamage = wept.MeleeDamage * 0.8
	wept.Primary.Delay = wept.Primary.Delay * 1.2
	if CLIENT then 
		wept.VElements = {
			["nail1++"] = { type = "Model", model = "models/props_debris/rebar001a_32.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(1.557, -0.519, 9.869), angle = Angle(71.299, -29.222, -3.507), size = Vector(0.6, 0.6, 0.6), color = Color(255, 188, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["base"] = { type = "Model", model = "models/props_debris/wood_chunk03a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.299, 2, -11), angle = Angle(180, 153.117, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["nail1"] = { type = "Model", model = "models/props_debris/rebar001b_48.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(0, -0.519, 8.831), angle = Angle(113.376, -176.495, -17.532), size = Vector(0.4, 0.4, 0.4), color = Color(255, 188, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["nail1+"] = { type = "Model", model = "models/props_debris/rebar001b_48.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(2.596, 1.557, 14.026), angle = Angle(111.039, 171.817, -180), size = Vector(0.4, 0.4, 0.4), color = Color(255, 188, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
		wept.WElements = {
			["base"] = { type = "Model", model = "models/props_debris/wood_chunk03a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.557, 1.557, -6.753), angle = Angle(3.506, -104.027, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["nail1++"] = { type = "Model", model = "models/props_debris/rebar001a_32.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.557, -0.519, 9.869), angle = Angle(71.299, -29.222, -3.507), size = Vector(0.6, 0.6, 0.6), color = Color(255, 188, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["nail1"] = { type = "Model", model = "models/props_debris/rebar001b_48.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, -0.519, 8.831), angle = Angle(113.376, -176.495, -17.532), size = Vector(0.4, 0.4, 0.4), color = Color(255, 188, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["nail1+"] = { type = "Model", model = "models/props_debris/rebar001b_48.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(2.596, 1.557, 14.026), angle = Angle(111.039, 171.817, -180), size = Vector(0.4, 0.4, 0.4), color = Color(255, 188, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	end

	wept.OnMeleeHit = function(self, hitent, hitflesh, tr)
		if hitent:IsValid() and hitent:IsPlayer() then
			local bleed = hitent:GiveStatus("bleed")
			if bleed and bleed:IsValid() then
				bleed:AddDamage(10)
				bleed.Damager = self:GetOwner()
			end
		end
	end

	wept.PostOnMeleeHit = function(self, hitent, hitflesh, tr)
		if hitent:IsValid() and hitent:IsPlayer() then
			local combo = self:GetDTInt(8)
			local owner = self:GetOwner()

			self:SetDTInt(8, combo + 1)
		end
		self.MeleeDamage = wept.MeleeDamage
	end
end)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/wood/wood_plank_impact_hard"..math.random(5)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(5)..".wav")
end

SWEP.SwingTime = 0
local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	
	self:SetNextPrimaryFire(CurTime() + math.max(0.2, E_GetTable(self).Primary.Delay * (1 - self:GetDTInt(8) / 10)) * armdelay)
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() then
		local combo = self:GetDTInt(8)
		local owner = self:GetOwner()

		self:SetDTInt(8, combo + 1)
	end
end

function SWEP:PostOnMeleeMiss(tr)
	self:SetDTInt(8, 0)
end
