--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local EffectData = EffectData
local util_Effect = util.Effect

ENT.Base = "projectile_arrow_sli"
ENT.Model = "models/items/ar2_grenade.mdl"

ENT.NoNails = true
ENT.HitOneTime = true

function ENT:InitProjectile()
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.55, 0)
	self:SetTrigger(true)

	self.TimeCreated = CurTime()
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end
	
	self:EmitSound("npc/barnacle/barnacle_gulp2.wav", 70, 120, 0.75, CHAN_WEAPON + 20)
	self:EmitSound("vehicles/airboat/pontoon_impact_hard1.wav", 65, 250, 0.5, CHAN_WEAPON + 21)
	self:Explode(ent)
end

function ENT:Explode(ent)
	if self.Exploded then return end
	self.Exploded = true
	local pos = self:GetPos()
	local owner = self:GetOwner()
	local entitybonus = IsEntity(ent) and ent:IsValidLivingZombie() and ent:GetMaxHealthEx() or 0
	local bonusdmg = entitybonus > 0 and math.min(entitybonus * ((ent:GetBossTier() > 1) and 0.05 or (ent:GetBossTier() > 0) and 0.1 or 0.2), 300) or 0
	local source = self:ProjectileDamageSource()
	local standartdmg = self.ProjDamage or 68
	if owner:IsValidHuman() then
		if self.ExpType == "explosion" then
			util.BlastDamagePlayer(source, owner, pos, self.ProjRadius or 68, standartdmg + bonusdmg, DMG_ALWAYSGIB, self.ProjTaper or 0.75)
			
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			util_Effect("Explosion", effectdata)
			
		elseif self.ExpType == "pulse" then
		
			util.ElectricWonder(self, owner, pos, 1000, (standartdmg + bonusdmg) * 0.9, 0.85, 12)
			
			for _, enc in pairs(util.BlastAlloc(source, owner, pos, (self.ProjRadius or 68) * (owner.ExpDamageRadiusMul or 1))) do
				if enc:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", enc, owner) then
					enc:AddLegDamageExt((standartdmg + bonusdmg) * 0.065, owner, source, SLOWTYPE_PULSE) -- 0.05
				end
			end
			
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(owner:GetShootPos())
			util.Effect("explosion_shockcore", effectdata, true, true)
			
		elseif self.ExpType == "fire" then
		
			util.BlastDamagePlayer(source, owner, pos, self.ProjRadius or 68, (standartdmg + bonusdmg) * 0.5, DMG_BURN, self.ProjTaper or 0.75)
			
			for _, enc in pairs(util.BlastAlloc(source, owner, pos, (self.ProjRadius or 68) * (owner.ExpDamageRadiusMul or 1))) do
				if enc:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", enc, owner) then
					enc:AddBurnDamage((standartdmg + bonusdmg) * 0.65, owner, owner.BurnTickRate or 1) -- 0.8
				end
			end
			
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(owner:GetShootPos())
			util.Effect("explosion_sniperexp", effectdata, true, true)
			
		elseif self.ExpType == "cryo" then
			
			util.BlastDamagePlayer(source, owner, pos, self.ProjRadius or 68, (standartdmg + bonusdmg) * 0.5, DMG_ALWAYSGIB, self.ProjTaper or 0.75)
			
			for _, enc in pairs(util.BlastAlloc(source, owner, pos, (self.ProjRadius or 68) * (owner.ExpDamageRadiusMul or 1))) do
				if enc:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", enc, owner) then
					enc:AddLegDamageExt((standartdmg + bonusdmg) * 0.9, owner, source, SLOWTYPE_COLD)
				end
			end
			
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(owner:GetShootPos())
			util.Effect("explosion_cold", effectdata, true, true)
		end
	end
	if source:GetTumbler() then
		source:SetTumbler(false)
	end
	self:Remove()
end