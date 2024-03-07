AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_surefire"))
SWEP.Description = (translate.Get("desc_surefire"))
SWEP.Slot = 3
SWEP.SlotPos = 0

-- Ивент оружие, аналог рельсотрона из Awesome Strike Source, имеет такой же недостаток, как и у ивентового медлуча
-- Оружие под задел для специальной категории, люди смогут его покупать, когда будет активирован сам ивент

SWEP.HasAbility = true
SWEP.AbilityMax = 240

if CLIENT then
	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(1.5, 1.6, 0)
	SWEP.HUD3DAng = Angle(0, 90, 90)
	SWEP.HUD3DScale = 0.017

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.VElements = {
		["whity2"] = { type = "Sprite", sprite = "sprites/glow04", bone = "Base", rel = "", pos = Vector(-5, 1, 0), size = { x = 10, y = 10 }, color = Color(255, 125, 0, 10), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true}
	}

	local colBG = Color(16, 16, 16, 90)
	local colBlue = Color(50, 50, 220, 230)

	function SWEP:Draw2DHUD()
		local screenscale = BetterScreenScale()

		local sin2 = (math.abs(math.cos(CurTime() * 1.2))) * (self:GetResource() / self.AbilityMax)
		local colorspr = Color(255, 125, 0, 25 * sin2)
		self.VElements["whity2"].color = colorspr
	
		local wid, hei = 180 * screenscale, 64 * screenscale
		local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72
	
		draw.RoundedBox(16, x, y, wid, hei, colBG)
		draw.SimpleTextBlurry(self:GetResource(), "ZSHUDFontBig", x + wid * 0.5, y + hei * 0.5, colBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	function SWEP:Draw3DHUD(vm, pos, ang)
		local wid, hei = 256, 144
		local x, y = wid * -0.6, hei * -0.5
	
		cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
			draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)
			draw.SimpleTextBlurry(self:GetResource(), "ZS3D2DFont", x + wid * 0.5, y + hei * 0.3, colBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleTextBlurry(self:GetPrimaryAmmoCount(), "ZS3D2DFont2", x + wid * 0.5, y + hei * 0.8, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if self:GetTumbler() then
				draw.SimpleText("Ready", "ZSHUDFontBig", x + wid * 0.5, y + hei * -0.2, Color(math.abs(math.sin(CurTime()*8)) * 255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/rmzs/weapons/mp7/c_surefire.mdl"
SWEP.WorldModel = "models/rmzs/weapons/mp7/w_surefire.mdl"
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")npc/strider/fire.wav"
SWEP.Primary.Damage = 768
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.5
SWEP.ReloadDelay = 1

SWEP.Primary.ClipSize = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 0

SWEP.Secondary.Automatic = true

SWEP.TracerName = "tracer_surefire"
SWEP.Tracer = 50

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.Tier = 6
SWEP.ResistanceBypass = 0

SWEP.SpecificCond = true
SWEP.AllowQualityWeapons = false

SWEP.Recoil = 15

SWEP.Pierces = 99
SWEP.DamageTaper = 1

SWEP.Primary.ProjExplosionRadius = 128
SWEP.Primary.ProjExplosionTaper = 0.85

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, -1, 0)

SWEP.WalkSpeed = SPEED_SLOWER

local texture = Material("models/weapons/v_smg1_new/plasma_collector")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:Initialize()
	if CLIENT then
		texture:SetFloat("$emissiveblendtint", 0)
	end
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "weapons/gauss/chargeloop.wav")

	self.ChargingSound2 = CreateSound(self, "^weapons/physcannon/energy_sing_loop4.wav")
	self.ChargingSound2:SetSoundLevel(85)
end

function SWEP:TakeAmmo()
end

function SWEP:TakeAmmo2()
	self:TakeCombinedPrimaryAmmo(2)
end

function SWEP:CanPrimaryAttack()
	if not self:GetTumbler() then return false end

	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:CanSecondaryAttack()
	if self:GetPrimaryAmmoCount() <= 0 then
		return false
	end

	if self:GetTumbler() then return false end
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	dmginfo:SetDamageType(DMG_DISSOLVE)
	local wep = dmginfo:GetInflictor()

	local ent = tr.Entity
	if SERVER and ent and ent:IsValidLivingZombie() then
		ent:AddBurnDamage(wep.Primary.Damage, attacker or dmginfo:GetInflictor(), 2)

	end

	if SERVER then
		if tr.HitWorld then
			util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

			local pos = tr.HitPos
			util.BlastDamagePlayer(wep, attacker, pos, 128, wep.Primary.Damage / 2, DMG_ALWAYSGIB, 0.94)
			for _, ent2 in pairs(util.BlastAlloc(self, attacker, pos, 160 * (attacker.ExpDamageRadiusMul or 1))) do
				if ent2:IsValidLivingZombie() then
					ent2:AddBurnDamage(wep.Primary.Damage, attacker or dmginfo:GetInflictor(), 2)
				end
			end
		end
	end

end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self.BaseClass.PrimaryAttack(self)
	self:SetResource(0)
	self:SetTumbler(false)

	if CLIENT then
		texture:SetFloat("$emissiveblendtint", 0)
	end
	self.ChargeSound:Stop()
	self.ChargingSound2:Stop()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	
	if CLIENT then
		texture:SetFloat("$emissiveblendtint", self:GetResource() / self.AbilityMax)
	end

	self.ChargingSound2:PlayEx(1, 70 - (50 * (self:GetResource() / self.AbilityMax)))
	self.ChargingSound2:ChangePitch( 20, (1 - (self:GetResource() / self.AbilityMax)) ) 

	self:TakeAmmo2()
	self:SetResource( math.min(self.AbilityMax, self:GetResource() + 2) )
	
	if self:GetResource() >= self.AbilityMax then self:SetTumbler(true) end
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if self:GetTumbler() then
		self.ChargeSound:PlayEx(1, 100)
	end
end

function SWEP:Holster()
	self.ChargeSound:Stop()
	self.ChargingSound2:Stop()
	self.BaseClass.Holster(self)
	return true
end