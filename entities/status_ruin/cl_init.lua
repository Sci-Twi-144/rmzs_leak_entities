include("shared.lua")

ENT.NextEmit = 0
ENT.SColor = nil
function ENT:Initialize()
    if not self:GetDTEntity(0):IsValid() then return end
	self:DrawShadow(false)
    self.SColor = self:GetDTEntity(0):GetColor()
end

local matDamage = Material("models/shadertest/shader2")
function ENT:Draw()
    if not self:GetDTEntity(0):IsValid() then return end
	local sat = 1 - math.abs(math.sin(CurTime() * 3)) * 0.6
    local scale = 1 + math.abs(math.sin(CurTime() * 3)) * 0.03
    local parent = self:GetDTEntity(0)
    
	--render.ModelMaterialOverride(matDamage)
    render.SetBlend(0.95)
	render.SetColorModulation(1, 1, sat)
    
    self:SetModel(parent:GetModel())
    self:SetPos(parent:LocalToWorld(Vector(0, 0, 0)))
    self:SetAngles(parent:LocalToWorldAngles(Angle(0, 0, 0)))
    self:SetModelScale(1 * scale, 0)
    parent:SetColor(Color(255, 128 * sat, 0, 255))

	self:DrawModel()

	render.SetColorModulation(1, 1, 1)
    render.SetBlend(1)
	--render.ModelMaterialOverride(0)
    --self:GetParent():SetColor(Color(255, 255, 255, 255))
      

	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.02
end

function ENT:OnRemove()
    if self:GetDTEntity(0):IsValid() then self:GetDTEntity(0):SetColor(self.SColor) end
end
