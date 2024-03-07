AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_medicalkit"))
SWEP.Description = (translate.Get("desc_medicalkit"))
SWEP.Slot = 4
SWEP.SlotPos = 0

if CLIENT then
    SWEP.ViewModelFOV = 47
    SWEP.ViewModelFlip = false
 
    SWEP.BobScale = 2
    SWEP.SwayScale = 1.5
 
    SWEP.VElements = {}
    SWEP.ShowViewModel = true
    SWEP.ShowWorldModel = true
    SWEP.ViewModelBoneMods = {
        ["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1.034), pos = Vector(-70, 0, 0), angle = Angle(0, 0, 0) },
    }
 
    SWEP.VMPos = Vector(-3, 6.03, -3.628)
    SWEP.VMAng = Vector(4.221, -12.664, 13.366)
end

SWEP.Base = "weapon_zs_base"

SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.UseHands = true

SWEP.Heal = 15
SWEP.CoolDown = 12

SWEP.Primary.Delay = -1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 151
SWEP.Primary.Ammo = "Battery"

SWEP.Secondary.DelayMul = 20 / SWEP.CoolDown
SWEP.Secondary.HealMul = 10 / SWEP.Heal

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HealRange = 36

SWEP.NoMagazine = false
SWEP.AllowQualityWeapons = true
SWEP.IsMedicalDevice = true

SWEP.HoldType = "slam"

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_HEALCOOLDOWN, -1, 3)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALRANGE, 4, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALING, 1, 2)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_restorkit")), (translate.Get("desc_restorkit")), function(wept)
	wept.FixUsage = true
	wept.CoolDown = wept.CoolDown * 1.3
end)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	GAMEMODE:DoChangeDeploySpeed(self)

	timer.Simple(0.06, function()
		if self:GetPrimaryAmmoCount() > 0 then
			if self:GetOwner():IsSkillActive(SKILL_INTENSIVETHERAPY) then
				local cd = self.CoolDown * (self:GetOwner().MedicCooldownMul or 1)
				self:SetCoolDownInfo(cd)
				self:SetNextCharge(CurTime() + cd)
				self:GetOwner().NextMedKitUse = CurTime() + cd

				self.IsVirginMedkit = true
			end
		end
		
		local ENTITY = self
		hook.Add("Think", tostring(ENTITY), function() if not IsValid(ENTITY) then return end ENTITY:MedKitThink() end)
	end)
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP.MedKitThink(ENTITY)
	if not ENTITY:GetOwner() or not ENTITY:GetOwner():IsSkillActive(SKILL_INTENSIVETHERAPY) then hook.Remove("Think", tostring(ENTITY)) return end

	if ENTITY:GetOwner():IsSkillActive(SKILL_INTENSIVETHERAPY) then
		local timeleft = math.ceil(ENTITY:GetNextCharge() - CurTime())
		if ENTITY:GetPrimaryAmmoCount() > 0 then
			if ENTITY:GetNextCharge() <= CurTime() and (ENTITY:GetCharges() < (ENTITY.IsVirginMedkit and 1 or 2)) then
				local cd = ENTITY.CoolDown * (ENTITY:GetOwner().MedicCooldownMul or 1) * (ENTITY:GetChance() or 1)
				ENTITY:SetCoolDownInfo(cd)
				ENTITY:SetNextCharge(CurTime() + cd)
				if timeleft == 0 then
					ENTITY:SetCharges(ENTITY:GetCharges() + 1)
					ENTITY:SetNextCharge(0)
					if ENTITY.IsVirginMedkit then
						local cd = ENTITY.CoolDown * (ENTITY:GetOwner().MedicCooldownMul or 1)
						ENTITY:SetCoolDownInfo(cd)
						ENTITY:SetNextCharge(CurTime() + cd)
						ENTITY.IsVirginMedkit = false
					end
				end
			end
		end
	end
end

function SWEP:Holster()
    if CLIENT then
        self:Anim_Holster()
    end
   
    return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self:GetOwner()

	local trtbl = owner:CompensatedPenetratingMeleeTrace(self.HealRange, 2, nil, nil, true)
	local ent
	for _, tr in pairs(trtbl) do
		local test = tr.Entity
		if test and test:IsValidLivingHuman() and gamemode.Call("PlayerCanBeHealed", test) then
			ent = test

			break
		end
	end

	if not ent then return end
	
	local chance
	if owner.TrinketMedicCooldown then
		if owner.MedCoolChance >= math.random() then
			chance = 0.01
		else
			chance = 1
		end
	end

	local multiplier = (self.MedicHealMul or 1) * (ent.HumanHealMultiplier or 1)
	local cooldownmultiplier = owner.MedicCooldownMul or 1
	local healed = owner:HealPlayer(ent, math.min(self:GetCombinedPrimaryAmmo(), self.Heal), 1.5)
	local totake = self.FixUsage and 15 or math.ceil(healed / multiplier)

	if totake > 0 then
		if not owner:IsSkillActive(SKILL_INTENSIVETHERAPY) then
			local cd = self.CoolDown * math.min(1, healed / self.Heal) * cooldownmultiplier * (chance or 1)
			self:SetCoolDownInfo(cd)
			self:SetNextCharge(CurTime() + cd)
			owner.NextMedKitUse = self:GetNextCharge()
		else
			self:SetChance(chance or 1)
			self:SetCharges(self:GetCharges() - 1)
		end

		self:TakeCombinedPrimaryAmmo(totake)

		self:EmitSound("items/medshot4.wav")

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		owner:DoAttackEvent()
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if not self:CanPrimaryAttack() or not gamemode.Call("PlayerCanBeHealed", owner) then return end

	local multiplier = self.MedicHealMul or 1
	local cooldownmultiplier = owner.MedicCooldownMul or 1
	local healed = owner:HealPlayer(owner, math.min(self:GetCombinedPrimaryAmmo(), self.Heal * self.Secondary.HealMul))
	local totake = self.FixUsage and 10 or math.ceil(healed / multiplier)

	--[[if SERVER then
		owner:ApplyHumanBuff("regeneration", nil, {Healer = owner, AddHeal = 25})
		owner:ApplyHumanBuff("cleanser", nil, {Applier = owner, Stacks = 1})
	end]]

	--local clanse = owner:GiveStatus("cleanser")
	--if clanse and IsValid(clanse) then
	--	clanse:SetStacks(clanse:GetStacks() + 1)
	--	clanse.Applier = owner
	--end
	
	local chance
	if owner.TrinketMedicCooldown then
		if owner.MedCoolChance >= math.random() then
			chance = 0.01
		else
			chance = 1
		end
	end
	
	if totake > 0 then
		if not owner:IsSkillActive(SKILL_INTENSIVETHERAPY) then
			local cd = self.CoolDown * self.Secondary.DelayMul * math.min(1, healed / self.Heal * self.Secondary.HealMul) * cooldownmultiplier * (chance or 1)
			self:SetCoolDownInfo(cd)
			self:SetNextCharge(CurTime() + cd)
			owner.NextMedKitUse = self:GetNextCharge()
		else
			self:SetChance(chance or 1)
			self:SetCharges(self:GetCharges() - 1)
		end

		self:TakeCombinedPrimaryAmmo(totake)

		self:EmitSound("items/smallmedkit1.wav")

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		owner:DoAttackEvent()
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:OnRemove()
	hook.Remove("Think", tostring(ENTITY))
