AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.Seed = math.Rand(0, 10)

	SpawnProtection[self:GetOwner()] = true
end

function ENT:PlayerSet(pl)
	SpawnProtection[pl] = true
	self:SetStartTime(CurTime())
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	SpawnProtection[self:GetOwner()] = false
end

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
