AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_aspirant"))
SWEP.Description = (translate.Get("desc_aspirant"))
SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80

	SWEP.HUD3DBone = "m16_parent"
	SWEP.HUD3DPos = Vector(1.5, -0.5, 4)
	SWEP.HUD3DAng = Angle(180, 0, -25)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(2.25, -1, -1.25)
	SWEP.VMAng = Angle(0, 0, 0)

	SWEP.VElements = {
		["suppressor"] = { type = "Model", model = "models/weapons/rmzs/attachments/c_nvis_new.mdl", bone = "m16_parent", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = true, bodygroup = {}, active = false }
	}
	SWEP.WElements = {
		["suppressor"] = { type = "Model", model = "models/weapons/rmzs/attachments/w_nvis_new.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.5, 0.6, 2.6), angle = Angle(190, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

 --Нужно модифицировать дропнутые модели для передачи этих свойств!
	function SWEP:PreDrawViewModel(vm)
		if vm:IsValid() then
			render.MaterialOverrideByIndex(0, Material("models/weapons/rmzs/m4a1/m4a1_e"))
		end
	end

	function SWEP:ViewModelDrawn()
		render.MaterialOverrideByIndex(0, 0)
		render.MaterialOverrideByIndex(1, 0)
		self.BaseClass.ViewModelDrawn(self)
	end

	local meta = FindMetaTable("Entity")
	local E_GetTable = meta.GetTable
	
	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()
		local owner_valid = IsValid(owner)
	
		if not owner_valid then return end
	
		if FrameNumber() - (LastDrawFrame[owner] or 0) > 30 then return end
		if E_GetTable(owner).ShadowMan or SpawnProtection[owner] then return end
		if GAMEMODE.NoDrawHumanWeaponsAsZombie and MySelf and MySelf:Team() == TEAM_UNDEAD and owner:Team() == TEAM_HUMAN then return end
		if MySelf and owner ~= MySelf and owner:GetPos():DistToSqr(EyePos()) > (GAMEMODE.SCKWorldRadius or 250000) then return end
		render.MaterialOverrideByIndex(0, Material("models/weapons/rmzs/m4a1/m4a1_e"))
		self:Anim_DrawWorldModel()
	end

	SWEP.IronsightsMultiplier = 0.25

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
			self:DrawRegularScope()
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/rmzs/c_m4a1_new.mdl"
SWEP.WorldModel = "models/weapons/rmzs/w_m4a1_new.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = Sound(")weapons/rmzs/m4a1/first.ogg")
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.BurstShots = 3
SWEP.Primary.Delay = 0.627

SWEP.ResistanceBypass = 0.65

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 1.65
SWEP.ConeMin = 0.45

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4

SWEP.IronSightsPos = Vector(-5.1, -19, -0.075)
SWEP.IronSightsAng = Vector(0.75, 0, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 3, 3)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:EmitFireSound()

	self:SetNextShot(CurTime())
	self:SetShotsLeft(self.Primary.BurstShots)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
	BaseClass.Think(self)

	self:ProcessBurstFire()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)			
	if SERVER then
		local ent = tr.Entity
		if ent:IsValidLivingZombie() then
			local hits = rawget(PlayerIsMarked2, ent)["Hitcount"] or 0
			if hits and hits >= 3 then
				ent:ApplyZombieDebuff("sapping", 3 , {Applier = attacker}, true, 41)
				rawset(PlayerIsMarked2, ent, {})
			end

			local hitcount = rawget(PlayerIsMarked2, ent)["Hitcount"] and (rawget(PlayerIsMarked2, ent)["Hitcount"] + 1 ) or 1
			rawset(PlayerIsMarked2, ent, {Time = CurTime() + 0.25, Hitcount = hitcount})
		end
	end
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end