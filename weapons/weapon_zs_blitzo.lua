AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_blitzo"))
SWEP.Description = (translate.Get("desc_blitzo"))

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
	
	--test code
	function SWEP:DrawHitBox()
		local sprite = Material("zombiesurvival/headshot_stacks.png")
		if not self:GetZombie() then return end
		if not self:GetBone() then return end
		local color = Color( 255, 255, 100, 150 )
		local zombie, zbone = self:GetLockedZombie(), self:GetBone()
		local bone = zombie:GetHitBoxBone( zbone, 0)
		if bone == nil then return end
		local bpos, bang = zombie:GetBonePosition(bone)
		local min, max = zombie:GetHitBoxBounds( zbone, 0 )
		--render.SetColorMaterial()

		cam.IgnoreZ(true)
		--render.DrawBox( bpos, bang, min, max, color)
		--render.DrawWireframeBox( bpos, bang, min, max, color)
		
		local size = (min - max):Length2DSqr()^0.5
		render.SetMaterial(sprite)
		render.DrawSprite(bpos+ bang:Forward() * max, 1*size, 1* size, color)
		cam.IgnoreZ(false)
	end
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
SWEP.ConeMin = 2.475

SWEP.ZoomSound = Sound("Default.Zoom")

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 5
SWEP.ResistanceBypass = 0.6

SWEP.FireAnimSpeed = 0.5

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RESISTANCE_BYPASS, -0.1, 1)

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:GetCone()
	return BaseClass.GetCone(self) * (self:GetIronsights() and 0.1 or 1)
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self.BaseDelay = self.Primary.Delay
	self.BlitzoOwner = self:GetOwner()
	local owner = self:GetOwner()
	
	local enty = self
	local ENTC = tostring(enty)
	local owner = self:GetOwner()
	
	if CLIENT then
		hook.Add("PostPlayerDraw", ENTC,  function(pl)
			if self.BlitzoOwner and LocalPlayer() == self.BlitzoOwner then
				if self:GetIronsights() and self:GetZombie() then
					self:DrawHitBox()
				end
			end
		end)
	end
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)	
	self:SetIronsights(false)
	self:SetZombie(false)
	self:SetLockedZombie(nil)
	self:SetSights(0)
	self:UpdateState()
	return true
end

function SWEP:Reload()
	self.BaseClass.Reload(self)	
	self:SetSights(0)
	self:SetZombie(false)
	self:SetLockedZombie(nil)
	self:UpdateState()
end

function SWEP:OnRemove()
	local ENTC = tostring(self)
	if CLIENT then
		hook.Remove("PostPlayerDraw", ENTC)
	end

	self.BaseClass.OnRemove(self)
end

function SWEP:UpdateState()
	if self:GetIronsights() then
		self.Primary.Delay = self.BaseDelay * 3
		self.Primary.Sound = Sound("Weapon_GR9.Fire_Alt")
	else
		self.Primary.Delay = self.BaseDelay
		self.Primary.Sound = Sound("Weapon_GR9.Fire")
	end
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
			self:UpdateState()
		elseif self:GetSights() == 1 then
			if CLIENT then
				self.IronsightsMultiplier = 0.25
			end
			self:SetSights(2)
			self:EmitSound(self.ZoomSound)
			self:UpdateState()
		else
			self:SetZombie(false)
			self:SetLockedZombie(nil)
			self:SetIronsights(false)
			self:SetSights(0)
			self:EmitSound(self.ZoomSound)
			self:UpdateState()
		end
	end
end

function SWEP:PrimaryAttack()
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:OnZombieKilled(zombie, total, dmginfo)
	local killer = self:GetOwner()
	local target = self:GetLockedZombie()
	
	if target and target:IsValid() and target == zombie then
		self:SetLockedZombie(nil)
		self:SetZombie(false)
	end
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

function SWEP:SetBoneTarget()
	if not self:GetLockedZombie():IsValidLivingZombie() then return end
	
	local zombie = self:GetLockedZombie()
	self:SetBone(math.random(zombie:GetHitBoxCount(0)))
	self:SetZombie(true)
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
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity
	if wep:GetIronsights() and ent:IsValidLivingZombie() then
		if not wep:GetZombie() then
			wep:SetLockedZombie(ent)
			wep:SetBoneTarget()
			wep:SetZombieMulti(0)
		end
		
		if tr.HitBox == wep:GetBone() then
			if gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
				dmginfo:SetDamageType(DMG_DIRECT)
				dmginfo:SetDamage(dmginfo:GetDamage() + wep.Primary.Damage * (wep:GetZombieMulti() + 1) or 1)
				wep:SetZombieMulti(math.min(wep:GetZombieMulti() + 1, 3))
				wep:SetBoneTarget()
			end
		end
		
		if wep:GetZombie() and wep:GetLockedZombie() ~= ent then
			wep:SetLockedZombie(ent)
			wep:SetBoneTarget()
			wep:SetZombieMulti(0)
		elseif wep:GetLockedZombie() == ent then
			wep:SetBoneTarget()
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

function SWEP:SetLockedZombie(fag)
	self:SetDTEntity(15, fag)
end

function SWEP:GetLockedZombie()
	return self:GetDTEntity(15)
end

function SWEP:SetSights(a)
	self:SetDTInt(16, a)
end

function SWEP:GetSights()
	return self:GetDTInt(16)
end

function SWEP:SetBone(b)
	self:SetDTInt(17, b)
end

function SWEP:GetBone()
	return self:GetDTInt(17)
end

function SWEP:SetZombie(c)
	self:SetDTBool(18, c)
end

function SWEP:GetZombie()
	return self:GetDTBool(18)
end

function SWEP:SetZombieMulti(n)
	self:SetDTInt(19, n)
end

function SWEP:GetZombieMulti()
	return self:GetDTInt(19)
end