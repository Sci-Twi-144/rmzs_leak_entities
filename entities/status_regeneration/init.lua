--[[SECURE]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Appliers = {}

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.Regeneration = self
	
	self:SetTickMultiplier(1)
end

function ENT:Think()
	local owner = self:GetOwner()
	local healer, _ = next( self.Appliers )
	if self:GetHeal() <= 0 or not owner:IsValidLivingHuman() or not healer:IsValidLivingHuman() then
		self:Remove()
		return
	end
	
	if rawget(PLAYER_LastHitTime, owner) >= CurTime() then
		self:NextThink(rawget(PLAYER_LastHitTime, owner))
		return end

	STATUS_HEAL = true
	local healer, _ = next( self.Appliers )
	local bool = (owner:Health() >= owner:GetMaxHealth())
	if not healer then healer = owner end
	if not self:GetTickAnyway() then
		if bool then return end
	else
		local overregen = math.floor(owner:GetMaxHealth() * 0.15) >= self:GetHeal() -- сохранение регена в 15% от макс здоровья
		if bool and overregen then return end
	end
	
	if healer == owner then
		owner:SetHealth(math.min(owner:Health() + 1, owner:GetMaxHealth()))
		self:AddHeal(-1, owner)
	else
		healer:HealPlayer(owner, 1.5) -- костыль изза math_floor в функции
		self:AddHeal(-1, healer)
	end
	STATUS_HEAL = false

	self:NextThink(CurTime() + self:GetTickMultiplier())
	return true
end