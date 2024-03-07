--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/hunter/misc/sphere075x075.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetSolid(SOLID_NONE)
	self:DrawShadow(false)
	self:SetRenderFX(kRenderFxDistort)
	self:SetModelScale(10, 0.8)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end