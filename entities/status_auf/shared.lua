AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Stacks", "Int", 1)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	local ent = self
	local ENTC = tostring(ent)
	local power = math.Clamp(ent:GetStartTime() + ent:GetDuration() - CurTime(), 0, 1)

	if CLIENT then
		local overlay = Material("effects/tp_eyefx/tpeye")
		hook.Add("RenderScreenspaceEffects", ENTC, function()
			if not IsValid(ent) then return end

			if MySelf ~= ent:GetOwner() then return end

			DrawMotionBlur(0.1, power * 0.3, 0.01)
			overlay:SetFloat("$alpha", 0.05)
			DrawMaterialOverlay("effects/tp_eyefx/tpeye", -0.05)
			DrawMaterialOverlay("effects/invuln_overlay_blue", -0.15)
		end)

		hook.Add("HUDPaint", ENTC, function()
			if not IsValid(ent) then return end

			if MySelf ~= ent:GetOwner() then return end

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("effects/invuln_overlay_red") )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH())
		end)
	end

	if SERVER then
		self:CreateSVHook(ent)
	end	
end

function ENT:OnRemove()
	local ENTC = tostring(self)
	local owner = self:GetOwner()

	if CLIENT then
		hook.Remove("RenderScreenspaceEffects", ENTC)
		hook.Remove("HUDPaint", ENTC)
	end	

	if SERVER then
		self:RemoveSVHook(ENTC)
	end	
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end