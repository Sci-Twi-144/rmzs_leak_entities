--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.Burn = self
end
-- WARN
-- Надо перенести росжиг непосредственно в статус.
function ENT:Think()
	local owner = self:GetOwner()
	if self:GetDamage() <= 0 or owner:WaterLevel() > 0 or not owner:Alive() then
		self:Remove()
		return
	end
	local attacker = self.Damager
	local dmg = math.Clamp(self:GetDamage(), 1, 8)
	owner:TakeSpecialDamage(dmg, DMG_BURN, attacker and attacker:IsValid() and attacker:IsPlayer() and attacker:Team() ~= owner:Team() and attacker or owner, self)
	
	if attacker.TrinketFlameCompound then
		attacker:AddAccuFlame(dmg)
		owner:FlameExplosion(attacker)
	end

	self:AddDamage(-dmg)
	if attacker and attacker:IsValid() then
		GAMEMODE:ElementalDamageFloater(attacker, self, self:WorldSpaceCenter() + Vector(0, 0, 6), dmg, 2)
	end
	
	self:NextThink(CurTime() + 0.5 / self:GetTickRateMul())
	return true
end
