AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = (translate.Get("wep_ks23"))
SWEP.Description = (translate.Get("desc_ks23"))

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.AbilityText = ""
SWEP.AbilityColor = Color(65, 250, 220)
SWEP.AbilityMax = 3600

if CLIENT then
    SWEP.ViewModelFOV = 64
	SWEP.ViewModelFlip = false
    SWEP.ShowWorldModel = false

	SWEP.HUD3DBone = "ks23"
	SWEP.HUD3DPos = Vector(-1.8, -0.5, 0.65)
	SWEP.HUD3DAng = Angle(90, 270, 90)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(1.5, 0, 0)

    SWEP.VElements = {}
    SWEP.WElements = {
        ["weapon"] = { type = "Model", model = "models/weapons/fas2wm/shotguns/ks23_wm.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1, -3), angle = Angle(-11, 1, 180), size = Vector(1.1000000238419, 1.1000000238419, 1.1000000238419), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, true, 6, 1/6)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, true, 6, 1/6)
	end

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "SLUG"
		else
			return "BIO"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "SLUG"
		else
			return "BIO"
		end
	end	
end

SWEP.ViewModel = "models/weapons/fas2vm/shotguns/ks23.mdl"
SWEP.WorldModel = "models/weapons/fas2wm/shotguns/ks23_wm.mdl"
SWEP.UseHands = true

SWEP.HoldType = "shotgun"

SWEP.CSMuzzleFlashes = true

--SWEP.ReloadDelay = 0.9

SWEP.Primary.Sound = ")weapons/fas2tfa/ks23/ks23_fire1.wav"
SWEP.Primary.Damage = 18
SWEP.DamageSave = SWEP.Primary.Damage * (GAMEMODE.ZombieEscape and 4 or 1)
SWEP.Primary.NumShots = 16
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.NoReviveFromKills = true
SWEP.Tier = 6

SWEP.ConeMax = 8
SWEP.ConeMin = 4

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin

SWEP.HasAbility = true
SWEP.MainAttack = true
SWEP.ItsFinal = false

SWEP.PumpActivity = ACT_SHOTGUN_RELOAD_FINISH
SWEP.ReloadStartActivityEmpty = ACT_VM_RELOAD_EMPTY
SWEP.UseEmptyReloads = false 

SWEP.IronSightsPos = Vector(-2.7285, -7.035, 1.8975)
SWEP.IronSightsAng = Vector(.7, 0.015, 0)

SWEP.DontScaleReloadSpeed = false 

SWEP.IronAnim = ACT_VM_PRIMARYATTACK_1

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.350, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.034, 1)

SWEP.SpreadPattern = {
	{-5, 0},
	{-4, 3},
	{0, 5},
	{4, 3},
	{5, 0},
	{4, -3},
	{2, 2},
	{-2, -2},
	{-2, 2},
	{2, -2},
	{0, 2},
	{0, -2},
	{-2, 0},
	{2, 0},
	{0, -5},
	{-4, -3},
}

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = false

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
	elseif self:GetFireMode() == 1 then
	end
end

local function BIOMOMENT(self)
	self.Primary.Damage = self.DamageSave * 16
	self.ResistanceBypass = 0.6
	self.Primary.NumShots = 1
	self.ClassicSpread = true
	self.Pierces = 1
	self.Recoil = 1.5
	self.DamageTaper = nil
	self.SpecificCond = true
end

local function SLUGMOMENT(self)
	self.Primary.Damage = self.DamageSave * 16
	self.ResistanceBypass = 0.4
	self.Primary.NumShots = 1
	self.ClassicSpread = true
	self.Pierces = 4
	self.Recoil = 2
	self.DamageTaper = 0.5
	self.SpecificCond = true
end

local function BASED(self)
	self.Primary.Damage = self.DamageSave
	self.ClassicSpread = false
	self.ResistanceBypass = 1
	self.Primary.NumShots = 16
	self.Pierces = 1
	self.Recoil = 0
	self.DamageTaper = nil
	self.SpecificCond = false
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:ForceReload()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.2)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:GetIronsights() and ACT_VM_PRIMARYATTACK_1 or ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
    local time = self:GetNextPrimaryFire()
	timer.Simple(0.05, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
		end
	end)
