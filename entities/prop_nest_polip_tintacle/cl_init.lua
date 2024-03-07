include("shared.lua")

function ENT:Initialize()
    ent = ClientsideModel("models/gibs/strider_gib1.mdl")
    if ent:IsValid() then
        ent:SetParent(self)
        ent:SetLocalPos(vector_origin + Vector(0, -6, -2))
        ent:SetLocalAngles(angle_zero + Angle(-45, 90, 0))
        ent:SetMaterial("models/flesh")

        matrix = Matrix()
        matrix:Scale(Vector(1, 1, 1))
        ent:EnableMatrix("RenderMultiply", matrix)

        ent:Spawn()
        self.SelfBase = ent
    end

end

function ENT:OnRemove()
    self.SelfBase:Remove()
end

function ENT:Think()
    local atch = self.SelfBase
    if atch and atch:IsValid() then
        local mul = self:GetCanAttack() and (1 + math.abs(math.sin(CurTime() * 5)) * 0.1) or 1
        matrix = Matrix()
        matrix:Scale(Vector(0.85 * mul, 0.85 * mul, 0.85 * mul))
        atch:EnableMatrix("RenderMultiply", matrix)
        atch:SetParent(self)
    end
end

function ENT:Draw()
	render.SetBlend(0)
	self:DrawModel()
    render.SetBlend(1)
end