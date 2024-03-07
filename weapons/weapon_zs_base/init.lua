--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.AIRating = 1
SWEP.AICombatRange = 1000

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:CalcBotRate()
	if self:Clip1() == 0 and self:Ammo1() == 0 then return -1 end
	local stbl = E_GetTable(self)
	return stbl.AIRating + (stbl.Primary.Damage / 40)
end

function SWEP:BotAttackMode( enemy )
	if self:Clip1() == 0 then return 2 end -- Must reload if possible.
	return 0
end

function SWEP:sv_Think()
	if self:GetIronsights() and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end

	local stbl = E_GetTable(self)

	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end
	elseif stbl.IdleAnimation and stbl.IdleAnimation <= CurTime() then
		stbl.IdleAnimation = nil
		self:SendWeaponAnim(stbl.IdleActivity)
	end
end

function SWEP:OnZombieDed(zombie)
	local attacker = self:GetOwner()
	
	if attacker:IsValid() then
		if attacker.TrinketResupplyKill then
			rawset(PLAYER_NextResupplyUse, attacker, rawget(PLAYER_NextResupplyUse, attacker) - math.ceil(zombie:GetMaxHealth() * 0.02))
			net.Start("zs_nextresupplyuse")
			net.WriteFloat(rawget(PLAYER_NextResupplyUse, attacker))
			net.Send(attacker)
		end
	end
end
