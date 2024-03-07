AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local ent = self
	local ENTC = tostring(ent)
	local power = math.Clamp(ent:GetStartTime() + ent:GetDuration() - CurTime(), 0, 1)

	if CLIENT then
		hook.Add("RenderScreenspaceEffects", ENTC, function()
			if not IsValid(ent) then return end

			if MySelf ~= ent:GetOwner() then return end

			DrawMotionBlur(0.1, power * 0.3, 0.01)
		end)
	end
end

function ENT:OnRemove()
	local ENTC = tostring(self)
	local owner = self:GetOwner()

	if SERVER then
		timer.Simple(0, function() owner:ResetJumpPower() owner.FunnyCrabBiteCount = 0 end)
	end	

	if CLIENT then
		hook.Remove("RenderScreenspaceEffects", ENTC)
	end	
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
	self:GetOwner():ResetJumpPower()
end