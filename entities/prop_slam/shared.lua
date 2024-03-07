ENT.Type = "anim"
ENT.Base = "prop_detpack"

ENT.ExplosionDelay = 0.25
ENT.ArmTime = 2.5

function ENT:GetScanFilter()
	if GAMEMODE.AllowFriendlyFireCollision then
		return {self}
	end
	local filter = table.Copy(team.GetPlayers(TEAM_HUMAN))
	filter[#filter + 1] = self
	filter = table.Add(filter, ents.FindByClass("prop_ffemitterfield"))
	filter = table.Add(filter, ents.FindByClass("projectile_*"))

	return filter
end

ENT.NextCache = 0
function ENT:GetCachedScanFilter()
	if CurTime() < self.NextCache and self.CachedFilter then return self.CachedFilter end

	self.CachedFilter = self:GetScanFilter()
	self.NextCache = CurTime() + 1

	return self.CachedFilter
end