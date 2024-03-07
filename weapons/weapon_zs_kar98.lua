AddCSLuaFile()

DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_kar98"))
SWEP.Description = (translate.Get("desc_kar98"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 56
	SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "Weapon"
	SWEP.HUD3DPos = Vector(1.4, -5.5, 0.75)
	SWEP.HUD3DAng = Angle(0, 180, 75)
	SWEP.HUD3DScale = 0.01

	SWEP.VMPos = Vector(1, 1.5, -2)

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(-0.0, -0.05, 0.2), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.93, 0.93, 0.93), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.93, 1, 0.93), pos = Vector(0.25, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_ins2/w_k98.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.0999999046326, 0.75, -1), angle = Angle(-10, -1.1000000238419, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	function SWEP:DrawAds()
		if not self:GetIronsights() then
			self.ViewModelFOV = 56
		end
	end
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/tfa_ins2/c_k98.mdl"
SWEP.WorldModel = "models/weapons/tfa_ins2/w_k98.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/tfa_ins2/k98/mosin_fp.wav"
SWEP.Primary.Damage = 69.5 --132
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.527
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 5
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.FireAnimSpeed = 1.25
SWEP.Tier = 2 --5

SWEP.Pierces = 1
SWEP.ProjExplosionTaper = 0.52
SWEP.DamageTaper = SWEP.ProjExplosionTaper

SWEP.Primary.Ammo = "357"
SWEP.ConeMax = 1.5 * 2
SWEP.ConeMin = 0.5

SWEP.ResistanceBypass = 0.4
SWEP.IronSightsPos = Vector(-5.275, -6.5, 2.85)
SWEP.IronSightsAng = Vector(0.2, 0, 0)
SWEP.CurrentRicos = 0

SWEP.UseEmptyReloads = false
SWEP.BoltAction = ACT_SHOTGUN_RELOAD_FINISH

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BULLET_PIERCES, 1, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.75)
--GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_TAPER, 0.5, 3)

function SWEP:PrimaryAttack()
	self.CurrentRicos = 2
	BaseClass.PrimaryAttack(self)
	local iron = self:GetIronsights()
	local seq = self:SequenceDuration(self:SelectWeightedSequence(ACT_VM_PRIMARYATTACK)) --любители блядь пустых кадров насовать
	local seq1 = self:SequenceDuration(self:SelectWeightedSequence(iron and ACT_VM_PULLBACK_HIGH or ACT_VM_PULLBACK_LOW))
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	--print(((seq + seq1) / self.FireAnimSpeed) / reloadspeed)
	self:SetNextPrimaryFire(CurTime() + ((seq + seq1) / self.FireAnimSpeed) / reloadspeed)
end

function SWEP:SendWeaponAnimation()
	local iron = self:GetIronsights()
	local is_last = (self:Clip1() == 1) and ACT_VM_PRIMARYATTACK_EMPTY or ACT_VM_PRIMARYATTACK
	local is_lastiron = (self:Clip1() == 1) and ACT_VM_PRIMARYATTACK_2 or ACT_VM_PRIMARYATTACK_1
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	self:SendWeaponAnim(iron and is_lastiron or is_last)
	self:GetOwner():GetViewModel():SetPlaybackRate(iron and (self.FireAnimSpeed * reloadspeed) or (0.8 * reloadspeed))
	if not (self:Clip1() > 0) then return end
	if not IsFirstTimePredicted() then return end
	timer.Simple(0.33 / (self.FireAnimSpeed * reloadspeed), function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed * reloadspeed)
		end
	end)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
		if CLIENT then
			self.ViewModelFOV = 80
		end
	end
end

function SWEP:Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	self.BaseClass.Think(self)
end

function SWEP:OnZombieKilled(zombie, total, dmginfo)
	local killer = self:GetOwner()
	--print(self.CurrentRicos)
	if killer:IsValid() and zombie:WasHitInHead() and self.CurrentRicos > 0 then

		local headpos = zombie:GetShootPos()
		local function FindHead(target)
			local classmdl, bloated, poison, skeletaltorso = (target and target:GetZombieClassTable().Model or nil), Model("models/player/fatty/fatty.mdl"), Model("models/Zombie/Poison.mdl"), Model("models/zombie/classic_torso.mdl")
			local bonenum = target and ((classmdl == poison and 14) or (classmdl == bloated and 12) or (classmdl == skeletaltorso and 7)) or 0
			
			return (target:GetBonePositionMatrixed(target:GetHitBoxBone(bonenum, 0)) - headpos):GetNormalized()
		end
		self.CurrentRicos = self.CurrentRicos - 1
		local numba = 1
		local zombiedamageprev = zombie:GetMaxHealthEx() * 0.10
		timer.Simple(0.06, function()
			for _, ent in pairs(team.GetPlayers(TEAM_ZOMBIE)) do
				if ent and ent:IsValid() and ent:IsValidLivingZombie() and ent:GetShootPos():DistToSqr(headpos) < (1028 ^ 2) and WorldVisible(headpos, ent:GetShootPos()) and not SpawnProtection[ent] then
					if numba < 1 then break end
					local vectordir = FindHead(ent)
					local damage = self.Primary.Damage * 0.8 + zombiedamageprev
					headpos.z = headpos.z + 2
					FORCE_B_EFFECT = true
					self:FireBulletsLua(headpos, vectordir, 0, 1, 1, 1, damage, killer, nil, "tracer_piercer", self.BulletCallback, nil, nil, 1028, nil, self)
					FORCE_B_EFFECT = false
					numba = numba - 1
				end
			end
		end)
	end
end

sound.Add({
	name = 			"TFA_INS2_K98.Boltback",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/k98/mosin_boltback.wav"
})

sound.Add({
	name = 			"TFA_INS2_K98.Boltrelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/k98/mosin_boltrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2_K98.Boltforward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/k98/mosin_boltforward.wav"
})

sound.Add({
	name = 			"TFA_INS2_K98.BoltLatch",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/k98/mosin_boltlatch.wav"
})

sound.Add({
	name = 			"TFA_INS2_K98.Roundin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			{"weapons/tfa_ins2/k98/mosin_bulletin_1.wav", "weapons/tfa_ins2/k98/mosin_bulletin_2.wav", "weapons/tfa_ins2/k98/mosin_bulletin_3.wav", "weapons/tfa_ins2/k98/mosin_bulletin_4.wav" }
})

sound.Add({
	name = 			"TFA_INS2_K98.Empty",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/tfa_ins2/k98/mosin_empty.wav"
})