ENT.Base = "base_point"
ENT.Type = "point"

ENT.InputDispatch = {}
ENT.EventQueue = {}

function ENT:Initialize()
	if not self.m_OutValue then self.m_OutValue = 0 end
	if not self.m_flMin then self.m_flMin = 0 end
	if not self.m_flMax then self.m_flMax = 0 end

	-- Make sure max and min are ordered properly or clamp won't work.
	if self.m_flMin > self.m_flMax then
		local flTemp = self.m_flMax
		self.m_flMax = self.m_flMin
		self.m_flMin = flTemp
	end

	-- Clamp initial value to within the valid range.
	if (self.m_flMin ~= 0) or (self.m_flMax ~= 0) then
		local flStartValue = math.Clamp(self.m_OutValue, self.m_flMin, self.m_flMax)
		self.m_OutValue = flStartValue
	end

	self.m_bHitMin = false
	self.m_bHitMax = false

	self.m_bDisabled = false
end

function ENT:DefineInputFunc( name, func )
	name = string.lower(name)
	self.InputDispatch[name] = func
end

function ENT:KeyValue( key, value )
	local lkey = string.lower(key)

	-- Set the initial value of the counter.
	if lkey == "startvalue" then
		self.m_OutValue = tonumber(value)
		return true
	elseif lkey == "min" then
		self.m_flMin = tonumber(value)
	elseif lkey == "max" then
		self.m_flMax = tonumber(value)
	end

	self:StoreOutput( key, value )
end

function ENT:AcceptInput( name, activator, caller, data )
	name = string.lower(name)

	local inputActionFunc = self.InputDispatch[name]

	if isfunction(inputActionFunc) then
		local inputdata = {
			name = name,
			pActivator = activator,
			pCaller = caller,
			value = data
		}

		inputActionFunc(self, inputdata)

		self:PostAcceptInput(name, activator, caller, data)

		return true
	end

	return false
end

function ENT:PostAcceptInput(name, activator, caller, data)
	-- Setup initial value
	if not self.m_InitialValue or self.m_InitialValue < self.m_OutValue then
		self.m_InitialValue = self.m_OutValue
	end

	if not self.m_LastValue or self.m_LastValue ~= self.m_OutValue then
		hook.Call("MathCounterUpdate", GAMEMODE, self, activator)
	end

	if self.m_bHitMin then
		hook.Call("MathCounterHitMin", GAMEMODE, self, activator)
	elseif self.m_bHitMax then
		hook.Call("MathCounterHitMax", GAMEMODE, self, activator)
	end

	self.m_LastValue = self.m_OutValue
end

function ENT:InputSetHitMax(inputdata)
	self.m_flMax = tonumber(inputdata.value)

	if self.m_flMax < self.m_flMin then
		self.m_flMin = self.m_flMax
	end

	self:UpdateOutValue(inputdata.pActivator, self.m_OutValue)
end

function ENT:InputSetHitMin(inputdata)
	self.m_flMin = tonumber(inputdata.value)

	if self.m_flMax < self.m_flMin then
		self.m_flMax = self.m_flMin
	end

	self:UpdateOutValue(inputdata.pActivator, self.m_OutValue)
end

function ENT:InputAdd(inputdata)
	if self.m_bDisabled then
		Msg("Math Counter "..self:GetName().." ignoring ADD because it is disabled\n")
		return
	end

	local fNewValue = self.m_OutValue + tonumber(inputdata.value)
	self:UpdateOutValue( inputdata.pActivator, fNewValue )
end

function ENT:InputDivide(inputdata)
	if self.m_bDisabled then
		Msg("Math Counter "..self:GetName().." ignoring DIVIDE because it is disabled\n")
		return
	end

	local flValue = tonumber(inputdata.value)
	if (flValue ~= 0) then
		local fNewValue = self.m_OutValue / flValue
		self:UpdateOutValue( inputdata.pActivator, fNewValue )
	else
		ErrorNoHalt("LEVEL DESIGN ERROR: Divide by zero in math_value\n")
		self:UpdateOutValue( inputdata.pActivator, self.m_OutValue )
	end
end

function ENT:InputMultiply(inputdata)
	if self.m_bDisabled then
		Msg("Math Counter "..self:GetName().." ignoring MULTIPLY because it is disabled\n")
		return
	end

	local fNewValue = self.m_OutValue * tonumber(inputdata.value)
	self:UpdateOutValue( inputdata.pActivator, fNewValue )
