AddCSLuaFile()

SWEP.PrintName = "Ghoul"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 6
SWEP.MeleeForceScale = 0.5
SWEP.SlowDownScale = 0.25
SWEP.EnfeebleDurationMul = 10 / SWEP.MeleeDamage
SWEP.MeleeDamageVsProps = 22
--[[SWEP.MeleeForceScale = 0.1
SWEP.SlowDownScale = 2.25
SWEP.SlowDownImmunityTime = 2]]

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		ent:PoisonDamage(damage * 2.5, self:GetOwner(), self, trace.HitPos)
	end
	if SERVER and ent:IsPlayer() then
		ent:ApplyZombieDebuff("enfeeble", damage * self.EnfeebleDurationMul, {Applier = self:GetOwner(), Stacks = 1}, true, 6) -- lmao
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

local Spread = {
	{0, 0},
	{-1, 0},
	{1, 0},
	{-0.5, 0},
	{0.5, 0}
}
local function DoFleshThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:ResetSpeed()
		pl.LastRangedAttack = CurTime()

		if SERVER then
			local startpos = pl:GetShootPos()
			local aimang = pl:EyeAngles()
			local ang

			for _, spr in ipairs(Spread) do
				ang = Angle(aimang.p, aimang.y, aimang.r)
				ang:RotateAroundAxis(ang:Up(), spr[1] * 5)
				ang:RotateAroundAxis(ang:Right(), spr[2] * 5)

				local ent = ents.Create("projectile_ghoulflesh")
				if ent:IsValid() then
					ent:SetPos(startpos)
					ent:SetOwner(pl)
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

	self:SetNextSecondaryFire(CurTime() + 3)
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
