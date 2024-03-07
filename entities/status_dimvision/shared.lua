ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:DrawShadow(false)

	if CLIENT then
		local ent = self
		local ENTC = tostring(self)

		local colModDimVision = {
			["$pp_colour_colour"] = 1,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_mulr"]	= 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0,
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0
		}

		hook.Add("HUDPaint", ENTC, function()
			if not IsValid(ent) then return end

			if MySelf ~= ent:GetOwner() then return end

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("effects/invuln_overlay_dark") )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH())
		end)

		hook.Add("CalcView", ENTC, function( ply, pos, angles, fov)	
			if not IsValid(ent) then return end

			if MySelf ~= ent:GetOwner() then return end

			local view = {}
			local dur = ent:GetDim() * -2 + CurTime() 
			view.origin = origin
			view.angles = angles
			view.fov = fov
			
			local mul = math.min(1,(CurTime() - dur) / 3)
			view.fov = fov - mul * 30
			if CurTime() - dur >= 10 then
				mul = 1 - math.max(math.min(1,(CurTime() - dur - 10) / 3), 0)
				view.fov = fov - mul * 30
			end
			return view
		end)

		local overlay = Material("effects/tp_eyefx/tpeye")
		hook.Add("RenderScreenspaceEffects", ENTC, function()
			if not IsValid(ent) then return end

			if MySelf ~= ent:GetOwner() then return end

			overlay:SetFloat("$alpha", 0.05 * ent:GetDim())
			DrawMaterialOverlay("effects/tp_eyefx/tpeye", -0.05)
			DrawMaterialOverlay("effects/invuln_overlay_blue", -0.15)

			colModDimVision["$pp_colour_brightness"] = ent:GetDim() * -0.15
			DrawColorModify(colModDimVision)
		end)
	end

	--self:GetOwner().DimVision = self
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

--	self:GetOwner().DimVision = nil

	local ENTC = tostring(self)
	hook.Remove("RenderScreenspaceEffects", ENTC)
	hook.Remove("CalcView", ENTC)
	hook.Remove("HUDPaint", ENTC)
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())

	local owner = self:GetOwner()
	if owner:IsValid() and owner.VisionAlterDurationMul then
		local newdur = self:GetDuration() * owner.VisionAlterDurationMul
		self.DieTime = CurTime() + newdur
		self:SetDuration(newdur)
	end
end
