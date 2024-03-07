AddCSLuaFile()

SWEP.Base = "weapon_zs_executioner"

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base+++"] = { type = "Model", model = "models/hunter/triangles/1x1mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(3.743, 0, 19.208), angle = Angle(180, 0, 90), size = Vector(0.12, 0.029, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} },
		["base"] = { type = "Model", model = "models/props_docks/channelmarker_gib01.mdl", bone = "tag_weapon", rel = "", pos = Vector(0, 0, 7), angle = Angle(0, 180, 0), size = Vector(0.15, 0.15, 0.813), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 15.366), angle = Angle(0, 0, 0), size = Vector(0.09, 0.09, 0.143), color = Color(211, 255, 255, 255), surpresslightning = false, material = "models/props_debris/rebar_medthin01", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/hunter/tubes/circle2x2d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.888, 0, 19.982), angle = Angle(-33.882, 0, 90), size = Vector(0.231, 0.268, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_docks/channelmarker_gib01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.664, 2.203, -11.2), angle = Angle(174.453, -10, 3.076), size = Vector(0.15, 0.15, 0.813), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/hunter/triangles/1x1mirrored.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(3.743, 0, 19.208), angle = Angle(180, 0, 90), size = Vector(0.12, 0.029, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 15.366), angle = Angle(0, 0, 0), size = Vector(0.09, 0.09, 0.143), color = Color(211, 255, 255, 255), surpresslightning = false, material = "models/props_debris/rebar_medthin01", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/hunter/tubes/circle2x2d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.888, 0, 19.982), angle = Angle(-33.882, 0, 90), size = Vector(0.231, 0.268, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/pipemetal004a", skin = 0, bodygroup = {} }
	}

	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self.ResCap, col, "Double-Shot", false)
	end
end

SWEP.MeleeDamage = 75
SWEP.Primary.Delay = 1.35
SWEP.MeleeKnockBack = 0

SWEP.StaminaConsumption = 0
SWEP.SwingTime = 0.7

SWEP.AllowQualityWeapons = false
SWEP.UseMelee1 = true
SWEP.CanBlocking = false
SWEP.NoGlassWeapons = true
SWEP.SpecialBossWeapon = true
SWEP.ZombieOnly = true
SWEP.Undroppable = true
SWEP.NoPickupNotification = true
SWEP.NoDismantle = true

SWEP.ResourceMul = 1
SWEP.ResCap = 200
SWEP.HasAbility = true

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

function SWEP:Reload()
	if self:GetResource() >= self.ResCap then
		local owner = self:GetOwner()
		local center = owner:GetPos() + Vector(0, 0, 32)
		owner:EmitSound("ambient/machines/machine1_hit2.wav", 100, 100)
		if SERVER then
			timer.Simple(0.08, function()
				owner:Give("weapon_zs_sv10_z")
				owner:SelectWeapon("weapon_zs_sv10_z")
			end)
		end
		self:SetResource(0)
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:SendWeaponAnim(self:IsHeavy() and ACT_VM_HITRIGHT or ACT_VM_HITLEFT)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, self.SwingTime * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5) -- we dont want over 2x attack penalty, right?
	local condition = clamped 

	self:SetSwingEnd(CurTime() + time * condition)
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf_club/golf_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end