--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:Alive() and owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().Name == "Corruptor") then self:Remove() end
end

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.m_Couple = self
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner.m_Couple == self then
		for i = 1, 4 do
			owner:SetBodygroup(i, 0)
		end
		owner.m_Couple = nil
	end
end
