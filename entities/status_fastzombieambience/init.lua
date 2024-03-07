--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Think()
	local owner = self:GetOwner()
	local name = owner:GetZombieClassTable().Name
	if not (owner:Alive() and owner:Team() == TEAM_UNDEAD and (name == "Fast Zombie" or name == "Slingshot Zombie" or name == "Fast Zombie Torso" or name == "Slingshot Zombie Torso")) then self:Remove() end
end
