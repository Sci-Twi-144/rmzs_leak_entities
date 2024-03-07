AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_bizon"))
SWEP.Description = (translate.Get("desc_bizon"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60 --70

	SWEP.HUD3DBone = "v_weapon.bizon_parent"
	SWEP.HUD3DPos = Vector(1.4, -4, 3)
	SWEP.HUD3DAng = Angle(180, 0, -25)
	SWEP.HUD3DScale = 0.015

	--SWEP.VMPos = Vector(1, -3, -1)
	--SWEP.VMAng = Vector(0, 0, 0)

--	SWEP.WMPos = Vector(1, 8, -4)
--	SWEP.WMAng = Angle(95, 180, 0)
--	SWEP.WMScale = 1.1

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_csgo/w_bizon.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9, 1, -3.8), angle = Angle(95, 180, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["v_weapon.bizon_bolt"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VMPos = Vector(0, 0, 0)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(1, -0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -12, 0) )
            self.ViewModelBoneMods[ "v_weapon.bizon_bolt" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.bizon_bolt" ].pos, Vector(0, 0, -5) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
            self.ViewModelBoneMods[ "v_weapon.bizon_bolt" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.bizon_bolt" ].pos, lBarrelOrigin )
        end
        self.BaseClass.Think(self)
    end	
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"


SWEP.ViewModel = "models/weapons/tfa_csgo/c_bizon.mdl"
SWEP.WorldModel = "models/weapons/tfa_csgo/w_bizon.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = ")weapons/tfa_csgo/bizon/bizon-1.ogg"
SWEP.Primary.Damage = 25.35
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.085

SWEP.Primary.ClipSize = 52
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 4.5
SWEP.ConeMin = 2.25

SWEP.FireAnimSpeed = 5

SWEP.Tier = 5

SWEP.StandartIronsightsAnim = false
SWEP.SpecificCond = false

SWEP.IronSightsPos = Vector(-5.1, -3, 1)

SWEP.IronsightsMultiplier = 0.8
--SWEP.IronSightsPos = Vector(-3, 2, 0)
--SWEP.IronSightsAng = Vector(2, 0, 0)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 6, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.05, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, nil, nil, "weapon_zs_veresk")

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if attacker:IsValidLivingHuman() then
		local ent = tr.Entity
	
		if SERVER then
			if ent:IsValidLivingZombie() and gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
				local dmg = 0
				-- dmginfo:GetDamage()
				if ent:GetStatus("burn") then
					ent:TakeDamage(dmginfo:GetDamage() * 0.2, attacker, wep)
				end

				if ent:GetStatus("frost") then
					ent:TakeDamage(dmginfo:GetDamage() * 0.2, attacker, wep)
				end
				
				if ent:GetStatus("zombiestrdebuff") then
					ent:TakeDamage(dmginfo:GetDamage() * 0.2, attacker, wep)
				end

			end
		end
	end
end
if not CLIENT then return end

function SWEP:Draw3DHUD(vm, pos, ang)
	self.BaseClass.Draw3DHUD(self, vm, pos, ang)

	local wid, hei = 180, 200
	local x, y = wid * -0.6, hei * -0.5

	cam.Start3D2D(pos, ang, self.HUD3DScale)
		local owner = self:GetOwner()
		local text = ""

		if owner.Focused.DieTime >= CurTime() then
			if owner.Focused.Stacks then
				for i = 0, owner.Focused.Stacks -1 do
					text = text .. "+"
				end
				draw.SimpleTextBlurry(text, "ZS3D2DFontSmall", x + wid/2, y + hei * 0.15, Color(130, 130, 130, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	cam.End3D2D()
end