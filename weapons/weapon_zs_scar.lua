AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_scar"))
SWEP.Description = (translate.Get("desc_scar"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(1.65, -1, 2.8)
	SWEP.HUD3DAng = Angle(0, 270, 90)
	SWEP.HUD3DScale = 0.012
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_bo2_scarh_n.mdl"
SWEP.WorldModel = "models/weapons/w_bo2_scarh_n.mdl"
SWEP.UseHands = true

SWEP.SoundFireVolume = 1
SWEP.SoundFireLevel = 85
SWEP.SoundPitchMin = 85
SWEP.SoundPitchMax = 90

SWEP.HeadshotMulti = 2.5

--SWEP.Primary.Sound = ")weapons/scar_bo2_rifle/fire.wav"
SWEP.Primary.Sound = Sound("Weapon_Scar.Single")
SWEP.Primary.Damage = 27.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 3.5
SWEP.ConeMin = 1.4

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 5

SWEP.FireAnimSpeed = 1

SWEP.ReloadSpeed = 0.82

SWEP.ResistanceBypass = 0.55

SWEP.IsBranch = false

SWEP.IronSightsPos = Vector(-2.22, 0.446, -0.08)
SWEP.IronSightsAng = Vector(-0.012, 0, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.06, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 4, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.05, 1)

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end

function SWEP:Deploy()
	self:SetHitStacks(0)
	self:SetNextReload(0)
	self:SetReloadFinish(0)

	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self:SetIronsights(false)

	E_GetTable(self).IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		self:CheckCustomIronSights()
		--self.bInitBobVars = true
	end

	return true
end

function SWEP:FinishReload()
	self:SetHitStacks(0)
	self.IdleActivity = ACT_VM_IDLE
	BaseClass.FinishReload(self)
end

function SWEP:GetCone()
	return BaseClass.GetCone(self) * (1 - self:GetHitStacks()/35)
end

function SWEP:SendWeaponAnimation()
	self.BaseClass.SendWeaponAnimation(self)
	self.IdleActivity = (self:Clip1() == 0) and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
end

function SWEP:SendReloadAnimation()
	--[[for num, index in pairs(self:GetSequenceList()) do
        print(index, self:GetSequenceActivityName(num))
    end]]
	self:SendWeaponAnim((self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD)
end

function SWEP:Deploy()
	self:SetHitStacks(0)
	self.IdleActivity = (self:Clip1() == 0) and ACT_VM_IDLE_EMPTY or ACT_VM_IDLE
	self.BaseClass.Deploy(self)
	return true
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if SERVER then
		local wep = attacker:GetActiveWeapon()
		if not wep.IsBranch then
			if ent:IsValidZombie() then
				wep:SetHitStacks(wep:GetHitStacks() + 1)
			end
		end
	end
end

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_smolder")
GAMEMODE:AddNewRemantleBranch(SWEP, 2, nil, nil, "weapon_zs_fal")
-- local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, translate.Get("wep_fal"), translate.Get("desc_fal"), function(wept)
	-- if CLIENT then
		-- wept.ViewModelFlip = false
		-- wept.ViewModelFOV = 70

		-- wept.HUD3DBone = "tag_weapon"
		-- wept.HUD3DPos = Vector(2.3, -1, 3)
		-- wept.HUD3DAng = Angle(0, 270, 90)
		-- wept.HUD3DScale = 0.011
	-- end

	-- wept.ViewModel = "models/weapons/c_bo2_fal.mdl"
	-- wept.WorldModel = "models/weapons/w_bo2_fal.mdl"

	-- wept.IronSightsPos = Vector(-2.36, 0.346, 0.48)
	-- wept.IronSightsAng = Vector(-0.012, 0.06, 0)

	-- wept.IsBranch = true

	-- wept.SoundFireVolume = 1
	-- wept.SoundFireLevel = 85
	-- wept.SoundPitchMin = 105
	-- wept.SoundPitchMax = 120

	-- wept.HeadshotMulti = 3

	-- wept.Primary.Sound = ")weapons/bo2/fal_fire.wav"
	-- wept.Primary.Damage = wept.Primary.Damage * 1.2
	-- wept.Primary.NumShots = 1
	-- wept.Primary.Delay = 0.125

	-- wept.Primary.ClipSize = 15
	-- wept.Primary.Automatic = false

	-- wept.ReloadSpeed = 0.91

	-- wept.ResistanceBypass = 0.4

	-- wept.ConeMax = 3.5 * 0.7
	-- wept.ConeMin = 1.4 * 0.7
-- end)
-- branch.Killicon = "weapon_zs_fal"

-- local branch2 = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_smolder")), (translate.Get("desc_smolder")), "weapon_zs_smolder")
-- branch2.Colors = {Color(130, 130, 240), Color(65, 65, 120), Color(39, 39, 90)}

sound.Add({
	name = "Weapon_Scar.Single",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 85,
	pitch = {80,90},
	sound = {"weapons/zs_scar/scar_fire1.ogg"}
})

sound.Add({
	name = 			"scar_bo2_rifle.fire",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scar_bo2_rifle/fire.wav"	
})

sound.Add({
	name = 			"scar_bo2_rifle.out",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scar_bo2_rifle/out.wav"	
})

sound.Add({
	name = 			"scar_bo2_rifle.in",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scar_bo2_rifle/in.wav"	
})

sound.Add({
	name = 			"mac_bo2_ballsita.safety",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scar_bo2_rifle/safety.wav"	
})

sound.Add({
	name = 			"scar_bo2_rifle.catch",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/scar_bo2_rifle/catch.wav"	
})

sound.Add({
	name = 			"scar_bo2_rifle.deploy",			
	channel = 		CHAN_AUTO,
	volume = 		1.0,
	sound = 			"weapons/scar_bo2_rifle/deploy.wav"	
})

sound.Add({
	name = 			"Weapon_BO2_Fal.Fire",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/bo2/fal_fire.wav"	
})

sound.Add({
	name = 			"Weapon_BO2_Fal.Magout",		
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/bo2/fal_magout.wav"	
})

sound.Add({
	name = 			"Weapon_BO2_Fal.Magin",	
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/bo2/fal_magin.wav"	
})

sound.Add({
	name = 			"Weapon_BO2_Rifles.bb",	
	channel = 		CHAN_AUTO,
	volume = 		1.0,
	sound = 			"weapons/bo2/fly_assault_bb.wav"	
})

sound.Add({
	name = 			"Weapon_BO2_Rifles.bf",	
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/bo2/fly_assault_bf.wav"	
})