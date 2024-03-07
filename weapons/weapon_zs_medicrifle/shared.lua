SWEP.PrintName = (translate.Get("wep_medicrifle"))
SWEP.Description = (translate.Get("desc_medicrifle"))
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Base = "weapon_zs_baseproj"
DEFINE_BASECLASS("weapon_zs_baseproj")

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.Primary.Delay = 1.52
SWEP.Primary.ClipSize = 40
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Ammo = "Battery"

SWEP.RequiredClip = 5
SWEP.Primary.Damage = 50
SWEP.ReloadSpeed = 1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.FireAnimSpeed = 1

SWEP.BuffDuration = 10

SWEP.Tier = 3

SWEP.AllowQualityWeapons = true
SWEP.IsMedicalDevice = true

SWEP.Heal = 15

SWEP.PushFunction = true
SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_BUFF_DURATION, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALING, 2.5)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Invigorator' Strength Rifle", "Strength boost instead of defence, and makes zombies more vulnerable to damage instead", function(wept)
	wept.Heal = 5
	if SERVER then
		wept.EntModify = function(self, ent)
			local owner = self:GetOwner()

			ent:SetDTInt(15, 1)
			ent:SetSeeked(self:GetSeekedPlayer() or nil)
			ent.Heal = wept.Heal * (owner.MedDartEffMul or 1)
			ent.BuffDuration = wept.BuffDuration
			ent.AttackMode = (self:GetFireMode() == 1)
		end
	else
		for k,v in pairs(wept.VElements) do
			v.color = Color(215, 100, 75, 255)
		end
	end
end)

GAMEMODE:AddNewRemantleBranch(SWEP, 2, "'Distributor' Ammo Rifle", "Gives Ammo status for target, thats returning some ammo count then target is shooting.", function(wept)
	wept.Heal = 10
	if SERVER then
		wept.EntModify = function(self, ent)
			local owner = self:GetOwner()

			ent:SetDTInt(15, 2)
			ent:SetSeeked(self:GetSeekedPlayer() or nil)
			ent.Heal = wept.Heal * (owner.MedDartEffMul or 1)
			ent.BuffDuration = wept.BuffDuration
			ent.AttackMode = (self:GetFireMode() == 1)
		end
	else
		for k,v in pairs(wept.VElements) do
			v.color = Color(75, 215, 110)
		end
	end
end)


function SWEP:EmitFireSound()
	self:EmitSound("weapons/ar2/npc_ar2_altfire.wav", 70, math.random(137, 143), 0.85)
	self:EmitSound("weapons/ar2/fire1.wav", 70, math.random(105, 115), 0.85, CHAN_WEAPON + 20)
	self:EmitSound("items/smallmedkit1.wav", 70, math.random(165, 170), 0.65, CHAN_WEAPON + 21)
end

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
	if owner:IsSkillActive(SKILL_DISABLEDTARGETING) or self:GetFireMode() == 1 then return end

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

function SWEP:Think()
	self.BaseClass.Think(self)
	if self:GetSeekedPlayer() and self:GetSeekedPlayer():IsValidLivingHuman() and (self._timer or 0) < CurTime() then
		self._timer = CurTime() + 0.5
		self:SetSeekedPlayerStats()
	end
end
 
function SWEP:CallWeaponFunction()
	self:SetSeekedPlayer(nil)
end

function SWEP:SetSeekedPlayer(ent)
	self:SetDTEntity(6, ent)
end

function SWEP:GetSeekedPlayer()
	return self:GetDTEntity(6)
end

function SWEP:SetSeekedPlayerStats()
	self:SetDTInt(16, self:GetSeekedPlayer() and self:GetSeekedPlayer():GetMaxHealth() or 0)
	self:SetDTInt(17, self:GetSeekedPlayer() and self:GetSeekedPlayer():Health() or 0)
	self:SetDTInt(18, self:GetSeekedPlayer() and self:GetSeekedPlayer():GetBloodArmor() or 0)
	self:SetDTInt(19, self:GetSeekedPlayer() and self:GetSeekedPlayer().MaxBloodArmor or 0)
	self:SetDTInt(20, self:GetSeekedPlayer() and self:GetSeekedPlayer():GetHealthRegeneration() or 0)
end
