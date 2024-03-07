ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = ""
ENT.Category = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.CanPackUp = true
ENT.PackUpTime = 1

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.NoPropDamageDuringWave0 = true
ENT.EntityDeployable = true
ENT.ForceDamageFloaters = true

ENT.ExplosionDelay = 1

function ENT:GetScanFilter()
	if GAMEMODE.AllowFriendlyFireCollision then
		return {self}
	end
	local filter = table.Copy(team.GetPlayers(TEAM_HUMAN))
	filter[#filter + 1] = self
	return filter
end

ENT.NextCache = 0
function ENT:GetCachedScanFilter()
	if CurTime() < self.NextCache and self.CachedFilter then return self.CachedFilter end

	self.CachedFilter = self:GetScanFilter()
	self.NextCache = CurTime() + 1

	return self.CachedFilter
end

function ENT:SetExplodeTime(time)
	self:SetDTFloat(0, time)
end

function ENT:GetExplodeTime()
	return self:GetDTFloat(0)
end

function ENT:SetObjectOwner(owner)
	self:SetOwner(owner)
end

function ENT:GetObjectOwner()
	return self:GetOwner()
end
