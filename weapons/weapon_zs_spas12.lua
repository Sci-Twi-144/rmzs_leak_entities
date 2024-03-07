AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"


SWEP.PrintName = (translate.Get("wep_scattershot"))
SWEP.Description = (translate.Get("desc_scattershot"))

if CLIENT then
    SWEP.ViewModelFOV = 64
	SWEP.ViewModelFlip = false
    SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1.25, 0.3, 0.5)
	SWEP.HUD3DAng = Angle(180, 0, -115)
	SWEP.HUD3DScale = 0.0125

	SWEP.VMPos = Vector(0.5, 0, -1.25)

    SWEP.VElements = {}
	
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_spas12_bri.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1, -2.7), angle = Angle(-10, -1, 178), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.AbilityText = "BOOM"
	SWEP.AbilityColor = Color(250, 108, 65)
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.IsBranch and "MAGNUM SHOT" or self.AbilityText)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.IsBranch and "MAGNUM SHOT" or self.AbilityText)
	end
end

SWEP.ViewModel = "models/weapons/tfa_ins2/c_spas12_bri.mdl"
SWEP.WorldModel = "models/weapons/tfa_ins2/w_spas12_bri.mdl"
SWEP.UseHands = true

SWEP.HoldType = "shotgun"

SWEP.ReloadDelay = 0.5

SWEP.Primary.Sound = ")weapons/tfa_ins2/spas12/fire.wav" --m590_suppressed_fp.wav
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 0.6 --0.9

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.BulletType = SWEP.Primary.Ammo
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 7
SWEP.ConeMin = 5.25

SWEP.ReloadStartActivityEmpty = ACT_VM_RELOAD_EMPTY
SWEP.UseEmptyReloads = false

SWEP.IronSightsPos = Vector(-2.62, -7.452, 0.86)
SWEP.IronSightsAng = Vector(0.07, -0.01, 0)

SWEP.Tier = 5

SWEP.DontScaleReloadSpeed = false

SWEP.HasAbility = true
SWEP.AbilityMax = 1200
SWEP.ResourceCap = SWEP.AbilityMax
SWEP.IsBranch = false

SWEP.SpreadPattern = {
    {0, 0},
    {-5, 0},
    {-4, 3},
    {0, 5},
    {4, 3},
    {5, 0},
    {4, -3},
    {0, -5},
    {-4, -3},
}

SWEP.ProceduralPattern = true
SWEP.PatternShape = "circle"

