ENT.Base = "base_point"
ENT.Type = "point"

function ENT:AcceptInput(action, activator, caller, value)
    action = string.lower(action)
    value = string.Trim(value, ";")

    -- Run code
    if action == "runscriptcode" then
        RunString(value)
        -- store the activator because some funcs use him without assignment (maybe remake this part)
        GAMEMODE.LogicScriptActivator = activator
    end

end