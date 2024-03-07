AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_noobtube"))
SWEP.Description = (translate.Get("desc_noobtube"))

SWEP.Slot = 4
SWEP.SlotPos = 0
if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(3, -1.5, 1.3)
	SWEP.HUD3DAng = Angle(0, -90, 55)
	SWEP.HUD3DScale = 0.015

	SWEP.WMPos = Vector(1, 2, 1)
	SWEP.WMAng = Angle(-9, 0, 180)
	SWEP.WMScale = 1.0

	SWEP.ShowWorldModel = false

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/weapons/w_thumper.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 2, 3), angle = Angle(-15, 5, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "CONTACT"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "CONTACT"
		end
	end	
	
	function SWEP:Draw2DHUDAds(x, y, hei, wid)
		local instabonus = self:GetHitStacks()
		draw.SimpleTextBlurry("+ "..instabonus, "ZSHUDFontSmall", x + wid * 0.5, y + hei * 1.6, Color(192, 128, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function SWEP:Draw3DHUDAds(x, y, hei, wid)
		local instabonus = self:GetHitStacks()
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(x, y + hei * 0.92, wid, 34)
		draw.SimpleTextBlurry("+ "..instabonus, "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 1, Color(192, 128, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

end

SWEP.UseHands = true
SWEP.WorldModelFix = true

SWEP.Base = "weapon_zs_baseproj"

SWEP.HoldType = "shotgun"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_thumper.mdl"
SWEP.WorldModel = "models/weapons/w_thumper.mdl"

SWEP.Primary.Sound = ")weapons/thumper/fire.wav"
SWEP.SoundFireVolume = 1.0
SWEP.SoundFireLevel = 140
SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "impactmine"
SWEP.Primary.Damage = 150
SWEP.Primary.Delay = 0.9
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Projectile = "projectile_grenade_launcher"
SWEP.ProjectileVel = 1200

SWEP.ProjHasDMGRadius = true

SWEP.IronSightsPos = Vector(-1, 2, 0)
SWEP.IronSightsAng = Vector(8, 0, 0)

SWEP.ReloadDelay = 1.1

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Tier = 6

SWEP.IsAoe = true

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.AllowQualityWeapons = false

SWEP.Primary.Projectile = "projectile_grenade_launcher"
SWEP.Primary.ProjVelocity = 900

SWEP.Primary.ProjExplosionRadius = 95
SWEP.Primary.ProjExplosionTaper = 0.85

SWEP.OriginalDamage = SWEP.Primary.Damage

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.4, 1)

local mogus = 1
function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		mogus = 1
	elseif self:GetFireMode() == 1 then
		mogus = 0
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:SetSwitchDelay(0.1)
end

if SERVER then
	function SWEP:EntModify(ent)
		ent:SetDTBool(mogus, true)
	end
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
end

function SWEP:OnZombieKilled(zombie, total, dmginfo)
	local killer = self:GetOwner()
	if killer:IsValidLivingHuman() then
		local pos = zombie:GetPos()
			if dmginfo:GetInflictor() == killer:GetActiveWeapon() then
				timer.Simple(0.06, function()
					if killer:IsValidLivingHuman() then
						util.BlastDamagePlayer(killer:GetActiveWeapon(), killer, pos, 144, self.Primary.Damage * 3, DMG_ALWAYSGIB, 0.65)
						self:SetHitStacks(self:GetHitStacks() + 1)
						self.Primary.Damage = self.OriginalDamage + self:GetHitStacks()
						
					end
				end)
			end

			local effectdata = EffectData()
				effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata, true, true)
		end
end

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end

sound.Add({
	name 	=	"mw2_thumper_new.out",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound	=	"weapons/thumper/out.wav"	
})

sound.Add({
	name 	=	"mw2_thumper_new.insert",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/thumper/insert.wav"	
})

sound.Add({
	name 	=	"mw2_thumper_new.open",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/thumper/open1.wav"	
})

sound.Add({
	name 	=	"mw2_thumper_new.close",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/thumper/close.wav"	
})

sound.Add({
	name	=	"mw2_thumper_new.deploy",			
	channel =	CHAN_ITEM,
	volume 	=	1.0,
	sound 	=	"weapons/thumper/deploy.wav"	
})