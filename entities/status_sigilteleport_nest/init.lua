--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Push = true

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer:SendLua("MySelf:EmitSound(\"ambient/machines/thumper_hit.wav\", 100, 50, 1)")

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	local enty = self
	local ENTC = tostring(ent)
	hook.Add("SpecialPlayerDamage", ENTC, function(ent, dmginfo)
		if not IsValid(self) then return end
		
		local owner = enty:GetOwner()
		local attacker = dmginfo:GetAttacker()

		if ent == owner and (attacker:IsValid() and (attacker == owner or (owner:IsPlayer() and attacker:IsPlayer() and attacker:Team() ~= owner:Team()))) and not dmginfo:GetInflictor().IsStatus then
			enty:SetStartTime(CurTime())
			enty:SetEndTime(CurTime() + 2)
		end
	end)

	hook.Add("SetupPlayerVisibility", ENTC, function(pl)
		if not IsValid(enty) then return end
		
		if enty:GetOwner() ~= pl or not enty:GetSigilSight() then return end

		local sigil = enty:GetTargetSigil()
		if not sigil or not sigil:IsValid() then return end

		AddOriginToPVS(sigil:WorldSpaceCenter()+Vector(0,0,64))
	end)
end

function ENT:OnRemove()
	hook.Remove("SpecialPlayerDamage", tostring(self))
	hook.Remove("SetupPlayerVisibility", tostring(self))
end

function ENT:Think()
	local owner = self:GetOwner()
	local froms = self:GetFromSigil()
	local target = self:GetTargetSigil(true)

	if self:GetSigilSight() then return end

	if CurTime() >= self:GetEndTime() then
		owner:DoSigilTeleport(target, froms, nil, self:GetNestTP())
		self:Remove()
	end

	self:GetTargetSigil()

	print(owner:GetPos():DistToSqr(froms:GetPos()))

	if froms and froms:IsValid() and (owner:GetPos():DistToSqr(froms:GetPos()) > 7500) then
		self:Remove()
	end

	self:NextThink(CurTime() + 0.3)
	return true
end
