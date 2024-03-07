AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Ephemeral = true

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Magnitude", "Int", 1)

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if SERVER then
		self:EmitSound("physics/glass/glass_impact_bullet"..math.random(4)..".wav", 70, 85)
	end

	if CLIENT then
		local ent = self
		local ENTC = tostring(ent)

		hook.Add("PrePlayerDraw", ENTC, function(pl)
			if not IsValid(ent) then return end

			if pl ~= ent:GetOwner() then return end
		
			local b = 1 - math.abs(math.sin((CurTime() + ent:EntIndex()) * 3)) * 0.2
			render.SetColorModulation(0.1, 0.1, b)
		end)
		
		hook.Add("PostPlayerDraw", ENTC, function(pl)
			if not IsValid(ent) then return end

			if pl ~= ent:GetOwner() then return end
		
			render.SetColorModulation(1, 1, 1)
		end)

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
		
		hook.Add("RenderScreenspaceEffects", ENTC, function()
			if not IsValid(ent) then return end
			
			if MySelf ~= ent:GetOwner() then return end
		
			colModDimVision["$pp_colour_addb"] = ent:GetPower() * 0.2
			colModDimVision["$pp_colour_addg"] = ent:GetPower() * -0.05
			colModDimVision["$pp_colour_addr"] = ent:GetPower() * -0.13
			DrawColorModify(colModDimVision)
		end)
	end
end

function ENT:Think()
	if SERVER then
		local owner = self:GetOwner()
		if owner:IsValid() and owner:Alive() and owner:IsPlayer() then
		--if not owner:IsValid() or not owner:Alive() or not owner:IsPlayer() then self:Remove() return end
			local hpfr = owner:GetMaxHealthEx() / 10
			local hppercent = self:GetMagnitude() / hpfr
			if (self.DieTime - CurTime() - hppercent) <= 0 then
				self:SetMagnitude(self:GetMagnitude() - hpfr * 0.5)
				self:NextThink(CurTime() + 0.5)
				if self:GetMagnitude() <= 0 then
					self:Remove()
				end
			end
		else
			self:Remove()
		end
	end
	
	if SERVER and self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:UpdDuration(owner)
	if SERVER then
		local hppercent = owner:GetMaxHealthEx() / 10
		local afterdur = self:GetMagnitude() / hppercent
		self:SetDie(3 + afterdur)
	end
end

function ENT:UpdateMagnitude(ply, mag, dur)
	mag = math.ceil(mag)
	local curmag = self:GetMagnitude()
	local owner = self:GetOwner()
	if not owner:IsValid() or not owner:Alive() or not owner:IsPlayer() then self:Remove() return end
	--[[if (curmag + mag) >= owner:Health() then
		self:ProcessFreeze(ply, owner)
	else]]
	self.Applier = ply
	self:SetMagnitude(math.min(owner:GetMaxHealthEx(), curmag + mag))
	self:UpdDuration(owner)
end

function ENT:ProcessFreeze(appl, owner)
	local durmul = owner:Team() == TEAM_UNDEAD and (math.max(1, (5 - (owner:GetBossTier() + 1)))) or 3
	local buff = {Applier = appl}
	if owner:Alive() then
		owner:ApplyZombieDebuff("freeze", durmul, buff, true, 42)
	end
	self:Remove()
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	local ENTC = tostring(self)
	hook.Remove("PrePlayerDraw", ENTC)
	hook.Remove("PostPlayerDraw", ENTC)
	hook.Remove("RenderScreenspaceEffects", ENTC)
end

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end
