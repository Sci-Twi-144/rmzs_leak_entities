AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_waraxe"))
SWEP.Description = (translate.Get("desc_waraxe"))
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "slide"
	SWEP.HUD3DScale = 0.015
	SWEP.HUD3DPos = Vector(1.55, 0.25, 0.1)
	SWEP.HUD3DAng = Angle(0, 180, 90)
	SWEP.VMPos = Vector(0, -5, 1)
	SWEP.VMAng = Vector(0, 0, 0)
	
	SWEP.StartCharge = 0
	
	local glowmat = Material("sprites/glow04_noz")
	
	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "SEMI"
		elseif self:GetFireMode() == 1 then
			return "CHRG"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Semi-Auto"
		elseif self:GetFireMode() == 1 then
			return "Charged Attack"
		end
	end
	
	function SWEP:DrawChargeVisual(vm)
				
		local roundmul = self:GetGunCharge()
		local start = self.StartCharge
		--local lerpmul = math.min(Lerp((CurTime() - start)/0.5, 0, 3), roundmul)
		local lerpmul = math.min((CurTime() - start) * 1/self.ChargeTime, roundmul)
		
		local bpos, bang = vm:GetBonePosition(3)
		
		local pos = bpos + bang:Right() * 10

		local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)

			for i=1, math.random(4, 5 * roundmul) do
				local heading = VectorRand()
				heading:Normalize()
				
				local power = heading * (lerpmul + 2) * 2.5
				
				local gravector = (pos - (pos + power))--:GetNormalized()

				local particle = emitter:Add("sprites/glow04_noz", pos + power)
				particle:SetVelocity(0 * power)
				particle:SetDieTime(math.Rand(0.2, 0.3))
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(20)
				particle:SetStartSize(math.Rand(1, 2))
				particle:SetEndSize(0.2)
				particle:SetStartLength(1)
				particle:SetEndLength(10)
				particle:SetColor(100, 100, 255)
				
				particle:SetNextThink( CurTime() )
				particle:SetThinkFunction( function( pa )
					local factor = (pa:GetDieTime() - CurTime())/pa:GetLifeTime()
					local tcaf = 1 - factor
					pa:SetColor(50, 50 + 50 * factor , 150 + 100 * factor)
					pa:SetNextThink( CurTime() )
				end )
				
				particle:SetGravity(gravector * 1)
				particle:SetAirResistance(100)
			end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
		
		local spritecolor = Color( 50, 50 + 100 * (lerpmul/self.MaxCharge), 255 * (lerpmul/self.MaxCharge))
		render.SetMaterial(glowmat)
		render.DrawSprite( pos, 1 * lerpmul, 1 * lerpmul, spritecolor)
	end
	
	function SWEP:PostDrawViewModel(vm)
		self.BaseClass.PostDrawViewModel(self, vm)
		if self:GetFireMode() == 1 and self:GetCharging() then
			self:DrawChargeVisual(vm)
		end
	end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/rmzs/weapons/ez2/c_gausspistol_u1.mdl"
SWEP.WorldModel = "models/rmzs/weapons/ez2/w_gausspistol_u1.mdl"
SWEP.UseHands = true

SWEP.Primary.Damage = 13.85
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 15
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.Sound = Sound("Weapon_PulsePistol.Fire")
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 1
SWEP.Tier = 2

SWEP.TracerName = "AR2Tracer"

SWEP.ConeMax = 3.5
SWEP.ConeMin = 1.8

SWEP.IronSightsPos = Vector(-3.6, 1.2, 1)
SWEP.IronSightsAng = Angle(0,0,4.7)

SWEP.PointsMultiplier = 1.1	

SWEP.SetUpFireModes = 1

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 1
SWEP.LegDamage = 1
SWEP.InnateLegDamage = true

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HasAbility = false
SWEP.CantSwitchFireModes = false
SWEP.MaxCharge = 15
SWEP.ChargeTime = SWEP.Primary.Delay * 0.5
SWEP.FirstDraw = true
SWEP.ClassicSpread = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEADSHOT_MULTI, 0.07)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.625)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.02, 1)

--[[
GAMEMODE:AddNewRemantleBranch(SWEP, 1, (translate.Get("wep_halberd")), (translate.Get("desc_halberd")), function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.85

	wept.BulletCallback = function(attacker, tr, dmginfo)
		if SERVER then
			local hitent = tr.Entity
			if hitent:IsValidLivingZombie() and hitent:Health() == hitent:GetMaxHealthEx() and gamemode.Call("PlayerShouldTakeDamage", hitent, attacker) then
				hitent:TakeSpecialDamage(hitent:Health() * 0.1, DMG_DIRECT, attacker, attacker:GetActiveWeapon(), tr.HitPos)
			end
		end
	end
end)
]]

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "weapons/pulsepistol/pulse_pistol_charging.wav")
end

