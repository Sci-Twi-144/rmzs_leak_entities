AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_novacolt"))
SWEP.Description = (translate.Get("desc_novacolt"))
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 65

	SWEP.HUD3DBone = "barrel_plug"
	SWEP.HUD3DPos = Vector(-1, -5, 1.22)
	SWEP.HUD3DAng = Angle(0, 0, 90)
	SWEP.HUD3DScale = 0.016

	SWEP.VElements = {}

	SWEP.WElements = {
		["wep"] = { type = "Model", model = "models/rmzs/weapons/w_malorian_arms.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 1, 2), angle = Angle(-7.23, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.IronSightsPos = Vector(-0.09, 9, -1.45)
	SWEP.IronSightsAng = Vector(0, -0.15, 0)
	
	function SWEP:DrawAds()
		GAMEMODE:DrawCircleEx(x, y, 22, Color(255, 220, 140), self:GetDTFloat(16), 10, 360)
	end
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "FIRE"
		elseif self:GetFireMode() == 1 then
			return "SHOCK"
		elseif self:GetFireMode() == 2 then
			return "CRYO"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Fire Burst"
		elseif self:GetFireMode() == 1 then
			return "Electric Wonder"
		elseif self:GetFireMode() == 2 then
			return "Cryo Burst"
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/rmzs/weapons/c_malorian_arms.mdl"
SWEP.WorldModel = "models/rmzs/weapons/w_malorian_arms.mdl"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.Primary.Damage = 85
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.37

SWEP.Primary.ClipSize = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.2
SWEP.ConeMin = 0.5

SWEP.FireAnimSpeed = 1.25
SWEP.ReloadSpeed = 0.8

SWEP.Pierces = 1

SWEP.ProjExplosionTaper = 0.7
SWEP.DamageTaper = SWEP.ProjExplosionTaper

SWEP.Tier = 5
SWEP.ResistanceBypass = 0.65
SWEP.FirstDraw = true
SWEP.SetUpFireModes = 2
SWEP.CantSwitchFireModes = false

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 2, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BULLET_PIERCES, 1, 3)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Walther' Handgun", "Урон увеличивается, если зомби больше чем людей, лимит в x2.5", "weapon_zs_walther")
GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_ot33")), (translate.Get("desc_ot33")), "weapon_zs_ot33")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:FireAnimationEvent(pos, ang, event, options, source)
	--print(event, options)
	local vm = self:GetOwner():GetViewModel()
	if event == 3111 then
		vm:SetBodygroup(vm:FindBodygroupByName(options), 1)
	elseif event == 3112 then
		vm:SetBodygroup(vm:FindBodygroupByName(options), 0)
	end
end

function SWEP:Deploy()
	local stbl = E_GetTable(self)
	self.BaseClass.Deploy(self)

	self:SendWeaponAnim(self.FirstDraw and ACT_VM_READY or ACT_VM_DRAW)
	if self.FirstDraw then
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	self.FirstDraw = false

	return true
end

function SWEP:Reload()
		local owner = self:GetOwner()
	if owner:IsHolding() or self:GetCharging() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	local stbl = E_GetTable(self)
	-- Custom reload function to change reload speed.
	if self:CanReload() then
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(stbl.IdleAnimation)
		self:SetReloadStart(CurTime())

		self:SendReloadAnimation()
		self:ProcessReloadEndTime()

		owner:DoReloadEvent()

		self:EmitReloadSound()
	elseif self:GetSequenceActivityName(self:GetSequence()) != "ACT_VM_PULLBACK" and self:GetReloadFinish() < CurTime() then
		self:SendWeaponAnim(ACT_VM_PULLBACK)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/malorian/malorian_shoot.wav", 75, math.random(81, 85), 0.8)
end

function SWEP:PrimaryAttack()
	self.BaseClass.PrimaryAttack(self)
	self:SetConePower(0.91)
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if owner:KeyDown(IN_ATTACK) and self:CanBurst() then
		self:SpreadFire()
	else
		self.BaseClass.SecondaryAttack(self)
		if self:OwnerAllowedIron(owner) then
			self.IdleActivity = self:GetIronsights() and ACT_VM_PULLPIN or ACT_VM_IDLE
		end
	end
end

function SWEP:SetIronsights(b)
	self:SetDTBool(DT_WEAPON_BASE_BOOL_IRONSIGHTS, b)
	local stbl = E_GetTable(self)
	local owner = self:GetOwner()
	if stbl.IronSightsHoldType then
		if b then
			self:SetWeaponHoldType(stbl.IronSightsHoldType)
		else
			self:SetWeaponHoldType(stbl.HoldType)
		end
	end
	
	if self:OwnerAllowedIron(owner) then
		self:SendWeaponAnim(self:GetIronsights() and ACT_VM_PULLPIN or ACT_VM_IDLE)
		self.IdleActivity = self:GetIronsights() and ACT_VM_PULLPIN or ACT_VM_IDLE
	end
	
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)
end

