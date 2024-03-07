AddCSLuaFile()

SWEP.PrintName = "Ghost Of Evil"--(translate.Get("wep_butcherknife"))
SWEP.Description = ""--(translate.Get("desc_butcherknife"))

SWEP.Base = "weapon_zs_basemelee"

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["element_name4"] = { type = "Model", model = "models/props_combine/combine_barricade_bracket02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.264, -0.724, -6.337), angle = Angle(-90, -91.817, 0.078), size = Vector(0.248, 0.151, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name1"] = { type = "Model", model = "models/Mechanics/robotics/a1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.016, 1.514, -0.848), angle = Angle(98.297, 0, 0), size = Vector(0.414, 0.133, 0.337), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
		["element_name2"] = { type = "Model", model = "models/props_phx/gears/bevel12.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(4.721, -0.068, 0.054), angle = Angle(-87.707, -9.733, -9.974), size = Vector(0.15, 0.125, 0.616), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props/CS_militia/milceil001", skin = 0, bodygroup = {} },
		["element_name7"] = { type = "Model", model = "models/props_phx/wheels/magnetic_large_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.044, 0.992, -0.09), angle = Angle(0, -0.7, -85), size = Vector(0.136, 0.136, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/introomarea_sheet", skin = 0, bodygroup = {} },
		["element_name5+++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(0, 0, 255, 230), surpresslightning = true, material = "models/shadertest/shader1_dudv", skin = 0, bodygroup = {} },
		["element_name4+"] = { type = "Model", model = "models/props_combine/combine_barricade_bracket01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.106, 0.476, 6.309), angle = Angle(90, -91.817, 0.078), size = Vector(0.248, 0.151, 0.155), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["element_name5++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/props_combine/portalball001_sheet", skin = 0, bodygroup = {} },
		["element_name3"] = { type = "Model", model = "models/props_phx/gears/bevel90_24.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(5.087, -0.003, 0.245), angle = Angle(92.072, 0, 0), size = Vector(0.122, 0.057, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props/CS_militia/milceil001", skin = 0, bodygroup = {} },
		["element_name5++++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/props_combine/portalball001_sheet", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["element_name4"] = { type = "Model", model = "models/props_combine/combine_barricade_bracket02b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9, 1.7, -4.7), angle = Angle(-1, -19, 97), size = Vector(0.248, 0.151, 0.155), color = Color(255, 210, 115, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
		["element_name1"] = { type = "Model", model = "models/Mechanics/robotics/a1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.016, 1.514, -0.848), angle = Angle(98.297, 0, 0), size = Vector(0.414, 0.133, 0.337), color = Color(255, 210, 115, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
		["element_name5++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(255, 210, 115, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
		["element_name7"] = { type = "Model", model = "models/props_phx/wheels/magnetic_large_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.044, 0.992, -0.09), angle = Angle(0, -0.7, -85), size = Vector(0.136, 0.136, 0.13), color = Color(255, 210, 115, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
		["element_name4+"] = { type = "Model", model = "models/props_combine/combine_barricade_bracket01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(-4.106, 0.476, 6.309), angle = Angle(90, -91.817, 0.078), size = Vector(0.248, 0.151, 0.155), color = Color(255, 210, 115, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
		["element_name2"] = { type = "Model", model = "models/props_phx/gears/bevel12.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(4.721, -0.068, 0.054), angle = Angle(-87.707, -9.733, -9.974), size = Vector(0.15, 0.125, 0.616), color = Color(255, 210, 115, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
		["element_name3"] = { type = "Model", model = "models/props_phx/gears/bevel90_24.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "element_name1", pos = Vector(5.087, -0.003, 0.245), angle = Angle(92.072, 0, 0), size = Vector(0.122, 0.057, 0.048), color = Color(255, 210, 115, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
		["element_name5+++++"] = { type = "Model", model = "models/props_phx/misc/flakshell_big.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.436, 1.513, -3.623), angle = Angle(6.921, 0, 180), size = Vector(0.194, 0.009, 1.289), color = Color(255, 210, 115, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
	}

	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self:GetAbstractNumber(), col, "Next Shield", true)
	end
end

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Automatic = false
SWEP.Secondary.Automatic = false

SWEP.UseHands = false 

SWEP.MeleeDamage = 80
SWEP.MeleeRange = 75
SWEP.MeleeDamageSave = SWEP.MeleeDamage
SWEP.Primary.Delay = 1.35
SWEP.MeleeSize = 1

SWEP.SwingTime = 0
SWEP.MeleeKnockBack = 0
SWEP.StaminaConsumption = 0

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitDecal = nil
SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.AllowQualityWeapons = false
SWEP.UseMelee1 = true
SWEP.CanBlocking = false
SWEP.NoGlassWeapons = true
SWEP.ZombieOnly = true

if CLIENT then
	local matWhite = ("models/debug/debugwhite")
	function SWEP:PostDrawViewModel(vm)
		for _, element in pairs(self.VElements) do
			element.color = Color(255, 210, 115)
			element.material = matWhite
		end

		self.BaseClass.PostDrawViewModel(self, vm)
	end
end

function SWEP:CanPrimaryAttack()
	local pl = self:GetOwner()
	if (pl.ShadeControl and pl.ShadeControl:IsValid()) or (pl.ShadeShield and pl.ShadeShield:IsValid()) then return false end
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	local owner = self:GetOwner()
	if hitent:IsPlayer() then
		self.MeleeDamage = 135
	else
		self.MeleeDamage = self.MeleeDamageSave
	end

	if SERVER then 
		local pos = tr.HitPos
		local radius = 64
		local damage = self.MeleeDamageSave
		for _, hitent2 in pairs(util.BlastAlloc(self, owner, pos, radius)) do
			if hitent2:IsBarricadeProp() then
				local nearest = hitent2:NearestPoint(pos)
					
				damage = damage * 0.5
				hitent2:TakeSpecialDamage((((radius ^ 2) - nearest:DistToSqr(pos)) / (radius ^ 2)) * damage, DMG_SLASH, owner, self)
			end
		end
	end
end


function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() then
		local owner = self:GetOwner()
		ent:ApplyZombieDebuff("enfeeble", 3, {Applier = owner, Stacks = 3}, true, 6)
		ent:ApplyZombieDebuff("frightened", 3, {Applier = owner}, true, 39)
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
end

function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * armdelay)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/eblade/eblade_swing_0"..math.random(3)..".wav", 125, math.random(85, 100))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/eblade/eblade_swing_0"..math.random(3)..".wav", 125, math.random(85, 100))
end
