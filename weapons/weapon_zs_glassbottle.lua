AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_glassbottle"))
SWEP.Description = (translate.Get("desc_glassbottle"))

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/glassbottle01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.799, 0.899, -7), angle = Angle(8.182, -12.858, 8.182), size = Vector(1.144, 1.144, 1.144), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/glassbottle01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.4, 1.557, -5.715), angle = Angle(0, 0, 0), size = Vector(1.274, 1.274, 1.274), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_junk/glassbottle01a.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true
SWEP.Secondary.Automatic = false

SWEP.MeleeDamage = 80
SWEP.MeleeRange = 48
SWEP.MeleeSize = 0.875

SWEP.Secondary.Delay = 2

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.Primary.Delay = 0.85
SWEP.SwingTime = 0
SWEP.SwingHoldType = "grenade"

SWEP.NoHitSoundFlesh = true


function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/glass/glass_bottle_break2.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/glass/glass_bottle_break2.wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() then
		if SERVER then
			local owner = self:GetOwner()
			timer.Simple(0, function()
				owner:StripWeapon(self:GetClass())
			end)

			owner:Give("weapon_zs_crackedbottle")
			owner:SelectWeapon("weapon_zs_crackedbottle")
		end
	end
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	local owner = self:GetOwner()
	if SERVER then
		local ent = ents.Create("projectile_glassbottle")
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetOwner(owner)
			ent.Team = owner:Team()
			ent:Spawn()
	
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
	
				angle = owner:GetAimVector():Angle()
				phys:SetVelocityInstantaneous(angle:Forward() * 840 * (owner.ProjectileSpeedMul or 1))
			end
		end

		timer.Simple(0, function()
			if self and self:IsValid() then
				owner:StripWeapon(self:GetClass())
			end
		end)
	end
end