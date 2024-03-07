include("shared.lua")

function ENT:Initialize()
	local ent = self
	hook.Add("CreateMove", tostring(ent), function(cmd)
		if not IsValid(self) then return end
		
		if MySelf ~= ent:GetOwner() then return end
	
		local ang = cmd:GetViewAngles()
		ang.yaw = ent.CommandYaw or ang.yaw
		cmd:SetViewAngles(ang)
	
		cmd:ClearButtons(0)
		cmd:ClearMovement()
	end)

	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()
	if owner:IsValid() then
		Revive[owner] = self

		self.CommandYaw = owner:GetAngles().yaw

		owner:CallWeaponFunction("KnockedDown", self, false)
		owner:CallZombieFunction("KnockedDown", self, false)
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then
		Revive[owner] = nil
	end

	hook.Remove("CreateMove", tostring(self))
end

function ENT:Think()
	local endtime = self:GetReviveTime()
	if endtime == 0 then return end

	local owner = self:GetOwner()
	if owner:IsValid() then
		local rag = owner:GetRagdollEntity()
		if rag and rag:IsValid() then
			local phys = rag:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:ComputeShadowControl({secondstoarrive = 0.05, pos = owner:GetPos() + Vector(0,0,16), angle = phys:GetAngles(), maxangular = 2000, maxangulardamp = 10000, maxspeed = 5000, maxspeeddamp = 1000, dampfactor = 0.85, teleportdistance = 200, deltatime = FrameTime()})
			end
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Draw()
end
