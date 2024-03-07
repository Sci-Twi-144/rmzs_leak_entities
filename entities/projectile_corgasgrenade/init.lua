--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.TickTime = 0.6
ENT.Ticks = 19
ENT.Damage = 13

function ENT:Initialize()
	self:SetModel("models/props_lab/labpart.mdl")
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.42, 0)
	self:SetupGenericProjectile(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(1)
		phys:SetBuoyancyRatio(0.01)
		phys:SetDamping(1.5, 4)
		phys:EnableDrag(false)
		phys:Wake()
	end

	self:SetGasEmit(false)
end

function ENT:Think()
	if not self.Collided and self.PhysicsData then
		self:Fire("corrode", "", self.TickTime)
		self:Fire("kill", "", self.TickTime * self.Ticks + 0.01)
		self:SetGasEmit(true)

		self.Collided = true
	end
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "corrode" then return end

	self.Ticks = self.Ticks - 1

	local owner = self:GetOwner()
	if not owner:IsValidLivingHuman() then owner = self end

	local vPos = self:GetPos()
	for _, ent in pairs(util.BlastAlloc(self, owner, vPos, self.Radius)) do
		if owner:IsValidLivingHuman() and ent:IsValidLivingPlayer() and (ent:Team() == TEAM_UNDEAD or ent == owner) then
			--ent.Corrosion = CurTime()
			ent:AddLegDamageExt(5, owner, self, SLOWTYPE_ACID)
			ent:EmitSound("player/pl_burnpain" .. math.random(1,3) .. ".wav", 65, math.random(60, 70))
			ent:TakeSpecialDamage(self.Damage, DMG_GENERIC, owner, self)
		end
	end

	if self.Ticks > 0 then
		self:Fire("corrode", "", self.TickTime)
	end

	return true
end
