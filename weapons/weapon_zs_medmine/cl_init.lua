include("shared.lua")

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70

function SWEP:Holster()
    if CLIENT then
        self:Anim_Holster()
    end
   
    return true
end