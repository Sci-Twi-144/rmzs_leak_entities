--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NoNails = true

ENT.Base = "projectile_arrow_sli"

ENT.HitOneTime = true

ENT.LifeSpan = 3
ENT.Model = "models/combine_helicopter/helicopter_bomb01.mdl"
ENT.Special = false
ENT.ChargeCount = 1

function ENT:InitProjectile()
	self:SetColor(Color(0, 255, 0))
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2 * (1 + self.ChargeCount/10), 0)
	self:SetTrigger(true)
	self:SetupGenericProjectile(true)
	self:SetMaterial("models/shadertest/shader2")
end

function ENT:ProcessHitEntity(ent)
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end
	local source = self:ProjectileDamageSource()
	if not self.Special then
		self:DealProjectileTraceDamageNew(ent, (self.ProjDamage or 66), self:GetPos(), owner, source)
	end
	local type = self:GetDTInt(5)
		if ent:IsPlayer() then
			if self.LegDamage then 
				ent:AddLegDamageExt(6, owner, source, SLOWTYPE_PULSE)
			end
			if type == 0 then
				if self.Special then
					self:ChargeExplode(self.ProjDamage, owner, self:GetPos(), type)
				else
					ent:AddLegDamageExt(3, owner, source, SLOWTYPE_ACID)
				end
			end
			if type == 2 then -- FIX THAT LATER
				if self.Special then
					self:ChargeExplode(self.ProjDamage, owner, self:GetPos(), type)
				else
					local multi = (owner.IceRoundMulti or 1) * (owner.RoundTrinketMulti or 1)
					local damage = (self.ProjDamage * --[[0.1075]]0.8) * multi
					ent:AddLegDamageExt(damage, owner, source, SLOWTYPE_COLD)
				end
			end
			if type == 1 then
				if self.Special then
					self:ChargeExplode(self.ProjDamage, owner, self:GetPos(), type)
				else
					ent:AddBurnDamage(self.ProjDamage/4, owner, owner.BurnTickRate or 1)
				end
			end
		end

	util.Blood(ent:WorldSpaceCenter(), math.max(0, 15), -self:GetForward(), math.Rand(100, 300), true)

	self:Remove()
end

function ENT:ChargeExplode(damage, owner, pos, type)
	local count = self.ChargeCount
	local taperpower = 0.04 * 10/count
	local scaler = 1 + (1 * count/10)
	local taper = 1
	local source = self:ProjectileDamageSource()
	if owner:IsValidLivingHuman() then
		util.BlastDamagePlayer(source, owner, pos, scaler * 60, self.ProjDamage, (type == 1) and DMG_BURN or DMG_ALWAYSGIB, 1 - taperpower)
		for _, zomb in pairs(util.BlastAlloc(source, owner, pos, scaler * 60 * (owner.ExpDamageRadiusMul or 1))) do
			if zomb:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", zomb, owner) then
				if type == 2 then
					local dmg = self.ProjDamage * 1.1 * ((owner.IceRoundMulti or 1) * (owner.RoundTrinketMulti or 1) or 1) * taper
					zomb:AddLegDamageExt(dmg, owner, source, SLOWTYPE_COLD)
				elseif type == 1 then
					zomb:AddBurnDamage(self.ProjDamage/4 * taper, owner, owner.BurnTickRate or 1)
				else
					local shareddmg = math.max(1, 5 * taper)
					zomb:AddLegDamageExt(shareddmg, owner, source, SLOWTYPE_ACID)
				end
				taper = taper * (1 - taperpower)
			end
		end
	end
	local effecttbl = {
		[0] = {"explosion_chem", 0.7},
		[2] = {"explosion_cold", 2},
		[1] = {"Explosion", 2}
	}
	
	if SERVER then
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(Vector(0,0,1))
			effectdata:SetMagnitude(effecttbl[type][2] * scaler)
		util.Effect(effecttbl[type][1], effectdata, true)
	end
end

function ENT:ProcessHitWall()
	local type = self:GetDTInt(5)
	local owner = self:GetOwner()
	self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav", 70, 250)
	self:EmitSound(
		type == 0 and "npc/barnacle/barnacle_gulp2.wav" or
		type == 1 and "ambient/fire/mtov_flame2.wav" or
		"nox/scatterfrost.ogg",
		70, type == 2 and 230 or 120, 0.75, CHAN_WEAPON + 20
	)
	self:EmitSound("vehicles/airboat/pontoon_impact_hard1.wav", 65, 250, 0.5, CHAN_WEAPON + 21)
	
	if self.Special then
		self:ChargeExplode(self.ProjDamage, owner, self:GetPos(), type)
	end

	self:Remove()
end