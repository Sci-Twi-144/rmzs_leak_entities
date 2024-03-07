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
	--[[
	hook.Add("Move", ENTC, function(pl, move)
		if not IsValid(self) then return end
		
		if pl ~= ent:GetOwner() then return end
	
		move:SetMaxSpeed(0)
		move:SetMaxClientSpeed(0)
	end)
	]]
end
--[[
function ENT:RemoveHook()
	local ENTC = tostring(self)
	hook.Remove("Move", ENTC)
end
]]
function ENT:Initialize()
	BaseClass.Initialize(self)
	self.NextDeflect = 0

	self:SetModel("models/props_phx/construct/metal_plate_curve2x2.mdl")
	self:DrawShadow(false)
	self:SetCustomCollisionCheck(true)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_FORCEFIELD, ZS_COLLISIONFLAGS_SHADESHIELD)

	--self:EmitSound("weapons/physcannon/physcannon_charge.wav", 70, 190)
	timer.Simple(0, function()
	self:SetMaxObjectHealth(GAMEMODE:CalcMaxShieldHealth(self:GetOwner()))
	self:SetObjectHealth(self:GetMaxObjectHealth())
	end)
end

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.ShadeShield = self
	pPlayer:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	--pPlayer:SetMoveType(MOVETYPE_NONE)

	self:SetParent(nil)
	self:SetPos(pPlayer:GetPos())

	local angs = pPlayer:GetAngles()
	angs:RotateAroundAxis(self:GetUp(), 135)
	self:SetAngles(angs)

	--[[if pPlayer:KeyDown(IN_BACK) then
		self:SetDirection(DIR_BACK)
	elseif pPlayer:KeyDown(IN_MOVERIGHT) then
		self:SetDirection(DIR_RIGHT)
	elseif pPlayer:KeyDown(IN_MOVELEFT) then
		self:SetDirection(DIR_LEFT)
	else
		self:SetDirection(DIR_FORWARD)
	end--]]
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	local owner = self:GetOwner()

	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
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
		if self:GetStateEndTime() <= fCurTime and self:GetState() == 1 or not owner:Alive() or owner:GetZombieClassTable().Name ~= "Shade" or self.Destroyed then
			local extraduration = (1 - self:GetObjectHealth() / self:GetMaxObjectHealth()) * 10
			owner.NextShield = fCurTime + (self.Destroyed and 12 or (2 + extraduration))

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
		--parent:SetMoveType(MOVETYPE_WALK)
	end

	--self:RemoveHook()
end