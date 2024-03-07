ENT.Type = "anim"
ENT.Base = "status__base"

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self.Seed = math.Rand(0, 10)

	local ent = self
	if CLIENT then
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

		local overlay = Material("effects/tp_eyefx/tpeye")
		hook.Add("RenderScreenspaceEffects", tostring(ent), function()
			if not IsValid(self) then return end

			if MySelf ~= ent:GetOwner() then return end
		
			overlay:SetFloat("$alpha", 0.05 * ent:GetPower())
			DrawMaterialOverlay("effects/tp_eyefx/tpeye", -0.05)
		
			colModDimVision["$pp_colour_addg"] = ent:GetPower() * 0.15
			DrawColorModify(colModDimVision)
		end)
	end

	hook.Add("Move", tostring(ent), function(pl, move)
		if not IsValid(self) then return end
		
		if pl ~= ent:GetOwner() then return end
	
		local sloweffect = 0.4
	
		move:SetMaxSpeed(move:GetMaxSpeed() * sloweffect)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * sloweffect)
	end)
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if CLIENT then
		hook.Remove("RenderScreenspaceEffects", tostring(self))
	end
	hook.Remove("Move", tostring(self))
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end