end

function SWEP:Reload()
end

function SWEP:GetCharges()	
	return self:GetDTInt(7)
end

function SWEP:SetCharges(num)
	return self:SetDTInt(7, num)	
end

function SWEP:SetNextCharge(tim)
	self:SetDTFloat(7, tim)
end

function SWEP:GetNextCharge()
	return self:GetDTFloat(7)
end

function SWEP:SetChance(chc)
	self:SetDTFloat(8, chc)
end

function SWEP:GetChance()
	return self:GetDTFloat(8)
end

function SWEP:SetCoolDownInfo(val)
	self:SetDTFloat(17, val)
end

function SWEP:GetCoolDownInfo(val)
	return self:GetDTFloat(17)
end

function SWEP:CanPrimaryAttack()
	local owner = self:GetOwner()
	if owner:IsHolding() or owner:GetBarricadeGhosting() then return false end
	if (owner.NextMedKitUse or 0) >= CurTime() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:EmitSound("items/medshotno1.wav")

		self:SetNextCharge(0.75) 
		owner.NextMedKitUse = self:GetNextCharge()
		return false
	end

	local check = owner:IsSkillActive(SKILL_INTENSIVETHERAPY) and self:GetCharges() >= 1 or (self:GetNextCharge() <= CurTime() and (owner.NextMedKitUse or 0) <= CurTime())
	return check
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

local texGradDown = surface.GetTextureID("VGUI/gradient_down")
local matGlow = Material("sprites/glow04_noz")

local colHealth = Color(0, 0, 0, 240)
function SWEP:DrawHUD()
	local screenscale = BetterScreenScale()
	local wid, hei = 364 * screenscale, 16 * screenscale
	local x, y = ScrW() - wid - 32 * screenscale, ScrH() - hei - 72 * screenscale
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFontSmall")

	local timeleft = self:GetNextCharge() - CurTime() 
	if 0 < timeleft then
		local CoolDown = math.Clamp(timeleft / self:GetCoolDownInfo() , 0, 1)
		local subwidth = CoolDown * wid
		
		colHealth.r =  CoolDown * 180
		colHealth.g = (1 - CoolDown) * 180
		colHealth.b = 0
		
		surface.SetDrawColor(0, 0, 0, 230)
		surface.DrawRect(x, y, wid, hei)

		surface.SetDrawColor(colHealth.r * 0.6, colHealth.g * 0.6, colHealth.b, 160)
		surface.SetTexture(texGradDown)
		surface.DrawTexturedRect(x + 2, y + 1, subwidth - 4, hei - 2)
		surface.SetDrawColor(colHealth.r * 0.6, colHealth.g * 0.6, colHealth.b, 30)
		surface.DrawRect(x + 2, y + 1, subwidth - 4, hei - 2)

		surface.SetMaterial(matGlow)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(x + 2 + subwidth - 6, y + 1 - hei/2, 3, hei * 2)

		draw.SimpleText(math.Round(timeleft, 2), "ZSHUDFontSmall", x, texty+50, COLOR_GREEN, TEXT_ALIGN_LEFT)
	end

	draw.SimpleText(self.PrintName, "ZSHUDFontSmall", x, texty, COLOR_GREEN, TEXT_ALIGN_LEFT)

	local charges = self:GetPrimaryAmmoCount()
	
	if self:GetOwner():IsSkillActive(SKILL_INTENSIVETHERAPY) then
		draw.SimpleText(self:GetCharges()..translate.Get("medic_charges"), "ZSHUDFontSmall", x, texty - 25, COLOR_GREEN, TEXT_ALIGN_LEFT)
	end

	if charges > 0 then
		draw.SimpleText(charges, "ZSHUDFontSmall", x + wid, texty, COLOR_GREEN, TEXT_ALIGN_RIGHT)
	else
		draw.SimpleText(charges, "ZSHUDFontSmall", x + wid, texty, COLOR_DARKRED, TEXT_ALIGN_RIGHT)
	end

	if GetConVar("crosshair"):GetInt() == 1 then
		self:DrawCrosshairDot()
	end
end
