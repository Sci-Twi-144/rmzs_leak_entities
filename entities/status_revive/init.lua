--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	Revive[pPlayer] = self
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsValid() and (owner:Alive() or self:GetReviveTime() <= CurTime()) then
		self:Remove()
	end
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		Revive[parent] = nil
		if not parent:Alive() then
			parent:SecondWind()
		end
	end
end
