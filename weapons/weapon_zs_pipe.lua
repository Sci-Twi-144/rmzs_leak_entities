AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_pipe"))
SWEP.Description = (translate.Get("desc_pipe"))

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.2, 1, -2.274), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.599, 1, -6), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end
 
SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_canal/mattpipe.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 65
SWEP.MeleeRange = 60
SWEP.MeleeSize = 1.5

SWEP.Primary.Delay = 1.2

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingTime = 0.6
SWEP.SwingRotation = Angle(10, -20, -20)
SWEP.SwingHoldType = "grenade"

SWEP.BlockRotation = Angle(0, 15, -50)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.2
SWEP.BlockReduction = 6
SWEP.StaminaConsumption = 8

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 1, 1)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(55, 65))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.random(115, 125))
end

if SERVER then
	function SWEP:OnMeleeHit(hitent, hitflesh, tr)
		if hitent:IsValid() and hitent:IsPlayer() and CurTime() >= (hitent._NextLeadPipeEffect or 0) then
			if (hitent:GetBossTier() >= 2) then return end
			hitent._NextLeadPipeEffect = CurTime() + 1.5

			--hitent:GiveStatus("disorientation")
			local x = math.Rand(0.75, 1)
			x = x * (math.random(2) == 2 and 1 or -1)

			local ang = Angle(1 - x, x, 0) * 38
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
