--[[SECURE]]--

ENT.Type = "brush"
ENT.ObjectiveNum = 0

function ENT:Initialize()
end

function ENT:InitTo( info )
	self:PhysicsInitBox(Vector(0,0,0),info[3]-info[2])
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetTrigger(true)
	self.ObjectiveNum = info[1]
end

function ENT:StartTouch(ent)
	if not self.Done and IsValid(ent) and ent:IsPlayer() and ent:Team()==TEAM_HUMAN then
		self.Done = true
		gamemode.Call("ObjectiveTrigger", ent, self.ObjectiveNum)
		SafeRemoveEntityDelayed(self,0.01)
	end
end