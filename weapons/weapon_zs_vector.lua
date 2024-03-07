AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_vector"))
SWEP.Description = (translate.Get("desc_vector"))

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.HasAbility = true
SWEP.AbilityMax = 2500

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(2, -1, 1)
	SWEP.HUD3DAng = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.01

	SWEP.VMPos = Vector(0, 1.5, -0.25)
	SWEP.VMAng = Vector(0, 0, 0)
	
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, Color(130, 130, 240), self:GetResource(), self.AbilityMax, "BURST ATTACK")
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, Color(130, 130, 240), self:GetResource(), self.AbilityMax, "BURST ATTACK")
	end

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		elseif self:GetFireMode() == 1 then
			return "ABILITY"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Stock"
		elseif self:GetFireMode() == 1 then
			return "Ability"
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_vector_a1.mdl"
SWEP.WorldModel = "models/weapons/w_vector_a1.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/zs_vector/Fire.wav"
SWEP.Primary.Damage = 24.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06

SWEP.Primary.ClipSize = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3.85
SWEP.ConeMin = 1.85

SWEP.FireAnimSpeed = 1.5

SWEP.ResistanceBypass = 0.825

SWEP.Tier = 5

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.IronsightsMultiplier = 0.8
SWEP.IronSightsPos = Vector(-2.5, -1.346, 0.83)
SWEP.IronSightsAng = Vector(-0.212, 0, 0)

SWEP.ConeMaxSave = SWEP.ConeMax
SWEP.ConeMinSave = SWEP.ConeMin
SWEP.DamageSave = SWEP.Primary.Damage
SWEP.DelaySave = SWEP.Primary.Delay

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.15)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 3, 1)

function SWEP:SendWeaponAnimation()
	local dfanim = self:GetIronsights() and ACT_VM_PRIMARYATTACK_DEPLOYED or ACT_VM_PRIMARYATTACK
	self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local wep = dmginfo:GetInflictor()

	if SERVER and IsValid(wep) and wep:GetTumbler() and wep:GetFireMode() == 1 then
		wep:SetResource(wep:GetResource() - 75)
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end
		
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	local owner = self:GetOwner()

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

	if self:GetTumbler() and (self:GetFireMode() == 1) and (owner:GetAmmoCount(self.Primary.Ammo) >= 1) and (self:GetResource() > 75) then
		self:EmitFireSound()
		self:TakeCombinedPrimaryAmmo(1)
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	elseif self:GetFireMode() == 0 then -- стандартная стрельба, если активирован 2 режим стрельбы без тумблера, оружие не будет стрелять
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	else
		self:EmitSound(self.DryFireSound)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
	end
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self.Primary.Damage = self.DamageSave
		self.ConeMax = self.ConeMaxSave
		self.Primary.NumShots = 1
		self.Primary.Delay = self.DelaySave
		self:SetTumbler(false)
	elseif self:GetFireMode() == 1 then 
		self.Primary.Damage = self.DamageSave * 1.25
		self.ConeMax = self.ConeMaxSave * 0.5
		self.Primary.NumShots = 2
		self.Primary.Delay = self.DelaySave * 0.66
		self:SetTumbler(true)
	end
end

--[[
Должно работать следующем образом
Если активирован тумблер, но режим стрельбы стоковый, будет работать дефолт
Если активирован тумблер, но режим стрельбы абилити, и при этом в инвентаре есть смг пули, то это заработает
Если и тумблер и режим стрельбы абилити активированы, но нету патронов, то стрельбы не будет
]]

sound.Add({
	name = 			"Vector.fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/Fire.wav"
})

sound.Add({
	name = 			"Vector.lift",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/lift.wav"	
})

sound.Add({
	name = 			"Vector.clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/clipout.wav"	
})

sound.Add({
	name = 			"Vector.clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/clipin.wav"	
})

sound.Add({
	name = 			"Vector.chamber",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/chamber.wav"	
})

sound.Add({
	name = 			"Vector.draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/zs_vector/draw.wav"	
})