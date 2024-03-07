AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_fauna")) -- 'Fauna' Medical Ray
SWEP.Description = (translate.Get("desc_fauna")) -- Медлуч способный лечить в радиусе, может также наносить урон по зомби

SWEP.Slot = 3
SWEP.SlotPos = 0

-- Ивент оружие, медлуч из Awesome Strike (его сделал тоже JetBoom), имел точно такой же функционал, как и нынешний медлуч
-- Данная версия: Хилит владельца, Хилит в радиусе, Хилит раненого если он находиться далеко от хилера, Убивает зомби
-- Текущая версия имеет костыль, статус удаляется только если отжата +attack, через OnRemove работать не хочет
-- А через 	if not (owner:IsValid() and owner:GetActiveWeapon():IsValid() and owner:GetActiveWeapon():GetClass() == "weapon_zs_fauna") then self:Remove() end
-- Если оружие вкачено минимум на q1, статус будет по кд удаляться
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(4.5, -0.8, -8)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.04
	
	SWEP.VElements = {
	["medkit"] = { type = "Model", model = "models/Items/HealthKit.mdl", bone = "Base", rel = "", pos = Vector(0, 0, -8.606), angle = Angle(180, 180, 45), size = Vector(0.247, 0.247, 0.247), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
	["medkit"] = { type = "Model", model = "models/Items/HealthKit.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.189, -0.806, -4.506), angle = Angle(-161.288, 99.775, -60.269), size = Vector(0.247, 0.247, 0.247), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "physgun"

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("")
SWEP.Primary.Damage = 50
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.16
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Battery"
SWEP.Primary.DefaultClip = 60

SWEP.IsMedicalDevice = true

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.TracerName = ""

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.Heal = 10

SWEP.Tier = 6

SWEP.ResistanceBypass = 0.4

SWEP.IronSightsPos = Vector(-4, -4, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOW

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALING, 1)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	return {impact = false}
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
		GAMEMODE.MedicalAura = true
	end
	
	if owner and owner:IsValid() then
		owner:RemoveStatus("medray", false, true)
	end

	return true
end

function SWEP:Holster()
	if CLIENT and self:GetOwner() == MySelf then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end
	if owner and owner:IsValid() then
		owner:RemoveStatus("medray", false, true)
	end
	return true
end

function SWEP:OnRemove()
	if CLIENT and self:GetOwner() == MySelf then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end
end

function SWEP:Reload()
end

-- function SWEP.BulletCallback(attacker, tr, dmginfo)	
	-- local ent = tr.Entity
	-- local pos = tr.HitPos
	-- local wep = dmginfo:GetInflictor()
	-- local eyetrace = wep:GetEyeTrace()
	-- local ent2 = wep:TraceHull(32768, MASK_SHOT, 0).Entity
	-- if SERVER then
	-- for _, ent2 in pairs(util.BlastAlloc(wep, attacker, eyetrace.HitPos, 64)) do
		-- if ent2 then
			-- wep:HealPlayer(ent, wep.Heal, 0.5, true)
		-- end
	-- end
	-- end
-- end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end
	
	local stbl = E_GetTable(self)

	if self:GetPrimaryAmmoCount() < 3 then
		self:EmitSound(stbl.DryFireSound)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, stbl.Primary.Delay))
		return false
	end
	
	local owner = self:GetOwner()
	owner:LagCompensation(true)
	local ent = owner:TraceHull(32768, MASK_SHOT, 0).Entity
	local eyetrace = self.Owner:GetEyeTrace() 
	if SERVER then
	for _, ent in pairs(util.BlastAlloc(owner, owner, eyetrace.HitPos, 50)) do
		if ent and ent:IsValidLivingHuman() then
			owner:HealPlayer(ent, self.Heal, 0.5, true)
		end
	end
	end
	owner:LagCompensation(false)

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	local owner = self:GetOwner()
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	
	local stbl = E_GetTable(self)
	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(stbl.Primary.Damage, stbl.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self.Owner:GiveStatus("medray")
end

function SWEP:TakeAmmo()
	self:TakeCombinedPrimaryAmmo(3)
end

function SWEP:SecondaryAttack()
end

if SERVER then
function SWEP:Think()
	local owner = self.Owner
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end
	elseif self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(self.IdleActivity)
	end

	if owner.MedRay then
		if owner:KeyDown(IN_ATTACK) and 0 < self:GetPrimaryAmmoCount() then
		elseif owner.MedRay:IsValid() then
			owner.MedRay:Remove()
		end
	end
		
end
end

if CLIENT then
	function SWEP:Think()
		local owner = self.Owner
		if owner.MedRay and owner:KeyDown(IN_ATTACK) and 0 < self:GetPrimaryAmmoCount() then
		end

		self:NextThink(CurTime())
		return true
	end
end

local colBG = Color(16, 16, 16, 90)
local colRed = Color(220, 0, 0, 230)
local colWhite = Color(220, 220, 220, 230)

function SWEP:Draw2DHUD()
	local screenscale = BetterScreenScale()

	local wid, hei = 180 * screenscale, 64 * screenscale
	local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
	local spare = self:GetPrimaryAmmoCount()

	draw.RoundedBox(16, x, y, wid, hei, colBG)
	draw.SimpleTextBlurry(spare, spare >= 1000 and "ZSHUDFont" or "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:Draw3DHUD(vm, pos, ang)
	local wid, hei = 180, 64
	local x, y = wid * -0.6, hei * -0.5
	local spare = self:GetPrimaryAmmoCount()

	cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
		draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
		draw.SimpleTextBlurry(spare, spare >= 1000 and "ZS3D2DFontSmall" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
