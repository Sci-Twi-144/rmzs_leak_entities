include("shared.lua")

function ENT:Initialize()
	local pickuptype = self:GetType()
	if pickuptype == 1 then
		self:SetColor(self.ColorBlood)
	elseif pickuptype == 2 then
		self:SetColor(self.ColorStamina)
	elseif pickuptype == 3 then
		self:SetColor(self.ColorMedsup)
	end
end

local matGlow = Material("sprites/glow04_noz")

function ENT:Draw()
	render.SetBlend(0.4)
	self:DrawModel()
	render.SetBlend(1)
	
	local pickuptype = self:GetType()
	local pos = self:GetPos()
	
	local color
	if pickuptype == 1 then
		color = self.ColorBlood
	elseif pickuptype == 2 then
		color = self.ColorStamina
	elseif pickuptype == 3 then
		color = self.ColorMedsup
	end
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 16, 16, color)
end