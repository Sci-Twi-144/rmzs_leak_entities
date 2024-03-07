--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/elka/elka.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	local worldhint = ents.Create("point_worldhint")
	if worldhint:IsValid() then
		self.WorldHint = worldhint
		worldhint:SetPos(self:GetPos())
		worldhint:SetParent(self)
		worldhint:SetOwner(self)
		worldhint:Spawn()
		--worldhint:SetViewable(TEAM_HUMAN)
		worldhint:SetRange(3000)
		worldhint:SetHint("")
		--worldhint:SetTranslated(true)
	end
end

function ENT:OnTakeDamage(dmginfo)
	if true then return end
end

ENT.CaptureProgress = 0
ENT.NextVisThink = 0
ENT.HeatLevel = 0
function ENT:Think()
	if self.NextVisThink<=CurTime() then
		self.NextVisThink = CurTime() + 1
		local progress 
		local t = {}
		for _, ent in pairs(util.BlastAlloc(self, self, self:GetPos(), 100)) do
			if EntityIsPlayer(ent) and ent:Team() == TEAM_HUMAN then
				t[#t + 1] = ent
				local sum = 1 * #t
				self.HeatLevel = self.HeatLevel + sum
				net.Start("zs_updateprogressbar")
					net.WriteUInt(self.HeatLevel, 16)
					net.WriteInt(350, 16)
				net.Send(ent)
			end
		end
	end

	if self.HeatLevel >= 350 then
		for _, ent in pairs(team.GetPlayers(TEAM_HUMAN)) do
			net.Start("zs_updateprogressbar")
				net.WriteUInt(0, 16)
				net.WriteInt(0, 16)
			net.Send(ent)
		end

		for _, ent in pairs(util.BlastAlloc(self, self, self:GetPos(), 100)) do
			if EntityIsPlayer(ent) and ent:Team() == TEAM_HUMAN then
				if not ent:HasAward("won_newyear_gift") then
					ent:GiveAward("won_newyear_gift")

					local prerollruby = math.random(2000,4500)
					ent:PS_GivePoints(prerollruby)
					PrintMessage(HUD_PRINTTALK, "[color=233,75,75@"..ent:Name().."] ".. "открыл подарок и нашел" .. " [color=255,132,0@" .. prerollruby .. "] " .. "рубинов!")
				else
					GiveRareGift2(ent)
				end
			end
		end
		self:Remove()
	end
end
