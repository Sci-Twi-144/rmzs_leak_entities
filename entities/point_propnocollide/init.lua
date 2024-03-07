--[[SECURE]]--
ENT.Type = "point"

local pairs = pairs
local ents_FindByClass = ents.FindByClass
local ents_FindInSphere = ents.FindInSphere
local FVPHYSICS_PLAYER_HELD = FVPHYSICS_PLAYER_HELD
local string_match = string.match
local FrameTime = FrameTime
local Vector = Vector
local util_TraceLine = util.TraceLine
local MASK_SOLID_BRUSHONLY = MASK_SOLID_BRUSHONLY

function ENT:Initialize()
end

function ENT:SetProp( ent, bForced )
	self.m_entProp = ent

	if not IsValid(ent) then return end

	for _, e in pairs(ents_FindByClass(self:GetClass())) do
		if e ~= self and IsValid(e) and e.m_entProp == ent then return end
	end

	if bForced then
		self.ForceHeldTime = CurTime()+0.5
	end

	self.OldMaterial = ent:GetMaterial()

	ent:SetCollisionGroupState(false)
	ent:SetMaterial("models/spawn_effect")
	ent.bPushBackPlayers = true
end

function ENT:OnRemove()
	local ent = self.m_entProp
	if not IsValid(ent) then return end

	ent.bPushBackPlayers = nil
	if self.OldMaterial then
		ent:SetMaterial(self.OldMaterial)
	end
	
	local objphys = ent:GetPhysicsObject()
	if not IsValid(objphys) or not objphys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then
		ent:SetCollisionGroupState(true)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end

local ents_FindInBox = ents.FindInBox
function ENT:Think()
	local ent = self.m_entProp
	if not IsValid(ent) then
		self:Remove()
		return
	end

	local pushout = false
	local timeout = self.TimeOut and CurTime() >= self.TimeOut
	local rate = 900 * FrameTime()
	local center = ent:LocalToWorld(ent:OBBCenter())

	for _, pl in pairs(ents_FindInBox(ent:WorldSpaceAABB())) do
		if IsValid(pl) and pl:IsPlayer() and pl:Alive() and pl:Team() == TEAM_HUMAN and pl:OverlapsEntity(ent) and not (ent:IsBarricadeProp() and pl:GetBarricadeGhosting()) then
			pushout = true

			if timeout then
				if ent:IsBarricadeProp() then
					pl:SetBarricadeGhosting(true)
				end
			else
				local plpos = pl:LocalToWorld(pl:OBBCenter())
				local diff = plpos - center
				diff.z = 0
				diff:Normalize()
				local heading = diff * rate
				local starttrace = plpos + heading
				if util_TraceLine({start = starttrace, endpos = starttrace + Vector(0, 0, -80), mask = MASK_SOLID_BRUSHONLY}).Hit then
					pl:SetVelocity(heading)
				end
			end
		end
	end

	if (not pushout and (not self.ForceHeldTime or self.ForceHeldTime<CurTime())) or timeout then
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end
