AddCSLuaFile()

SWEP.PrintName = "Noxious Ghoul"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 16
SWEP.MeleeDamageVsProps = 24
SWEP.MeleeForceScale = 0.5
SWEP.SlowDownScale = 0.25
SWEP.EnfeebleDurationMul = 10 / SWEP.MeleeDamage

if SERVER then
	function SWEP:BotAttackMode( enemy )
		local dist = enemy:GetPos():DistToSqr(self:GetOwner():GetPos())
		if not enemy:IsPlayer() or dist < 8500 then
			return 0
		elseif dist < 15000 and (not self.NextLeapTimer or self.NextLeapTimer < CurTime()) then
			self.NextLeapTimer = CurTime() + 4
			return 1
		end
	end
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		ent:PoisonDamage(damage * 2, self:GetOwner(), self, trace.HitPos)
	end
	
	if SERVER and ent:IsPlayer() then
		ent:ApplyZombieDebuff("enfeeble", damage * self.EnfeebleDurationMul, {Applier = self:GetOwner(), Stacks = 1}, true, 6)
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
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/fast_zombie/fz_alert_close1.wav", 75, math.Rand(70, 80))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(110, 130))
end

local PoisonPattern = {
	{-0.66, 0},
	{-0.33, 0},
	{0, 0},
	{0, 1},
	{0, -1},
	{0.33, 0},
	{0.66, 0},
}

local function DoFleshThrow(owner, self)
	local startpos = owner:GetShootPos()
	local aimang = owner:EyeAngles()
	local ang

	for k, spr in pairs(PoisonPattern) do
		if k == "BaseClass" then continue end

		ang = Angle(aimang.p, aimang.y, aimang.r)
		ang:RotateAroundAxis(ang:Up(), spr[1] * 12.5)
		ang:RotateAroundAxis(ang:Right(), spr[2] * 5)
		local heading = ang:Forward()

		local ent = ents.Create(k % 3 == 1 and "projectile_ghoulfleshno" or "projectile_poisonflesh")
		if ent:IsValid() then
			ent:SetPos(startpos + heading * 8)
			ent:SetOwner(owner)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocityInstantaneous(heading * 300 + owner:GetVelocity())
			end
		end
	end

	owner:EmitSound(string.format("physics/body/body_medium_break%d.wav", math.random(2, 4)), 72, math.Rand(105, 115))
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
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local SCD = self:GetNextSecondaryFire() - CurTime()
	self:SetMaxCooldown(SCD)
	self:SetCooldown(SCD)

	if SERVER then
		timer.Simple(0.7, function() DoFleshThrow(owner, self) end)
	end
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
	render.SetColorModulation(1, 1, 1)
end

local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
	render.SetColorModulation(0.9, 0.55, 0.9)
end
