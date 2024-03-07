--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Attacker = nil

function ENT:PlayerSet(pPlayer, bExists)
	self.Attackers = {}

	pPlayer.Shock = self

	self:NextThink(CurTime() + 2)
end

function ENT:Think()
	local owner = self:GetOwner()
	local attacker = self.Attacker or self.Applier or self
	
	local eData = EffectData()
	eData:SetEntity( owner )
	eData:SetMagnitude(5)
	eData:SetScale(10)
	util.Effect( "TeslaHitboxes", eData, true, true )
	
	owner:EmitSound("player/pl_pain"..math.random(5, 7)..".wav")
	owner:TakeSpecialDamage(6, DMG_SHOCK, attacker, self)
	owner:AddLegDamageExt(1.25, attacker, self, SLOWTYPE_PULSE)
	
	if self.DieTime <= CurTime() then
		self:Remove()
	end

	self:NextThink(CurTime() + 1)
	return true
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent.Shock = nil
	end
end
