AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_pulserifle"))
SWEP.Description = (translate.Get("desc_pulserifle"))

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.AbilityText = "AR2 BALL"
SWEP.AbilityColor = Color(27, 103, 133)
SWEP.AbilityMax = 1500

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "Vent"
	SWEP.HUD3DPos = Vector(1.4, 0, 0)
	SWEP.HUD3DScale = 0.03

	if not GAMEMODE.ZombieEscape then
		function SWEP:AbilityBar3D(x, y, hei, wid, col, val, max, name)
			self:DrawAbilityBar3D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
		end
		
		function SWEP:AbilityBar2D(x, y, hei, wid, col, val, max, name)
			self:DrawAbilityBar2D(x, y, hei, wid, self.AbilityColor, self:GetResource(), self.AbilityMax, self.AbilityText)
		end

		function SWEP:DefineFireMode3D()
			if self:GetFireMode() == 0 then
				return "AUTO"
			else
				return "BALL"
			end
		end
		
		function SWEP:DefineFireMode2D()
			if self:GetFireMode() == 0 then
				return "AUTO"
			else
				return "BALL"
			end
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")

SWEP.SoundPitchMin = 95
SWEP.SoundPitchMax = 100

SWEP.Primary.Sound = "weapons/airboat/airboat_gun_energy1.wav"
SWEP.Primary.Damage = 29
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = GAMEMODE.ZombieEscape and 0.15 or 0.2

SWEP.Primary.ClipSize = GAMEMODE.ZombieEscape and 40 or 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 3
SWEP.ConeMin = 1

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-3, 1, 1)

SWEP.Tier = 5

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

SWEP.TracerName = "AR2Tracer"

SWEP.FireAnimSpeed = 0.4

SWEP.HasAbility = GAMEMODE.ZombieEscape and false or true
SWEP.SetUpFireModes = 1
SWEP.CantSwitchFireModes = GAMEMODE.ZombieEscape and true or false

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 2
SWEP.LegDamage = 4
SWEP.InnateLegDamage = true

SWEP.Primary.Projectile = "projectile_ar2bomb"
SWEP.Primary.ProjVelocity = 1000

SWEP.Ar2Ball = nil

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local wep = dmginfo:GetInflictor()
	local ent = tr.Entity 

	if wep.Ar2Ball and wep.Ar2Ball:IsValid() then
		wep.SpecificCond = true
	elseif wep.Ar2Ball then
		wep.SpecificCond = false
		wep.Ar2Ball = nil
	end

	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end

	if SERVER and ent:IsValidLivingZombie() and wep:IsValid() then
		if wep:GetTumbler() and wep:GetResource() <= 0 then
			wep:SetTumbler(false) 
		elseif wep:GetResource() >= wep.AbilityMax then
			wep:SetTumbler(true)
		end
	end
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

if SERVER then
	function SWEP:ShootGrenade(damage, numshots, cone)
		local owner = self:GetOwner()
		local wep = owner:GetActiveWeapon()
		self:SendWeaponAnimation()
	
		local recoil = 8
		local r = math.Rand(0.8, 1)
		owner:ViewPunch(Angle(r * -recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * recoil))
	
		local damage = damage * 5
	
		local ent = ents.Create(self.Primary.Projectile)
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetAngles(owner:EyeAngles())
			ent:SetOwner(owner)
			ent.ProjDamage = damage * (owner.ProjectileDamageMul or 1)
			ent.ProjSource = self
			ent.Team = owner:Team()
			ent:Spawn()

			wep.Ar2Ball = ent
			wep.SpecificCond = true

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				local angle = owner:GetAimVector():Angle()
				ent.PreVel = angle:Forward() * self.Primary.ProjVelocity * (owner.ProjectileSpeedMul or 1)
				phys:SetVelocityInstantaneous(ent.PreVel)
			end
		end
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then return false end

	local stbl = E_GetTable(self)
	
	if (self:Clip1() < stbl.RequiredClip) and self:CanReload() then
		self:Reload()
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
    if not self.BaseClass.CanPrimaryAttack(self) then return end
    if self:GetFireMode() == 1 and self:GetTumbler() then

        self:SetNextPrimaryFire(CurTime() + 0.75)
		self:EmitSound("Weapon_IRifle.Single", 75, 100, 1, CHAN_WEAPON)

        if SERVER then
            self:ShootGrenade(self.Primary.Damage, self.Primary.NumShots)
        end
		self:SetResource(0)
		self:SetTumbler(false) 

        self.IdleAnimation = CurTime() + self:SequenceDuration()
    end

    if self:GetFireMode() == 1 then return end
    self.BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
	end
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:GetFireMode() == 1 and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)
end

