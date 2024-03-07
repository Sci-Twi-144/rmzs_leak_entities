--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/props_junk/harpoon002a.mdl"

ENT.LifeSpan = 30
ENT.HitOneTime = true
--ENT.MaxHitCounts = 1

local vector_origin = vector_origin

ENT.NextDamage = 0
ENT.TicksLeft = 50

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.DieTime = CurTime() + 3
end

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetupGenericProjectile(false)

	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))

	self.LastPhysicsUpdate = UnPredictedCurTime()
end

function ENT:PhysicsUpdate(phys)
	if not self.Done then
		self:TraceHits()
	end

	if not self.InitVelocity then self.InitVelocity = self:GetVelocity() end

	local dt = (UnPredictedCurTime() - self.LastPhysicsUpdate)
	self.LastPhysicsUpdate = UnPredictedCurTime()

	phys:AddVelocity(self.InitVelocity * dt * -0.6)
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValidLivingHuman() then
		owner:Give(self.BaseWeapon)
	end
end

function ENT:Think()
	if self.PhysicsData then
		self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.OurOldVelocity, self.PhysicsData.HitEntity)
	end

	local parent = self:GetParent()
	if parent:IsValid() and parent:IsPlayer() then
		if parent:IsValidLivingZombie() and not SpawnProtection[parent] then
			if CurTime() >= self.NextDamage then
				self.NextDamage = CurTime() + 0.35

				util.Blood((parent:NearestPoint(self:GetPos()) + parent:WorldSpaceCenter()) / 2, math.random(4, 9), Vector(0, 0, 1), 100)
				parent:TakeSpecialDamage((self.ProjDamage or 35) * 0.15, DMG_SLASH, self:GetOwner(), self)
			end
		else
			self:Remove()
		end
	end

	if self.Exploded and not self.ColChange then
		self.ColChange = true
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end

	if self.DieTime < CurTime() then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end
--[[
function ENT:ProcessHitWall()
	self:Hit(self.PhysicsData.HitPos, self.PhysicsData.HitNormal, self.PhysicsData.OurOldVelocity, self.PhysicsData.HitEntity)
end
]]
function ENT:ProcessHitEntity(ent)
	self:Hit(self:GetPos(), self:GetPos(), self:GetVelocity():Length(), ent)
end

function ENT:Hit(vHitPos, vHitNormal, vel, hitent)
	if self.Exploded then return end

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	if hitent and hitent:IsValid() and hitent:IsPlayer() then
		hitent:AddLegDamage(hitent:PlayerIsBoss() and 15 or 30)

		self.Exploded = true

		hitent:TakeSpecialDamage(self.ProjDamage or 35, DMG_GENERIC, owner, self, self:GetPos())
		hitent:EmitSound("npc/strider/strider_skewer1.wav", 70, 112)

		self.DieTime = CurTime() + 7

		self:GetPhysicsObject():SetVelocityInstantaneous(vector_origin)
		self:SetParent(hitent)
	end
end

function ENT:PhysicsCollide(data, phys)
	self.PhysicsData = data
	self:NextThink(CurTime())
end
