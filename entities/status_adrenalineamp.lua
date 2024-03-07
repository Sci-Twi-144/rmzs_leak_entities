AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

if SERVER then
	function ENT:SetDie(fTime)
		if fTime == 0 or not fTime then
			self.DieTime = 0
		elseif fTime == -1 then
			self.DieTime = 999999999
		else
			self.DieTime = CurTime() + fTime
			self:SetDuration(fTime)
		end
	end
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local ent = self
	hook.Add("Move", tostring(ent), function(pl, move)
		if not IsValid(ent) then return end
		
		if pl ~= ent:GetOwner() then return end

		move:SetMaxSpeed(move:GetMaxSpeed() + ent:GetSpeed())
		move:SetMaxClientSpeed(move:GetMaxSpeed())
	end)
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)
	
	hook.Remove("Move", tostring(self))
end

function ENT:SetSpeed(speed)
	self:SetDTFloat(1, math.max(-15, speed))
end

function ENT:GetSpeed()
	return self:GetDTFloat(1)
end
