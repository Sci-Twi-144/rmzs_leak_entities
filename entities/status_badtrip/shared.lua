AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Stacks", "Int", 1)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
	if SERVER then
		self:Processing()
	end
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local ent = self
	local ENTC = tostring(ent)

	if CLIENT then

		hook.Add("RenderScreenspaceEffects", ENTC, function()
			if not IsValid(ent) then return end
			
			if MySelf ~= ent:GetOwner() then return end

			if ent:GetStacks() < 3 then return end

			DrawSobel(1)
			DrawToyTown(2, ScrH())
			DrawSharpen(40 * ent:GetDim(), math.sin(CurTime() * 0.5) * 48)
		end)

		hook.Add("CalcView", ENTC, function(pl, origin, angles, fov, znear, zfar)
			if not IsValid(ent) then return end
			
			if MySelf ~= ent:GetOwner() then return end

			if ent:GetStacks() < 3 then return end

			local ang = angles
			ang.roll = ang.roll + math.sin(CurTime() * 0.5) * (15 * ent:GetDim())

			local matan = 5 * math.sin(CurTime())
			ang.pitch = math.NormalizeAngle(ang.pitch + ((matan * math.cos(CurTime() * 0.65)) * ent:GetDim()))
			ang.yaw = math.NormalizeAngle(ang.yaw + ((-matan * math.cos(CurTime() * 0.65)) * ent:GetDim()))
			
			return {origin = origin, angles = ang}
		end)
		
	end

	hook.Add("Move", ENTC, function(pl, move)
		if not IsValid(ent) then return end
		
		if pl ~= ent:GetOwner() then return end

		if ent:GetStacks() < 3 then return end

		move:SetMaxSpeed(move:GetMaxSpeed() - 60)
		move:SetMaxClientSpeed(move:GetMaxSpeed())
	end)

	local ENTC = tostring(ent)
end 

function ENT:RemoveHook()
	local ENTC = tostring(self)
	if CLIENT then
		hook.Remove("RenderScreenspaceEffects", ENTC)
		hook.Remove("CalcView", ENTC)
	end
	hook.Remove("Move", ENTC)
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)
	self:RemoveHook()

	if SERVER then
		self:GetOwner():ApplyTrinkets()
	end
end