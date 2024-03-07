include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	render.SetColorModulation(1, 0, 0)
	render.SetBlend(self:GetPower() * 0.95)
	render.SuppressEngineLighting(true)
	
	self:SetRenderOrigin(owner:GetPos() + Vector(0, 0, owner:OBBMaxs().z + math.abs(math.sin(CurTime() * 2)) * 4))
	self:SetRenderAngles(Angle(0, CurTime() * 270, 0))
	self:DrawModel()

	render.SuppressEngineLighting(false)
	render.SetBlend(1)
	render.SetColorModulation(1, 1, 1)
end

function ENT:GetPower()
	return math.Clamp(self:GetStartTime() + self:GetDuration() - CurTime(), 0, 1)
end