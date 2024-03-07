AddCSLuaFile()

SWEP.PrintName = "Chem Destroyer"

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = Model("models/weapons/zombine/v_zombine_fix.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.MeleeDelay = 0.65
SWEP.Primary.Delay = 1.3

SWEP.MeleeDamage = 32
SWEP.Radius = 75 --^2
SWEP.Taper = 0.75
SWEP.SlowDownScale = 0

SWEP.AlertDelay = 3.5
SWEP.ResourceMul = 1
SWEP.ResCap = 500
SWEP.HasAbility = true

AccessorFuncDT(SWEP, "AnimTime", "Float", 5)

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	
	self.BaseClass.PrimaryAttack(self)

	if self:IsSwinging() then
		self:SetAnimTime(CurTime() + self.Primary.Delay * armdelay)
	end
end

function SWEP:SendAttackAnim()
	local owner = self:GetOwner()
	local armdelay = self.MeleeAnimationMul

	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	if self.SwingAnimSpeed then
		owner:GetViewModel():SetPlaybackRate(self.SwingAnimSpeed * armdelay)
	else
		owner:GetViewModel():SetPlaybackRate(1 * armdelay)
	end
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	local owner = self:GetOwner()
	local radius = self.Radius

	if not ent:IsPlayer() then
		if SERVER then
			local pos = trace.HitPos -- or ent:GetPos()???

			for _, hitent in pairs(util.BlastAlloc(self, owner, pos, radius)) do
				if hitent:IsBarricadeProp() then
					local nearest = ent:NearestPoint(pos)
					
					damage = damage * self.Taper
					hitent:TakeSpecialDamage((((radius ^ 2) - nearest:DistToSqr(pos)) / (radius ^ 2)) * damage, DMG_SLASH, owner, self)
				end
			end
		end
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
					--ent:GiveStatus("zombie_chembuff", 6)
					ent:SimpleStatus("zombie_chembuff", 6, nil, nil, true)
				end
			end
		end
		self:SetResource(0)
		self:SecondaryAttack()
	else
		self:SecondaryAttack()
	end
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("weapons/npc/zombine/zombie_voice_idle"..math.random(1, 10)..".wav", 75, math.random(70,75))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self:EmitSound("weapons/npc/zombine/zo_attack"..math.random(1, 2)..".wav", 75, math.random(75,80))
end