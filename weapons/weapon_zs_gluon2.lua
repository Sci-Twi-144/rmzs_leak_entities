AddCSLuaFile()

if CLIENT then
	SWEP.NextEmit = 0

	SWEP.Slot = 3
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 83
	
	SWEP.VMPos = Vector(0.8, -2, -1)
	SWEP.VMAng = Vector(0, 0, 0)
	
	SWEP.HUD3DPos = Vector(8, -5.5, -2)
	SWEP.HUD3DAng = Angle(90, 0, 0)
	SWEP.HUD3DScale = 0.04
	SWEP.HUD3DBone = "Egon_Root"
	
	local colBG = Color(16, 16, 16, 90)
	local colWhite = Color(220, 220, 220, 230)
	local colRed = Color(255, 0, 0, 230)

	function SWEP:Draw2DHUD()
		local screenscale = BetterScreenScale()

		local wid, hei = 230 * screenscale, 60 * screenscale
		local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 90
		local spare = self:GetPrimaryAmmoCount()

		local longdiv = self:GetFireCoolDown()
		local textheight = 30
		local texty = y + hei * 1
		local textlongwid = math.max(wid * longdiv - 8, 0)


		surface.SetDrawColor(16, 16, 16, 255)
		surface.DrawRect(x, texty, wid, textheight)
		surface.SetDrawColor(1 * self:GetFireCoolDown() * 255, 255 / self:GetFireCoolDown() / 8, 0, 255)
		surface.DrawRect(x, texty, textlongwid, textheight)

		if self:GetGunMode() == 2 then
			draw.SimpleText("COOLDOWN", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, Color(255 * math.abs(math.sin(RealTime() * 6)) * 0.6,255 * math.abs(math.sin(RealTime() * 6)) * 0.6,255 * math.abs(math.sin(RealTime() * 6)) * 0.6), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		draw.RoundedBox(0, x, y, wid, hei, colBG)
		draw.SimpleTextBlurry(spare, spare >= 100 and "ZS3D2DFontSmall" or "ZS3D2DFontSmall", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function SWEP:Draw3DHUD(vm, pos, ang)
		local wid, hei = 220, 60
		local x, y = wid * -0.6, hei * -0.6
		local spare = self:GetPrimaryAmmoCount()

		cam.Start3D2D(pos, ang, self.HUD3DScale / 2)

			local longdiv = self:GetFireCoolDown()
			local textheight = 30
			local texty = y + hei * 1
			local textlongwid = math.max(wid * longdiv - 8, 0)

			surface.SetDrawColor(16, 16, 16, 255)
			surface.DrawRect(x, texty, wid, textheight)
			surface.SetDrawColor(1 * self:GetFireCoolDown() * 255, 255 / self:GetFireCoolDown() / 8, 0, 255)
			surface.DrawRect(x, texty, textlongwid, textheight)

			if self:GetGunMode() == 2 then
				draw.SimpleText("COOLDOWN", "ZSHUDFontSmall", x + wid/2, texty + hei * 0.3, Color(255 * math.abs(math.sin(RealTime() * 6)) * 0.6,255 * math.abs(math.sin(RealTime() * 6)) * 0.6,255 * math.abs(math.sin(RealTime() * 6)) * 0.6), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			draw.RoundedBoxEx(0, x, y, wid, hei, colBG, true, false, true, false)
			draw.SimpleText(spare, spare >= 100 and "ZS3D2DFont" or "ZS3D2DFont", x + wid * 0.5, y + hei * 0.5, spare == 0 and colRed or colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end
end

SWEP.PrintName = (translate.Get("wep_gluon"))
SWEP.Description = (translate.Get("desc_gluon"))
SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "physgun"

SWEP.ViewModel = "models/weapons/c_egon.mdl"
SWEP.WorldModel = "models/weapons/w_egon.mdl"
SWEP.UseHands		= true
SWEP.ShowWorldModel	= true

SWEP.Primary.Sound = Sound("")
SWEP.Primary.Damage = 22
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09  --0.06  0.0667
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.MaxDistance = 896
SWEP.MaxStock = 2
SWEP.Tier = 6

SWEP.TracerName = "egon_tracer"

SWEP.ConeMax = 0.001
SWEP.ConeMin = 0.001

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.IronSightsPos = Vector(-2, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.CoolDownSpeed = 0.3
SWEP.HeatFactor = 0.17
SWEP.HeatBuildShort = SWEP.HeatFactor

SWEP.NoCSRecoil = true

SWEP.DamagedEnt = {}

SWEP.ResistanceBypass = 0

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_hades")), (translate.Get("desc_hades")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 10.5/12.5
	wept.InnateTrinket = "trinket_pulse_rounds"
	wept.ForceInnateEffect = true
    wept.LegDamageMul = 3
	wept.LegDamage = 3
	wept.InnateLegDamage = true
end)
branch.Colors = {Color(150, 110, 180), Color(130, 90, 160), Color(110, 60, 150)}
branch.NewNames = {"Deep", "Null", "Void"}

local branch2 = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_muon")), (translate.Get("desc_muon")), function(wept)
	wept.Primary.Ammo = "chemical"
	wept.Primary.Damage = 22
	wept.HeatFactor = 0.2
	wept.GluonDamage = function(self)
		return wept.Primary.Damage + (wept.Primary.Damage * (self:GetFireCoolDown() * 0.6))
	end
	wept.Primary.MaxDistance = 512
end)

function SWEP:Initialize()
	self.FiringSound = CreateSound(self, "weapons/gluon/special1.wav")
	self.FiringSound:SetSoundLevel(85)
	self.BaseClass.Initialize(self)
end

function SWEP:Reload()
end

function SWEP:Deploy()
	local holstertime = CurTime() - self:GetLastHolstered()
	if self:GetFireCoolDown() > 0 then
		local heatpoints = holstertime * self.CoolDownSpeed
		self:SetFireCoolDown(math.max(self:GetFireCoolDown() - heatpoints, 0))
		if self:GetGunMode() == 1 and self:GetFireCoolDown() <= 0.25 then
			self:SetGunMode(0)
		end
	end
	self.BaseClass.Deploy(self)	
	return true
end

if CLIENT then
	function SWEP:GetMuzzlePos( weapon, attachment )
		if not IsValid(weapon) then return end

		local origin = weapon:GetPos()
		local angle = weapon:GetAngles()

		if weapon:IsWeapon() and weapon:IsCarriedByLocalPlayer() then
			if IsValid(weapon:GetOwner()) and GetViewEntity() == weapon:GetOwner() then
				local viewmodel = weapon:GetOwner():GetViewModel()
				if IsValid(viewmodel) then
					weapon = viewmodel
				end
			end
		end
		
		local attachment = weapon:GetAttachment(1)
		return attachment.Pos  + Vector(0,0,10), attachment.Ang
	end
end

function SWEP:GluonDamage()
	return self.Primary.Damage
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self:GetPrimaryAmmoCount() < 2 then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local cooldown = self:GetCooldown()
	if cooldown then
		self:TakeCombinedPrimaryAmmo(1)
	end
	self:SetCooldown(not cooldown)

	self:ShootBullets(self:GluonDamage(), self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	
	if self:GetGunMode() ~= 1 then
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK)
		if IsFirstTimePredicted() then
			if CLIENT then
				local trStart = self:GetMuzzlePos( self, 1 )
				util.ScreenShake( trStart, 5, 5, 0.6, 512 ) -- Start Shake when it's first shot.
			end
		end
		self:SetGunMode(1)
	end
end

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoCount() < 2 then return end

	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end
	
	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
end

function SWEP:OnRemove()
	self.FiringSound:Stop()
end

function SWEP:Holster()
	self:SetLastHolstered(CurTime())
	self.FiringSound:Stop()
	self.BaseClass.Holster(self)
	return true
end

function SWEP:SetGunMode(mode)
	self:SetDTInt(1, mode)
end

function SWEP:GetGunMode(mode)
	return self:GetDTInt(1)
end

function SWEP:SetCooldown(usage)
	self:SetDTBool(1, usage)
end

function SWEP:GetCooldown()
	return self:GetDTBool(1)
end

function SWEP:SetFireCoolDown(heat)
	self:SetDTFloat(9, heat)
end

function SWEP:GetFireCoolDown()
	return self:GetDTFloat(9)
end

function SWEP:SendWeaponAnimation()
end

function SWEP:Think()
	self.BaseClass.Think(self)

	local ReachFullCooldown = self:GetFireCoolDown() >= 1
	if self:GetGunMode() == 1 and CurTime() >= self:GetNextPrimaryFire() + 0.1 or ReachFullCooldown then
		self:EmitSound("weapons/gluon/special2.ogg")
		self:SendWeaponAnim(ACT_VM_IDLE)
		self:SetGunMode(ReachFullCooldown and 2 or 0)
		self:SetNextPrimaryFire(CurTime() + 0.25)
	end

	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		local frametime = FrameTime()
		if self:GetGunMode() == 1 then
			self.FiringSound:PlayEx(1, 100 + CurTime() % 1)
			self:SetFireCoolDown(math.min(self:GetFireCoolDown() + frametime * self.HeatFactor, 1))
		elseif self:GetGunMode() == 2 then
			self.FiringSound:Stop()
			self:SetFireCoolDown(math.max(self:GetFireCoolDown() - frametime * self.CoolDownSpeed, 0))
			self:SetNextPrimaryFire(CurTime() + 0.1)

			if self:GetFireCoolDown() <= 0.25 then
				self:SetGunMode(0)
			end
		else
			self.FiringSound:Stop()
			self:SetFireCoolDown(math.max(self:GetFireCoolDown() - frametime * self.HeatFactor, 0))
		end
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	dmginfo:SetDamageType(DMG_DISSOLVE)
	if ent:IsValidLivingZombie() then
		local wep = dmginfo:GetInflictor()
		local abovedelay = wep.Primary.Delay * 0.7 * (attacker.AbilityCharge or 1)
		if not wep.DamagedEnt[ent] then
			wep.DamagedEnt[ent] = {CurTime() + 1, abovedelay}
		elseif wep.DamagedEnt[ent] then
			if wep.DamagedEnt[ent][1] < CurTime() then
				wep.DamagedEnt[ent] = {CurTime() + 1, abovedelay}
			else
				local timefaloff = wep.DamagedEnt[ent][1] - CurTime()
				dmginfo:SetDamage(dmginfo:GetDamage() + wep.Primary.Damage * wep.DamagedEnt[ent][2] * timefaloff)
				wep.DamagedEnt[ent][1] = CurTime() + 1
				wep.DamagedEnt[ent][2] = math.min((wep.DamagedEnt[ent][2] + abovedelay), 2)
			end			
		end
	end
	

	local e = EffectData()
	e:SetOrigin(tr.HitPos)
	e:SetMagnitude(1)
	e:SetScale(1)
	util.Effect("hit_egon", e)

	return {impact=false,ragdoll_impact=false}
end

function SWEP:SetLastHolstered(timer)
	self:SetDTFloat(15, timer)
end

function SWEP:GetLastHolstered()
	return self:GetDTFloat(15)
end