--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
ENT.DeathTime = 0

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/hunter/misc/sphere075x075.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetRenderFX(kRenderFxDistort)
	self:SetModelScale(1.2 * self.Scale , 0.25)
	self:SetColor(Color(255, 100, 0))
	self:SetMaterial("models/debug/debugwhite")
	self.DeathTime = CurTime() + 0.25
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end

function ENT:Think()
	if self.DeathTime <= CurTime() then
		self:Remove()
	end
	self:NextThink(CurTime())
end