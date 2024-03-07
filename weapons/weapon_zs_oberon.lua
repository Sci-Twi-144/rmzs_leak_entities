AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_oberon"))
SWEP.Description = (translate.Get("desc_oberon"))

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(2.12, -1, -8)
	SWEP.HUD3DScale = 0.025

	SWEP.ShowViewModel = true

	SWEP.VElements = {
		["base+++"] = { type = "Model", model = "models/Items/boxflares.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(-1.283, -2.158, 1.508), angle = Angle(90, -90, -90), size = Vector(0.437, 0.226, 0.446), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/error/new light1", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_combine/combine_mortar01a.mdl", bone = "ValveBiped.Pump", rel = "", pos = Vector(-1.313, 1.697, -20.396), angle = Angle(0.476, 90, 0), size = Vector(0.172, 0.179, 0.256), color = Color(255, 147, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base++"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0.197, 3.431, 3.428), angle = Angle(-90, 0, -90.676), size = Vector(0.071, 0.019, 0.025), color = Color(255, 180, 123, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base++"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.329, 1.085, -3.164), angle = Angle(175.024, 0.411, 0), size = Vector(0.037, 0.02, 0.017), color = Color(255, 180, 123, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["base+++"] = { type = "Model", model = "models/Items/boxflares.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.725, -0.431, -6.599), angle = Angle(6.518, 180, -90), size = Vector(0.277, 0.277, 0.469), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/error/new light1", skin = 0, bodygroup = {} },
		["base+"] = { type = "Model", model = "models/props_combine/combine_mortar01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.356, 0.796, -2.659), angle = Angle(-94.139, 1.621, 0), size = Vector(0.129, 0.136, 0.108), color = Color(255, 147, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		else
			return "OVRCL"
		end
	end

	function SWEP:PostDrawViewModel(vm)
		if self:GetFireMode() == 1 then
			self.VElements["base+++"].color = Color(0, 255, 255)
		else
			self.VElements["base+++"].color = Color(255, 255, 255, 255)
		end
		self.BaseClass.PostDrawViewModel(self, vm)
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "In Stock"
		else
			return "Overclocked"
		end
	end	
end

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Damage = 14.5
SWEP.Primary.NumShots = 5
SWEP.Primary.Delay = 0.8

SWEP.FireAnimSpeed = 0.55

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 30

SWEP.ConeMax = 7.5
SWEP.ConeMin = 5

SWEP.ReloadDelay = 0.4

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.TracerName = "AR2Tracer"

SWEP.PumpSound = Sound("Weapon_Shotgun.Special1")
SWEP.ReloadSound = Sound("npc/scanner/scanner_scan2.wav")

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 3
SWEP.LegDamage = 3
SWEP.InnateLegDamage = true

SWEP.Tier = 3

SWEP.SpreadPattern = {
    {0, 0},
    {2, -2},
    {-2, -2},
    {4, 0},
    {-4, 0},
}

SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.DamageSave = SWEP.Primary.Damage

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_LEG_DAMAGE, 0.25)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.06, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_oberon_slug")), (translate.Get("desc_generic_slug")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 3.5
	wept.Primary.NumShots = 1
	wept.ResistanceBypass = 0.6
	wept.ConeMin = wept.ConeMin * 0.15
	wept.ConeMax = wept.ConeMax * 0.3
	wept.DamageSave = wept.Primary.Damage

	wept.Primary.ClipSize = 7
	wept.ReloadSound = Sound("npc/scanner/scanner_scan4.wav")

	--local dmg = wept.Primary.Damage 
	wept.CheckOverClock = function(self)
		if self:GetFireMode() == 1 then
			self.RequiredClip = 3
			self.Primary.ClipSize = 21
			self.Primary.Delay = 0.5
			--self.Primary.Damage = dmg * 1.3
		elseif self:GetFireMode() == 0 then
			self.RequiredClip = 1
			self.Primary.ClipSize = 7
			self.Primary.Delay = 0.8
			--self.Primary.Damage = dmg
			self:SetUpClip()
		end
	end

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 72, 115, 0.65, CHAN_AUTO)
		self:EmitSound("weapons/gauss/fire1.wav", 72, 108, 0.65)
	end

	if CLIENT then
		wept.PostDrawViewModel = function(self, vm)
			if self:GetFireMode() == 1 then
				self.VElements["base+++"].color = Color(0, 0, 255)
			else
				self.VElements["base+++"].color = Color(0, 255, 0)
			end
			self.BaseClass.PostDrawViewModel(self, vm)
		end
	end
end)
GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_tithonus")), (translate.Get("desc_tithonus")), "weapon_zs_tithonus")
--local dmg = SWEP.Primary.Damage 
function SWEP:CheckOverClock()
	if self:GetFireMode() == 1 then
		self.RequiredClip = 3
		self.Primary.ClipSize = 21
		self.Primary.Delay = 0.5
	--	self.Primary.Damage = dmg * 1.1
	elseif self:GetFireMode() == 0 then
		self.RequiredClip = 1
		self.Primary.ClipSize = 7
		self.Primary.Delay = 0.8
	--	self.Primary.Damage = dmg
		--if SERVER then
			self:SetUpClip()
		--end
	end
end
--if SERVER then
	function SWEP:SetUpClip()
		local current = self:Clip1()
		timer.Simple(0.15, function()
			local validate_clip = math.min(math.max(0, current), self:GetPrimaryClipSize())
			if not (current <= self:GetPrimaryClipSize()) then
				if SERVER then
					self:GetOwner():GiveAmmo(current, self.Primary.Ammo, true)
				end
				self:SetClip1(validate_clip)
				self:GetOwner():RemoveAmmo(validate_clip, self.Primary.Ammo, false)
			end
		end)
	end
--end

function SWEP:CallWeaponFunction()
	self:CheckOverClock()
	self:SetDTFloat(15, CurTime() + self:GetReloadTime() + 0.25)
	self:SetNextPrimaryFire(CurTime() + self:GetReloadTime())
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity

	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/glock/glock18-1.wav", 75, math.random(162, 168), 0.7, CHAN_WEAPON + 20)
	self:EmitSound("weapons/gauss/fire1.wav", 100, math.random(85, 92), 1.0, CHAN_WEAPON)
end