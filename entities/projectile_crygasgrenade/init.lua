--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Ticks = 19
ENT.Damage = 16
ENT.LegDamage = 40
ENT.PointsMultiplier = 1.25

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "corrode" then return end

	self.Ticks = self.Ticks - 1

	local owner = self:GetOwner()
	if not owner:IsValidLivingHuman() then owner = self end

	local vPos = self:GetPos()

	if self.PointsMultiplier then
		POINTSMULTIPLIER = self.PointsMultiplier
	end

	for _, ent in pairs(util.BlastAlloc(self, owner, vPos, self.Radius)) do
		if owner:IsValidLivingHuman() and ent:IsValidLivingPlayer() and (ent:Team() == TEAM_UNDEAD or ent == owner) then
			ent:EmitSound("physics/glass/glass_impact_bullet"..math.random(4)..".wav", 70, 85)
			ent:TakeSpecialDamage(self.Damage, DMG_DROWN, owner, self)
			ent:AddLegDamageExt(self.LegDamage, owner, self, SLOWTYPE_COLD)
		end
	end

	if self.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end

	if self.Ticks > 0 then
		self:Fire("corrode", "", self.TickTime)
	end

	return true
end
