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
		--eHitEntity:GiveStatus("frost", 9)
		--eHitEntity:GiveStatus("dimvision", 9)
		--eHitEntity:AddArmDamage(18)
		eHitEntity:AddLegDamageExt(25, owner, self, SLOWTYPE_COLD)
		eHitEntity:AddLegDamage(18)
	end

	if eHitEntity.IsForceFieldShield and eHitEntity:IsValid() then
		eHitEntity:PoisonDamage(10, owner, self)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(vHitPos)
		effectdata:SetNormal(vHitNormal)
	util.Effect("hit_frost", effectdata)
end
