AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_onyx"))
SWEP.Description = (translate.Get("desc_onyx"))

SWEP.Slot = 3
SWEP.SlotPos = 0

sound.Add({
	name = 			"robotnik_bo1_psg1.Single",			// <-- Sound Name That gets called for
	channel = 		CHAN_USER_BASE +10,
	volume = 		1.0,
	sound = 			"weapons/robotnik_bo1_psg1/fire.wav"	// <-- Sound Path
})

sound.Add({
	name = 			"robotnik_bo1_psg1.out",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/robotnik_bo1_psg1/out.wav"	
})

sound.Add({
	name = 			"robotnik_bo1_psg1.in1",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/robotnik_bo1_psg1/in1.wav"	
})

sound.Add({
	name = 			"robotnik_bo1_psg1.in2",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/robotnik_bo1_psg1/in2.wav"	
})

sound.Add({
	name = 			"robotnik_bo1_psg1.pull",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/robotnik_bo1_psg1/pull.wav"	
})

sound.Add({
	name = 			"robotnik_bo1_psg1.safety",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/robotnik_bo1_psg1/safety.wav"	
})

sound.Add({
	name = 			"robotnik_bo1_psg1.deploy",			
	channel = 		CHAN_AUTO,
	volume = 		1.0,
	sound = 			"weapons/robotnik_bo1_psg1/deploy.wav"	
})

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(-2, -1.2, 3)
	SWEP.HUD3DAng = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.013
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_psg1_a1.mdl"
SWEP.WorldModel = "models/weapons/w_psg1_a1.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/robotnik_bo1_psg1/fire.wav"
SWEP.Primary.Damage = 89.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.75

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 6.5
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(11, -9, -2.2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.HeadshotMulti = 2

SWEP.Tier = 3

SWEP.ResistanceBypass = 0.4

SWEP.FireAnimSpeed = 0.6

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.09)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim((self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawRegularScope()
		end
	end
end

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_onyx_bounty")), (translate.Get("desc_onyx_bounty")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.775
	wept.InnateBounty = true
	wept.BountyDamage = 0.6
	wept.HeadshotMulti = 2

	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.05, 1, branch)
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_BOUNTY, 0.075, 2, branch)
end)