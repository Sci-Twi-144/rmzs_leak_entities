--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
DEFINE_BASECLASS("status__base")

ENT.NextHeal = 0
ENT.NextDamageSet = 0
ENT.DamageTaken = 0

function ENT:OnInitialize()
	self:CreateHook()
end

function ENT:CreateHook()
	local ent = self
	local ENTC = tostring(ent)

end
--[[models/props_phx/construct/metal_plate_curve2x2.mdl -- base
	models/props_phx/construct/metal_dome360.mdl

	models/hunter/triangles/1x1x2carved025.mdl
	models/hunter/triangles/1x1x2carved.mdl

	models/hunter/tubes/tube2x2x2c.mdl

	models/hunter/tubes/circle2x2.mdl
	]]
function ENT:Initialize()
	BaseClass.Initialize(self)
	self.NextDeflect = 0

	self:SetModel("models/props_phx/construct/metal_plate_curve2x2.mdl")
	self:DrawShadow(false)
	self:SetCustomCollisionCheck(true)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_FORCEFIELD, ZS_COLLISIONFLAGS_SHADESHIELD)

	timer.Simple(0, function()

	self:SetMaxObjectHealth(GAMEMODE:CalcMaxShieldHealth(self:GetOwner()) * 2)
	self:SetObjectHealth(self:GetMaxObjectHealth() * 2)
	end)
end

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.ShadeShield = self
	pPlayer:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

	self:SetParent(nil)
	self:SetPos(pPlayer:GetPos())

	local angs = pPlayer:GetAngles()
	angs:RotateAroundAxis(self:GetUp(), 135)
	self:SetAngles(angs)
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	local owner = self:GetOwner()

	if attacker:IsValidLivingHuman() then
		if self.NextDeflect and self.NextDeflect < CurTime() then
			local center = self:LocalToWorld(self:OBBCenter())
			local hitpos = self:NearestPoint(dmginfo:GetDamagePosition())
			local effectdata = EffectData()
				effectdata:SetOrigin(center)
				effectdata:SetStart(self:WorldToLocal(hitpos))
				effectdata:SetAngles((center - hitpos):Angle())
				effectdata:SetEntity(self)
			util.Effect("shadedeflect", effectdata, true, true)

			owner:TakeSpecialDamage(1, DMG_GENERIC, attacker, self, owner:WorldSpaceCenter())

			self.NextDeflect = CurTime() + 0.1
		end

		local damagetaken = math.min(self.DamageTaken + dmginfo:GetDamage(), 150)
		local diff = damagetaken - self.DamageTaken
		self.DamageTaken = self.DamageTaken + diff
		self:SetObjectHealth(self:GetObjectHealth() - diff)

		if attacker:IsValidLivingHuman() then
			local points = dmginfo:GetDamage() / owner:GetMaxHealth() * (owner:GetZombiePointGain() / 2)
			rawset(PointQueue, attacker, rawget(PointQueue, attacker) + points)
		end

		GAMEMODE:ShieldDamageFloater(attacker, self, dmginfo:GetDamagePosition(), dmginfo:GetDamage(), true)
	end
end

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()

	if owner:IsValid() then
		if self:GetStateEndTime() <= fCurTime and self:GetState() == 1 or not owner:Alive() or owner:GetZombieClassTable().Name ~= "Ghost Of Pointsave" or self.Destroyed then
			local extraduration = (1 - self:GetObjectHealth() / self:GetMaxObjectHealth()) * 10
			owner.NextShield = fCurTime + (self.Destroyed and 16 or (2 + extraduration))

			if owner:IsValidLivingZombie()  then
				local wep = owner:GetActiveWeapon()
				local SCD = owner.NextShield - fCurTime
				wep:SetAbstractNumber(SCD)
				wep:SetResource(SCD, true)
			end
			self:Remove()
			return
		elseif self:GetStateEndTime() <= fCurTime and self:GetState() == 0 and not self.Constructed then
			self:PhysicsInit(SOLID_VPHYSICS)

			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(false)
			end

			self:EmitSound("npc/vort/attack_shoot.wav", 70, 245)
			self.Constructed = true
		end

		if self:GetState() == 1 and self.Constructed then
			self:PhysicsInit(SOLID_NONE)
			self:EmitSound("weapons/physgun_off.wav", 70, 190)

			self.Constructed = false
		end

		if fCurTime >= self.NextHeal and self.DamageTaken ~= 150 then
			self.NextHeal = fCurTime + 0.4

			if self:GetObjectHealth() < self:GetMaxObjectHealth() then
				self:SetObjectHealth(math.min(self:GetObjectHealth() + 20, self:GetMaxObjectHealth()))
			end
		end

		if fCurTime >= self.NextDamageSet then
			self.NextDamageSet = fCurTime + 1
			self.DamageTaken = 0
		end

		self:SetPos(LerpVector(0.75, self:GetPos(), owner:GetPos() + owner:GetForward() * 40))
		local angs = owner:GetAngles()
		angs:RotateAroundAxis(self:GetUp(), 135)
		local entangle = self:GetAngles()
		entangle.p = 0
		entangle.r = 0

		self:SetAngles(LerpAngle(0.75, entangle, angs))

	else
		self:Remove()
	end

	self:NextThink(fCurTime)
	return true
end

function ENT:OnRemove()
	local parent = self:GetOwner()
	if parent:IsValid() then
		parent.ShadeShield = nil
	end
end