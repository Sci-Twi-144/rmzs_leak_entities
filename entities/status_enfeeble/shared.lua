AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.DamageScale = 1.1 -- based

ENT.Model = Model("models/gibs/HGIBS.mdl")

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Stacks", "Int", 1)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetModel(self.Model)
	self:DrawShadow(false)

	local ent = self
	local ENTC = tostring(ent)
	local power = math.Clamp(ent:GetStartTime() + ent:GetDuration() - CurTime(), 0, 1)

	if SERVER then
		self:CreateSVHook(ENTC)
	end

	if CLIENT then
		hook.Add("PrePlayerDraw", ENTC, function(pl)
			if not IsValid(ent) then return end

			if pl ~= ent:GetOwner() then return end

			local r = 1 - math.abs(math.sin((CurTime() + ent:EntIndex()) * 3)) * 0.2
			render.SetColorModulation(r, 0.1, 0.1)
		end)

		hook.Add("PostPlayerDraw", ENTC, function(pl)
			if not IsValid(ent) then return end

			if pl ~= ent:GetOwner() then return end

			render.SetColorModulation(1, 1, 1)
		end)

		hook.Add("RenderScreenspaceEffects", ENTC, function()
			if not IsValid(ent) then return end

			if MySelf ~= ent:GetOwner() then return end

			DrawMotionBlur(0.1, power * 0.3, 0.01)
		end)
	end
end

function ENT:OnRemove()
	local ENTC = tostring(self)

	if SERVER then
		self:RemoveSVHook(ENTC)
	end	

	if CLIENT then
		hook.Remove("PrePlayerDraw", ENTC)
		hook.Remove("PostPlayerDraw", ENTC)
		hook.Remove("RenderScreenspaceEffects", ENTC)
	end	
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end