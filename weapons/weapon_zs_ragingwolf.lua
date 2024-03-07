AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_ragingwolf"))
SWEP.Description = (translate.Get("desc_ragingwolf")) -- Мощный револьвер, имеет способность моментально убивать цель кроме боссов
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.HasAbility = true
SWEP.AbilityText = "ONESHOT"
SWEP.AbilityColor = Color(65, 250, 220)
SWEP.AbilityMax = 4200

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.HUD3DBone = "tag_weapon"
	SWEP.HUD3DPos = Vector(0, -0.8, 2)
	SWEP.HUD3DAng = Angle(0, -90, 75)
	SWEP.HUD3DScale = 0.013

	SWEP.VElements = {}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/weapons/arccw/dm1973/c_dmi_454_casull.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8.5, 4, -4), angle = Angle(-10, 0, 180), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}	

	SWEP.ViewModelBoneMods = {
		["j_bolt"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["j_press_rear"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		
	}

	SWEP.VMPos = Vector(2, 1.5, -0.5)
	SWEP.VMAng = Angle(0, 0, 0)
	local uBarrelOrigin = SWEP.VMPos
	local lBarrelOrigin = Vector(0, 0, 0)
	local BarAngle = Angle(0, 0, 0)
    function SWEP:Think()
        if self.IsShooting >= CurTime() and self:GetIronsights() then
			
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(3, -0, 0) )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(2, -12, 0) )
            self.ViewModelBoneMods[ "j_bolt" ].angle = LerpAngle( RealFrameTime() * 60, self.ViewModelBoneMods[ "j_bolt" ].angle, Angle(0, 0, -35) )
			self.ViewModelBoneMods[ "j_press_rear" ].angle = LerpAngle( RealFrameTime() * 60, self.ViewModelBoneMods[ "j_press_rear" ].angle, Angle(-35, 0, 0) )
        else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
            self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
            self.ViewModelBoneMods[ "j_bolt" ].angle = LerpAngle( RealFrameTime() * 36, self.ViewModelBoneMods[ "j_bolt" ].angle, BarAngle )
			self.ViewModelBoneMods[ "j_press_rear" ].angle = LerpAngle( RealFrameTime() * 36, self.ViewModelBoneMods[ "j_press_rear" ].angle, BarAngle )
        end
        self.BaseClass.Think(self)
    end		

	function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, true, 6, 1/6)
	end

	function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
		self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText, true, 6, 1/6)
	end

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "STOCK"
		elseif self:GetFireMode() == 1 then
			return "ONESHOT"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Stock"
		elseif self:GetFireMode() == 1 then
			return "Oneshot"
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/arccw/dm1973/c_dmi_454_casull_fix.mdl"
SWEP.WorldModel = "models/weapons/arccw/dm1973/c_dmi_454_casull_fix.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.SoundFireVolume = 0.93
SWEP.SoundPitchMin = 88
SWEP.SoundPitchMax = 93
SWEP.Primary.Sound = ")weapons/arccw/dmi_454_casull/127-"..math.random(1,3)..".wav"

SWEP.Primary.Delay = 0.3
SWEP.Primary.Damage = 97.25
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.HeadshotMulti = 2.15

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.ResistanceBypass = 0.5

SWEP.CannotHaveExtendetMag = true

SWEP.ConeMax = 3.5
SWEP.ConeMin = 1.5

SWEP.IronSightsPos = Vector(-4.161, 1.5, 1.262)
SWEP.IronSightsAng = Angle(-0.695, -0.051, 0)

SWEP.ReloadActivity = ACT_VM_RELOAD_EMPTY

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.6, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.3, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)


SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = false
SWEP.PushFunction = true

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.016
    local dfanim = self:GetIronsights() and ACT_VM_IDLE or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

-- function SWEP:CallWeaponFunction() -- AUF
	-- if self:GetTumbler() then
		-- local owner = self:GetOwner()
		-- if SERVER then
			-- owner:ApplyHumanBuff("auf", 12 * (owner.BuffDuration or 1), {Applier = owner, Stacks = 1, Max = 3}, true, false)
		-- end
		-- self:SetResource(0, false)
		-- self:SetTumbler(false)
	-- end
-- end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local wep = dmginfo:GetInflictor()
	
	if SERVER and ent and ent:IsValidLivingZombie() then
		dmginfo:SetDamageForce(attacker:GetUp() * 7000 + attacker:GetForward() * 25000)
	end
	
	if SERVER then
		if wep:GetResource() > wep.AbilityMax then
			wep:SetResource(wep.AbilityMax)
		end
	end
	
	if SERVER then
		if wep:GetResource() < 0 then
			wep:SetResource(0)
		end
	end

	if SERVER and IsValid(wep) and wep:GetResource() >= 700 and wep:GetTumbler() and wep:GetFireMode() == 1 then
		if ent:IsValidLivingZombie() then ---then who the fuck did that?
			wep:SetResource(wep:GetResource() - 700)
			if gamemode.Call("PlayerShouldTakeDamage", ent, attacker) and (ent:GetBossTier() < 1) then
				dmginfo:SetDamageType(DMG_DIRECT)
				dmginfo:SetDamage(ent:Health())
			end
		end
	end
end

function SWEP:CallWeaponFunction()
	self:CheckFireMode()
	self:SetSwitchDelay(self:GetReloadFinish() + 0.1)
end

function SWEP:CheckFireMode()
	if self:GetFireMode() == 0 then
		self:SetTumbler(false)
	elseif self:GetFireMode() == 1 then 
		self:SetTumbler(true)
	end
end

function SWEP:EmitReloadSound()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if IsFirstTimePredicted() then
		timer.Create("reload_start", 0.48 / reloadspeed, 1, function()
			self:EmitSound("weapons/arccw/bo1_python/open.wav", 75, 75, 1, CHAN_WEAPON + 21)
		end)
		timer.Create("reload_empty", 1.08 / reloadspeed, 1, function()
			self:EmitSound("weapons/arccw/bo1_python/empty.wav", 75, 75, 1, CHAN_WEAPON + 22)
		end)
		timer.Create("reload_load", 1.94 / reloadspeed, 1, function()
			self:EmitSound("weapons/arccw/bo1_python/load.wav", 75, 75, 1, CHAN_WEAPON + 23)
		end)
		timer.Create("reload_close", 2.37 / reloadspeed, 1, function()
			self:EmitSound("weapons/arccw/bo1_python/close.wav", 70, 57, 1, CHAN_WEAPON + 24)
		end)
	end
end

function SWEP:RemoveAllTimers()
	timer.Remove("reload_start")
	timer.Remove("reload_empty")
	timer.Remove("reload_load")
	timer.Remove("reload_close")
end

function SWEP:Holster()
	self:RemoveAllTimers()
	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)
	self:RemoveAllTimers()
end
