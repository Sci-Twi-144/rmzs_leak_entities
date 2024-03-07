AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_magnum"))
SWEP.Description = (translate.Get("desc_magnum"))
SWEP.Slot = 1
SWEP.SlotPos = 0

local matBeam = Material("trails/laser")

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "smdimport"
	SWEP.HUD3DPos = Vector(0.85, 2.5, 3.25)
	SWEP.HUD3DAng = Angle(0, 180, 90)
	SWEP.HUD3DScale = 0.015
	
	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Vector(0, 0, 0)
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "ANGL"
		elseif self:GetFireMode() == 1 then
			return "NORM"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Angle-related"
		elseif self:GetFireMode() == 1 then
			return "Normal to surface"
		end
	end
	
	function SWEP:PostDrawViewModel(vm)
		self.BaseClass.PostDrawViewModel(self, vm)
		local owner = self:GetOwner()
		if owner:KeyDown(IN_SPEED) and self:GetVectorStart() and self:GetVectorEnd() and self.MainOwner == LocalPlayer() then
			local clrtbl = {
				[1] = Color(0,0,255),
				[2] = Color(0,255,0),
				[3] = Color(255,0,0)
			}			
			local clr = clrtbl[self:GetCollideColor()]
			render.SetMaterial(matBeam)
			--render.SetColorMaterial()
			render.DrawBeam( self:GetVectorStart(), self:GetVectorEnd(), 5, 0, 1, clr )
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/rmzs/c_357new.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.SoundFireVolume = 0.93
SWEP.SoundPitchMin = 88
SWEP.SoundPitchMax = 93
SWEP.Primary.Sound = Sound("Weapon_357.Fire")

SWEP.Primary.Delay = 0.7
SWEP.Primary.Damage = 63 -- со скрепящими зубами
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Tier = 2

SWEP.ResistanceBypass = 0.75

SWEP.CannotHaveExtendetMag = true

SWEP.ConeMax = 3.75
SWEP.ConeMin = 2
SWEP.BounceMulti = 1.5

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false

SWEP.IronSightsPos = Vector(-4.78, -4, 2.15)
SWEP.IronSightsAng = Vector(-0.5, -0.18, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.7, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.35, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.07, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_backlash")), (translate.Get("desc_backlash")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.85
	wept.BounceMulti = 1.764
	
	wept.OnZombieKilled = function(self, zombie, total, dmginfo)
		local killer = self:GetOwner()
		if killer:IsValid() and zombie:WasHitInHead() then
			if SERVER then
				killer:SimpleStatus("focused",  10, {Applier = killer, Stacks = 1, Max = 3}, true, false)
			end
		end
	end
end)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.FirstDraw = true
	timer.Simple(0.06, function()
		self.MainOwner = self:GetOwner()
	end)
end

function SWEP:Deploy()
	self:SendWeaponAnim(self.FirstDraw and ACT_VM_DRAW_DEPLOYED or ACT_VM_DRAW)
	self.FirstDraw = false
	self.BaseClass.Deploy(self)
	return true
end

function SWEP:SecondaryAttack()
	self.BaseClass.SecondaryAttack(self)
	self.IdleActivity = self:GetIronsights() and ACT_VM_SWINGMISS or ACT_VM_IDLE
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

local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	local RicoCallback = function(att, tr, dmginfo)
		local ent = tr.Entity
		local wep = att:GetActiveWeapon()
		if wep.Branch == 1 and ent:IsValidZombie() then
			wep:SetDTInt(9, wep:GetDTInt(9) + 2)
		end
	end

	attacker.RicochetBullet = true
	if attacker:IsValid() then
		local wep = attacker:GetActiveWeapon()
		local curfiremode = wep:GetFireMode()
		FORCE_B_EFFECT = true
		attacker:FireBulletsLua(hitpos, curfiremode == 0 and (2 * hitnormal * hitnormal:Dot(normal * -1) + normal) or hitnormal, 0, 1, 1, 1, damage, nil, nil, "tracer_rico", RicoCallback, nil, nil, nil, nil, attacker:GetActiveWeapon())
		FORCE_B_EFFECT = nil
	end
	attacker.RicochetBullet = nil
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if SERVER and tr.HitWorld and not tr.HitSky then
		local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * attacker:GetActiveWeapon().BounceMulti
		timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
	end

