AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_juggernaut"))
SWEP.Description = (translate.Get("desc_juggernaut"))

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.m249"
	SWEP.HUD3DPos = Vector(1.4, -1.3, 5)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015

	function SWEP:Draw3DHUD(vm, pos, ang)
		self.BaseClass.Draw3DHUD(self, vm, pos, ang)
	
		local wid, hei = 180, 200
		local x, y = wid * -0.6, hei * -0.5
	
		cam.Start3D2D(pos, ang, self.HUD3DScale)
			local num = self:GetKillStacks()
			if num > 0 then
				draw.SimpleText("x"..num, "ZS3D2DFont2Small", x + wid/2, y + hei * 0.18, Color(255, 0, 0, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end	
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = ")weapons/m249/m249-1.wav"
SWEP.Primary.Damage = 26 --196/6.6--29.33 -- this gun is too op...
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.08

SWEP.Primary.ClipSize = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.Recoil = 3

SWEP.ConeMax = 6
SWEP.ConeMin = 2.4

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.Tier = 6
SWEP.MaxStock = 2

SWEP.ResistanceBypass = 0.7

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)

SWEP.CSSinousGraphMul = -1
SWEP.CSRecoilMul = 0.8

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.9, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.5, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1, 1)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * (self:Clip1() == 2 and 5 or 1))

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	local zeroclip = self:Clip1() == 0
	local stbl = E_GetTable(self)

	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	--[[if self.Recoil > 0 then
		local r2 = zeroclip and 1 or 0
		local r = math.Rand(0.8, 1) * r2
		owner:ViewPunch(Angle(r * -self.Recoil, r * (math.random(2) == 1 and -1 or 1) * self.Recoil, (r2 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
	end]]

	if SERVER and (self:Clip1() % 10 == 1 or zeroclip) then
		for i = 1, zeroclip and 8 or 1 do
			local ent = ents.Create("projectile_juggernaut")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Up(), 90)
				ent:SetAngles(angle)

				ent:SetOwner(owner)
				ent.ProjDamage = (self.Primary.Damage * 0.75 * (owner.ProjectileDamageMul or 1)) * (1 + (0.5 * self:GetKillStacks()))
				ent.ProjSource = self
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
	end
	
	local aimvec = owner:GetAimVector()	
	local iscs = owner.HasCsShoot
	if iscs then
		local v = self:GetCSFireParams(aimvec)
		aimvec = v
	else
		self.Recoil = zeroclip and 3 or 0
	end

	owner:LagCompensation(true)
	owner:FireBulletsLua(owner:GetShootPos(), aimvec, cone, numbul * (zeroclip and 12 or 1), self.Pierces, self.DamageTaper, dmg / (zeroclip and 1.5 or 1), nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)
	
	self:AddCSTimers()
	self:HandleVisualRecoil(stbl, iscs, owner, cone)
end

function SWEP:Deploy()
	self:SetKillStacks(0)
	self.BaseClass.Deploy(self)
	return true
end

function SWEP:SetKillStacks(stacks)
	self:SetDTInt(9, math.min(stacks, 20))
end

function SWEP:GetKillStacks()
	return self:GetDTInt(9)
end

function SWEP:OnZombieKilled(zombie)
	self:SetKillStacks(self:GetKillStacks() + 1)
end

function SWEP:FinishReload()
	self.BaseClass.FinishReload(self)
	self:SetKillStacks(0)
end

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, "M1919", "Powerful!", function(wept)
	DEFINE_BASECLASS("weapon_zs_base")
	GAMEMODE:AttachWeaponModifier(wept, WEAPON_MODIFIER_RELOAD_SPEED, 0.13, 2, 1)
	if CLIENT then
		wept.ViewModelFOV = 70

		wept.HUD3DBone = "tag_weapon"
		wept.HUD3DPos = Vector(5.8, -1.7, 2.1)
		wept.HUD3DAng = Angle(0, 270, 90)
		wept.HUD3DScale = 0.018

		wept.ResistanceBypass = 1

		local colLine = Color(200, 16, 16, 255)
		local colWhite = Color(220, 220, 220, 230)

		local function DrawHeatBar(self, x, y, wid, hei, is3d)
			local heatcolor = 1 * self:GetOverheat() * 255
			colWhite.g = heatcolor
			colWhite.b = heatcolor
			colWhite.a = 230

			local shortdiv = self:GetOverheat()
			local barheight = 20
			local bary = y + hei * 0.6
			local barshortwid = math.max(wid * shortdiv - 8, 0)

			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(x, bary, wid - 8, barheight)
			surface.SetDrawColor(1 * self:GetOverheat() * 255, 255 / self:GetOverheat() / 8, 0, 255)
			surface.DrawRect(x + 4, bary + 4, barshortwid, barheight - 8)
			surface.SetDrawColor(colLine)
			surface.DrawRect(x - 12 + wid, bary, 4, barheight)
		end

		wept.Draw3DHUD = function(self, vm, pos, ang)
			BaseClass.Draw3DHUD(self, vm, pos, ang)

			local wid, hei = 180, 64
			local x, y = wid * -0.6, hei * -1.5

			cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
				DrawHeatBar(self, x + wid * 0.25 - wid / 4, y - hei * 1, wid, hei, true)

				draw.SimpleTextBlurry("Heat", "ZS3D2DFontSmall", x + wid * 0.5, y - hei * 1, COLOR_ORANGE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end

		wept.Draw2DHUD = function(self)
			BaseClass.Draw2DHUD(self)

			local screenscale = BetterScreenScale()
			local wid, hei = 180 * screenscale, 64 * screenscale
			local x = ScrW() - wid - screenscale * 128
			local yy = ScrH() - hei * 2 - screenscale * 84

			DrawHeatBar(self, x + wid * 0.25 - wid / 4, yy + hei * 0.2, wid, hei)

			draw.SimpleTextBlurry("Heat", "ZSHUDFont", x + wid * 0.5, yy + hei * 0.45, COLOR_ORANGE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	-- Fix prediction for switch wep.
	wept.SetReloadAmmoDelay = function(self, s)
		self:SetDTFloat(8, s)
	end

	wept.GetReloadAmmoDelay = function(self)
		return self:GetDTFloat(8)
	end

	wept.SetReloadAmmoDropDown = function(self, s)
		self:SetDTFloat(9, s)
	end

	wept.GetReloadAmmoDropDown = function(self)
		return self:GetDTFloat(9)
	end

	wept.SetReloadAmmoAfterReload = function(self, s)
		self:SetDTFloat(10, s)
	end

	wept.GetReloadAmmoAfterReload = function(self)
		return self:GetDTFloat(10)
	end

	wept.SetOverheat = function(self, s)
		self:SetDTFloat(11, s)
	end

	wept.GetOverheat = function(self)
		return self:GetDTFloat(11)
	end

	wept.SetMode = function(self, s)
		self:SetDTFloat(12, s)
	end

	wept.GetMode = function(self)
		return self:GetDTFloat(12)
	end

	wept.ShowWorldModel = true
	wept.ShowViewModel = true

	wept.ViewModel = "models/weapons/c_waw_browningm1919.mdl"
	wept.WorldModel = "models/weapons/w_waw_browningm1919_a.mdl"

	wept.Primary.Sound = Sound(")weapons/waw_m1919/fire.wav")
	wept.Primary.Damage = 29
	wept.Primary.NumShots = 1
	wept.Primary.Delay = 0.08

	wept.Primary.ClipSize = 125
	wept.Primary.Automatic = true

	wept.Recoil = 0

	wept.IronSightsPos = Vector(-5.68, 1, 1.275)
	wept.IronSightsAng = Vector(0.65, -2.22, 0.8)

	wept.EmitFireSound = function(self)
		self:EmitSound(self.Primary.Sound, 140, math.random(115, 125), 1.0, CHAN_WEAPON)
	end

	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	wept.ShootBullets = function(self, dmg, numbul, cone)
		local owner = self:GetOwner()
		self:SendWeaponAnimation()
		owner:DoAttackEvent()

		if self:GetMode() == 0 then
			self:SetOverheat(self:GetOverheat() + 0.01)
			self:SetMode(1)
		end

		if self.Recoil > 0 then
			local r = math.Rand(0.8, 1)
			owner:ViewPunch(Angle(r * -self.Recoil, 0, (1 - r) * (math.random(2) == 1 and -1 or 1) * self.Recoil))
		end

		if self.PointsMultiplier then
			POINTSMULTIPLIER = self.PointsMultiplier
		end

		owner:LagCompensation(true)
		owner:FireBulletsLua(owner:GetShootPos(), owner:GetAimVector(), cone, numbul, self.Pierces, self.DamageTaper, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
		owner:LagCompensation(false)

		if self.PointsMultiplier then
			POINTSMULTIPLIER = nil
		end
	end

	wept.Think = function(self)
		self.BaseClass.Think(self)

		local owner = self:GetOwner()
		if self:GetReloadFinish() >= 1 and self:GetOverheat() >= 0.05 then
			self:SetOverheat(self:GetOverheat() - FrameTime() * 0.12)
		end

		if owner:IsHolding() or owner:GetBarricadeGhosting() or self:GetReloadFinish() >= 1 then
			self:SetNextPrimaryFire(CurTime() + 0.75)
			self:SetMode(0)
			return
		end

		if owner:KeyReleased(IN_ATTACK) and self:GetReloadFinish() == 0 then
			self:SetMode(0)
		end

		self.Primary.Delay = 0.1 - (self:GetOverheat() / 12)

		if IsValid(owner) then
			if self:GetMode() == 1 and self:Clip1() >= 1 and self:GetOverheat() <= 1 then
				self:SetOverheat(self:GetOverheat() + FrameTime() * (0.095 - (self:GetOverheat() / 60)))
			else
				if self:GetOverheat() <= 0.05 then return end
				self:SetOverheat(self:GetOverheat() - FrameTime() * 0.03 / self:GetOverheat())
			end
		end
	end

	wept.OnZombieKilled = function(self, zombie)
	end
end)
branch.Killicon = "weapon_zs_m1919"
local br = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_lmg")), (translate.Get("desc_lmg")), "weapon_zs_lmg")
br.Colors = {Color(130, 130, 240), Color(65, 65, 120), Color(39, 39, 90)}

sound.Add({
	name = 			"waw_m1919.Single",			// <-- Sound Name That gets called for
	channel = 		CHAN_STATIC,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/fire.wav"	// <-- Sound Path
})

sound.Add({
	name = 			"waw_m1919.pull",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/pull.wav"	
})

sound.Add({
	name = 			"waw_m1919.open",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/open.wav"	
})

sound.Add({
	name = 			"waw_m1919.removechain",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/removechain.wav"	
})

sound.Add({
	name = 			"waw_m1919.addchain",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/addchain.wav"	
})

sound.Add({
	name = 			"waw_m1919.close",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/close.wav"	
})

sound.Add({
	name = 			"waw_m1919.hit",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/hit.wav"	
})

sound.Add({
	name = 			"waw_m1919.chainmove",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/chainmove.wav"	
})

sound.Add({
	name = 			"waw_m1919.release",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/release.wav"	
})

sound.Add({
	name = 			"waw_m1919.deploy",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/waw_m1919/deploy.wav"	
})