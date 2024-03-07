AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.MedRay = self
	pPlayer.WhatWeapon = self
	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	if self:GetEndTime() == 0 then
		self:SetEndTime(CurTime() + 0.1)
	end
end

function ENT:OnRemove()

end

function ENT:Think()
	local owner = self:GetOwner()
	local parent = self:GetParent()
	
	if owner:KeyDown(IN_ATTACK2) then
		self:SetEndTime(CurTime() + 0.1)
	end
	
	-- if not (owner:IsValid() and owner:GetActiveWeapon():IsValid()) and CurTime() >= self:GetEndTime() then
		-- self:Remove()
	-- end
	
	if CurTime() >= self:GetEndTime() then
		self:Remove()
	end
end
