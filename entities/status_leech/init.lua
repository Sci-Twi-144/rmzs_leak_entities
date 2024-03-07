--[[SECURE]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.Leech = self
end

function ENT:Think()
	local owner = self:GetOwner()
	if not (self.Damager:Alive() and self.Damager:Team() == TEAM_UNDEAD and self.Damager:GetZombieClassTable().Name == "Grim Reaper") then self:Remove() end
	if self:GetDamage() <= 0 or owner:Team() == TEAM_UNDEAD then
		self:Remove()
		return
	end

	local dmg = math.Clamp(self:GetDamage(), 1, 2)
	local wep = self.Damager:GetActiveWeapon()
	owner:TakeDamage(dmg, self.Damager and self.Damager:IsValid() and self.Damager:IsPlayer() and self.Damager:Team() ~= owner:Team() and self.Damager or owner, self)
	self.Damager:SetHealth(math.min(self.Damager:GetMaxHealthEx(), self.Damager:Health() + dmg * 1.5))
	wep:SetResource(wep:GetResource() + dmg * 1.5, false)
	--print(wep:GetResource(), "res")
	self:AddDamage(-dmg)

	local dir = VectorRand()
	dir:Normalize()
	util.Blood(owner:WorldSpaceCenter(), 3, dir, 32)

	self:NextThink(CurTime() + 1 / math.max(1, self:GetDamage() / 10))
	return true
end
