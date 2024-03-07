--[[SECURE]]--

ENT.Type = "point"

function ENT:Initialize()
	if self.ForceSpawn == nil then self.ForceSpawn = false end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "forcespawn" then
		self.ForceSpawn = tonumber(value) == 1
	elseif key == "disableteleports" then
		self.DisableTeleports = tonumber(value) == 1
	elseif key == "sigilgroupname" then
		self.SigilGroup = tostring(value) or ""
	elseif key == "nocrate" then
		self.NoCrate = tonumber(value) == 1
	elseif string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	end
end

function ENT:AcceptInput(name, activator, caller, arg)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
    elseif key == "enableteleport" then
        self.DisableTeleports = false
    elseif key == "corrupt" then
        self.DesiredCorruptionState = true
    elseif key == "uncorrupt" then
        self.DesiredCorruptionState = false
    elseif key == "disableteleport" then
        self.DisableTeleports = true
	end
end