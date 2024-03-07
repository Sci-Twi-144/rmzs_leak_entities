--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Timer = 0
ENT.LastDamaged = 0
ENT.ForcedShit = false

function ENT:Initialize()

	--ambient\atmosphere\drone1lp.wav
	self:SetModel("models/props/cs_militia/militiarock05.mdl")
	self:PhysicsInitBox(Vector(-15, -35, 0), Vector(15, 35, 64))
	self:SetMaterial("models/flesh")
	self:GetRandomOwner()

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_ZOMBIE, ZS_COLLISIONFLAGS_ZOMBIE)

	self:SetNestMaxHealth(12500)
	self:SetNestCurHealth(12500)

	self:SetShield(false)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	--[[
	local ent = ents.Create("prop_nest_polip_tintacle")
	if ent:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z + 60
		pos.y = pos.y + 20
		ent:SetPos(pos)
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		self:DeleteOnRemove(ent)
	end]]

	local ent = ents.Create("prop_physics")
	if ent:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z + 8
		ent:SetModel("models/props_junk/trashcluster01a.mdl")
		ent:SetMaterial("models/flesh")
		ent:SetModelScale(1.2)
		ent:SetPos(pos)
		ent:SetAngles(self:GetAngles() * math.random(360))
		ent:Spawn()
		ent:SetParent(self)
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent:PhysicsInit(SOLID_NONE)
		self:DeleteOnRemove(ent)
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end

	local ent2 = ents.Create("prop_physics")
	if ent2:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z + 40
		ent2:SetModel("models/Gibs/HGIBS.mdl")
		ent2:SetMaterial("models/flesh")
		ent2:SetModelScale(2)
		ent2:SetPos(pos)
		ent2:SetAngles(self:GetAngles() + Angle(0, math.random(360), 0))
		ent2:Spawn()
		ent2:SetParent(self)
		ent2:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent2:PhysicsInit(SOLID_NONE)
		self:DeleteOnRemove(ent2)
		local phys = ent2:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end

	local ent2 = ents.Create("prop_physics")
	if ent2:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z + 10
		pos.y = pos.y + 20
		pos.x = pos.x + 10
		ent2:SetModel("models/Gibs/HGIBS.mdl")
		ent2:SetMaterial("models/flesh")
		ent2:SetModelScale(2)
		ent2:SetPos(pos)
		ent2:SetAngles(self:GetAngles() + Angle(0, math.random(360), 0))
		ent2:Spawn()
		ent2:SetParent(self)
		ent2:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent2:PhysicsInit(SOLID_NONE)
		self:DeleteOnRemove(ent2)
		local phys = ent2:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end

	local ent2 = ents.Create("prop_physics")
	if ent2:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z + 15
		pos.y = pos.y - 20
		pos.x = pos.x - 15
		ent2:SetModel("models/Gibs/HGIBS.mdl")
		ent2:SetMaterial("models/flesh")
		ent2:SetModelScale(1.5)
		ent2:SetPos(pos)
		ent2:SetAngles(self:GetAngles() + Angle(0, math.random(360), 0))
		ent2:Spawn()
		ent2:SetParent(self)
		ent2:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent2:PhysicsInit(SOLID_NONE)
		self:DeleteOnRemove(ent2)
		local phys = ent2:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end

	local ent2 = ents.Create("prop_physics")
	if ent2:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z + 3
		pos.y = pos.y - 40
		pos.x = pos.x + 5
		ent2:SetModel("models/Gibs/HGIBS.mdl")
		ent2:SetMaterial("models/flesh")
		ent2:SetModelScale(1.5)
		ent2:SetPos(pos)
		ent2:SetAngles(self:GetAngles() + Angle(0, math.random(360), 0))
		ent2:Spawn()
		ent2:SetParent(self)
		ent2:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent2:PhysicsInit(SOLID_NONE)
		self:DeleteOnRemove(ent2)
		local phys = ent2:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end

	local ent = ents.Create("prop_physics")
	if ent:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z - 1
		pos.y = pos.y - 63
		ent:SetModel("models/props/de_train/de_train_securityguard.mdl")
		ent:SetMaterial("models/flesh")
		ent:SetModelScale(1)
		ent:SetPos(pos)
		ent:SetAngles(Angle(5, 270, 0))
		ent:Spawn()
		ent:SetParent(self)
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent:PhysicsInit(SOLID_NONE)
		self:DeleteOnRemove(ent)
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end

	local ent = ents.Create("prop_physics")
	if ent:IsValid() then
		local pos = self:GetPos()
		pos.z = pos.z + 6.7
		pos.y = pos.y + 55
		pos.x = pos.x - 5
		ent:SetModel("models/gibs/strider_gib1.mdl")
		ent:SetMaterial("models/flesh")
		ent:SetModelScale(1)
		ent:SetPos(pos)
		ent:SetAngles(Angle(180, 140, 0))
		ent:Spawn()
		ent:SetParent(self)
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ent:PhysicsInit(SOLID_NONE)
		self:DeleteOnRemove(ent)
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end

	local worldhint = ents.Create("point_worldhint")
	if worldhint:IsValid() then
		self.WorldHint = worldhint
		worldhint:SetPos(self:GetPos())
		worldhint:SetParent(self)
		worldhint:Spawn()
		worldhint:SetViewable(TEAM_ZOMBIE)
		worldhint:SetRange(750)
		worldhint:SetHint("Defend this!")
		self:DeleteOnRemove(worldhint)
	end
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end

	if self.Timer < CurTime() then
		self.Timer = CurTime() + 1

		if ((CurTime() - self.LastDamaged) > 15) then
			self:SetNestCurHealth(math.min(self:GetNestCurHealth() + 50, self:GetNestMaxHealth()))
		end

		if not IsValid(self:GetOwner()) then
			self:GetRandomOwner()
		end

		if self:GetNestCurHealth() < 5000 and not self.OrbsOut then
			self.OrbsOut = true
			for k = 1, 2 do
				timer.Simple(0 + 6 * (k - 1), function()
					for i = 1, math.random(5, 8) do
						local ent = ents.Create("projectile_necrotic_orb_universal")
						local randomvec = Vector(math.random(-100, 100), math.random(-100, 100), 20)
						if ent:IsValid() then
							ent:SetPos(self:GetPos() + randomvec)
							ent:SetOwner(self:GetOwner())
							ent.OffsetDieTime = math.random(3)
							for _, ent2 in pairs(util.BlastAlloc(self, self:GetOwner(), self:GetPos(), 500)) do
								if ent2:IsValidLivingHuman() then
									ent.Killer = ent2
									break
								end
							end
							ent:Spawn()
						end
					end
				end)
			end
		end

		if self:GetNestCurHealth() > 5500 and self.OrbsOut then -- retard balls out
			self.OrbsOut = false
		end

		if self:GetNestCurHealth() < 3500 and not self:GetShield() then -- x0.35 dmg
			self:SetShield(true)
		end

		if self:GetNestCurHealth() > 4000 and self:GetShield() then
			self:SetShield(false)
		end

		if self:GetNestCurHealth() >= self:GetNestMaxHealth() and self.ForcedShit then
			self.ForcedShit = false
		end

		if self:GetNestCurHealth() < 2500 and not self.ForcedShit then -- last try to save this
			if math.random(5) == 1 then
				self.ForcedShit = true

				net.Start("zs_director_notify")
					net.WriteInt(6, 5)
				net.Broadcast()

				local bots = player.GetBots()
				for i = 1, #bots do
					local bot = bots[i]
					if bot:IsBot() and (bot:GetBossTier() < 1) and bot:IsBot() then
						GAMEMODE.ShouldSpawnOnSpecialPlace = self
						GAMEMODE:SpawnDemibossByDirector(bot)
						GAMEMODE.ShouldSpawnOnSpecialPlace = false
					end
				end
			end
		end

		local allzombies = team.GetPlayers(TEAM_UNDEAD)
		for i = 1, #allzombies do -- free points for zteam
			local pl = allzombies[i]
			local num = (tobool(pl:GetDemiBossProgress()) and tobool(pl:GetDemiBossProgress() < 1000)) and 10 or 0
			pl:AddDemibossProgress(num, true)
		end

		GAMEMODE.ShouldSpawnOnSpecialPlace = false
	end

	local mul = 1 + math.abs(math.sin(CurTime() * 0.5)) * 0.1
	local mul2 = 1 + math.abs(math.sin(CurTime() * 2))

	for _, ent in pairs(ents.FindInSphere(self:GetPos(), 100)) do
		if ent and (ent:GetClass() == "prop_physics") then
			if ent:GetModel() == "models/gibs/hgibs.mdl" then
				ent:SetModelScale(2 * mul2, 1.5)
			end

			if (ent:GetModel() == "models/props_junk/trashcluster01a.mdl") and not ent.DontTouchMe then
				ent:SetModelScale(1.2 * mul, 1)
			end
		end
	end
