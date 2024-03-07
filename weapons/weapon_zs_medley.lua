DEFINE_BASECLASS("weapon_zs_base")

AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_medley"))
SWEP.Description = (translate.Get("desc_medley"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 75

	SWEP.HUD3DBone = "MP5_New"
	SWEP.HUD3DPos = Vector(1.5, 1, 0)
	SWEP.HUD3DAng = Angle(180, 0, -90)
	SWEP.HUD3DScale = 0.015
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "HE"
		elseif self:GetFireMode() == 1 then
			return "PULSE"
		elseif self:GetFireMode() == 2 then
			return "NAPALM"
		elseif self:GetFireMode() == 3 then
			return "CRYO"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "HE-Grenade"
		elseif self:GetFireMode() == 1 then
			return "Pulse Grenade"
		elseif self:GetFireMode() == 2 then
			return "Napalm Grenade"
		elseif self:GetFireMode() == 3 then
			return "Cryo Grenade"
		end
	end
	
	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, Color(192, 128, 0), self:GetResource(), self.AbilityMax, "NEXT GREANDE")
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, Color(192, 128, 0), self:GetResource(), self.AbilityMax, "NEXT GREANDE")
	end
	
	function SWEP:Draw2DHUDAds(x, y, hei, wid)
		local maxcoins, coinsleft = 3, self:GetGrenades()
		draw.SimpleTextBlurry(coinsleft.." / "..maxcoins, "ZSHUDFontSmall", x + wid * 0.5, y + hei * 1.6, Color(192, 128, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function SWEP:Draw3DHUDAds(x, y, hei, wid)
		local maxcoins, coinsleft = 3, self:GetGrenades()
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(x, y + hei * 0.92, wid, 34)
		draw.SimpleTextBlurry(coinsleft.."/"..maxcoins, "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 1, Color(192, 128, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/rmzs/weapons/mp5/c_mp5.mdl"
SWEP.WorldModel = "models/rmzs/weapons/mp5/w_mp5_mp.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 110

SWEP.Primary.Sound = Sound("weapon_mp5.Fire")
SWEP.Primary.Damage = 21.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 1 --72
SWEP.FireAnimSpeed = 1

SWEP.ConeMax = 4.1
SWEP.ConeMin = 1.8
SWEP.ReloadActEmpt = ACT_VM_RELOAD_EMPTY
SWEP.ReloadAct = ACT_VM_RELOAD
SWEP.WalkSpeed = SPEED_NORMAL

SWEP.Tier = 4

SWEP.ResistanceBypass = 0.7

SWEP.IronSightsPos = Vector(-2.93, 0, 1.1)
SWEP.IronSightsAng = Angle(1.8, -0.15, 2.1)

SWEP.Primary.Projectile = "projectile_grenade_various"
SWEP.Primary.ProjVelocity = 2200

SWEP.Primary.ProjExplosionRadius = 72
SWEP.Primary.ProjExplosionTaper = 0.96

SWEP.SetUpFireModes = 3

SWEP.HasAbility = true
SWEP.CantSwitchFireModes = false
SWEP.AbilityMax = 1000
SWEP.FirstDraw = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.3656)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.1575)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.007, 1)

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

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		local owner = self:GetOwner()
		if owner:KeyDown(IN_SPEED) and self:GetGrenades() > 0 then
			if self:GetTumbler() then
				self:SetTumbler(false)
			end
			if SERVER then
				self:ShootGrenade(self.Primary.Damage, 1, self:GetCone())
				self:SetGrenades(math.max(self:GetGrenades() - 1, 0))
			end
		else
			self.BaseClass.SecondaryAttack(self)
			self.IdleActivity = self:GetIronsights() and ACT_VM_SWINGMISS or ACT_VM_IDLE
		end
	end
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
	elseif self:GetSequenceActivityName(self:GetSequence()) != "ACT_VM_FIDGET" and self:GetReloadFinish() < CurTime() then
		self:SendWeaponAnim(ACT_VM_FIDGET)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:Deploy()
	if self.FirstDraw then
		self:SendWeaponAnim(self.FirstDraw and ACT_VM_PICKUP or ACT_VM_DRAW)
		self.FirstDraw = false
	end
	self.BaseClass.Deploy(self)
	return true
end

function SWEP:SendReloadAnimation()
	self:SendWeaponAnim((self:Clip1() == 0) and self.ReloadActEmpt or self.ReloadAct)
end

function SWEP:EntModify(ent)
	ent.ProjRadius = self.Primary.ProjExplosionRadius
	ent.ProjTaper = self.Primary.ProjExplosionTaper
end

