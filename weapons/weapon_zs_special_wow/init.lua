--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Deploy()
	self:GetOwner():CreateAmbience("ambience_wow")

	return true
end
