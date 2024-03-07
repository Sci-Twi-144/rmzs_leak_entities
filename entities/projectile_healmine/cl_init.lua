include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.CreateTime = CurTime()
end

function ENT:Draw()
	self:DrawModel()
end

local matGlow = Material("sprites/glow04_noz")
function ENT:DrawTranslucent()
	local lightpos = self:GetPos() + self:GetUp() * 1

	if self:GetExplodeTime() ~= 0 then
		local size = (CurTime() * 8.5 % 1) * 24
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, size, size, Color(255, 50, 50, size * 5))
		render.DrawSprite(lightpos, size / 2, size / 2, Color(255, 50, 50, size * 15))
	elseif self.CreateTime + self:GetARMTime() < CurTime() then
		local size = 4 + (CurTime() * 2 % 1) * 6
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, size, size, Color(50, 255, 50, size * 5))
		render.DrawSprite(lightpos, size / 2, size / 2, Color(50, 255, 50, size * 15))
	end
end
