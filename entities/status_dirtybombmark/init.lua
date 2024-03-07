--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

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

function ENT:CreateSVHook(ENTC)
	local enty = self
	--print("check")

	hook.Add("HumanKilledZombie", ENTC, function(pl, attacker, inflictor, dmginfo, headshot, suicide)
		if not IsValid(enty) then return end

		if pl ~= enty:GetOwner() then return end

		if attacker:IsValid() and not suicide then
			--print("wtf")
			local proj = ents.Create("projectile_necrotic_orb_universal")
			if proj:IsValid() then
				proj:SetPos(pl:GetPos() + Vector(0, 0, 32))
				proj:SetOwner(self:GetOwner())
				proj.Killer = attacker
				proj:Spawn()
			end
		end
	end)

	self:EmitSound("beams/beamstart5.wav", 65, 140)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("HumanKilledZombie", ENTC)
end