end

function SWEP:PrimaryAttack()
	self.MainAttack = true
	self.ItsFinal = false
	BASED(self)
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end

	if self:GetResource() >= 600  then
		self:SetResource(self:GetResource() - 600)
		if self:GetFireMode() == 0 then
			SLUGMOMENT(self)
		elseif self:GetFireMode() == 1 then
			BIOMOMENT(self)
		end
		self.MainAttack = false
		self.BaseClass.PrimaryAttack(self)
		self.ItsFinal = false
	end
end

function SWEP:GetCone()
	return self.BaseClass.GetCone(self) * (self.MainAttack and 1 or 0.35)
end

function SWEP:OnZombieKilled(pl, totaldamage, dmginfo)
	local killer = self:GetOwner()
	local rag = pl:GetRagdollEntity()
	if killer:IsValid() then
		local attackerpos = killer:GetPos()
		local dist = pl:GetPos():Distance(attackerpos)
		if not pl.Gibbed then
			pl:Gib()
		end
	end
	SUPRESS_RAGDOLL = false 
end

function SWEP.BulletCallback(attacker, tr, dmginfo)	
	local ent = tr.Entity
	local pos = tr.HitPos
	local wep = dmginfo:GetInflictor()

	if (wep:GetFireMode() == 1) and not wep.MainAttack then
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetMagnitude(0.75)
		util.Effect("explosion_chem", effectdata, true)
	end

	if SERVER then
		if wep:GetResource() > wep.AbilityMax then
			wep:SetResource(wep.AbilityMax)
		end

		if IsFirstTimePredicted() then	
			SUPRESS_RAGDOLL = true
			timer.Simple(0, function() SUPRESS_RAGDOLL = false end)
		end	
		if not wep.MainAttack then
			local ent = tr.Entity
			if wep:GetFireMode() == 0 then
				if ent:IsValidLivingZombie() then
					local sdamage = (1 - (0.25 * (attacker.BuffEffectiveness or 1)))
					ent:ApplyZombieDebuff("zombiedartdebuff", 3 * (attacker.BuffDuration or 1) , {Applier = attacker, Damage = sdamage}, true, 37)
					ent:ApplyZombieDebuff("zombiestrdebuff", 3 * (attacker.BuffDuration or 1) , {Applier = attacker, Damage = 1.25}, true, 35)
				end
			else
				local taper = 1
				if attacker:IsValidLivingHuman() then
					util.BlastDamagePlayer(wep, attacker, pos, 65 * (attacker.ExpDamageRadiusMul or 1), dmginfo:GetDamage() * 0.5, DMG_ALWAYSGIB, 0.8)
					for _, zomb in pairs(util.BlastAlloc(wep, attacker, pos, 65 * (attacker.ExpDamageRadiusMul or 1))) do
						if zomb:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", zomb, attacker) then
							zomb:AddLegDamageExt(10 * taper, attacker, wep, SLOWTYPE_ACID)
							taper = taper * 0.8
						end
					end
				end
			end
		end
	end
end


--[[
sound.Add({
	name = 			"FAS2TFA_KS23.1",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/fas2tfa/ks23/ks23_fire1.wav"
})

sound.Add({
	name = 			"FAS2TFA_KS23.2",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/fas2tfa/ks23/ks23_fire_suppressed.wav"
})
]]
sound.Add({
	name = 			"FAS2TFA_KS23.OUTDOOR",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/fas2tfa/ks23/ks23_outdoors.wav"
})

sound.Add({
	name = 			"FAS2TFA_KS23.PumpBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/fas2tfa/ks23/ks23_pump_back.wav"
})

sound.Add({
	name = 			"FAS2TFA_KS23.PumpForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/fas2tfa/ks23/ks23_pump_forward.wav"
})

sound.Add({
	name = 			"FAS2TFA_KS23.InsertPort",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/fas2tfa/ks23/ks23_insert_port.wav"
})

sound.Add({
	name = 			"FAS2TFA_KS23.Insert",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/fas2tfa/ks23/ks23_insert"..math.random(1, 3)..".wav"
})