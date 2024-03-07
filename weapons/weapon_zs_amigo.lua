AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = (translate.Get("wep_amigo"))
SWEP.Description = (translate.Get("desc_amigo"))

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
SWEP.Primary.Damage = 20
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15

SWEP.Primary.ClipSize = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2
SWEP.ConeMin = 0.8
SWEP.HeadshotMulti = 2.1

SWEP.ReloadSpeed = 0.9

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 2
SWEP.ResistanceBypass = 0.75

SWEP.IronSightsPos = Vector(-3, 4, 1)
SWEP.IronSightsAng = Vector(0, 0, 0)

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable


GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.01, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.07)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_comrade")), (translate.Get("desc_comrade")), function(wept)
	wept.ConeMax = wept.ConeMax * 1.5
	wept.ConeMin = wept.ConeMin * 1.5
	wept.Primary.Damage = wept.Primary.Damage * 0.8
	wept.Primary.ClipSize = 35
	
	wept.OnZombieKilled = function(self, zombie, total, dmginfo)
	end

	wept.ShootBullets = function(self, dmg, numbul, cone)
		local owner = self:GetOwner()
		local iscs = owner.HasCsShoot

		self:SendWeaponAnimation()
		owner:DoAttackEvent()

		if SERVER and self:Clip1() % 10 == 1 then
			local ent = ents.Create("projectile_juggernaut")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Up(), 90)
				ent:SetAngles(angle)

				ent:SetOwner(owner)
				ent.ProjDamage = self.Primary.Damage * 3.5 * (owner.ProjectileDamageMul or 1)
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
		
		local aimvec = owner:GetAimVector()		
		if iscs and not self.NoCSRecoil then
			local v = self:GetCSFireParams(aimvec)
			aimvec = v
		end

		owner:LagCompensation(true)
		owner:FireBulletsLua(owner:GetShootPos(), aimvec, cone, numbul, self.Pierces, self.DamageTaper, dmg, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
		owner:LagCompensation(false)
		
		self:AddCSTimers()
		self:HandleVisualRecoil(self, iscs, owner, cone)
	end
end)
local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 2, (translate.Get("wep_horrizon")), (translate.Get("desc_horrizon")), function(wept)

	-- killicon.Add("weapon_zs_horizon", "zombiesurvival/killicons/weapon_zs_horizon") -- Иконку нужно прописать в cl_deathnotice

	wept.Primary.Damage = wept.Primary.Damage * 1.12
	wept.Primary.Delay = wept.Primary.Delay * 6
	wept.CSRecoilMul = 0.5
	wept.Primary.BurstShots = 3
	wept.ConeMin = wept.ConeMin * 0.6
	wept.ConeMax = wept.ConeMax * 0.85
	wept.Primary.ClipSize = 24
	wept.Primary.Sound = Sound("br_fire1")
	wept.ReloadSound = ""
	wept.ReloadSpeed = 0.85
	wept.IronSightsPos = Vector(5.015, -8, 2.52)
	wept.IronSightsAng = Vector(0, 0, 0)

	wept.ViewModel = "models/rmzs/weapons/horizon/c_br_horizon.mdl"
	wept.WorldModel = "models/rmzs/weapons/horizon/w_br_horizon.mdl"
	
	wept.OnZombieKilled = function(self, zombie, total, dmginfo)
	end

	wept.PrimaryAttack = function(self)
		if not self:CanPrimaryAttack() then return end

		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
		self:EmitFireSound()

		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end

	wept.Think = function(self)
		BaseClass.Think(self)

		self:ProcessBurstFire()
	end

	-- wept.EmitFireSound = function(self)
		-- self:EmitSound("weapons/famas/famas-1.wav", 75, math.random(80, 85), 0.8)
		-- self:EmitSound("npc/sniper/echo1.wav", 75, math.random(81, 85), 1, CHAN_WEAPON+20)
	-- end

	wept.BulletCallback = function(attacker, tr, dmginfo)		
		if SERVER then
			timer.Simple(0.1, function()
				local ent = tr.Entity
				if ent:IsValidLivingZombie() and ent:WasHitInHead() then
					local hits = rawget(PlayerIsMarked2, ent)["Hitcount"] or 0
					if hits and hits >= 3 then
						--attacker.ReaperStackValExtra = 1 -- блядь
						attacker:ApplyBountyBuff("renegadeb", 13, {Applier = attacker, Stacks = 1, Max = 2}, true, false)
						rawset(PlayerIsMarked2, ent, {})
					end

					local hitcount = rawget(PlayerIsMarked2, ent)["Hitcount"] and (rawget(PlayerIsMarked2, ent)["Hitcount"] + 1 ) or 1
					rawset(PlayerIsMarked2, ent, {Time = CurTime() + 0.25, Hitcount = hitcount})
				end
			end)
		end
	end
	
	-- wept.SendReloadAnimation = function(self) -- Полная и неполная перезарядка
		-- local checkempty = (self:Clip1() == 0) and ACT_VM_RELOAD_EMPTY or ACT_VM_RELOAD
		-- self:SendWeaponAnim(checkempty)
		-- self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.05)
	-- end
	
	wept.Reload = function(self)
		local owner = self:GetOwner()
		if owner:IsHolding() or self:GetCharging() then return end

		if self:GetIronsights() then
			self:SetIronsights(false)
		end

		local stbl = E_GetTable(self)
		-- Custom reload function to change reload speed.
		if self:CanReload() then
			stbl.IdleAnimation = CurTime() + self:SequenceDuration()
			self:SetNextReload(stbl.IdleAnimation)
			self:SetReloadStart(CurTime())

			self:SendReloadAnimation()
			self:ProcessReloadEndTime()

			owner:DoReloadEvent()

			self:EmitReloadSound()
		elseif self:GetSequenceActivityName(self:GetSequence()) != "ACT_VM_FIDGET" and self:GetReloadFinish() < CurTime() then
			self:SendWeaponAnim(ACT_VM_FIDGET)
			stbl.IdleAnimation = CurTime() + self:SequenceDuration()
		end
	end

	if CLIENT then
		wept.ViewModelFOV = 90
		wept.HUD3DBone = "safety"
		wept.HUD3DPos = Vector(-1, -0.7, 2.8)
		wept.HUD3DAng = Angle(0, -90, 80)
		wept.HUD3DScale = 0.01

		local colBG = Color(16, 16, 16, 90)
		local colRed = Color(220, 0, 0, 230)
		local colWhite = Color(220, 220, 220, 230)
		wept.Draw3DHUD = function(self, vm, pos, ang)
			local wid, hei = 180, 200
			local x, y = wid * -0.6, hei * -0.5
			local spare = self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
	
			cam.Start3D2D(pos, ang, self.HUD3DScale / 2)
				draw.RoundedBoxEx(32, x, y, wid, hei, colBG, true, false, true, false)

				draw.SimpleTextBlurry(spare, spare >= 100 and "ZS3D2DFont" or "ZS3D2DFontBig", x + wid * 0.5, y + hei * (0.5), colWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end

		wept.IronsightsMultiplier = 0.25

		wept.GetViewModelPosition = function(self, pos, ang)
			if GAMEMODE.DisableScopes then return end

			if self:IsScoped() then
				return pos + ang:Up() * 256, ang
			end

			return BaseClass.GetViewModelPosition(self, pos, ang)
		end

		wept.DrawHUDBackground = function(self)
			if GAMEMODE.DisableScopes then return end

			if self:IsScoped() then
				self:DrawRegularScope()
			end
		end
		
		---Начало прокси для индикатора патронов, встроенный в само оружие
		
		matproxy.Add( {
			name = "AMMO_COUNT",
			init = function( self, mat, values )
			self.ResultTo = values.resultvar
			self.Prefix = values.prefixstring
			end,
			bind = function( self, mat, ent )
				local Place = self.ResultTo
				local texture
				
				if LocalPlayer():GetActiveWeapon() and LocalPlayer():IsValidLivingHuman() then
					local OurWeapon = LocalPlayer():GetActiveWeapon()
					local KnowYourPlace = string.sub(string.reverse(OurWeapon:Clip1()), Place, Place)
					local digits = string.format( tonumber(KnowYourPlace) or 0 )

					texture = self.Prefix .. digits
				end
				
				if texture then
					mat:SetTexture( "$basetexture", texture )
				else end
		end
		} )
		
		--- Конец прокси
		
	end
end)

