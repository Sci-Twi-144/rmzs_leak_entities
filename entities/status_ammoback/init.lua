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

ENT.NamesOfAmmo = {
	["ar2"] = true,
	["pistol"] = true,
	["smg1"] = true,
	["357"] = true,
	["xbowbolt"] = true,
	["buckshot"] = true,
	["chemical"] = true,
	["pulse"] = true,
	["impactmine"] = true
}

function ENT:CreateSVHook(enty)
	hook.Add("AmmoCheckHook", tostring(enty), function(ent, num, type)
		--print(ent)
		if not IsValid(self) then return end
		local ply = ent:GetOwner()
		if ply ~= enty:GetOwner() then return end

		if ply:IsValidLivingHuman() and self.NamesOfAmmo[type] then
			local numofammoCache = GAMEMODE.AmmoCache[type]
			numofammoCache = numofammoCache <= 4 and 8 or numofammoCache
			local cond = num / (numofammoCache / 4)
	
			local tbl = rawget(AmmoStatusCacheTBL, ply)
			if not tobool(tbl) or table.IsEmpty(tbl) then tbl = {} end
			tbl[type] = (tbl[type] or 0) + cond
			rawset(AmmoStatusCacheTBL, ply, tbl)

			--print(tbl[type])

			if tbl[type] > 1 then
				tbl[type] = 0
				ply:GiveAmmo( 1, type, true )
				--print("ammo")
			end

			if enty.Applier and enty.Applier:IsValidLivingHuman() then
				local applier = enty.Applier
				PointQueue[applier] = PointQueue[applier] + cond / 2
				--print("points: "..PointQueue[applier])
				local pos = ent:GetPos()
				pos.z = pos.z + 32
				LastDamageDealtPos[applier] = pos
				LastDamageDealtTime[applier] = CurTime()
			end
		end
	end)

	self:SetDTInt(1, 0)
end

function ENT:RemoveSVHook(ENTC)
	hook.Remove("AmmoCheckHook", ENTC)
end