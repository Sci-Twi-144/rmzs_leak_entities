AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_pointer"))
SWEP.Description = (translate.Get("desc_pointer"))

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 65

	SWEP.HUD3DBone = "v_weapon.sg552_Parent"
	SWEP.HUD3DPos = Vector(-2.12, -6.25, -2)
	SWEP.HUD3DAng = Angle(0, -6, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.VMPos = Vector(-2, -7, 1)
	SWEP.VMAng = Vector(1, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_sg552.mdl"
SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_SG552.Clipout")

SWEP.SoundPitchMin = 85
SWEP.SoundPitchMax = 90

SWEP.Primary.Sound = ")weapons/sg552/sg552-1.wav"
SWEP.Primary.Damage = 13
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 32
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2
SWEP.ConeMin = 0.8

SWEP.ReloadSpeed = 0.9

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 3
SWEP.ResistanceBypass = 0.75

SWEP.IronSightsPos = Vector(-3, 4, 1)
SWEP.IronSightsAng = Vector(0, 0, 0)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.07)

function SWEP.BulletCallback(attacker, tr, dmginfo)

	local ent = tr.Entity
	local wep = dmginfo:GetInflictor()

	if SERVER and ent:IsValid() and ent:IsPlayer() then
			attacker:AddPoints(1)

			net.Start("zs_commission")
			net.WriteEntity(ent)
			net.WriteEntity(attacker)
			net.WriteFloat(1)
			net.Send(attacker)
	end
end

function SWEP.OnZombieKilled(self, zombie, total, dmginfo)
local killer = self:GetOwner()
		if SERVER and killer:IsValidLivingHuman() then
			killer:AddPoints(5)
			
			local owner = self:GetOwner()

			net.Start("zs_commission")
			net.WriteEntity(zombie)
			net.WriteEntity(activator)
			net.WriteFloat(5)
			net.Send(owner)
		end
end