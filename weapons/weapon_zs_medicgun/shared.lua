SWEP.PrintName = (translate.Get("wep_medicgun"))
SWEP.Description = (translate.Get("desc_medicgun"))
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"
DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Ammo = "Battery"
SWEP.RequiredClip = 5

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.ReloadSpeed = 0.85

SWEP.BuffDuration = 10

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

SWEP.AllowQualityWeapons = true
SWEP.IsMedicalDevice = true

SWEP.Heal = 6

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BUFF_DURATION, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALING, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.1, 1)

function SWEP:GetFireDelay()
	local owner = self:GetOwner()
	return (self.Primary.Delay * (owner.MedgunFireDelayMul or 1)) / (owner:GetStatus("frost") and 0.7 or 1)
end

function SWEP:GetReloadSpeedMultiplier()
	local owner = self:GetOwner()
	return BaseClass.GetReloadSpeedMultiplier(self) * (owner.MedgunReloadSpeedMul or 1) -- Convention is now BaseClass instead of self.BaseClass
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	return self:GetNextSecondaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondaryFire(CurTime() + 0.1)

	local owner = self:GetOwner()
	if owner:IsSkillActive(SKILL_DISABLEDTARGETING) then return end

	local lootply = owner.ZSplyChoice
	if lootply and lootply:IsValidLivingHuman() and not (owner:GetInfo("zs_disableuselootsckeck") == "1") then 
		self:SetSeekedPlayer(lootply)
		return
	end

	local trtbl = owner:CompensatedPenetratingMeleeTrace(2048, 2, nil, nil, true)
	local ent
	for _, tr in pairs(trtbl) do
		local test = tr.Entity
		if test and test:IsValidLivingHuman() and gamemode.Call("PlayerCanBeHealed", test) then
			ent = test

			break
		end
	end

	local locked = ent and ent:IsValidLivingHuman() and gamemode.Call("PlayerCanBeHealed", ent)

	if CLIENT then
		self:EmitSound(locked and "npc/scanner/combat_scan4.wav" or "npc/scanner/scanner_scan5.wav", 65, locked and 75 or 200)
	end
	self:SetSeekedPlayer(locked and ent)
end

function SWEP:SetSeekedPlayer(ent)
	self:SetDTEntity(6, ent)
end

function SWEP:GetSeekedPlayer()
	return self:GetDTEntity(6)
end