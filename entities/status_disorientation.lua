AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.LifeTime = 3

ENT.Ephemeral = true

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.DieTime = CurTime() + self.LifeTime

	if CLIENT then
		local ent = self
		local ENTC = tostring(ent)

		hook.Add("CreateMove", ENTC, function(cmd)
			if not IsValid(ent) then return end

			if MySelf ~= ent:GetOwner() then return end

			local curtime = CurTime()
			local frametime = FrameTime()
			local power = ent:GetPower()

			local ang = cmd:GetViewAngles()
			ang.pitch = math.Clamp(ang.pitch + math.sin(curtime) * 40 * frametime * power, -89, 89)
			ang.yaw = math.NormalizeAngle(ang.yaw + math.cos(curtime + ent.Seed) * 50 * frametime * power)

			cmd:SetViewAngles(ang)
		end)

		hook.Add("RenderScreenspaceEffects", ENTC, function()
			if not IsValid(ent) then return end
			
			if MySelf ~= ent:GetOwner() then return end

			local power = ent:GetPower()

			DrawMotionBlur(0.1, power, 0.05)
		end)

		self.Seed = math.Rand(0, 10)
	end

	local parent = self:GetParent()
	if parent:IsValid() and (SERVER or CLIENT and MySelf == parent) then
		parent:SetDSP(35)
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	local ENTC = tostring(self)
	hook.Remove("CreateMove", ENTC)
	hook.Remove("CreateMove", ENTC)
end

if SERVER then return end

function ENT:GetPower()
	return math.Clamp(self.DieTime - CurTime(), 0, 1)
end
