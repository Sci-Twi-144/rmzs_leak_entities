--[[SECURE]]--
ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, args)
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "disablefreshdead" then
		GAMEMODE.DisableFreshDead = value == "1"
	elseif key == "nosigils" then
		GAMEMODE.NoSigils = value == "1"
	elseif key == "noskills" then
		GAMEMODE.NoSkills = value == "1"
	elseif key == "nospawnonsigils" then
		GAMEMODE.NoSpawnOnSigils = value == "1"
	elseif key == "nometagame" then
		SetGlobalBool("nometagame",value == "1")
	elseif key == "nozombiefalldmg" then
		SetGlobalBool("nozombiefalldmg",value == "1")
	elseif key == "waveonesigils" then
		GAMEMODE.WaveOneSigils = value == "1"
	elseif key == "globalsigilname" then
		SetGlobalString("globalsigilname",value)
	elseif key == "mapreplays" then
		GAMEMODE.RoundLimit = tonumber(value) or GAMEMODE.RoundLimit
	elseif key == "mapreplaytime" then
		GAMEMODE.TimeLimit = tonumber(value) or GAMEMODE.TimeLimit
	elseif key == "nailhpmul" then
		GAMEMODE.NailHealthMultiplier = tonumber(value) or 1
	elseif key == "nestdistancemul" then
		GAMEMODE.CreeperNestDistBuildMultiplier = tonumber(value) or 1
	elseif key == "nestverticalskewmul" then
		GAMEMODE.CreeperNestVerticalSkewMultiplier = tonumber(value) or 1
	elseif key == "noescapedoors" then
		GAMEMODE.NoEscapeDoors = value == "1"
	elseif key == "zombiesigildamagemul" then
		SetGlobalFloat("zombiesigildamagemul",tonumber(value) or 1)
	elseif key == "humansigildamagemul" then
		SetGlobalFloat("humansigildamagemul",tonumber(value) or 1)
	elseif key == "sigilcount" then
		GAMEMODE.MaxSigilsGameRules = tonumber(value) or GAMEMODE.MaxSigils
	elseif key == "startzombiepercent" then
		SetGlobalFloat("startzombiepercent",tonumber(value) or GAMEMODE.WaveOneZombies)
	end
end
