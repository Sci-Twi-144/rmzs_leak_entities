AddCSLuaFile()

SWEP.PrintName = "Karatel"

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.ViewModelFOV = 50
	SWEP.CSMuzzleFlashes = true

	SWEP.VMPos = Vector(2.68, 0, -0.64)
	SWEP.VMAng = Vector(-1.407, -0.704, 0)

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/tfa_nmrih/w_fa_sv10.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11, 1.2, -3), angle = Angle(-15, 2.5, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/tfa_nmrih/v_fa_sv10.mdl"
SWEP.WorldModel	= "models/weapons/tfa_nmrih/w_fa_sv10.mdl"
SWEP.ShowWorldModel = false

SWEP.UseHands = true
SWEP.HoldType = "shotgun"

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = "weapons/firearms/shtg_berettasv10/beretta_fire_01.ogg"
SWEP.Primary.Damage = 35
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.5

SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = false

SWEP.IronSightsPos = Vector(-3.58, -2.638, 2.4)
SWEP.IronSightsAng = Vector(-0.071, 0.009, 0)

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.SpecialBossWeapon = true
SWEP.WorldModelFix = true
SWEP.AllowQualityWeapons = false
SWEP.ZombieOnly = true

SWEP.Undroppable = true
SWEP.NoPickupNotification = true
SWEP.NoDismantle = true

SWEP.Count = 0
function SWEP:Think()
	local owner = self:GetOwner()
	if self:IsValid() then
		self:PrimaryAttack()
		if self.Count >= 2 then
			if SERVER then
				timer.Simple(0.08, function()
					owner:StripWeapon( "weapon_zs_sv10_z" )
				end)
				timer.Simple(0, function()
					owner:SelectWeapon("weapon_zs_executioner_z")
				end)
			end
		end
	end
	self:NextThink(CurTime() + 0.5)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self.Count = self.Count + 1
    self.BaseClass.PrimaryAttack(self)
end


function SWEP:Reload()
end

function SWEP:TakeAmmo()
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
end

function SWEP:SecondaryAttack()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity 

	if SERVER and ent:IsValidLivingHuman() then
		ent:ApplyZombieDebuff("anchor", 12, { Applier = attacker } )
		ent:ApplyZombieDebuff("slow", 12, { Applier = attacker } )
		ent:ApplyZombieDebuff("enfeeble", 12, {Applier = attacker, Stacks = 3}, true, 6)
	end
end