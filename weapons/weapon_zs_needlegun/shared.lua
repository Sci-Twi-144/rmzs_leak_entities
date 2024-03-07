SWEP.PrintName = (translate.Get("wep_needlegun"))
SWEP.Description = (translate.Get("desc_needlegun"))

-- 2-ая ветка Хантера

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/rmzs/weapons/css_awp_new/c_awp_new.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = ""
SWEP.Primary.Delay = 1.5
SWEP.Primary.Automatic = false
SWEP.Primary.Damage = 117

SWEP.Primary.ClipSize = 5
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.DefaultClip = 20

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.Tier = 3

SWEP.ReloadDelay = 2.8

SWEP.ConeMax = 1.5
SWEP.ConeMin = 0

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)

function SWEP:EmitFireSound()
	self:EmitSound(")weapons/tmp/tmp-1.wav", 75, math.random(225, 250), 0.8)
	self:EmitSound(")weapons/flashbang/flashbang_explode2.wav", 75, math.random(300, 325), 1, CHAN_WEAPON+20)
end

function SWEP:SendReloadAnimation()
    local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
    self:SendWeaponAnim(checkempty)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
	self.ReloadTimerAnim = CurTime() + self:SequenceDuration() / (1.25 * self:GetReloadSpeedMultiplier())
end

function SWEP:FireAnimationEvent(pos,ang,event)
	if ( event == 20 ) then return true end	

	if ( event == 5001 ) then return true end
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

sound.Add({
	name = 			"NEW_AWP.Boltup",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_boltup.wav"
})

sound.Add({
	name = 			"NEW_AWP.Boltpull",
	channel = 		CHAN_ITEM2,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_boltpull.wav"
})

sound.Add({
	name = 			"NEW_AWP.Boltdown",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_boltdown.wav"
})

sound.Add({
	name = 			"NEW_AWP.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_clipout.wav"
})

sound.Add({
	name = 			"NEW_AWP.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/awp_new/awp_clipin.wav"
})