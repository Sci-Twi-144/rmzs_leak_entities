AddCSLuaFile()

SWEP.PrintName = "Alpha Ghoul"

SWEP.Base = "weapon_zs_zombie"

if CLIENT then
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource(), self.ResCap, col, "Throwable Rate", false, true, false)
	end
end

SWEP.MeleeDamage = 23
SWEP.MeleeForceScale = 0.5
SWEP.SlowDownScale = 0.25
SWEP.EnfeebleDurationMul = 10 / SWEP.MeleeDamage
SWEP.PosionDamage = 5
SWEP.ResourceMul = 1
SWEP.ResCap = 300
SWEP.HasAbility = true
SWEP.MeleeDamageVsProps = 23
--[[SWEP.MeleeForceScale = 0.1
SWEP.SlowDownScale = 2.25
SWEP.SlowDownImmunityTime = 2]]

function SWEP:ApplyMeleeDamage(ent, trace, damage)

	if SERVER and ent:IsPlayer() then
		ent:PoisonDamage(damage, self:GetOwner(), self, trace.HitPos)
		ent:TakeStamina(damage * 0.33, 4)
		ent:ApplyZombieDebuff("enfeeble", damage * self.EnfeebleDurationMul, {Applier = self:GetOwner(), Stacks = 3}, true, 6)
		ent:ApplyZombieDebuff("sickness", damage * self.EnfeebleDurationMul, {Applier = self:GetOwner()}, true, 12)
	end
	
self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = self.MeleeDamageVsProps
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if (self:GetResource() >= self.ResCap) then
		local center = owner:GetPos() + Vector(0, 0, 32)
		if SERVER then
			for _, ent in pairs(util.BlastAlloc(self, owner, center, 150)) do
				if ent:IsValidLivingZombie() and WorldVisible(ent:WorldSpaceCenter(), center) then
					--ent:GiveStatus("zombie_poisonbuff", 10)
					ent:SimpleStatus("zombie_poisonbuff", 10, nil, nil, true)
				end
			end
		end
		self:SetResource(0)
		self.BaseClass.SecondaryAttack(self)
	else
		self.BaseClass.SecondaryAttack(self)
	end
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/fast_zombie/fz_alert_close1.wav", 75, math.Rand(70, 80))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(110, 130))
end

local Spread = {
	{0, 0},
	{-1, 0},
	{1, 0},
	{-0.5, 0},
	{0.5, 0}
}

if SERVER then
	function SWEP:BotAttackMode( enemy )
		local dist = enemy:GetPos():DistToSqr(self:GetOwner():GetPos())
		if not enemy:IsPlayer() or dist<10000 then -- Square(100)
			return 0
		elseif (self:GetResource() >= self.ResCap) then
			return 2 
		end
	end
end

local function DoFleshThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:ResetSpeed()
		pl.LastRangedAttack = CurTime()

		if SERVER then
			local startpos = pl:GetShootPos()
			local aimang = pl:EyeAngles()
			local ang

			for _, spr in pairs(Spread) do
				ang = Angle(aimang.p, aimang.y, aimang.r)
				ang:RotateAroundAxis(ang:Up(), spr[1] * 5)
				ang:RotateAroundAxis(ang:Right(), spr[2] * 5)

				local ent = ents.Create("projectile_ghoulflesh_a")
				if ent:IsValid() then
					ent:SetPos(startpos)
					ent:SetOwner(pl)
					ent.Damage = wep.PosionDamage
					ent:Spawn()

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:SetVelocityInstantaneous(ang:Forward() * 460 + pl:GetVelocity())
					end
				end
			end

			pl:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.Rand(85, 95))
		end
	end
end

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or IsValid(FeignDeath[owner]) then return end
	
	local div = (owner.PoisonBuffZombie and owner.PoisonBuffZombie.DieTime >= CurTime() and 0.5) or 1
	
	self:SetNextSecondaryFire(CurTime() + 3 * div)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:GetOwner():DoZombieEvent()
	self:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(110, 130))
	self:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.Rand(85, 95))
	--self:GetOwner():RawCapLegDamage(CurTime() + 3)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	
	local SCD = self:GetNextSecondaryFire() - CurTime()
	self:SetMaxCooldown(SCD)
	self:SetCooldown(SCD)
	
	timer.Simple(0.7, function() DoFleshThrow(owner, self) end)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
