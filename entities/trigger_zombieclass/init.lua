--[[SECURE]]--
ENT.Type = "brush"

local ENTITY = nil
local position
local b_min, b_max

local string_sub = string.sub
local string_lower = string.lower
local string_Explode = string.Explode
local string_match = string.match
local table_LowerKeyNames = table.LowerKeyNames
local ZombieCLS = table_LowerKeyNames(table.Copy(GAMEMODE.ZombieClasses))

local M_Entity = FindMetaTable("Entity")
local E_GetTable = M_Entity.GetTable

local function GrabKeyFromTables(class_name)
	return ZombieCLS[class_name].index
end

local function BestAvailableTouchClass(value)
	local touch_class         = GAMEMODE.ZombieClasses[GrabKeyFromTables(value)]
	local index               = touch_class.Index
	local best_avail_with_new = GAMEMODE:GetBestAvailableZombieClass(index)
	local best_avail          = GAMEMODE.ZombieClasses[best_avail_with_new]
	local best_avail_name     = best_avail and string_lower(best_avail.Name)

	return best_avail_name or string_lower(touch_class.Name)
end

-- for example, map has that "butcher" but not "the butcher".
local NameCached = {}
local function NameChecker(clsname)
	local OldIndex = ZombieCLS[clsname] and clsname or NameCached[clsname]
	if not OldIndex then
		for k, v in ipairs(ZombieCLS) do -- don't do with pairs cuz its fucking slow.
			if (string_lower(v.name) == clsname or string_match(string_lower(v.name), clsname)) then
				NameCached[clsname] = string_lower(v.name)

				break
			end
		end
	end

	return NameCached[clsname] or OldIndex
end

local function DoTouch(ent)
	local namecheck = NameChecker(ENTITY.TouchClass)
	if not namecheck then return end
	-- Keep update better version available!
	local clsname = BestAvailableTouchClass(namecheck)
	local e_tbl = E_GetTable(ent)
	local ENT_tbl = E_GetTable(ENTITY)

	if ent:IsValidLivingZombie() and not e_tbl.Disconnecting then
		local zombietbl = ent:GetZombieClassTable()
		if not zombietbl.Boss and string_lower(zombietbl.Name) != clsname then
			local prev = ent:GetZombieClass()
			local deadcls = string_lower(ENT_tbl.TouchDeathClass)
			local switch_clsindex = GrabKeyFromTables(clsname)
			local dead_clsindex = GrabKeyFromTables(deadcls)

			if ENT_tbl.OnlyWhenClass[prev] == true or ENT_tbl.OnlyWhenClass[1] == -1 then
				if switch_clsindex then
					local prevpos = ent:GetPos()
					local prevang = ent:EyeAngles()

					ent:KillSilent()
					ent:SetZombieClass(switch_clsindex)
					e_tbl.DidntSpawnOnSpawnPoint = true
					ent:UnSpectateAndSpawn()

					if ENT_tbl.OneTime then
						e_tbl.DeathClass = prev
					end

					if ENT_tbl.InstantChange then
						ent:SetPos(prevpos)
						ent:SetEyeAngles(prevang)
					end

					-- Force health fix!
					ent:SetHealth(ZombieCLS[clsname].health)
				end

				if dead_clsindex and deadcls and deadcls == string_lower(zombietbl.Name) then
					e_tbl.DeathClass = dead_clsindex
				end
			end
		end
	end
end

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
	if self.InstantChange == nil then self.InstantChange = true end
	if self.OnlyWhenClass == nil then
		self.OnlyWhenClass = {}
		self.OnlyWhenClass[1] = -1
	end
end

function ENT:AcceptInput(name, caller, activator, arg)
	name = string_lower(name)

	if name == "seton" then
		self.On = tonumber(arg) == 1
		return true
	elseif name == "enable" then
		self.On = true
		return true
	elseif name == "disable" then
		self.On = false
		return true
	elseif name == "settouchclass" or name == "setendtouchclass" or name == "settouchdeathclass" or name == "setendtouchdeathclass" or name == "setonetime" or name == "setinstantchange" or name == "setonlywhenclass" then
		self:KeyValue(string_sub(name, 4), arg)
	end
end

function ENT:KeyValue(key, value)
	key = string_lower(key)
	if key == "enabled" then
		self.On = tonumber(value) == 1
	elseif key == "touchclass" then		
		self.TouchClass = string_lower(value)
	elseif key == "onlywhenclass" then
		self.OnlyWhenClass = {}
		if value == "disabled" then
			self.OnlyWhenClass[1] = -1
		else
			self.OnlyWhenClass[1] = -1

			for i, allowed_class in pairs(string_Explode(",", string_lower(value))) do
				self.OnlyWhenClass[i] = GrabKeyFromTables(string.lower(allowed_class))

				break
			end
		end
	elseif key == "endtouchclass" then
		self.EndTouchClass = string_lower(value)
	elseif key == "touchdeathclass" then
		self.TouchDeathClass = string_lower(value)
	elseif key == "endtouchdeathclass" then
		self.EndTouchDeathClass = string_lower(value)
	elseif key == "onetime" then
		self.OneTime = tonumber(value) == 1
	elseif key == "instantchange" then
		self.InstantChange = tonumber(value) == 1
	end
end

-- Start to fire!
local util_TraceHull = util.TraceHull
function ENT:Think()
	if E_GetTable(self).On then
		-- Its bug cause when its turn on and off so that not works.
		if ENTITY != self then
			ENTITY = self
			position = ENTITY:GetPos()
			b_min, b_max = ENTITY:GetCollisionBounds()
		end

		util_TraceHull({ignoreworld = true, start = position, endpos = position, mask = CONTENTS_EMPTY, mins = b_min, maxs = b_max, filter = DoTouch})
	end

	self:NextThink(CurTime() + 0.5) -- Delay

	return true
end

-- Do not use Touch because Entity can given NULL if someone disconnected or entity is removed.