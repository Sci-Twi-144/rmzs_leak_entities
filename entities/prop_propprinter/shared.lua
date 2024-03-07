ENT.Type = "anim"

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.CanPackUp = true

ENT.IsBarricadeObject = true
ENT.AlwaysGhostable = true

ENT.Delay = 1

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)

	if health <= 0 and not self.Destroyed then
		self.Destroyed = true
	end
end

function ENT:GetObjectHealth()
	return self:GetDTFloat(0)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(1, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(0, ent)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(0)
end

function ENT:ClearObjectOwner()
	self:SetObjectOwner(NULL)
end

function ENT:SetProp(ent)
	self:SetDTEntity(2, ent)
end

function ENT:SetBuilding(b)
	self:SetDTBool(0, b)
end

function ENT:SetPropName(s)
	self:SetDTString(0, s)
end

function ENT:SetBuildingTimer(time)
	self:SetDTFloat(2, time)
end

function ENT:GetBuilding()
	return self:GetDTBool(0)
end

function ENT:GetPropName()
	return self:GetDTString(0)
end

function ENT:GetBuildingTimer()
	return self:GetDTFloat(2)
end

function ENT:GetBuildTime()
	return self:GetDTInt(0)
end

function ENT:GetProp()
	return self:GetDTEntity(2)
end

function ENT:GetBuilder()
	return self:GetDTEntity(3)
end

function ENT:SetArsenalBool(bool)
	for _, item in pairs(GAMEMODE.Items) do
		if item.Prop then
			GAMEMODE.Items[item.Signature].Blocked = bool
		end
	end
end

function ENT:SetGlobalPrinter(ent)
	GAMEMODE.BestPrinter = ent
end

function ENT:DoShit()
	if CLIENT then
		RunConsoleCommand("zs_buytransponderprop", "oildrum")
	end
	if SERVER then
		print("button")
	end
end

function ENT:SetObjectLinkUp(ent)
	self:SetDTEntity(1, ent)
end

function ENT:GetObjectLinkUp()
	return self:GetDTEntity(1)
end

function ENT:GetTime()
	return self:GetDTInt(10)
end

function ENT:SetTime(time)
	self:SetDTInt(10, time)
end