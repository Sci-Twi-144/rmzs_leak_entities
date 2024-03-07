ENT.Type = "point"

local cmdignore = {
	"mp_roundtime",
	"mp_freezetime",
	"mp_flashlight",
	"mat_color_correction",
	"zombie_delete_dropped_weapons",
	"sv_pushaway_force",
	"sv_pushaway_clientside",
	"sv_turbophysics"
}

local function IgnoreCommand(data)
	if not data then return false end
	
	for _, v in pairs(cmdignore) do
		if string.find(data,v) then
			return true
		end
	end
	
	return false
end

local function RemoveChars(str)
	local chars = { ' ', '*', '-', '=', '>', '<' }
	
	str = string.gsub(str,'*','')

	for _, char in pairs(chars) do
		str = string.TrimRight(str, char)
		str = string.Trim(str, char)
		str = string.TrimLeft(str, char)
	end

	str = string.TrimRight(str,'.')
	
	return str
end

local function FixMessage(str, activator)
	str = RemoveChars(str)
	str = string.gsub(str, "say ", "")
	str = string.gsub(str, "SAY ", "")

	if IsValid(activator) and activator:IsPlayer() and
		string.find(string.lower(str), "player") then
		str = string.gsub(str, "A player", activator:Name()) -- mako reactor
		str = string.gsub(str, "Player", activator:Name())
		str = string.gsub(str, "PLAYER", activator:Name())
	end

	return str
end

function ENT:AcceptInput(name, activator, caller, data)
    if caller:IsPlayer() or IgnoreCommand(data) then return false end
	
    name = string.lower(name)
    if name == "command" then
		if string.find(string.lower(data), "say") then
			if GAMEMODE.ZombieEscape then
				ULib.tsayColor(nil, true, COLOR_YELLOW, tostring(FixMessage(data, activator)))
			else
				ULib.tsayColor(nil, true, COLOR_WHITE, tostring(FixMessage(data, activator)))
            end
		end
    end

	return true
end