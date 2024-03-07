ENT.Type = "point"

function ENT:AcceptInput(action, activator, caller, param)
    action = string.lower(action)

    -- Strip and StripWeaponsAndSuit input
    if string.StartsWith(action, "strip") and activator:IsPlayer() then
        
        activator:StripWeapons()
        -- in the source code it removes both weapons and ammo
        activator:RemoveAllAmmo()
        
    end

end