function SWEP:CanReload()
    local clipone = (self:GetMaxClip1() > 0 and self:Clip1() < (self:GetPrimaryClipSize()) and self:ValidPrimaryAmmo() and self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) > 0)
   -- local isgl = (self:GetFireMode() == 1) and cliptwo or (self:GetFireMode() == 0) and clipone
	return self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0 and clipone
end

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.016, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 5, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.08, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_servitor")), (translate.Get("desc_servitor")), function(wept)
	wept.ConeMin = 2.25
	wept.ConeMax = 3.75
	wept.LegDamage = 1
	wept.Primary.Damage = 24
	wept.Primary.Delay = 0.15
	wept.Primary.ClipSize = 35

	wept.AbilityMax = 2800

	wept.ResistanceBypass = 0.7

	wept.OnZombieKilled = function(self)
		local killer = self:GetOwner()

		if killer:IsValid() then
			for _,v in pairs(ents.FindByClass("prop_zapper*")) do
				if v:GetObjectOwner() == killer then
					v:SetNextZap(0)
				end
			end
		end
	end
end)

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_innervator")), (translate.Get("desc_innervator")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.5
	wept.Primary.Delay = wept.Primary.Delay * 8
	wept.Primary.NumShots = 5
	wept.Primary.BurstShots = 5
	wept.ConeMax = 6.5
	wept.ConeMin = 5
	wept.Primary.ClipSize = 30
	wept.Primary.MaxDistance = 288

	wept.HasAbility = false
	wept.CantSwitchFireModes = true
	wept.SetUpFireModes = 0

	wept.ReloadSpeed = 0.33

	wept.RequiredClip = 6

	wept.Primary.Sound = "weapons/zs_inner/innershot.ogg"
	wept.ReloadSound = Sound("ambient/machines/thumper_startup1.wav")

	wept.HoldType = "shotgun"
	wept.TracerName = "tracer_volt"

	wept.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
	wept.WorldModel = "models/weapons/w_shot_xm1014.mdl"

	wept.ReloadActivity = ACT_VM_DRAW

	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end
		if self:Clip1() < 1 then return end -- no time to debug this shit

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitFireSound()

		self:TakeAmmo()
		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	wept.Think = function(self)
		BaseClass.Think(self)
		self:ProcessBurstFire(12, true)
	end

	wept.SendReloadAnimation = function(self)
		self:SendWeaponAnim(ACT_VM_DRAW)
	end

	wept.SecondaryAttack = function(self)
	end

	wept.EmitFireSound = function(self)
		self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 85, 130, 0.65)
		self:EmitSound("weapons/zs_inner/innershot.ogg", 85, 128, 0.85, CHAN_WEAPON + 20)
	end

	wept.EmitReloadSound = function(self)
		if IsFirstTimePredicted() then
			self:EmitSound("npc/scanner/combat_scan1.wav", 70, 15, 0.9, CHAN_WEAPON + 21)
			self:EmitSound("items/battery_pickup.wav", 70, 47, 0.85, CHAN_WEAPON + 22)
		end
	end


	wept.EmitReloadFinishSound = function(self)
		if IsFirstTimePredicted() then
			self:EmitSound("npc/scanner/combat_scan2.wav", 70, 135)
		end
	end

	if CLIENT then
		wept.ViewModelFlip = false
		wept.ViewModelFOV = 49

		wept.HUD3DBone = "v_weapon.xm1014_Bolt"
		wept.HUD3DPos = Vector(-1.2, -1.1, 2)
		wept.HUD3DAng = Angle(0, 0, 0)
		wept.HUD3DScale = 0.02

		wept.ViewModelBoneMods = {
			["v_weapon.xm1014_Shell"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
			["v_weapon.xm1014_Parent"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		}

		wept.VElements = {
			["laser+++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, 3, -0.601), angle = Angle(180, 0, -91), size = Vector(0.019, 0.021, 0.3), color = Color(89, 89, 97, 255), surpresslightning = false, material = "models/props/de_nuke/coolingtower", skin = 0, bodygroup = {} },
			["laser+++++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, 4.9, 0.699), angle = Angle(180, 0, -90), size = Vector(0.449, 1, 0.1), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
			["laser++++"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(-0.301, -7.5, 0.5), angle = Angle(0, 180, -120.39), size = Vector(0.129, 0.1, 0.189), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["laser++++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, 9.869, 0.699), angle = Angle(180, 0, -90), size = Vector(0.5, 1, 0.1), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
			["laser+++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, -4.901, 0.699), angle = Angle(180, 0, -90), size = Vector(0.349, 1, 0.4), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
			["laser++"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(-1, 15, 2), angle = Angle(0, 180, 90), size = Vector(0.079, 0.039, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "v_weapon.xm1014_Bolt", rel = "", pos = Vector(0, -1.601, -2.401), angle = Angle(0, 0, 90), size = Vector(0.2, 0.2, 0.2), color = Color(0, 255, 186, 255), surpresslightning = false, material = "models/props_lab/eyescanner_disp", skin = 0, bodygroup = {} },
			["laser+++"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(-0.22, 16, -0.5), angle = Angle(180, 0, 90), size = Vector(0.029, 0.059, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["laser+"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0, 16.104, 0), angle = Angle(0, 0, 0), size = Vector(0.25, 0.25, 0.2), color = Color(0, 255, 186, 255), surpresslightning = false, material = "models/props_lab/eyescanner_disp", skin = 0, bodygroup = {} },
			["laser++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "v_weapon.xm1014_Bolt", rel = "laser", pos = Vector(0.1, 3, 2.5), angle = Angle(180, 0, -90), size = Vector(0.029, 0.029, 0.449), color = Color(89, 89, 97, 255), surpresslightning = false, material = "models/props/de_nuke/coolingtower", skin = 0, bodygroup = {} }
		}

		wept.WElements = {
			["laser+++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.1, 3, -0.601), angle = Angle(180, 0, -91), size = Vector(0.019, 0.021, 0.3), color = Color(89, 89, 97, 255), surpresslightning = false, material = "models/props/de_nuke/coolingtower", skin = 0, bodygroup = {} },
			["laser++++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.1, 9.869, 0.699), angle = Angle(180, 0, -90), size = Vector(0.5, 1, 0.1), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
			["laser+++++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.1, 4.9, 0.699), angle = Angle(180, 0, -90), size = Vector(0.449, 1, 0.1), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
			["laser++++"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(-0.301, -7.5, 0.5), angle = Angle(0, 180, -120.39), size = Vector(0.129, 0.1, 0.189), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["laser+++++++"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.009, -4.901, 0.699), angle = Angle(180, 0, -90), size = Vector(0.349, 1, 0.4), color = Color(108, 118, 133, 255), surpresslightning = false, material = "models/props/de_train/fence_sheet01", skin = 0, bodygroup = {} },
			["laser+++"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(-0.22, 16, -0.5), angle = Angle(180, 0, 90), size = Vector(0.029, 0.059, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["laser+"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0, 16.104, 0), angle = Angle(0, 0, 0), size = Vector(0.25, 0.25, 0.2), color = Color(0, 255, 186, 255), surpresslightning = false, material = "models/props_lab/eyescanner_disp", skin = 0, bodygroup = {} },
			["laser++"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(-1, 15, 2), angle = Angle(0, 180, 90), size = Vector(0.079, 0.039, 0.119), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
			["laser"] = { type = "Model", model = "models/props_pipes/pipe02_straight01_long.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8, 1, -5), angle = Angle(0, 90, 10), size = Vector(0.2, 0.2, 0.2), color = Color(0, 255, 186, 255), surpresslightning = false, material = "models/props_lab/eyescanner_disp", skin = 0, bodygroup = {} },
			["laser++++++"] = { type = "Model", model = "models/props_wasteland/laundry_washer001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "laser", pos = Vector(0.1, 3, 2.5), angle = Angle(180, 0, -90), size = Vector(0.029, 0.029, 0.449), color = Color(89, 89, 97, 255), surpresslightning = false, material = "models/props/de_nuke/coolingtower", skin = 0, bodygroup = {} }
		}
		

		local ghostlerp = 0
		wept.CalcViewModelViewExtra = function(self, vm, oldpos, oldang, pos, ang)
			if self:GetOwner():GetBarricadeGhosting() or self:GetReloadFinish() > 0 then
				ghostlerp = math.min(1, ghostlerp + FrameTime() * 2)
			elseif ghostlerp > 0 then
				ghostlerp = math.max(0, ghostlerp - FrameTime() * 2.5)
			end

			if ghostlerp > 0 then
				ang:RotateAroundAxis(ang:Right(), -35 * ghostlerp)
			end

			return pos, ang
		end
	end
end)
branch.Colors = {Color(110, 160, 170), Color(90, 140, 150), Color(70, 120, 130)}
branch.NewNames = {"Focused", "Transfixed", "Orphic"}
branch.Killicon = "weapon_zs_innervator"