end

function ENT:GetRandomOwner()
	local bots = #player.GetBots()
	local random = math.random(bots)
	local pl = player.GetBots()[random]
	self:SetOwner(pl)
end


function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	local damage = dmginfo:GetDamage()
	local attacker = dmginfo:GetAttacker()

	damage = damage * (dmginfo:GetInflictor().FlyingControllable and 0.3 or 1) 

	damage = damage * (self:GetShield() and 0.35 or 1)
	
	if attacker:IsValidLivingHuman() then
		local points = (damage * 2.35) / self:GetNestMaxHealth() * 5

		PointQueue[attacker] = PointQueue[attacker] + points

		local pos = self:GetPos()
		pos.z = pos.z + 32

		LastDamageDealtPos[attacker] = pos
		LastDamageDealtTime[attacker] = CurTime()
	end

	self:SetNestCurHealth(self:GetNestCurHealth() - damage)
	self.LastDamaged = CurTime()
	
	if self:GetNestCurHealth() <= 0 then

		net.Start("zs_nestnotifier")
			net.WriteString(self:GetClass())
			net.WriteString(dmginfo:GetInflictor():GetClass())
			net.WriteEntity(attacker)
		net.Broadcast()

		self:Remove()
	end
end

function ENT:OnRemove()
	net.Start("zs_director_notify")
		net.WriteInt(7, 5)
	net.Broadcast()

	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
	util.Effect("explosion_bonemesh", effectdata)

	--util.Blood(self:GetPos(), 250, self:GetAngles():Normalize(), 1000, true)
end