--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	if not self.Target:IsValid() then return end
	self:DrawShadow(false)
	self:Explode()

	self:Fire("kill", "", 0.01)
end

function ENT:Explode()
	local target = self.Target
	local attacker = self:GetOwner()
	if target == attacker then return end
	local attacker = self:GetOwner()

	if not attacker:IsValid() or not target:IsValid() then return end
	local tier = target:GetBossTier() > 0
	local dmgcap = math.min(math.max(36, target:GetMaxHealthEx() * (tier and 0.1 or 0.18)), 300)

	if attacker:IsValidLivingHuman() then
		util.BlastDamagePlayer(self, attacker, self:GetPos(), 100, dmgcap, DMG_ALWAYSGIB, 0.85)
		for _, ent in pairs(util.BlastAlloc(self, attacker, self:GetPos(), 100 * (attacker.ExpDamageRadiusMul or 1))) do
			if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
				ent:AddBurnDamage(1, attacker, 1)
				attacker:AddAccuFlame(dmgcap * 0.35)
			end
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(attacker:GetShootPos())
	util.Effect("Explosion", effectdata)
	
	self:Remove()
end