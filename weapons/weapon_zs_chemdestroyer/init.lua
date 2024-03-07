--[[SECURE]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

if SERVER then
	function SWEP:BotAttackMode( enemy )
		local dist = enemy:GetPos():DistToSqr(self:GetOwner():GetPos())
		if not enemy:IsPlayer() or dist<10000 then -- Square(100)
			return 0
		elseif (self:GetResource() >= self.ResCap) then
			return 2 
		end
	end
end