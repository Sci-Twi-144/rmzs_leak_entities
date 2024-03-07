--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.TickTime = 0.45
ENT.Ticks = 6
ENT.Damage = 7

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_wasteland/rockcliff01g.mdl")
	self:SetMaterial("models/shadertest/shader2")
	self:SetModelScale(0.67)
	self:SetColor(Color(130, 25, 0, 255))
	self:PhysicsInit(SOLID_NONE)

	self:Fire("burn", "", self.TickTime)
	self:Fire("kill", "", self.TickTime * self.Ticks + 0.01)

	--self:DropToFloor()
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "burn" then return end

	self.Ticks = self.Ticks - 1

	local owner = self:GetOwner()
	if not owner:IsValidLivingHuman() then owner = self end

	local vPos = self:GetPos()
	for _, ent in pairs(util.BlastAlloc(self, owner, vPos, 72)) do
		if ent:IsValidLivingPlayer() and ent:Team() == TEAM_UNDEAD then
			if owner:IsValidLivingHuman() then
				ent:AddBurnDamage(self.Damage/math.max((self.Ticks*2), 1)/5, owner, owner.BurnTickRate or 1)
				ent:TakeSpecialDamage(self.Damage/math.max((self.Ticks*2), 1), DMG_ALWAYSGIB, owner, self)
				--util.ScreenShake(vPos, 1, 1, 2, 560)
			end
		end
	end

	if self.Ticks > 0 then
		self:Fire("burn", "", self.TickTime)
	end

	return true
end