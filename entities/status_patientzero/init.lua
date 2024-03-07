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

function ENT:CreateSVHook(ENTC, enty)
	hook.Add("SpecialPlayerDamage", ENTC, function(ent, dmginfo)
		if not IsValid(self) then return end
		
		local attacker = dmginfo:GetAttacker()
		if attacker == enty:GetOwner() and attacker:IsValidLivingZombie() then
			local dmg = dmginfo:GetDamage()
			local extradamage = dmg * 0.15
			dmginfo:SetDamage(dmg + extradamage)

			if ent:IsValidLivingHuman() and dmg >= 15 and math.random(4) == 1 then
				if enty:GetType() == 1 then
					ent:ApplyZombieDebuff("frightened", 5, {Applier = attacker}, true, 39)
				elseif enty:GetType() == 2 then
					ent:ApplyZombieDebuff("enfeeble", 5, {Applier = attacker, Stacks = 3}, true, 6)
				elseif enty:GetType() == 3 then
					local bleed = ent:GiveStatus("bleed")
					if bleed and bleed:IsValid() then
						bleed:AddDamage(15)
						bleed.Damager = enty:GetOwner()
						bleed:SetType(1)
					end
				elseif enty:GetType() == 4 then
					ent:PoisonDamage(15, enty:GetOwner(), enty:GetOwner():GetActiveWeapon(), ent:GetPos())
				end
			end
		end
	
		if ent == enty:GetOwner() and attacker:IsValidHuman() then
			if bit.band(dmginfo:GetDamageType(), DMG_SLASH) == 0 and bit.band(dmginfo:GetDamageType(), DMG_CLUB) == 0 then
				dmginfo:SetDamage(dmginfo:GetDamage() * 0.9)
			else
				dmginfo:SetDamage(dmginfo:GetDamage() * 1.2)
			end
		end
	end)

	self:SetDTInt(1, 0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("SpecialPlayerDamage", ENTC)
end

function ENT:Think()
	local owner = self:GetOwner()
	if self.DieTime <= CurTime() or not (owner:IsValidLivingZombie() and not owner:GetZombieClassTable().Boss) then self:Remove() end
end

--[[
function ENT:CreateSVHook(ENTC, enty)
	hook.Add("SpecialPlayerDamage", ENTC, function(ent, dmginfo)
		if not IsValid(self) then return end
		
		local attacker = dmginfo:GetAttacker()
		if attacker == enty:GetOwner() and attacker:IsValidLivingZombie() then
			local dmg = dmginfo:GetDamage()
			local extradamage = dmg * 0.15
			dmginfo:SetDamage(dmg + extradamage)
	
			if ent:IsValidLivingHuman() and dmg >= 15 and math.random(4) == 1 then
				ent:GiveStatus(math.random(2) == 1 and "enfeeble" or "frightened", 5)
			end
		end
	
		if ent == enty:GetOwner() and attacker:IsValidHuman() then
			if bit.band(dmginfo:GetDamageType(), DMG_SLASH) == 0 and bit.band(dmginfo:GetDamageType(), DMG_CLUB) == 0 then
				dmginfo:SetDamage(dmginfo:GetDamage() * 0.9)
			else
				dmginfo:SetDamage(dmginfo:GetDamage() * 1.2)
			end
		end
	end)

	self:SetDTInt(1, 0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("SpecialPlayerDamage", ENTC)
end
]]
--[[
function ENT:Think()
	local owner = self:GetOwner()
	if not (owner:IsValidLivingZombie() and not owner:GetZombieClassTable().Boss) then self:Remove() end
end
]]