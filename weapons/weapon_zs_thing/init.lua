--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.NextRegen = nil
SWEP.Enemy = nil
--if enemy:IsPlayer() and self:GetNextSecondaryFire() <= CurTime() then


function SWEP:BotAttackMode(enemy)
	if not enemy:IsPlayer() or enemy:GetPos():DistToSqr(self:GetOwner():GetPos()) < 9216 then
		if self:GetNextHowl() <= CurTime() then 
			self.Enemy = enemy
			return  1
		else
			return 0
		end
	end
end

function SWEP:ThrowMalice()
	local owner = self:GetOwner()
	if owner:IsValid() and owner:Alive() and self:IsValid() then
		--pl:ResetSpeed()
		owner.LastRangedAttack = CurTime()

		local startpos = owner:GetPos()
		startpos.z = owner:GetShootPos().z
		local heading = owner:GetAimVector()

		local proj = ents.Create("projectile_necrotic_orb")
		if proj:IsValid() then
			proj:SetPos(owner:GetPos() + Vector(0, 0, 32))
			proj:SetOwner(owner)
			proj.Killer = self.Enemy
			proj:Spawn()
		end
	end
end