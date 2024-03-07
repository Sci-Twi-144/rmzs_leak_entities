--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	self.Attackers = {}

	pPlayer.Poison = self

	--self:NextThink(CurTime() + ticktime)
end

function ENT:Think()
	local owner = self:GetOwner()

	if self:GetDamage() <= 0 --[[or owner:Team() ~= TEAM_HUMAN]] then
		self:Remove()
		return
	end

	local attackers = self.Attackers
	local damage = math.min(self.DamagePerTick, self:GetDamage())
	local attacker = self

	-- Whoever has the most amount of remaining damage should get this credit.
	local mostd = 0
	for a, d in pairs(attackers) do --гений, в этой таблице индексами выступают игроки, проверь все свои остальные замены чтобы еще где не насрать
		if a:IsValidZombie() and d > mostd then
			attacker = a
			mostd = d
		end
	end
	-- Uhhh... just pick the first one in the list then.
	if attacker == self then
		for a, d in pairs(attackers) do
			if a:IsValidZombie() then
				attacker = a
				break
			end
		end
	end

	owner:EmitSound("player/pl_pain"..math.random(5, 7)..".wav")
	
	self:AddDamage(-damage)

	if attackers[attacker] then
		attackers[attacker] = attackers[attacker] - damage
	end

	owner:TakeSpecialDamage(damage, DMG_ACID, attacker, self)

	self:NextThink(CurTime() + 2 / (owner.PoisonSpeedMul or 1))
	return true
end