end

function ENT:InputSetValue(inputdata)
	if self.m_bDisabled then
		Msg("Math Counter "..self:GetName().." ignoring SETVALUE because it is disabled\n")
		return
	end

	self:UpdateOutValue( inputdata.pActivator, tonumber(inputdata.value) )
end

function ENT:InputSetValueNoFire(inputdata)
	if self.m_bDisabled then
		Msg("Math Counter "..self:GetName().." ignoring SETVALUENOFIRE because it is disabled\n")
		return
	end

	local flNewValue = tonumber(inputdata.value)
	if (( self.m_flMin != 0 ) || (self.m_flMax != 0 )) then
		flNewValue = math.Clamp(flNewValue, self.m_flMin, self.m_flMax)
	end

	self.m_OutValue = flNewValue
end

function ENT:InputSubtract(inputdata)
	if self.m_bDisabled then
		Msg("Math Counter "..self:GetName().." ignoring SUBTRACT because it is disabled\n")
		return
	end

	local fNewValue = self.m_OutValue - tonumber(inputdata.value)
	self:UpdateOutValue( inputdata.pActivator, fNewValue )
end

function ENT:InputGetValue(inputdata)
	self:QueueTriggerOutput("OnGetValue", inputdata.pActivator, self.m_OutValue)
end

function ENT:InputEnable(inputdata)
	self.m_bDisabled = false
end

function ENT:InputDisable(inputdata)
	self.m_bDisabled = true
end

function ENT:UpdateOutValue(pActivator, fNewValue)
	if !fNewValue then
		ErrorNoHalt("Math Counter " .. self:GetName() .. " received new out value which was nil (activator="..tostring(pActivator)..").\n")
		debug.Trace()
		fNewValue = 0
	end

	if (self.m_flMin != 0) || (self.m_flMax != 0) then
		-- Fire an output any time we reach or exceed our maximum value.
		if fNewValue >= self.m_flMax then
			if ( !self.m_bHitMax ) then
				self.m_bHitMax = true
				self:QueueTriggerOutput("OnHitMax", pActivator)
			end
		else
			self.m_bHitMax = false
		end

		-- Fire an output any time we reach or go below our minimum value.
		if ( fNewValue <= self.m_flMin ) then
			if ( !self.m_bHitMin ) then
				self.m_bHitMin = true
				self:QueueTriggerOutput("OnHitMin", pActivator)
			end
		else
			self.m_bHitMin = false
		end

		fNewValue = math.Clamp(fNewValue, self.m_flMin, self.m_flMax)
	end

	self:SetOutValue(fNewValue, pActivator)
end

function ENT:SetOutValue(fNewValue, pActivator)
	self.m_OutValue = fNewValue
	self:QueueTriggerOutput("OutValue", pActivator, self.m_OutValue)
end

function ENT:GetOutValue()
	return self.m_OutValue
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end

function ENT:QueueTriggerOutput( name, activator, data )
	table.insert(self.EventQueue, {self,name,activator, data})
end

ENT:DefineInputFunc("Add", ENT.InputAdd)
ENT:DefineInputFunc("Divide", ENT.InputDivide)
ENT:DefineInputFunc("Multiply", ENT.InputMultiply)
ENT:DefineInputFunc("SetValue", ENT.InputSetValue)
ENT:DefineInputFunc("SetValueNoFire", ENT.InputSetValueNoFire)
ENT:DefineInputFunc("Subtract", ENT.InputSubtract)
ENT:DefineInputFunc("SetHitMax", ENT.InputSetHitMax)
ENT:DefineInputFunc("SetHitMin", ENT.InputSetHitMin)
ENT:DefineInputFunc("GetValue", ENT.InputGetValue)
ENT:DefineInputFunc("Enable", ENT.InputEnable)
ENT:DefineInputFunc("Disable", ENT.InputDisable)

local EventQueue = ENT.EventQueue
local function EventQueueThink()
	while #EventQueue > 0 do
		local event = table.remove(EventQueue, 1)
		local ent = table.remove(event, 1)

		if IsValid(ent) then
			ent:TriggerOutput(unpack(event))
		end
	end
end
hook.Add("Think", "ProcessCounterEventQueue.LUA2", EventQueueThink)