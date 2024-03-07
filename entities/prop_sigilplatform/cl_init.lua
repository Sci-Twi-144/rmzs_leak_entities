include("shared.lua")

function ENT:Initialize()
    --local texture = Material( "models/rmzs/sigil/sigil_platform_em.vmt" )
    --texture:SetFloat("$emissiveblendstrength", 1)
	self.BaseClass.Initialize(self)
end
