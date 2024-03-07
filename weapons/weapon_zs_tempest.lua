AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_tempest"))
SWEP.Description = (translate.Get("desc_tempest"))
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.FIVESEVEN_PARENT"
	SWEP.HUD3DPos = Vector(-1, -2.5, -1)
	SWEP.HUD3DAng = Angle(0, 0, 0)

	SWEP.VElements = {
		["top2"] = { type = "Model", model = "models/combine_turrets/ground_turret.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top+", pos = Vector(0.1, 0, 1.5), angle = Angle(-90, 0, 0), size = Vector(0.2, 0.079, 0.1), color = Color(208, 229, 255, 255), surpresslightning = false, material = "models/weapons/v_models/pist_fiveseven/pist_fiveseven", skin = 0, bodygroup = {} },
		["bottom"] = { type = "Model", model = "models/props_combine/combinethumper001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "top+", pos = Vector(0.699, 0, -2), angle = Angle(0, 90, 0), size = Vector(0.009, 0.014, 0.019), color = Color(171, 191, 204, 255), surpresslightning = false, material = "models/weapons/v_models/pist_fiveseven/pist_fiveseven", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "v_weapon.FIVESEVEN_SLIDE", rel = "", pos = Vector(0, 7.989, -0.28), angle = Angle(-90, 90, 0), size = Vector(0.029, 0.028, 0.104), color = Color(49, 55, 62, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["top+"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -2, -9.429), angle = Angle(0, -90, 0), size = Vector(0.025, 0.035, 0.108), color = Color(49, 52, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["top2"] = { type = "Model", model = "models/combine_turrets/ground_turret.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top+", pos = Vector(0.1, 0, 1.5), angle = Angle(-90, 0, 0), size = Vector(0.2, 0.079, 0.1), color = Color(208, 229, 255, 255), surpresslightning = false, material = "models/weapons/v_models/pist_fiveseven/pist_fiveseven", skin = 0, bodygroup = {} },
		["bottom"] = { type = "Model", model = "models/props_combine/combinethumper001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top+", pos = Vector(0.699, 0, -2), angle = Angle(0, 90, 0), size = Vector(0.009, 0.014, 0.019), color = Color(171, 191, 204, 255), surpresslightning = false, material = "models/weapons/v_models/pist_fiveseven/pist_fiveseven", skin = 0, bodygroup = {} },
		["top+"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.5, 2.2, -2.5), angle = Angle(90, 174, 180), size = Vector(0.025, 0.035, 0.108), color = Color(49, 52, 55, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} },
		["top"] = { type = "Model", model = "models/props_lab/hev_case.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "top+", pos = Vector(-2, 0, -0.101), angle = Angle(180, 0, 180), size = Vector(0.029, 0.028, 0.104), color = Color(49, 55, 62, 255), surpresslightning = false, material = "phoenix_storms/concrete2", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["v_weapon.FIVESEVEN_SLIDE"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = "weapons/ar2/npc_ar2_altfire.wav"
SWEP.Primary.Damage = 43
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.47
SWEP.Primary.BurstShots = 3

SWEP.Primary.ClipSize = 15
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3.5
SWEP.ConeMin = 1.7

SWEP.Tier = 3
SWEP.FireAnimSpeed = 1.5

SWEP.ReloadSpeed = 1.05

SWEP.IronSightsPos = Vector(-5.95, 0, 2.3)

SWEP.BurstFire = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.37, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.25, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.03, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 3, 1)
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_cosmos")), (translate.Get("desc_cosmos")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.55
	wept.Primary.Delay = wept.Primary.Delay * 0.8--1.5
	wept.ConeMin = wept.ConeMin * 0.75

	wept.MaxDistance = 512
	wept.TracerName = "tracer_cosmos"
	wept.Primary.Ammo = "pulse"
	
	wept.InnateTrinket = "trinket_pulse_rounds"
    wept.LegDamageMul = 1
	wept.LegDamage = 1
	wept.InnateLegDamage = true

	wept.PointsMultiplier = 1.1

	wept.IronSightsPos = Vector(-5.91, 0, 2.2)
	
	wept.BurstFire = false

	
	wept.ShootBullets = function(self, dmg, numbul, cone)
		local owner = self:GetOwner()
		local zeroclip = self:Clip1() == 0

		self:SendWeaponAnimation()
		owner:DoAttackEvent()
		if SERVER and (self:Clip1() % 7 == 1) then
			local ent = ents.Create("projectile_shockball")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Up(), 90)
				ent:SetAngles(angle)

				ent:SetOwner(owner)
				ent.ProjDamage = self.Primary.Damage * (owner.ProjectileDamageMul or 1)
				ent.ProjSource = self
				ent.ShotMarker = i
				ent.Team = owner:Team()	

				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()

					angle = owner:GetAimVector():Angle()
					angle:RotateAroundAxis(angle:Forward(), math.Rand(0, 360))
					angle:RotateAroundAxis(angle:Up(), math.Rand(-cone/1.5, cone/1.5))
					phys:SetVelocityInstantaneous(angle:Forward() * 700 * (owner.ProjectileSpeedMul or 1))
				end
			end
		end
		owner:LagCompensation(true)
		owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, self.Pierces, self.DamageTaper, dmg / (zeroclip and 1.5 or 1), nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
		owner:LagCompensation(false)
	end

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 70, 155, 0.65, CHAN_AUTO)
		self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 70, 157, 0.65, CHAN_WEAPON + 20)
	end

	wept.EmitReloadFinishSound = function(self)
		if IsFirstTimePredicted() then
			self:EmitSound("items/battery_pickup.wav", 70, 156, 0.85, CHAN_AUTO)
		end
	end

	wept.BulletCallback = function(attacker, tr, dmginfo)
		local ent = tr.Entity
		if ent:IsValidZombie() then
			ent:AddLegDamageExt(6.5, attacker, attacker:GetActiveWeapon(), SLOWTYPE_PULSE)
		end

		if IsFirstTimePredicted() then
			util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
		end
	end
		
	wept.VElements = {
		["lucasarts+"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -2, -5), angle = Angle(0, 90, 0), size = Vector(0.449, 0.899, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lucasarts++"] = { type = "Model", model = "models/props_lab/reciever01a.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "lucasarts+", pos = Vector(0.5, 0, 1.899), angle = Angle(0, 0, 90), size = Vector(0.079, 0.37, 0.2), color = Color(112, 125, 133, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["lucasarts+++"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "lucasarts+", pos = Vector(1, 0, 2), angle = Angle(0, 90, 90), size = Vector(0.109, 0.5, 0.119), color = Color(204, 255, 255, 255), surpresslightning = false, material = "models/props_building_details/courtyard_template001c_bars_dark", skin = 0, bodygroup = {} },
		["lucasarts++++"] = { type = "Model", model = "models/items/grenadeammo.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "lucasarts+", pos = Vector(1, 0, -7), angle = Angle(0, 90, 0), size = Vector(0.4, 0.4, 1.2), color = Color(92, 110, 135, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["lucasarts"] = { type = "Model", model = "models/props_pipes/valve001.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "lucasarts+", pos = Vector(-2, 0, -2), angle = Angle(0, 90, 0), size = Vector(0.1, 0.2, 0.05), color = Color(90, 102, 123, 255), surpresslightning = false, material = "models/props_interiors/radiator01c", skin = 0, bodygroup = {} }
	}

	wept.WElements = {
		["lucasarts+"] = { type = "Model", model = "models/items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.5, -3), angle = Angle(-90, -5, 180), size = Vector(0.449, 0.899, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lucasarts++"] = { type = "Model", model = "models/props_lab/reciever01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lucasarts+", pos = Vector(0.5, 0, 1.899), angle = Angle(0, 0, 90), size = Vector(0.079, 0.37, 0.2), color = Color(112, 125, 133, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["lucasarts+++"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lucasarts+", pos = Vector(1, 0, 2), angle = Angle(0, 90, 90), size = Vector(0.109, 0.5, 0.119), color = Color(204, 255, 255, 255), surpresslightning = false, material = "models/props_building_details/courtyard_template001c_bars_dark", skin = 0, bodygroup = {} },
		["lucasarts++++"] = { type = "Model", model = "models/items/grenadeammo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lucasarts+", pos = Vector(1, 0, -7), angle = Angle(0, 90, 0), size = Vector(0.4, 0.4, 1.2), color = Color(92, 110, 135, 255), surpresslightning = false, material = "models/props_lab/ravendoor_sheet", skin = 0, bodygroup = {} },
		["lucasarts"] = { type = "Model", model = "models/props_pipes/valve001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lucasarts+", pos = Vector(-2, 0, -2), angle = Angle(0, 90, 0), size = Vector(0.1, 0.2, 0.05), color = Color(90, 102, 123, 255), surpresslightning = false, material = "models/props_interiors/radiator01c", skin = 0, bodygroup = {} }
	}
end)
branch.Colors = {Color(100, 130, 180), Color(90, 120, 170), Color(70, 100, 160)}
branch.NewNames = {"Jovial", "Orbital", "Celestial"}
branch.Killicon = "weapon_zs_cosmos"

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	--self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 1.82)
	self:EmitFireSound()

	self:SetNextShot(CurTime())
	self:SetShotsLeft(self.Primary.BurstShots)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local pos = tr.HitPos
	local wep = dmginfo:GetInflictor()
	
	if ent:IsValid() and ent:IsValidLivingZombie() then
		wep:SetHitStacks(wep:GetHitStacks() + 1)
	elseif ent:IsValid() then
		wep:SetHitStacks(0)
	end
	
	if SERVER and ent:IsValidLivingZombie() and wep:GetHitStacks() >= 3 then
		wep:SetHitStacks(0)
		dmginfo:SetDamage(dmginfo:GetDamage() * 1.15)
	end
end

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end

SWEP.IsShooting = 0
function SWEP:SendWeaponAnimation()
	self.IsShooting = CurTime() + 0.006
    local dfanim = self:GetIronsights() and ACT_VM_IDLE or ACT_VM_PRIMARYATTACK
    self:SendWeaponAnim(dfanim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Angle(0, 0, 0)
local uBarrelOrigin = SWEP.VMPos
local lBarrelOrigin = Vector(0, 0, 0)
local BarAngle = Angle(0, 0, 0)

function SWEP:Think()
	if CLIENT then
		if (self.IsShooting >= CurTime()) and self:GetIronsights() then
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, Angle(2, -0, 0) )
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos, Vector(0, -9, 0) )
			self.ViewModelBoneMods[ "v_weapon.FIVESEVEN_SLIDE" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.FIVESEVEN_SLIDE" ].pos, Vector(0, 0, 8) )
		else
			self.VMAng = LerpAngle( RealFrameTime() * 8, self.VMAng, BarAngle )
			self.VMPos = LerpVector( RealFrameTime() * 8, self.VMPos,  uBarrelOrigin )
			self.ViewModelBoneMods[ "v_weapon.FIVESEVEN_SLIDE" ].pos = LerpVector( RealFrameTime() * 16, self.ViewModelBoneMods[ "v_weapon.FIVESEVEN_SLIDE" ].pos, lBarrelOrigin )
		end
	end
	self:ProcessBurstFire()
	self.BaseClass.Think(self)
end