DEFINE_BASECLASS("weapon_zs_base")
AddCSLuaFile()	

SWEP.PrintName = (translate.Get("wep_z9000"))	
SWEP.Description = (translate.Get("desc_z9000"))	
SWEP.Slot = 1	
SWEP.SlotPos = 0	

if CLIENT then	
	SWEP.ViewModelFlip = false	
	SWEP.ViewModelFOV = 60	

	SWEP.HUD3DBone = "smdimport"	
	SWEP.HUD3DPos = Vector(1.0, -3, 2.35)
	SWEP.HUD3DAng = Angle(-10, 180, 75)
	SWEP.HUD3DScale = 0.012	
	
	SWEP.StartCharge = 0
	
	local glowmat = Material("sprites/glow04_noz")

	function SWEP:DefineFireMode3D()
		if self:GetFireMode() == 0 then
			return "SEMI"
		elseif self:GetFireMode() == 1 then
			return "BURST"
		elseif self:GetFireMode() == 2 then
			return "CHRG"
		end
	end

	function SWEP:DefineFireMode2D()
		if self:GetFireMode() == 0 then
			return "Semi-Auto"
		elseif self:GetFireMode() == 1 then
			return "3 Round-Burst"
		elseif self:GetFireMode() == 2 then
			return "Charged Attack"
		end
	end
	
	function SWEP:DrawChargeVisual(vm)
				
		local roundmul = self:GetGunCharge()
		local start = self.StartCharge
		--local lerpmul = math.min(Lerp((CurTime() - start)/0.5, 0, 3), roundmul)
		local lerpmul = math.min((CurTime() - start) * 1/self.ChargeTime, roundmul)
		
		local bpos, bang = vm:GetBonePosition(1)
		
		local pos = bpos + bang:Right() * 5

		local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)

			for i=1, math.random(4, 5 * roundmul) do
				local heading = VectorRand()
				heading:Normalize()
				
				local power = heading * (lerpmul + 2) * 4
				
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
		
		local spritecolor = Color( 50, 50 + 100 * (lerpmul/3), 255 * (lerpmul/3))
		render.SetMaterial(glowmat)
		render.DrawSprite( pos, 2 * lerpmul, 2 * lerpmul, spritecolor)
	end
	
	function SWEP:PostDrawViewModel(vm)
		self.BaseClass.PostDrawViewModel(self, vm)
		if self:GetFireMode() == 2 and self:GetCharging() then
			self:DrawChargeVisual(vm)
		end
	end

	function SWEP:DrawAds()
		if not self:GetIronsights() then
			self.ViewModelFOV = 60
		end
	end
end	

SWEP.Base = "weapon_zs_base"	

SWEP.HoldType = "pistol"	

SWEP.ViewModel = "models/weapons/alyxgun/c_alyx_gun.mdl"	
SWEP.WorldModel = "models/weapons/alyxgun/w_alyx_gun.mdl"	
SWEP.UseHands = true	

SWEP.CSMuzzleFlashes = false	

SWEP.SoundFireVolume = 0.8
SWEP.SoundFireLevel = 79
SWEP.SoundPitchMin = 97
SWEP.SoundPitchMax = 103

SWEP.ReloadSound = Sound("weapons/alyx_gun/alyx_shotgun_cock1.wav")
SWEP.Primary.Sound = "weapons/alyxgun/alyxgun_fire_player_0"..math.random(1,6)..".wav" --"weapons/alyx_gun/alyx_gun_fire3.wav"
SWEP.Primary.Damage = 18
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 60	

SWEP.ConeMax = 2	
SWEP.ConeMin = 1.5	

SWEP.IronSightsPos = Vector(-3.775, 4, 2.115)
SWEP.IronSightsAng = Vector(0.165, 0.02, 0)

SWEP.TracerName = "AR2Tracer"	

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.25)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.25)	
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)	

SWEP.PointsMultiplier = 1.1	

SWEP.SetUpFireModes = 2

SWEP.InnateTrinket = "trinket_pulse_rounds"
SWEP.LegDamageMul = 1
SWEP.LegDamage = 1
SWEP.InnateLegDamage = true

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HasAbility = false
SWEP.CantSwitchFireModes = false
SWEP.MaxCharge = 3
SWEP.ChargeTime = 0.5
SWEP.Primary.BurstShots = 3

function SWEP:Initialize()
	BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "ambient/levels/citadel/extract_loop1.wav")
end

function SWEP:GetCone()
	return BaseClass.GetCone(self) * 1/(self:GetGunCharge() + 1)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())
	if self:GetFireMode() == 0 then
		self:RecalculateCSBurstFire(false)
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	elseif self:GetFireMode() == 1 then
		self:RecalculateCSBurstFire(true)
		self:SetNextPrimaryFire(CurTime() + self:GetFireDelay() * 3.3)
		self:SetNextShot(CurTime())
		self:SetShotsLeft(self.Primary.BurstShots)
		self:EmitFireSound()
	elseif self:GetFireMode() == 2 then
		self:RecalculateCSBurstFire(false)
		if CLIENT then
			self.StartCharge = CurTime()
		end
		self:SetShotsLeft(0)
		self:SetGunCharge(1)
		self:SetLastChargeTime(CurTime())
		self:SetCharging(true)
		self:TakeAmmo()
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
local math_random = math.random
function SWEP:EmitFireSound()
	local stbl = E_GetTable(self)

	self:EmitSound(stbl.Primary.Sound, stbl.SoundFireLevel, math_random(stbl.SoundPitchMin, stbl.SoundPitchMax), stbl.SoundFireVolume, CHAN_WEAPON)

	self:EmitSound("weapons/alyx_gun/alyx_gun_fire3.wav", 140, math_random(95, 100), 1.0, CHAN_WEAPON + 1)
end

function SWEP:Think()
	BaseClass.Think(self)
	if self:GetFireMode() == 1 then
		self:ProcessBurstFire(3)
	elseif self:GetFireMode() == 2 then
		self:ProcessCharge()
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)	
	if IsFirstTimePredicted() then	
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)	
	end	
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() and not self:GetOwner():IsHolding() and self:GetReloadFinish() == 0 then
		self:SetIronsights(true)
		if CLIENT then
			self.ViewModelFOV = 90
		end
	end
end

sound.Add({
	name = "Weapon_Alyxgun.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/pistol/handling/pistol_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_Alyxgun.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/pistol/handling/pistol_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_Alyxgun.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/pistol/handling/pistol_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_Alyxgun.Slide_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapons/pistol/handling/pistol_slide_release_01.wav"
})
