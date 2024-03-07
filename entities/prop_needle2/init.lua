--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NextDamage = 0
ENT.TicksLeft = 8

function ENT:Initialize()
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEFlags(EFL_SETTING_UP_BONES)
end
--[[
function ENT:CheckDrop()
	if self:GetParent():GetZombieClassTable().Boss or self:GetParent():GetZombieClassTable().MiniBoss then
		return "prop_weapon"
	else
		return "prop_fakeweapon"
	end
end
]]

function ENT:Think()
	local parent = self:GetParent()
	if parent:IsValid() and parent:IsPlayer() then
		if parent:Alive() and parent:Team() == TEAM_UNDEAD and self.TicksLeft >= 1 and not SpawnProtection[parent] then
			if CurTime() >= self.NextDamage then
				local taketicks = parent:PlayerIsBoss() and 2 or 1
				local owner = self:GetOwner()
				self.NextDamage = CurTime() + 0.35
				self.TicksLeft = self.TicksLeft - taketicks

				util.Blood((parent:NearestPoint(self:GetPos()) + parent:WorldSpaceCenter()) / 2, math.random(4, 9), Vector(0, 0, 1), 100)
				parent:TakeSpecialDamage(self.BleedPerTick, DMG_SLASH, owner, owner)
			end
		else
			self:Remove()
		end
	else
		self:Remove()
	end
end
