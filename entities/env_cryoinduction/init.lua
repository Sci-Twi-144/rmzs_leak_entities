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
	local val = attacker.InductorVal

	if not attacker:IsValid() or not target:IsValid() then return end
	
	local multiplier = (target:GetBossTier() >= 2) and 0.1 or (target:GetBossTier() > 0) and 0.3 or 1
	
	target:TakeSpecialDamage(target:Health() * multiplier + 90, DMG_DIRECT, attacker, self)

	if attacker:IsValidLivingHuman() then
		local dmgcap = math.min(math.max(36, target:GetMaxHealthEx() * (0.12 + val)), 300)
		local taper = 1
		util.BlastDamagePlayer(self, attacker, self:GetPos(), 100, dmgcap, DMG_ALWAYSGIB, 0.85)
		for _, ent in pairs(util.BlastAlloc(self, attacker, self:GetPos(), 100 * (attacker.ExpDamageRadiusMul or 1))) do
			if ent:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
				ent:AddLegDamageExt(dmgcap * 1.5 * taper, attacker, self, SLOWTYPE_COLD)
				taper = taper * 0.9
			end
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(attacker:GetShootPos())
	util.Effect("hit_ice", effectdata)
	
	self:Remove()
end