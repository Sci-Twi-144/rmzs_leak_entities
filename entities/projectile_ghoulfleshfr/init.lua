--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Hit(vHitPos, vHitNormal, eHitEntity)
	if self.Exploded then return end
	self.Exploded = true
	self.DeathTime = 0

	local owner = self:GetOwner()
	if not owner:IsValid() then owner = self end

	vHitPos = vHitPos or self:GetPos()
	vHitNormal = vHitNormal or Vector(0, 0, 1)

	if eHitEntity:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", eHitEntity, owner) then
		--eHitEntity:ApplyZombieDebuff("frost", 5, {Applier = owner}, true, 10)
		eHitEntity:AddLegDamageExt(18, owner, self, SLOWTYPE_COLD)
		eHitEntity:ApplyZombieDebuff("dimvision", 3, {Applier = owner}, true, 7)
		--eHitEntity:AddArmDamage(18)
	end

	if eHitEntity.IsForceFieldShield and eHitEntity:IsValid() then
		eHitEntity:PoisonDamage(10, owner, self)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("hit_frost", effectdata)
end
