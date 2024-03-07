--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Think()
	local owner = self:GetOwner()

	if owner:GetZombieShield() <= 0 or not (owner:IsValidLivingZombie() and owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().Name == "Ice Marrow") then
		self:Remove()
	end
end

function ENT:PlayerSet(pPlayer, bExists)
	--pPlayer.Shielded = self
	pPlayer:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	
	pPlayer:SetZombieShield(GAMEMODE:CalcMaxShieldHealth(pPlayer))
end 

function ENT:OnRemove()
	local owner = self:GetOwner()
	--owner.Shielded = nil
	owner:SetZombieShield(0)
end