branch.Colors = {Color(110, 160, 170), Color(90, 140, 150), Color(70, 120, 130)}
branch.NewNames = {"Focused", "Transfixed", "Orphic"}
branch.Killicon = "weapon_zs_oicw"

GAMEMODE:AddNewRemantleBranch(SWEP, 3, (translate.Get("wep_infiltrator")), (translate.Get("desc_infiltrator")), "weapon_zs_infiltrator")

function SWEP.OnZombieKilled(self, zombie, total, dmginfo)
local killer = self:GetOwner()
		if SERVER and killer:IsValidLivingHuman() then
			killer:AddPoints(1)
			
			local owner = self:GetOwner()

			net.Start("zs_commission")
			net.WriteEntity(zombie)
			net.WriteEntity(activator)
			net.WriteFloat(1)
			net.Send(owner)
		end
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

sound.Add({
	name = 			"br_fire1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/horizon/br_fire.wav"
})

sound.Add(
{
    name = "h3.br_deploy",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = {"weapons/horizon/br_draw1.wav","weapons/horizon/br_draw2.wav",}
})

sound.Add(
{
    name = "h3.br_pose1",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = {"weapons/horizon/br_pose1a.wav","weapons/horizon/br_pose1b.wav","weapons/horizon/br_pose1c.wav","weapons/horizon/br_pose1d.wav",}
})

sound.Add(
{
    name = "h3.br_pose2",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = {"weapons/horizon/br_pose2a.wav","weapons/horizon/br_pose2b.wav","weapons/horizon/br_pose2c.wav",}
})

sound.Add(
{
    name = "h3.br_reload1",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = {"weapons/horizon/br_reload1-1.wav","weapons/horizon/br_reload2-1.wav","weapons/horizon/br_reload3-1.wav",}
})

sound.Add(
{
    name = "h3.br_reload2",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = {"weapons/horizon/br_reload1-2.wav","weapons/horizon/br_reload2-2.wav","weapons/horizon/br_reload3-2.wav",}
})

sound.Add(
{
    name = "h3.br_reload3",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = {"weapons/horizon/br_reload1-3.wav","weapons/horizon/br_reload2-3.wav","weapons/horizon/br_reload3-3.wav",}
})

sound.Add(
{
    name = "h3.br_melee1",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = {"weapons/horizon/br_melee1a.wav", "weapons/horizon/br_melee1b.wav","h3/br_melee1c.wav",}
})

sound.Add(
{
    name = "h3.br_melee2",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = 80,
    sound = {"h3/br_melee2a.wav","h3/br_melee2b.wav","h3/br_melee2c.wav",}
})