SWEP.Recoil = 7.5
SWEP.Knockback = 100

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.06, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 2, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_eradicator")), (translate.Get("desc_eradicator")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 7.5
	wept.ReloadSpeed = wept.ReloadSpeed * 1.25
	wept.Primary.Delay = wept.Primary.Delay * 0.9
	wept.Primary.NumShots = 1
	wept.ConeMax = wept.ConeMax * 0.45
	wept.ConeMin = wept.ConeMin * 0.33
	wept.Primary.Sound = ")weapons/tfa_ins2/spas12/m590_suppressed_fp.wav"
	wept.ClassicSpread = true --you make it slug, but with spredpattern option it has no spread at all
	wept.ResistanceBypass = 0.6
	wept.IsBranch = true

	wept.WalkSpeed = SPEED_SLOW

	wept.SecondaryAttack = function(self)
		if not self:CanPrimaryAttack() or (self:GetResource() < 1200) then return end
		local owner = self:GetOwner()
		local res = self:GetResource()

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitSound(self.Primary.Sound)

		local clip = self:Clip1()

		--self.ResourceMul = 0 

		self:ShootBulletsSec((self.Primary.Damage * 0.25) * clip, self.Primary.NumShots, self:GetCone())

		self:TakePrimaryAmmo(clip)
		owner:ViewPunch(clip * 0.5 * self.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		owner:SetGroundEntity(NULL)
		owner:SetVelocity(-self.Knockback * clip * owner:GetAimVector())

		timer.Simple(0, function()
			self:SetResource(res)
			self:SetResource(self:GetResource() - 1200)
		end)

		self.IdleAnimation = CurTime() + self:SequenceDuration()	
	end

	wept.ShootBulletsSec = function(self, dmg, numbul, cone)
		local owner = self:GetOwner()
		local otbl = owne
		local stbl = self
	
		self:SendWeaponAnimation()
		owner:DoAttackEvent()
		if self.Recoil > 0 then
			local r = math.Rand(0.8, 1)
			owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
		end
	
		owner:LagCompensation(true)
		owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, 10, 0.95, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallbackSec, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
		owner:LagCompensation(false)
	end

	wept.BulletCallbackSec = function(attacker, tr, dmginfo)
		local ent = tr.Entity
		if SERVER and ent and ent:IsValidLivingZombie() then
			dmginfo:SetDamageForce(attacker:GetUp() * 7000 + attacker:GetForward() * 25000)
			ent:ThrowFromPositionSetZ(tr.StartPos, dmginfo:GetDamage() * 6, nil, true)
			ent:ApplyZombieDebuff("zombiestrdebuff", 3, {Applier = attacker, Damage = 0.1}, true, 40)
		end
	end
	
	wept.GetAuraRange = function(self)
		return 256
	end

	if CLIENT then
		wept.WElements = {
			["sup"] = { type = "Model", model = "models/weapons/tfa_ins2/c_spas12_bri_supp.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "weapon", pos = Vector(-2.5, -2.2999999523163, 2.9000000953674), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_spas12_bri.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1, -2.7000000476837), angle = Angle(-10, -1, 178), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}

		wept.VElements = {
			["sup"] = { type = "Model", model = "models/weapons/tfa_ins2/c_spas12_bri_supp.mdl", bone = "Weapon", rel = "", pos = Vector(1.75, -5.7140002250671, 2.4500000476837), angle = Angle(0, -90, 0), size = Vector(0.89999997615814, 0.89999997615814, 0.89999997615814), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
	end
end)

GAMEMODE:AddNewRemantleBranch(SWEP, 2, translate.Get("wep_boomstick"), translate.Get("desc_boomstick"), "weapon_zs_boomsticknew")
GAMEMODE:AddNewRemantleBranch(SWEP, 3, translate.Get("wep_bulk"), translate.Get("desc_bulk"), "weapon_zs_bulk")

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.SpreadPatternSave = self:GeneratePattern(self.PatternShape, self.Primary.NumShots)
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() or (self:GetResource() < 600) then return end
	local owner = self:GetOwner()
	local res = self:GetResource()
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitSound("weapons/shotgun/shotgun_dbl_fire.wav")
 
	local clip = self:Clip1()

	--self.ResourceMul = 0 
	self.SpreadPattern = self:GeneratePattern("rectangle", self.Primary.NumShots * clip)
	
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self:GetCone())
	
	self.SpreadPattern = self.SpreadPatternSave

	self:TakePrimaryAmmo(clip)
	owner:ViewPunch(clip * 0.5 * self.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

	owner:SetGroundEntity(NULL)
	owner:SetVelocity(-self.Knockback * clip * owner:GetAimVector())

	timer.Simple(0, function()
		self:SetResource(res)
		self:SetResource(self:GetResource() - 1200)
	end)
	--self:SetResource(self:GetResource() - 600)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
	
    local time = self:GetNextPrimaryFire()
	timer.Simple(0.05, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:GetOwner():GetViewModel():SetPlaybackRate(1.65)
		end
	end)
end
--[[
function SWEP:StopReloading()
	self:SetDTFloat(15, 0)
	self:SetDTBool(9, false)
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	local seq2 = self:SequenceDuration(self:SelectWeightedSequence(self.PumpActivity))

	if self:Clip1() > 0 then
		if self.PumpSound then
			self:EmitSound(self.PumpSound)
		end
		if self.BoltAction then
			timer.Simple(0, function()
			self:SendWeaponAnim(self.BoltAction)
			self:ProcessReloadAnim()
			end)
		end
		if self.PumpActivity then
			self:SendWeaponAnim(self.PumpActivity)
			self:ProcessReloadAnim()
		end
	end
end
]]

sound.Add({
	name = 			"TFA_INS2_SPAS12.Draw",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/spas12/uni_weapon_draw_0"..math.random(1, 3)..".wav"
})

sound.Add({
	name = 			"TFA_INS2_SPAS12.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/spas12/uni_weapon_holster.wav"
})

sound.Add({
	name = 			"TFA_INS2_SPAS12.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/spas12/PumpBack.wav"
})

sound.Add({
	name = 			"TFA_INS2_SPAS12.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/spas12/PumpForward.wav"
})

sound.Add({
	name = 			"TFA_INS2_SPAS12.ShellInsert",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/spas12/insertshell-"..math.random(1, 3)..".wav"
})

sound.Add({
	name = 			"TFA_INS2_SPAS12.ShellInsertSingle",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/spas12/insertshell-"..math.random(1, 3)..".wav"
})

sound.Add({
	name = 			"TFA_INS2_SPAS12.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/spas12/m590_empty.wav"
})