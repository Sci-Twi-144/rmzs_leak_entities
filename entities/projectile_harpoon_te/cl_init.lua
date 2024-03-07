include("shared.lua")

ENT.NextEmit = 0

local matTrail = Material("cable/rope")
local matGlow = Material("sprites/light_glow02_add")
function ENT:Draw()
	if self:GetParent() ~= NULL then
		self:SetLocalPos(Vector(0, 0, -30))
	end
	self:DrawModel()
	if self:GetParent() ~= NULL then
		self:SetLocalPos(Vector(0, 0, 0))
	end

	local pos = self:GetPos()
	--pos.z = pos.z

	render.SetMaterial(matTrail)
	render.DrawBeam(pos, self:GetPuller():WorldSpaceCenter(), 3, 4, 0, Color(255, 255, 255))

	if CurTime() >= self.NextEmit and self:GetVelocity():LengthSqr() >= 256 then
		self.NextEmit = CurTime() + 0.06
	end
end

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "npc/strider/strider_skewer1.wav")
	self.Created = CurTime()
end

function ENT:Think()
	self.AmbientSound:PlayEx(1, 50 + math.min(1, CurTime() - self.Created) * 30)

	self:NextThink(CurTime())
	return true
end
