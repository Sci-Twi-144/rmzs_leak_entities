AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.MedRay = self
	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	if self:GetEndTime() == 0 then
		self:SetEndTime(CurTime() + 0.1)
	end
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent.MedRay = nil
		parent:EmitSound("weapons/physcannon/energy_bounce1.wav")
	end
end

function ENT:Think()
	local owner = self:GetOwner()
	
	if owner:KeyDown(IN_ATTACK) then
		self:SetEndTime(CurTime() + 0.1)
	end
	
	if CurTime() >= self:GetEndTime() then
		self:Remove()
	end
end
