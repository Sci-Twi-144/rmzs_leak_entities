AddCSLuaFile()

SWEP.PrintName = "Katana"

if CLIENT then

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	--SWEP.ShowViewModel = false
--	SWEP.ShowWorldModel = false
end

SWEP.Base = "weapon_zs_basemelee"
SWEP.HoldType = "melee2"

SWEP.ViewModel = "models/weapons/c_katana.mdl"
SWEP.WorldModel = "models/weapons/w_katana.mdl"
SWEP.UseHands = true

SWEP.SwingTime = 0
SWEP.SwingRotation = Angle(0, -20, -40)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee"
SWEP.HitDecal = "Manhackcut"
SWEP.MeleeDamage = 80
SWEP.MeleeRange = 65
SWEP.MeleeSize = 2

SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.BlockRotation = Angle(0, 15, -40)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.1
SWEP.BlockReduction = 11
SWEP.StaminaConsumption = 2

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.125)
function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(4)..".wav")
end

SWEP.NextSurge = 0
SWEP.Surging = false

function SWEP:Think()
	self.BaseClass.Think(self)
	
	if SERVER then
		self:SubThink()
	end
end
--if SERVER then
function SWEP:SubThink()
	local owner = self:GetOwner()
	if self.Surging then
	--	print("sex")
		if self.SurgePos and self.SurgePos:Distance(owner:GetPos()) > 36 then
			
			if owner and owner:IsValid() then
				owner:SetLocalVelocity(owner:GetVelocity() * 0.1)
				owner:ResetSpeed()
			end
			self.Surging = false
			self.SurgePos = nil
		end
	end

	if owner:KeyPressed(IN_SPEED) and owner:OnGround() then
		if owner:KeyDown(IN_MOVERIGHT) then
			self:PerformDodge(owner:GetRight(), 1300) 
		elseif owner:KeyDown(IN_MOVELEFT) then
			self:PerformDodge(owner:GetRight(), -1300) 
		elseif owner:KeyDown(IN_BACK) then
			self:PerformDodge(owner:GetForward(), -1300) 
		elseif owner:KeyDown(IN_FORWARD) then
			self:PerformDodge(owner:GetForward(), 1300) 
		end
	end
end

function SWEP:PerformDodge(dir, force)
	local owner = self:GetOwner()
	if (owner:GetStamina() < 10) then return end
	if not owner:GetGroundEntity():IsValid() and not owner:GetGroundEntity():IsWorld() or owner:GetBarricadeGhosting() then return end

	self.NextSurge = CurTime() + 1

	owner:TakeStamina(10, 5)
	local ang = owner:GetAimVector()
	ang.z = 0

	if (owner:GetGroundEntity():IsValid() or owner:GetGroundEntity():IsWorld() or owner:WaterLevel() > 0) then
		local dir = dir or owner:GetForward()
		local force = force or 2500
		self.SurgePos = owner:GetPos()
		owner:SetLocalVelocity(dir * force)
		self.Surging = true
	end
end
--end