function SWEP:GetCone()
	local chargemode = (self:GetFireMode() == 1)
	local cscone = self:GetOwner().HasCsShoot and ((1 + self:GetCSRecoil() * 4) * 0.2 * 0.3) or 1
	local chargecone = self:GetOwner().HasCsShoot and ((1 + self:GetCSRecoil() * 4) * 0.7) or 1
	local totaldiff = chargemode and 1 / cscone * chargecone or 1
	return self.BaseClass.GetCone(self) * totaldiff * (1 +  self:GetGunCharge() * 0.15)
end

function SWEP:Deploy()
	if self.FirstDraw then
		self:SendWeaponAnim(self.FirstDraw and ACT_VM_PICKUP or ACT_VM_DRAW)
		self.FirstDraw = false
	end
	self.BaseClass.Deploy(self)
	return true
end


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self.MaxCharge = math.floor(self:GetPrimaryClipSize() * 0.334)
	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	if self:GetFireMode() == 0 then
		self:EmitFireSound()
		self:TakeAmmo()
		self.SpreadPattern = nil
		self.ClassicSpread = true
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	elseif self:GetFireMode() == 1 then
		self:SetShotsLeft(0)
		self:SetGunCharge(1)
		self:SetLastChargeTime(CurTime())
		self:SetCharging(true)
		self:TakeAmmo()
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()
	--[[for a, b in pairs(self:GetSequenceList()) do
		print(self:GetSequenceActivityName(a))
	end]]
	self.BaseClass.SecondaryAttack(self)
	self.IdleActivity = self:GetIronsights() and ACT_VM_SWINGMISS or ACT_VM_IDLE
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if self:GetFireMode() == 1 then
		self:ProcessCharge()
	end
end

function SWEP:ProcessCharge()
	if self:GetCharging() then
		if not self:GetOwner():KeyDown(IN_ATTACK) then
			self:EmitFireSound()
			
			if self:GetGunCharge() > 1 then
				self.SpreadPattern = self:GeneratePattern("circle", self.Primary.NumShots * self:GetGunCharge())
				self.ClassicSpread = false
			else
				self.SpreadPattern = nil
				self.ClassicSpread = true
			end
			
			self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * self:GetGunCharge(), self:GetCone())
			self.IdleAnimation = CurTime() + self:SequenceDuration()

			self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
			self:SetCharging(false)
			self:SetLastChargeTime(CurTime())
			self:SetGunCharge(0)
			self.SpreadPattern = nil
			self.ClassicSpread = true
		elseif self:GetGunCharge() < self.MaxCharge and self:Clip1() ~= 0 and self:GetLastChargeTime() + self.ChargeTime < CurTime() then
			self:SetGunCharge(self:GetGunCharge() + 1)
			self:SetLastChargeTime(CurTime())
			self:TakeAmmo()
		end
		--self.ChargeSound:PlayEx(1, math.min(255, 165 + self:GetGunCharge() * 18))
		self.ChargeSound:PlayEx(2,255 - self:GetPrimaryClipSize() * 8)
	else
		self.ChargeSound:Stop()
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)	
	local ent = tr.Entity
	local wep = dmginfo:GetInflictor()
	if IsFirstTimePredicted() then	
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)	
	end	
	-- if SERVER then -- Так как при фулл чарже будет несколько трейсеров, и каждая вызывает эту функцию, может произойти такое, что статус шок наложиться несколько раз
		-- local ent = tr.Entity
		-- if ent:IsValidLivingZombie() and wep:GetGunCharge() >= wep.MaxCharge then
			-- ent:ApplyZombieDebuff("shockdebuff", 4 , {Applier = attacker}, true, 38)
		-- end
	-- end
end

sound.Add({
	name = 			"Weapon_PulsePistol.Fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/pulsepistol/pistol_fire3.wav"
})

sound.Add({
	name = 			"Weapon_PulsePistol.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pulsepistol/pistol_clipout.wav"	
})

sound.Add({
	name = 			"Weapon_PulsePistol.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pulsepistol/pistol_clipin.wav"	
})

sound.Add({
	name = 			"Weapon_PulsePistol.SlideForward",
	channel = 		CHAN_ITEM2,
	volume = 		1.0,
	sound = 			"weapons/pulsepistol/pulse_pistol_slideforward.wav"	
})

sound.Add({
	name = 			"Weapon_PulsePistol.Reload",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pulsepistol/pulse_pistol_working.wav"	
})

sound.Add({
	name = 			"Weapon_PulsePistol.Charge",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pulsepistol/pulse_pistol_charging.wav"	
})