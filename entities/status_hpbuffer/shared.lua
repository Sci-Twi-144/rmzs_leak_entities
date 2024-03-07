AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Magnitude", "Int", 1)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	print("init")

	if SERVER then
		local enty = self
		self:CreateSVHook(enty)
	end	
end

function ENT:UpdateMagnitude(ply, mag, dur)
	local curmag = self:GetMagnitude()
	self:SetMagnitude(curmag + mag)
	if IsValid(ply) and SERVER then
		self.Appliers[ply] = (self.Appliers[ply] or 0) + (self:GetMagnitude() - curmag)
		if self.Appliers[ply] <= 0 then self.Appliers[ply] = nil end
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if SERVER then
		self:GetOwner().HpBuffered = nil
		self:RemoveSVHook(tostring(self))
	end	
end