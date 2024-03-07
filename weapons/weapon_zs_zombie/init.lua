--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.NextRegen = nil

function SWEP:BotAttackMode(enemy)
	if not enemy:IsPlayer() or enemy:GetPos():DistToSqr(self:GetOwner():GetPos()) < 4900 then -- Square(70)
		return 0
	end
end

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
function SWEP:DoRegen()
    local owner = self:GetOwner()
	local stbl = E_GetTable(self)
	local nextregen = stbl.NextRegen and stbl.NextRegen > CurTime()
	if not nextregen then
		if owner:GetBossTier() < 1 then
			local status = owner:GiveStatus("zombie_regen2")
			if status and status:IsValid() then
				status:SetHealLeft(owner:GetMaxHealth() * 0.33)
			end
			stbl.NextRegen = CurTime() + stbl.AlertDelay * 2
		end
	end
end