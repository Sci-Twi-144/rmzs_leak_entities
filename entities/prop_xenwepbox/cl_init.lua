include("shared.lua")

local blockmat = Material("models/world_models/w_weaponbox_white.vmt")
function ENT:Draw()
    local type1 = self:GetSelfType()

    local sin =  math.abs(math.sin(CurTime() * (((type1 == 1) and 5) or ((type1 == 3) and 8) or 2)))

    local vector = 
    (type1 == 1) and Vector(8 * sin, 16 * sin, 8 * sin) or 
    (type1 == 2) and  Vector(8 * sin, 8 * sin, 16 * sin) or 
    (type1 == 3) and  Vector(12 * sin, 4 * sin, 16 * sin) or 
    Vector(16, 5, 0)

    Color(190,79,255)
    blockmat:SetVector("$selfillumtint", vector)

    render.ModelMaterialOverride(blockmat)
	self:DrawModel()
	render.ModelMaterialOverride(nil)
end