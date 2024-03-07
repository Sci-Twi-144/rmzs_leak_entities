AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_rebarmace"))
SWEP.Description = (translate.Get("desc_rebarmace"))

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_debris/rebar004b_48.mdl", bone = "tag_weapon", rel = "", pos = Vector(0, -0.78, 12), angle = Angle(0, 0, 180), size = Vector(0.8, 0.8, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_debris/rebar004b_48.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.244, 3.529, -15.808), angle = Angle(-3.796, 1.958, -4.97), size = Vector(0.8, 0.8, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	local texture = Material( "models/rmzs/weapons/fusion_breaker/fusion_breaker_head.vmt" )

	function SWEP:PreDrawViewModel(vm)
		self.BaseClass.PreDrawViewModel(self, vm)
		texture:SetFloat("$emissiveblendenabled", 0)
	end
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/rmzs/weapons/fusion_breaker/c_fusion_breaker.mdl"
--SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 160
SWEP.MeleeRange = 73
SWEP.MeleeSize = 2
SWEP.MeleeKnockBack = 300

SWEP.Primary.Delay = 1.4

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.SwingTime = 0.8
SWEP.SwingHoldType = "melee"

SWEP.BlockRotation = Angle(0, 0, 15)
SWEP.BlockOffset = Vector(-5, 0, -2)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.4
SWEP.BlockReduction = 13
SWEP.StaminaConsumption = 12

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER

SWEP.Tier = 3

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.15)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_rebarward")), (translate.Get("desc_rebarward")), function(wept)
	wept.Primary.Delay = wept.Primary.Delay * 0.8
	wept.MeleeDamage = wept.MeleeDamage * 0.8
	wept.MeleeKnockBack = 200

	wept.OnZombieKilled = function(self, zombie, total, dmginfo)
		local killer = self:GetOwner()
		if killer:IsValid() then
			killer:ApplyHumanBuff("medrifledefboost", 15 * (killer.BuffDuration or 1), {Applier = killer})
		end
	end

	if SERVER then
		wept.OnMeleeHit = function() end
	end
end)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(55, 65))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav", 75, math.random(95, 105))
end

if SERVER then
	function SWEP:OnMeleeHit(hitent, hitflesh, tr)
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

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	self:SendWeaponAnim(self:IsHeavy() and ACT_VM_HITRIGHT or ACT_VM_HITLEFT)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.SwingTime * (1 + (1 - (otbl.MeleeSwingDelayMul or 1))) * 1.25)
	stbl.IdleAnimation = CurTime() + self:SequenceDuration()

	self:PlayStartSwingSound()

	local time = stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	local clamped = math.min(math.max(0, self.SwingTime * (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5)
	local condition = clamped * 0.5

	self:SetSwingEnd(CurTime() + time * condition)
end
