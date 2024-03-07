AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_bulletstorm"))
SWEP.Description = (translate.Get("desc_bulletstorm"))
SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.p90_Release"
	SWEP.HUD3DPos = Vector(-1.35, -0.5, -6.5)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	
	function SWEP:Draw2DHUDAds(x, y, hei, wid)
		local maxbullets, bulletsleft = 100, self:GetBullets()
		draw.SimpleTextBlurry(bulletsleft.." / "..maxbullets, "ZSHUDFontSmall", x + wid * 0.5, y + hei * 1.6, Color(192, 128, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function SWEP:Draw3DHUDAds(x, y, hei, wid)
		local maxbullets, bulletsleft = 100, self:GetBullets()
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(x, y + hei * 0.92, wid, 34)
		draw.SimpleTextBlurry(bulletsleft.."/"..maxbullets, "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 1, Color(192, 128, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		elseif self:GetFireMode() == 1 then
			return "FANTOM"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Stock"
		elseif self:GetFireMode() == 1 then
			return "Fantom"
		end
	end
	
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/p90/p90-1.wav"
SWEP.Primary.Damage = 20.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09

SWEP.Primary.ClipSize = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.ConeMax = 5.5
SWEP.ConeMin = 3

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 4

SWEP.ResistanceBypass = 0.7

SWEP.FireAnimSpeed = 1

SWEP.IronSightsPos = Vector(-2, 6, 3)
SWEP.IronSightsAng = Vector(0, 2, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1)

GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_medley")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local pos = tr.HitPos
	local wep = dmginfo:GetInflictor()
	
	if ent:IsValidLivingZombie() and wep:GetFireMode() == 0 then
		wep:SetHitStacks(wep:GetHitStacks() + 1)
	end
	
	if SERVER and ent:IsValidLivingZombie() and wep:GetHitStacks() >= 2 then
		wep:SetHitStacks(0)
		wep:SetBullets(math.min(wep:GetBullets() + 1, 100))
	end
	
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	local owner = self:GetOwner()
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	
	local stbl = E_GetTable(self)
		if self:GetFireMode() == 0 then -- Первый режим тратит обычные патроны
			self:TakeAmmo()
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self:EmitFireSound()
		elseif self:GetFireMode() == 1 and self:GetBullets() > 0 then -- Второй тратит фантом пули, их должно быть больше 0 или не будет стрелять
			self:SetBullets(math.max(self:GetBullets() - 1, 0))
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self:EmitFireSound()
		else
			self:EmitSound(self.DryFireSound)
			self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		end
end

function SWEP:SetBullets(bullets)
	self:SetDTInt(15, bullets)
end

function SWEP:GetBullets()
	return self:GetDTInt(15)
end

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end