function SWEP:OwnerAllowedIron(pl)
	return pl:GetInfo("zs_noironsights") != "1"
end

function SWEP:SpreadFire()
	local owner = self:GetOwner()
	self:SendWeaponAnim(ACT_VM_MISSLEFT)
	self:SetNextPrimaryFire(self:SequenceDuration() + CurTime())
	local pos = owner:GetShootPos()
	local start, dir = owner:GetShootPos(), owner:GetAimVector():GetNormalized()
	local dist = 85
	local dumbs = ents.FindInCone( start, dir, dist, math.cos(math.rad(45)))
	local dmgtpr = 1
	local dmgaffect = 0.92
	self:SetNextBurst(CurTime() + 10)
	self:EmitSound("ambient/fire/gascan_ignite1.wav", 75, math.random(81, 85), 0.8)
	
	local modetbl = {
		[0] = function(self, ent, dmg, tpr, owner)
						ent:AddBurnDamage(dmg * 1.2 * dmgtpr, owner)
						ent:TakeSpecialDamage(dmg * 0.8 * dmgtpr, DMG_BURN, owner, self, nil)
					end,
		[1] = function(self, ent, dmg, tpr, owner)
						ent:TakeSpecialDamage(dmg * 0.3 * dmgtpr, DMG_SHOCK, owner, self, nil)
						ent:AddLegDamageExt(dmg * 0.1, owner, self, SLOWTYPE_PULSE)
					end,
		[2] = function(self, ent, dmg, tpr, owner)
						ent:TakeSpecialDamage(dmg * 0.7 * dmgtpr, DMG_PARALYZE, owner, self, nil)
						ent:AddLegDamageExt(dmg, owner, self, SLOWTYPE_COLD)
					end
	}
	
	if SERVER then
		owner:RemoveAmmo(8, self.Primary.Ammo)
	end
	if SERVER then
	
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(dir)
			effectdata:SetScale(self:GetFireMode())
		util.Effect("burst_fire", effectdata, true, true)
		
		local shockwaves = 3
		for num, entic in pairs(dumbs) do
			if entic:IsValidLivingZombie() and WorldVisible(pos, entic:NearestPoint(pos)) then
				if self:GetFireMode() == 1 and shockwaves > 0 then
					util.ElectricWonder(self, owner, entic:GetPos(), 1000, self.Primary.Damage * 0.7, 0.85, 5)
					shockwaves = shockwaves - 1
				end
				modetbl[self:GetFireMode()](self, entic, self.Primary.Damage * 1.5, dmgtpr, owner)
				dmgtpr = math.max(dmgtpr * dmgaffect, 0.05)
			end
		end
	end
end

function SWEP:SendWeaponAnimation()
	local owner = self:GetOwner()
	self:SendWeaponAnim(self:GetIronsights() and self:OwnerAllowedIron(owner) and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK)
	owner:GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
	if self:OwnerAllowedIron(owner) then
		self.IdleActivity = self:GetIronsights() and ACT_VM_PULLPIN or ACT_VM_IDLE
	end
end

function SWEP:SendReloadAnimation()
	local reloadtoplay = self:Clip1() > 0 and ACT_VM_RELOAD or ACT_VM_RELOAD_EMPTY
	self:SendWeaponAnim(reloadtoplay)
end

--[[function SWEP:Think()
	
	self.BaseClass.Think(self)
end]]

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity

	if SERVER and ent and ent:IsValidLivingZombie() then
		dmginfo:SetDamageForce(attacker:GetUp() * 7000 + attacker:GetForward() * 25000)
	end
end

function SWEP:SetConePower(pwr)
	local conecap = math.min(math.max(self:GetDTFloat(15) - CurTime(), 0) + pwr, 2.5)
	self:SetDTFloat(15, CurTime() + conecap)
end

function SWEP:GetConePower()
	return self:GetDTFloat(15)
end

function SWEP:SetNextBurst(p)
	self:SetDTFloat(16, p)
end

function SWEP:GetNextBurst()
	return self:GetDTFloat(16)
end

function SWEP:CanBurst()
	return (self:GetDTFloat(16) <= CurTime()) and (self:GetPrimaryAmmoCount() >= 8)
end

sound.Add({
	name = 			"Magnum.HelpingHandRetract",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/malorian/malorian_helpinghandretract.wav"
})

sound.Add({
	name = 			"Magnum.ClipIn",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/malorian/malorian_clip_in_1.wav"
})

sound.Add({
	name = 			"Magnum.HelpingHandExtend",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/malorian/malorian_helpinghandextend.wav"
})

sound.Add({
	name = 			"Magnum.SlideBack",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/malorian/malorian_slideback_1.wav"
})

sound.Add({
	name = 			"Magnum.SlideForward",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/malorian/malorian_slideforward_1.wav"
})