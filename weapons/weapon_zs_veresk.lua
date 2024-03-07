AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_veresk"))
SWEP.Description = (translate.Get("desc_veresk"))

SWEP.Slot = 2
SWEP.SlotPos = 0

-- SWEP.AbilityText = "Mass Ammo Back"
-- SWEP.AbilityColor = Color(0, 150, 50)
-- SWEP.AbilityMax = 1200 * (GAMEMODE.ZombieEscape and 4 or 1)

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "mp7_main"
	SWEP.HUD3DPos = Vector(1, -1, -1)
	SWEP.HUD3DAng = Angle(90, 270, 90)
	SWEP.HUD3DScale = 0.01

	SWEP.VMPos = Vector(0, 1.5, -0.25)
	SWEP.VMAng = Vector(0, 0, 0)

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
	end

	-- function SWEP:DefineFireMode3D()
		-- if self:GetFireMode() == 0 then
			-- return "IRONSIG"
		-- else
			-- return "ABILITY"
		-- end
	-- end
	
	-- function SWEP:DefineFireMode2D()
		-- if self:GetFireMode() == 0 then
			-- return "IRONSIGHTS"
		-- else
			-- return "MASS AMMO STATUS"
		-- end
	-- end

end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/rmzs/veresk/c_veresk.mdl"
SWEP.WorldModel = "models/weapons/rmzs/veresk/w_veresk.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = Sound("TFA_INS2.SR2M_Veresk.Fire")
SWEP.Primary.Damage = 23.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

-- SWEP.HasAbility = true

-- SWEP.SetUpFireModes = 1
-- SWEP.CantSwitchFireModes = false

SWEP.ConeMax = 3.85
SWEP.ConeMin = 1.85

SWEP.FireAnimSpeed = 1.5

SWEP.ResistanceBypass = 0.8

SWEP.Tier = 5

SWEP.IronsightsMultiplier = 0.8
SWEP.IronSightsPos = Vector(-2.185, -1.346, 1.5)
SWEP.IronSightsAng = Vector(-0.212, 0, 0)
SWEP.ReloadAct = ACT_VM_RELOAD
SWEP.ReloadActEmpt = ACT_VM_RELOAD_EMPTY
SWEP.FirstDraw = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.15)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5, 1)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
local math_random = math.random
function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	local stbl = E_GetTable(self)
	
	if (self:Clip1() < stbl.RequiredClip) and self:CanReload() then
		self:Reload()
		return false
	end
	
    if self:Clip1() < stbl.RequiredClip then
        self:EmitSound(stbl.DryFireSound, 75, 100, 0.7, CHAN_WEAPON)
		self:SetNextPrimaryFire(CurTime() + math.max(0.3, stbl.Primary.Delay))
        self:SendWeaponAnim(self:GetIronsights() and ACT_VM_PRIMARYATTACK_3 or ACT_VM_DRYFIRE)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SendWeaponAnimation()
	local standart = {
		[0] = ACT_VM_PRIMARYATTACK_EMPTY,
		[1] = ACT_VM_PRIMARYATTACK
	}
	
	local ironsight = {
		[0] = ACT_VM_PRIIMARYATTACK_2,
		[1] = ACT_VM_PRIMARYATTACK_1
	}
	self:SendWeaponAnim(self:GetIronsights() and (self:Clip1() > 0 and ironsight[1] or ironsight[self:Clip1()]) or (self:Clip1() > 0 and standart[1] or standart[self:Clip1()]))
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
	self.IdleActivity = (self:Clip1() == 0) and (self:GetIronsights() and  ACT_VM_IIDLE_EMPTY or ACT_VM_IDLE_EMPTY) or self:GetIronsights() and ACT_VM_IIDLE or ACT_VM_IDLE
end

function SWEP:FinishReload()
	self:SetHitStacks(0)
	self.IdleActivity = ACT_VM_IDLE
	self.BaseClass.FinishReload(self)
end

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end


-- function SWEP:GiveStatus()
	-- local attacker = self:GetOwner()
	-- if self:GetTumbler() then
		-- self:SetResource(0)
		-- self:SetTumbler(false)
		-- attacker:EmitSound("ambient/machines/combine_terminal_idle2.wav", 70, 75)
		-- if SERVER then
			-- attacker:ApplyHumanBuff('ammoback', 15, {Applier = attacker})
			-- local wep = attacker:GetActiveWeapon()
			-- local count = 0
			-- for _, ent in pairs(util.BlastAlloc(wep, attacker, attacker:GetPos(), 64)) do
				-- if ent:IsValidLivingPlayer() and ent ~= attacker then
					-- ent:ApplyHumanBuff('ammoback', 15, {Applier = attacker})
					-- count = count + 1
					-- if count >= 3 then break end
				-- end
			-- end
		-- end
	-- end
-- end	

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

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local pos = tr.HitPos
	local wep = dmginfo:GetInflictor()

	if ent:IsValid() and ent:IsValidLivingZombie() then
		wep:SetHitStacks(wep:GetHitStacks() + 1)
	elseif ent:IsValid() then
		wep:SetHitStacks(0)
	end

	if SERVER and ent:IsValidLivingZombie() then
		dmginfo:SetDamage(dmginfo:GetDamage() + (wep:GetHitStacks() * 0.33))
	end
end

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_fire.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Fire_Suppressed",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_fire_suppressed.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Empty",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_empty.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.BipodSwivel",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_stock.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Magout",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_magout.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Magrelease",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_magrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Magin",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_magin.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Boltback",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_boltback.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Boltforward",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_boltrelease.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Boltlock",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_boltlock.wav"
})

sound.Add({
	name = 			"TFA_INS2.SR2M_Veresk.Boltunlock",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 		")weapons/sr2m_veresk/sr2m_boltunlock.wav"
})
