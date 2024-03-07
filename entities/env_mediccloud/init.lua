--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.TickTime = 1
ENT.Ticks = 10
ENT.HealPower = 2.5

function ENT:Initialize()
	local owner = self:GetOwner()

	self:DrawShadow(false)
	self.Ticks = math.floor(self.Ticks * (owner:IsValidLivingHuman() and owner.CloudTime or 1))

	self:Fire("heal", "", self.TickTime)
	self:Fire("kill", "", self.TickTime * self.Ticks + 0.01)


	local vPos = self:GetPos()
	if owner:IsSkillActive(SKILL_CLEANSING) then
		for _, ent in pairs(team.GetPlayers(TEAM_HUMAN)) do
			if ent and ent:IsValidLivingPlayer() and WorldVisible(vPos, ent:NearestPoint(vPos)) then
				if ent:GetPos():DistToSqr(vPos) < ((self.Radius * (owner.CloudRadius or 1)) ^ 2) then
					ent:ApplyHumanBuff("cleanser", 45, {Applier = owner, Stacks = 1}, true)
				end
			end
		end
	end
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "heal" then return end

	self.Ticks = self.Ticks - 1

	local healer = self:GetOwner()
	if not healer:IsValidLivingHuman() then healer = self end

	local vPos = self:GetPos()
	for _, ent in pairs(team.GetPlayers(TEAM_HUMAN)) do
		if ent and ent:IsValidLivingPlayer() and WorldVisible(vPos, ent:NearestPoint(vPos)) then
			if ent:GetPos():DistToSqr(vPos) < ((self.Radius * (healer.CloudRadius or 1)) ^ 2) then
				healer:HealPlayer(ent, self.HealPower, 1, true)
			end
		end
	end

	if self.Ticks > 0 then
		self:Fire("heal", "", self.TickTime)
	end

	return true
end