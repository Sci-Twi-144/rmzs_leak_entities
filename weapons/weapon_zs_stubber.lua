AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_stubber"))
SWEP.Description = (translate.Get("desc_stubber"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 65

	SWEP.HUD3DBone = "v_weapon.scout_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.75, -6)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(-1.25, -3, 0.3)
	SWEP.VMAng = Vector(0, 0, 0)

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, Color(121, 121, 121), self:GetResource(), self.AbilityMax, "Pierce Shot")
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, Color(121, 121, 121), self:GetResource(), self.AbilityMax, "Pierce Shot")
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_Scout.ClipOut")
SWEP.Primary.Sound = ")weapons/scout/scout_fire-1.wav"
SWEP.Primary.Damage = 59
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.25
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 25

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 3.75
SWEP.ConeMin = 0

SWEP.HasAbility = true
SWEP.AbilityMax = 450
SWEP.ResourceCap = SWEP.AbilityMax

SWEP.ResistanceBypass = 0.4
SWEP.BleedDamageMul = 0.5

SWEP.IronSightsPos = Vector(-4, -4, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOW

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_prodder")), (translate.Get("desc_prodder")), function(wept)
	wept.HeadshotMulti = 2.68
	wept.Primary.Damage = wept.Primary.Damage * 0.8
	wept.Primary.ClipSize = math.ceil(wept.Primary.ClipSize / 2)

	wept.ReloadSpeed = 0.8
	wept.IronsightsMultiplier = 0.15
end)

function SWEP:PrimaryAttack()
	if self:GetTumbler() then
		self.Pierces = 4
		self.DamageTaper = 0.75
	else
		self.Pierces = 1
		self.DamageTaper = 0.8
	end
	self.BaseClass.PrimaryAttack(self)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if SERVER then
		local ent = tr.Entity
		local wep = attacker:GetActiveWeapon()

		timer.Simple(0, function()
			if wep and (wep:GetResource() >= wep.AbilityMax) then 
				wep:SetTumbler(true) 
			end
		end)

		if wep:GetTumbler() and ent:IsValidLivingZombie() and attacker:IsValidLivingHuman() then
			wep:SetResource(0)
			wep:SetTumbler(false)
			ent:AddBleedDamage(wep.Primary.Damage * wep.BleedDamageMul, attacker)
			local bleed = ent:GiveStatus("bleed")
			if bleed and bleed:IsValid() then
				bleed:AddDamage(wep.Primary.Damage * wep.BleedDamageMul)
				bleed.Damager = attacker
				bleed:SetType(1)
			end
		end
	end
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 100)
end

if CLIENT then
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
