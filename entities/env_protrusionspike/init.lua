--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_wasteland/rockcliff06d.mdl")
	self:SetMaterial("models/shadertest/shader2")
	self:SetColor(Color(30, 150, 255, 255))
	self:PhysicsInit(SOLID_NONE)

	self:Explode()

	self:Fire("kill", "", 0.75)
end

function ENT:Explode()
	local pos = self:GetPos()
	local owner = self:GetOwner()
	local wep = owner:GetActiveWeapon()
	local rad = 36

	local basedmg = self.Damage or 113.4
	local legdmg = self.Special and basedmg * 1.4 or basedmg * 1.2

	local taperfactor = 0.85

	local source = self:ProjectileDamageSource()

	for _, ent in pairs(util.BlastAlloc(self, owner, pos + Vector(0, 0, rad), rad)) do
		if ent:IsValidLivingZombie() and gamemode.Call("PlayerShouldTakeDamage", ent, owner) and ent ~= owner then
			ent:TakeSpecialDamage(basedmg, DMG_DROWN, owner, source, pos)
			ent:AddLegDamageExt(legdmg, owner, source, SLOWTYPE_COLD)
			
			if not self.Special then
				wep:SetResource(wep:GetResource() + basedmg * (owner.AbilityCharge or 1))
			end
			
			basedmg = basedmg * taperfactor
			legdmg = legdmg * taperfactor

		end
	end
end
