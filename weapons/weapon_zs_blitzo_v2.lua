AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_blitzo"))
SWEP.Description = (translate.Get("desc_blitzo2"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "base"
	SWEP.HUD3DPos = Vector(2, -2.5, 1.4)
	SWEP.HUD3DAng = Angle(270, 90, 90)
	SWEP.HUD3DScale = 0.018
	
	SWEP.IronSightsPos = Vector(-2.506, 0.1, 2.28)
	SWEP.IronSightsAng = Vector(-2.50, -1.92, 0)
end

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_blitzo_m1.mdl"
SWEP.WorldModel = "models/weapons/w_blitzo_m1.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_GR9.Fire")
SWEP.Primary.Damage = 27
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1
	
SWEP.Primary.ClipSize = 48
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 4.35
SWEP.ConeMin = 1.475

SWEP.ZoomSound = Sound("Default.Zoom")

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5
SWEP.ResistanceBypass = 0.6

SWEP.FireAnimSpeed = 0.5

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 4, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 2)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:Initialize()
	BaseClass.Initialize(self)

end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)	
	self:SetIronsights(false)
	self:SetSights(0)
	return true
end

function SWEP:Reload()
	self.BaseClass.Reload(self)	
	self:SetSights(0)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		if self:GetSights() == 0 then
			if CLIENT then
				self.IronsightsMultiplier = 0.5
			end
			self:SetIronsights(true)
			self:SetSights(1)
			self:EmitSound(self.ZoomSound)
		elseif self:GetSights() == 1 then
			if CLIENT then
				self.IronsightsMultiplier = 0.25
			end
			self:SetSights(2)
			self:EmitSound(self.ZoomSound)
		else
			self:SetIronsights(false)
			self:SetSights(0)
			self:EmitSound(self.ZoomSound)
		end
	end
end

function SWEP:PrimaryAttack()
	self.BaseClass.PrimaryAttack(self)
end

if CLIENT then
	--SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return BaseClass.GetViewModelPosition(self, pos, ang)
	end

	function SWEP:DrawHUDBackground()
		if GAMEMODE.DisableScopes then return end

		if self:IsScoped() then
			self:DrawFuturisticScope()
		end
	end
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Think()
	local stbl = E_GetTable(self)

	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end
	elseif stbl.IdleAnimation and stbl.IdleAnimation <= CurTime() then
		stbl.IdleAnimation = nil
		self:SendWeaponAnim(stbl.IdleActivity)
	end
	self:SmoothRecoil()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if attacker:IsValidLivingHuman() then
		local ent = tr.Entity
	
		if SERVER then
			if ent:IsValidLivingZombie() and gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
				local dmg = 0
				-- dmginfo:GetDamage()
				if ent:GetStatus("burn") then
					dmg = dmg + math.floor(ent:GetStatus("burn"):GetDamage() * (dmginfo:GetDamage() * 0.001))
				end

				if ent:GetStatus("frost") then
					dmg = dmg + math.floor(ent:GetStatus("frost"):GetMagnitude() * (dmginfo:GetDamage() * 0.0006))
				end

				math.min(dmg, 10)
				if dmg > 0 then
					ent:AddLegDamageExt(dmg, attacker, self, SLOWTYPE_PULSE)
				end
			end
		end
	end
end


sound.Add({
	name = 			"Weapon_GR9.Fire",			// <-- Sound Name That gets called for
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			")weapons/zs_blitzo/fire.wav"	// <-- Sound Path
})

sound.Add({
	name = 			"Weapon_GR9.Fire_Alt",			// <-- Sound Name That gets called for
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/zs_blitzo/fire_alt.wav"	// <-- Sound Path
})

sound.Add({
	name = 			"Weapon_GR9.Reload",			
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/zs_blitzo/reload.wav"	
})

function SWEP:SetSights(a)
	self:SetDTInt(16, a)
end

function SWEP:GetSights()
	return self:GetDTInt(16)
end