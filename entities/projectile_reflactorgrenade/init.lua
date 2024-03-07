--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.TickTime = 0.4
ENT.Ticks = 32
ENT.Damage = 12
ENT.LegDamage = 3

function ENT:Initialize()
	self:SetModel("models/rmzs/weapons/combine/w_pulsegrenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(4)
		phys:SetMaterial("metal")
	end

	self.Trail = util.SpriteTrail( self, 0, COLOR_CYAN, true, 12, 1, 1.5, 0.05, "sprites/bluelaser1" )
	self:SetGasEmit(false)
end

function ENT:Think()
	local owner = self:GetOwner()
	if not owner:IsValidLivingHuman() then
		self:Remove()
	end

	if not self.Collided and self.PhysicsData then
		self:Fire("corrode", "", self.TickTime)
		self:Fire("kill", "", self.TickTime * self.Ticks + 0.01)
		self:SetGasEmit(true)
	
		local ent = ents.Create("prop_grenadeshield")
		if ent:IsValid() then
			ent:SetPos(self:GetPos())
			ent:SetAngles(self:GetAngles())
			ent:SetParent(self)
			ent:Spawn()
			ent:SetOwner(self)
			self:DeleteOnRemove(ent)
		end

		self:EmitSound("hl1/ambience/particle_suck1.wav", 75, 100, 1, CHAN_AUTO)
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

	local pos = self:GetPos()
	local owner = self:GetOwner()
	local pos2 = self:LocalToWorld(Vector(0, 0, 0))

	if not owner:IsValidLivingHuman() then self:Remove() end

	util.BlastDamagePlayer(self, owner, pos, self.Radius, self.Damage or 50, DMG_ALWAYSGIB, 0.95)
	for _, ent in pairs(util.BlastAlloc(self, owner, pos, self.Radius)) do
		if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) then
			local legdamage = self.LegDamage * (owner.PulseRoundMulti or 1)
			ent:AddLegDamageExt(legdamage, owner, self, SLOWTYPE_PULSE)
			timer.Simple(0, function()
				ent:AddLegDamage(legdamage)
				ent:ApplyZombieDebuff("shockdebuff", 3, {Applier = owner}, true, 38)
			end)
			ent:EmitSound("ambient/levels/labs/electric_explosion1.wav", 75, 100, 1, CHAN_AUTO)

			local effectdata = EffectData()
				effectdata:SetOrigin(ent:WorldSpaceCenter())
				effectdata:SetStart(pos2)
				effectdata:SetEntity(self)
			util.Effect("tracer_muon", effectdata)
		end
	end

	if self.Ticks > 0 then
		self:Fire("corrode", "", self.TickTime)
	end

	return true
end

function ENT:OnRemove()
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetForward())
	util.Effect("explosion_shockcore", effectdata, true, true)
end