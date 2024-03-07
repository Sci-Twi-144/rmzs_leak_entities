--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:SetDie(fTime)
	if fTime == 0 or not fTime then
		self.DieTime = 0
	elseif fTime == -1 then
		self.DieTime = 999999999
	else
		self.DieTime = CurTime() + fTime
		self:SetDuration(fTime)
	end
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())

	local owner = self:GetOwner()
	owner:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_TELEPORT, ZS_COLLISIONFLAGS_AFTERTELEPORT)
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	local owner = self:GetOwner()
	if owner:Team() == TEAM_HUMAN then
		owner:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONFLAGS_HUMAN)
	elseif owner:Team()  == TEAM_UNDEAD then
		owner:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_ZOMBIE, ZS_COLLISIONFLAGS_ZOMBIE)
	end	
end
