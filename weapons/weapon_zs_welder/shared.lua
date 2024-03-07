SWEP.Base = "weapon_zs_base"

SWEP.PrintName = (translate.Get("wep_welder"))
SWEP.Description = (translate.Get("desc_welder"))
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.HoldType = "pistol"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Repair = 15
SWEP.RepairRange = 256
SWEP.HealStrength = 1.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.4
SWEP.Primary.ClipSize = -1 -- yes, it's zero lul
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 30

SWEP.ConeMax = -1
SWEP.ConeMin = -1

SWEP.NextEmmit = 0.1

SWEP.Tier = 4
SWEP.MaxStock = 3

SWEP.AllowQualityWeapons = true

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.033)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_REPAIRRANGE, 256, 1)

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "weapons/zs_gluon/beamloop.wav")
end

function SWEP:Holster()
	self.ChargeSound:Stop()

	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self.ChargeSound:Stop()
end

function SWEP:GetPrimaryAmmoCountNoClip()
	return self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
end

function SWEP:CanPrimaryAttack()
	return self:GetNextPrimaryFire() <= CurTime() and self:GetPrimaryAmmoCountNoClip() >= 1
end

function SWEP:Think()
	self.BaseClass.Think(self)

	if self:GetOwner():KeyReleased(IN_ATTACK) then
		self.ChargeSound:Stop()
	end	
end

function SWEP:PlayRepairSound(hitent)
	hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end
	
	local owner = self:GetOwner()
	local shootpos = self:GetOwner():GetEyeTrace()	
	local tr = owner:CompensatedMeleeTrace(self.RepairRange, 1, nil, nil, false, true)
	local ent = tr.Entity
	if tr.Hit and ent and ent:IsValid() and ((ent:IsPlayer() and ent:Team() == TEAM_UNDEAD) 
	or (not ent:IsWorld() and ent:IsNailed() and ent:GetBarricadeHealth() < ent:GetMaxBarricadeHealth() and ent:GetBarricadeRepairs() > 0) 
	or (ent.GetObjectHealth and ent:GetObjectHealth() < ent:GetMaxObjectHealth() 
	and not (ent.m_LastDamaged and CurTime() < ent.m_LastDamaged + 4) and not (ent.HitByWrench and ent:HitByWrench(self, owner, tr)))) then 

		self.ChargeSound:PlayEx(0.3, 120)

		local effectdata = EffectData()
		effectdata:SetFlags(3)
		effectdata:SetOrigin(ent:WorldSpaceCenter())
		effectdata:SetEntity(self)
		effectdata:SetAttachment(1)
		util.Effect("tracer_repairray", effectdata)
		
		if SERVER then
			self:DoShit()
		end
		self.ChargeSound:PlayEx(0.3, 120)
	else
		self.ChargeSound:Stop()
	end	

	if SERVER then 
		self:DoShitAgain()
	end

	self:SetNextPrimaryFire(CurTime() + 0.1)
end

function SWEP:Reload()
end

function SWEP:ShouldTakeAmmo(num)
	self:TakePrimaryAmmo(num)
end

function SWEP:SecondaryAttack()
end