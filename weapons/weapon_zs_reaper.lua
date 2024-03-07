AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_reaper"))
SWEP.Description = (translate.Get("desc_reaper"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.ump45_Release"
	SWEP.HUD3DPos = Vector(-1.5, -3, 2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(0, 0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -12, 0) )
            --self.ViewModelBoneMods[ "v_weapon.ump45_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.ump45_Slide" ].pos, Vector(0, 0, 10) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
            --self.ViewModelBoneMods[ "v_weapon.ump45_Slide" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.ump45_Slide" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/ump45/ump45-1.wav"
SWEP.Primary.Damage = 23
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 4
SWEP.ConeMin = 2.1

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ReloadSpeed = 1.15

SWEP.Tier = 4

SWEP.ResistanceBypass = 0.85

SWEP.IronSightsPos = Vector(-8.77, -7, 4.15)
SWEP.IronSightsAng = Vector(-1, -0.3, -1.5)

SWEP.StandartIronsightsAnim = false
SWEP.HasAbility = true
SWEP.SpecificCond = true
	
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.015)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5, 2)
function SWEP:OnZombieKilled()
	local killer = self:GetOwner()
	if killer:GetStatus("reaper") and killer:IsValid() then
		local reaperstatus = killer:GiveStatus("reaper", 14)
		if reaperstatus and reaperstatus:IsValid() then
			killer:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetStacks() * 30, 0.45)
		end
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local hitent = tr.Entity
	if hitent:IsValidLivingZombie() and hitent:Health() <= hitent:GetMaxHealthEx() * 0.04 and gamemode.Call("PlayerShouldTakeDamage", hitent, attacker) then
		if SERVER then
			hitent:SetWasHitInHead()
		end
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, attacker, attacker:GetActiveWeapon(), tr.HitPos)
		hitent:EmitSound("npc/roller/blade_out.wav", 80, 125)
	end
	local wep = dmginfo:GetInflictor()
	if SERVER and hitent and hitent:IsValidZombie() then	
		if IsValid(wep) then
			if wep:GetTumbler() then
				wep:SetResource(wep:GetResource() - 25)
				local reaperstatus = attacker:GiveStatus("reaper", 14)
				if reaperstatus and reaperstatus:IsValid() then
					reaperstatus:SetStacks(math.min(reaperstatus:GetStacks() + 1, 3))
					attacker:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetStacks() * 30, 0.45)
					attacker.ColliderShootCount = 0
				end
			else
				wep:SetResource(wep:GetResource() + (1 * (attacker.AbilityCharge or 1)))
			end
			if wep:GetResource() >= 25 then
				wep:SetTumbler(true)
				wep:SetResource(25)
			elseif wep:GetResource() < 1 then
				wep:SetResource(0)
				wep:SetTumbler(false)
			end
		end
	end
end

if not CLIENT then return end

function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
	self:DrawAbilityBar3D(x, y, hei, wid, Color(130, 30, 140), self:GetResource(), 25, "REAPER STACK")
end

function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
	self:DrawAbilityBar2D(x, y, hei, wid, Color(130, 30, 140), self:GetResource(), 25, "REAPER STACK")
end
		
function SWEP:Draw3DHUD(vm, pos, ang)
	self.BaseClass.Draw3DHUD(self, vm, pos, ang)

	local wid, hei = 180, 200
	local x, y = wid * -0.6, hei * -0.5

	cam.Start3D2D(pos, ang, self.HUD3DScale)
		local owner = self:GetOwner()
		local ownerstatus = owner:GetStatus("reaper")
		if ownerstatus then
			local text = ""
			for i = 0, ownerstatus:GetStacks() -1 do
				text = text .. "+"
			end
			draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x + wid/2, y + hei * 0.15, Color(60, 30, 175, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end
