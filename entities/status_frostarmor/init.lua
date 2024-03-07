--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Appliers = {}

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

--[[function ENT:Think()
	local owner = self:GetOwner()
	print("lol")
	if self:GetMagnitude() <= 0 or owner:Team() == TEAM_UNDEAD then
	print("bebra")
		self:Remove()
		return
	end
	
	self:NextThink(CurTime() + 0.1)
	return true
end]]

--[[function ENT:CreateSVHook(enty)
	hook.Add("SpecialPlayerDamage", tostring(enty), function(ent, dmginfo)
		if not IsValid(self) then return end
		local owner = enty:GetOwner()
		local attacker = dmginfo:GetAttacker()
		local inflictor = dmginfo:GetInflictor()
		local armory = enty
		print(self)
		
		if inflictor:GetClass() == "env_cryoinduction" and inflictor:GetOwner() == owner then
			self.DieTime = self.DieTime + math.floor(dmginfo:GetDamage() * 0.1)
			self:SetDuration(self:GetDuration() + math.floor(dmginfo:GetDamage() * 0.1))
			armory:UpdateMagnitude(self.Applier, dmginfo:GetDamage() * 0.5)
			local damageabs = dmginfo:GetDamage()
			dmginfo:SetDamage(dmginfo:GetDamage() - damageabs)
		elseif (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD) then

			local applier, _ = next( enty.Appliers )

			attacker:AddLegDamageExt(dmginfo:GetDamage(), owner, owner:GetActiveWeapon(), SLOWTYPE_COLD)
			owner:EmitSound("physics/glass/glass_largesheet_break"..math.random(1, 3)..".wav", 75, math.Rand(160, 180))
			
			local dmgbuffer = math.min(armory:GetMagnitude(), dmginfo:GetDamage())
			local points = dmgbuffer / dmginfo:GetDamage() * 10
			if self.Applier ~= owner then
				self.Applier:AddPoints(points)
			end
			dmginfo:SetDamage(dmginfo:GetDamage() - dmgbuffer)
			armory:UpdateMagnitude(self.Applier, -dmgbuffer)
		end
		
		if self:GetMagnitude() <= 0 or owner:Team() == TEAM_UNDEAD then
		
			self:Remove()
			return
		end
	end)

	self:SetMagnitude(0)
end


function ENT:RemoveSVHook(ENTC)
	hook.Remove("PlayerHurt", ENTC)
end]]