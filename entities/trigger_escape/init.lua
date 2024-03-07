--[[SECURE]]--
ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	elseif name == "seton" then
		self.On = tonumber(args) == 1
		return true
	elseif name == "enable" then
		self.On = true
		return true
	elseif name == "disable" then
		self.On = false
		return true
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	elseif key == "enabled" then
		self.On = tonumber(value) == 1
	end
end

function ENT:StartTouch(ent)
	if self.On and ent:IsPlayer() and ent:Team() == TEAM_HUMAN and ent:Alive() and ent:GetObserverMode() == OBS_MODE_NONE then
		local pos = ent:EyePos()

		rawset(PLAYER_IsAlive, ent, false)

		ent:Spectate(OBS_MODE_ROAMING)
		ent:SpectateEntity(self)
		ent:StripWeapons()
		ent:GodEnable()
		ent:SetMoveType(MOVETYPE_NOCLIP)

		ent:SetPos(pos)

		gamemode.Call("OnPlayerWin", ent)

		--ent:PrintMessage(HUD_PRINTTALK, "You've managed to survive! Waiting for other survivors...")
		net.Start("zs_survivor")
			net.WriteEntity(ent)
		net.Broadcast()
	end
end