function SWEP:ShootGrenade(damage, numshots, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	owner:DoAttackEvent()
	local bpmbtable = {[0] = "explosion", [1] = "pulse", [2] = "fire", [3] = "cryo"}
	local recoil = 8

	local r = math.Rand(0.8, 1)
	owner:ViewPunch(Angle(r * -recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * recoil))

	local damage = damage * 4
	self:SetTumbler(true)
	local ent = ents.Create(self.Primary.Projectile)
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		--local obj = self:GetBonePosition(23) --4 23 53 73
		--ent:SetPos(obj + Vector(2, 7, 0)) -- + Vector(-1, 5, 3)
		ent:SetAngles(owner:EyeAngles())
		ent:SetOwner(owner)
		ent.ProjDamage = damage * (owner.ProjectileDamageMul or 1)
		ent.ProjSource = self
		ent.ProjTaper = self.Primary.ProjExplosionTaper
		ent.ProjRadius = self.Primary.ProjExplosionRadius
		ent.ExpType = bpmbtable[self:GetFireMode()]
		ent.Team = owner:Team()
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()

			local angle = owner:GetAimVector():Angle()
			ent.PreVel = angle:Forward() * self.Primary.ProjVelocity * (owner.ProjectileSpeedMul or 1)
			phys:SetVelocityInstantaneous(ent.PreVel)
		end
	end
	--self:SetTumbler(false)
	--self:SetResource(0,true)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local wep = dmginfo:GetInflictor()
	if ent:IsValidLivingZombie() then
		if wep:GetResource() >= wep.AbilityMax then
			if wep:GetGrenades() >= 3 then
				wep:SetTumbler(true)
				wep:SetResource(wep.AbilityMax)
			else
				wep:SetGrenades(math.min(wep:GetGrenades() + 1, 3))
				wep:SetResource(0)
			end
		end
	end
end
	
function SWEP:SetGrenades(grenades)
	self:SetDTInt(15, grenades)
end

function SWEP:GetGrenades()
	return self:GetDTInt(15)
end

sound.Add({
	name = 			"weapon_mp5.IdleFidget",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rmzs/mp5/idle_fidget.wav"
})

sound.Add({
	name = 			"weapon_mp5.IdleFidget2",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rmzs/mp5/idle_fidget2.wav"
})

sound.Add({
	name = 			"weapon_mp5.IdleFidget3",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rmzs/mp5/idle_fidget3.wav"
})

sound.Add({
	name = 			"weapon_mp5.Reload",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rmzs/mp5/reload.wav"
})

sound.Add({
	name = 			"weapon_mp5.ReloadLong",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rmzs/mp5/reload_long.wav"
})

sound.Add({
	name = 			"weapon_mp5.ReloadLong2",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rmzs/mp5/reload_long2.wav"
})
-----------------------
sound.Add({
	name = 			"weapon_mp5.draw",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		{
		"weapons/rmzs/mp5/draw1.wav",
		"weapons/rmzs/mp5/draw2.wav",
		"weapons/rmzs/mp5/draw3.wav",
		"weapons/rmzs/mp5/draw4.wav",
		"weapons/rmzs/mp5/draw5.wav"
	}
})

sound.Add({
	name = 			"weapon_mp5.DrawAdmire",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		"weapons/rmzs/mp5/draw_admire.wav"
})

sound.Add({
	name = "weapon_mp5.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	pitch = math.random(96, 105),
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/rmzs/mp5/single"..math.random(1, 3)..".wav"
})

--[[
sound.Add({
	name = 			"weapon_mp5.Fire",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		{
		")weapons/rmzs/mp5/single1.wav",
		")weapons/rmzs/mp5/single2.wav",
		")weapons/rmzs/mp5/single3.wav",
		")weapons/rmzs/mp5/single1a.wav",
		")weapons/rmzs/mp5/single2a.wav",
		")weapons/rmzs/mp5/single3a.wav",
	}
})
]]

sound.Add({
	name = 			"weapon_mp5.sprintin",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		{
		"weapons/rmzs/mp5/sprintin1.wav",
		"weapons/rmzs/mp5/sprintin2.wav",
		"weapons/rmzs/mp5/sprintin3.wav",
		"weapons/rmzs/mp5/sprintin4.wav",
		"weapons/rmzs/mp5/sprintin5.wav",
		"weapons/rmzs/mp5/sprintin6.wav",
		"weapons/rmzs/mp5/sprintin7.wav",
		"weapons/rmzs/mp5/sprintin8.wav",
		"weapons/rmzs/mp5/sprintin9.wav",
		"weapons/rmzs/mp5/sprintin10.wav"
	}
})

sound.Add({
	name = 			"weapon_mp5.sprintout",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 		{
		"weapons/rmzs/mp5/sprintout1.wav",
		"weapons/rmzs/mp5/sprintout2.wav",
		"weapons/rmzs/mp5/sprintout3.wav",
		"weapons/rmzs/mp5/sprintout4.wav",
		"weapons/rmzs/mp5/sprintout5.wav",
		"weapons/rmzs/mp5/sprintout6.wav",
		"weapons/rmzs/mp5/sprintout7.wav",
		"weapons/rmzs/mp5/sprintout8.wav",
		"weapons/rmzs/mp5/sprintout9.wav",
		"weapons/rmzs/mp5/sprintout10.wav"
	}
})