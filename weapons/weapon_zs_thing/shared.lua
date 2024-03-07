SWEP.PrintName = "The Cringe"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 55
SWEP.MeleeDamageVsProps = 64
SWEP.MeleeReach = 100
SWEP.MeleeSize = 4

SWEP.HowlDelay = 15
SWEP.AlertDelay = 15

SWEP.BattlecryInterval = 0

local function Battlecry(pos)
	if SERVER then
		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(Vector(0,0,1))
		util.Effect("cringe_howl", effectdata, true)
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)

	if self:GetBattlecry() > CurTime() then
		if self.BattlecryInterval < CurTime() then
			self.BattlecryInterval = CurTime() + 0.25
			local owner = self:GetOwner()
			local center = owner:GetPos() + Vector(0, 0, 32)
			if SERVER then
				for _, ent in pairs(util.BlastAlloc(self, owner, center, 80)) do
					if ent:IsValidLivingZombie() and WorldVisible(ent:WorldSpaceCenter(), center)then
						ent:ApplyZombieDebuff("zombie_battlecry", 5, {Applier = owner}, true, 22)
					end
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextHowl() then return end

	local owner = self:GetOwner()
	local pos = owner:GetPos()

	owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)

	self:SetBattlecry(CurTime() + 5)


	if SERVER then
		self:ThrowMalice()
		owner:EmitSound("hl1/creatures/gon_pain3.wav")
		util.ScreenShake(pos, 5, 5, 3, 560)

		local center = owner:WorldSpaceCenter()
		timer.Simple(0, function() Battlecry(center) end)

		for _, ent in pairs(ents.FindInSphere(center, 150)) do
			if ent:IsValidLivingHuman() and WorldVisible(ent:WorldSpaceCenter(), center) then
				ent:ApplyZombieDebuff("frightened", 10, {Applier = owner}, true, 39)
			end
		end
	end
	self:SetNextHowl(CurTime() + self.HowlDelay)
	self:SetNextSecondaryFire(CurTime() + 0.5)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	self:DoAlert()
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = self.MeleeDamageVsProps
	end

	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("hl1/creatures/gon_alert"..math.random(3)..".wav")
end

SWEP.PlayAlertSound = SWEP.PlayIdleSound

function SWEP:PlayAttackSound()
	self:EmitSound("hl1/creatures/bc_attackgrowl"..math.random(3)..".wav", 60, math.random(75, 95), nil, CHAN_AUTO) 
	self:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav", 25, math.random(75, 80), nil, CHAN_AUTO) 
end

function SWEP:SetBattlecry(time)
	self:SetDTFloat(17, time)
end

function SWEP:GetBattlecry()
	return self:GetDTFloat(17)
end

function SWEP:SetNextHowl(time)
	self:SetDTFloat(16, time)
end

function SWEP:GetNextHowl()
	return self:GetDTFloat(16)
end