--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/hunter/plates/plate1x16.mdl"
ENT.LifeSpan = 4
ENT.HitOneTime = false

function ENT:InitProjectile()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolidFlags(FSOLID_NOT_SOLID)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetupGenericProjectile(false)
	self:EmitSound("npc/roller/blade_out.wav", 75, 95)
	self:Fire("kill", "", self.LifeSpan)
end

function ENT:Think()
	local pos = self:GetPos()
	local boxMins = pos + Vector(320, 100, 2)
	local boxMaxs = pos + Vector(-320, -100, -2)
	local owner = self:GetOwner()
	local source = self:ProjectileDamageSource()
	for _, ent in pairs(ents.FindInBox( boxMins, boxMaxs )) do
		if ent:IsValidLivingPlayer() and not (ent == owner) then
			ent:TakeSpecialDamage(1500, DMG_BULLET, owner, source)
		end
	end
	print(CurTime())
	self:NextThink(CurTime())
end

function ENT:ProcessHitEntity( ent )
end
--[[
local pos = self:GetPos()
local boxMins = pos + Vector(30, 50, 2)
local boxMaxs = pos + Vector(-30, -50, -2)
local owner = self:GetOwner()
local source = self:ProjectileDamageSource()
for _, ent in pairs(ents.FindInBox( boxMins, boxMaxs )) do
	if ent:IsValidLivingZombie() then
		ent:TakeSpecialDamage(500, DMG_BULLET, owner, source)
	end
end
print("123")]]