end

function SWEP:Think()
	self.BaseClass.Think(self)
	local owner = self:GetOwner()
	if owner:KeyDown(IN_SPEED) then
		local dir = owner:GetAimVector()
		local tracec = {mask = MASK_SOLID_BRUSHONLY}
		local shootpos = owner:GetShootPos()
		
		tracec.start = shootpos
		tracec.endpos = shootpos + dir * 10000
		--tracec.filter = function (ent) return obstacles[ent:GetClass()] end
		local tr = util.TraceLine(tracec)
		if tr.HitWorld then
			self:SetVectorStart(tr.HitPos)
			self:RicoLine(tr.HitPos, tr.HitNormal, tr.Normal)
		end
	end
end

function SWEP:RicoLine(hitpos, hitnormal, normal)
	local owner = self:GetOwner()
	local traceb = {mask = MASK_SHOT}
	local curfiremode = self:GetFireMode() 
	local dir = (curfiremode == 0) and (2 * hitnormal * hitnormal:Dot(normal * -1) + normal) or hitnormal
	
	traceb.start = hitpos
	traceb.endpos = hitpos + dir * 10000
	traceb.filter = function (ent) return ent:IsValidLivingZombie() end
	local tr = util.TraceLine(traceb)
	if tr.Entity and tr.Entity:IsValidLivingZombie() then
		self:SetVectorEnd(tr.HitPos)
		self:SetCollideColor(tr.HitGroup == HITGROUP_HEAD and 3 or 2)
	else
		self:SetVectorEnd(tr.HitPos)
		self:SetCollideColor(1)
	end
end

function SWEP:SetVectorStart(vec)
	self:SetDTVector( 15, vec )
end

function SWEP:GetVectorStart()
	return self:GetDTVector(15)
end

function SWEP:SetVectorEnd(vect)
	self:SetDTVector( 16, vect )
end

function SWEP:GetVectorEnd()
	return self:GetDTVector(16)
end

function SWEP:SetCollideColor(num)
	self:SetDTInt( 14, num )
end

function SWEP:GetCollideColor()
	return self:GetDTInt(14)
end

sound.Add({
	name = "Weapon_357.Fire",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 79,
	pitch = {97, 103},
	sound = {
		"weapons/357/357_fire_player_01.wav",
		"weapons/357/357_fire_player_02.wav",
		"weapons/357/357_fire_player_03.wav",
		"weapons/357/357_fire_player_04.wav",
		"weapons/357/357_fire_player_05.wav",
		"weapons/357/357_fire_player_06.wav"
	}
})

sound.Add({
	name = "Weapon_357.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = 140,
	pitch = {97, 103},
	sound = {
		")weapons/357/357_fire_player_01.wav",
		")weapons/357/357_fire_player_02.wav",
		")weapons/357/357_fire_player_03.wav",
		")weapons/357/357_fire_player_04.wav",
		")weapons/357/357_fire_player_05.wav",
		")weapons/357/357_fire_player_06.wav"
	}
})

sound.Add({
	name = "Weapon_357.Cylinder_Open",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/357/handling/357_cylinder_open_01.wav"
})
sound.Add({
	name = "Weapon_357.Cylinder_Unload",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = {
		"weapons/357/handling/357_cylinder_unload_01.wav",
		"weapons/357/handling/357_cylinder_unload_02.wav",
		"weapons/357/handling/357_cylinder_unload_03.wav"
	}
})
sound.Add({
	name = "Weapon_357.Cylinder_Load",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = {
		"weapons/357/handling/357_cylinder_load_01.wav",
		"weapons/357/handling/357_cylinder_load_02.wav",
		"weapons/357/handling/357_cylinder_load_03.wav"
	}
})
sound.Add({
	name = "Weapon_357.Cylinder_Close",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/357/handling/357_cylinder_close_01.wav"
})