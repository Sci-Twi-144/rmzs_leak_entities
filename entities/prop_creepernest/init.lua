--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NextDecay = 0
ENT.BuildsThisTick = 0
ENT.ZombieConstruction = true
ENT.DamageResist = 0.25
ENT.LocalRotation = 0
ENT.NextMutationTime = 0

ENT.Table = {
	[1] = "speed",
	[2] = "resist",
	[3] = "dmg"
}

ENT.StageBuff = {}

function ENT:Initialize()
	self:SetModel("models/props_wasteland/antlionhill.mdl")
	self:PhysicsInitBox(Vector(-18, -18, 0), Vector(18, 18, 36))
	self:SetCollisionBounds(Vector(-18, -18, 0), Vector(18, 18, 36))
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.2, 0)
	self:SetUseType(SIMPLE_USE)

	self:SetCustomCollisionCheck(true)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_ZOMBIE, ZS_COLLISIONFLAGS_ZOMBIE)

	self:ManipulateBoneScale(0, self.ModelScale)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("flesh")
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetNestHealth(self.MaxHealth)

	self.NextMutationTime = CurTime() + math.random(150, 220)

	self.LastBuild = CurTime()
end

function ENT:BuildUp()
	if CurTime() ~= self.LastBuildTime then
		self.LastBuildTime = CurTime()
		self.BuildsThisTick = 0
	end

	if self:GetNestLastDamaged() + 4 > CurTime() then return end

	if self.BuildsThisTick < 3 then
		self.BuildsThisTick = self.BuildsThisTick + 1

		self:SetNestHealth(math.min(self:GetNestHealth() + FrameTime() * self:GetNestMaxHealth() * 0.25, self:GetNestMaxHealth()))
	end
end

function ENT:Use(pl) -- from sigil
	if pl.NextSigilTPTry and pl.NextSigilTPTry >= CurTime() then return end
	if GAMEMODE:GetWaveActive() then
		if pl:IsValidLivingZombie() then
			local tpexist = pl:GetStatus("sigilteleport_nest")
			if tpexist and tpexist:IsValid() then return end

			if #GAMEMODE.AllNestsTbl > 1 then
				local status = pl:GiveStatus("sigilteleport_nest")
				if status:IsValid() then
					status:SetFromSigil(self)
					status:SetNestTP(true)
					status:SetEndTime(CurTime() + 2)

					pl.NextSigilTPTry = CurTime() + 1
				end
			end
		end
	else
		pl:CenterNotify(COLOR_RED, translate.ClientGet(pl, "cant_teleporting_to_nest"))
	end
end

function ENT:Think()
	if not self:GetNestBuilt() then
		local time = CurTime()
		if time >= self.LastBuild + 10 and time >= self.NextDecay then
			self.NextDecay = time + 1

			self:TakeDamage(5)
		end
	end

	if (self.LocalRotation < CurTime()) and self:GetDTBool(0) then -- таймер лул
		self.LocalRotation = CurTime() + 2

		if (self:GetNestMutationLevel() >= 3) then -- лечим зм в несте с полипами
			for _, ent in pairs(util.BlastAlloc(self, self:GetOwner(), self:GetPos(), 75)) do
				if ent:IsValidLivingZombie() then
					local percent = (ent.Boss and 0.2) or ((ent:GetBossTier() >= 1) and 0.4) or 0.8
					local healnum = math.max((ent:GetMaxHealthEx() * percent) - ent:Health(), 0)

					local status = ent:GiveStatus("zombie_regen2")
					if status and status:IsValid() then
						status.ThinkRate = 0.1
						status:SetHealLeft(healnum)
					end
				end
			end
		end

		if (self.NextMutationTime < CurTime()) and not (self:GetNestMutationLevel() >= 3) then -- уведомляем об мутации и ее смена
			self.NextMutationTime = CurTime() + 90
			self:SetNestMutationLevel(math.min(self:GetNestMutationLevel() + 1, 3))
			local name = self:GetNestOwner() and self:GetNestOwner():IsValid() and self:GetNestOwner():Name() or "No Named Nest"
			net.Start("zs_director_notify")
				net.WriteInt(8, 5)
				net.WriteUInt(self:GetNestMutationLevel(), 4)
				net.WriteString(tostring(name))
			net.Broadcast()
		end
		
		if self:GetNestMutationLevel() == 1 then -- ставим каждой стадии рандом эффект(сила, скорость и тд)
			self.DamageResist = 0.35
			if not self.StageBuff[1] then
				local num = math.random(#self.Table)
				self.StageBuff[1] = self.Table[num]
				table.remove(self.Table, num)
			end
		elseif self:GetNestMutationLevel() == 2 then
			self.DamageResist = 0.50
			if not self.StageBuff[2] then
				local num = math.random(#self.Table)
				self.StageBuff[2] = self.Table[num]
				table.remove(self.Table, num)
			end
		elseif self:GetNestMutationLevel() == 3 then
			self.DamageResist = 0.65
			if not self.StageBuff[3] then
				local num = math.random(#self.Table)
				self.StageBuff[3] = self.Table[num]
			end
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self:GetNestHealth() <= 0 or dmginfo:GetDamage() <= 0 then return end

	local damage = dmginfo:GetDamage()

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
		local owner = self:GetNestOwner()
		if attacker:GetZombieClassTable().Name ~= "Flesh Creeper" then
			return
		end

		if attacker.NestBanned then return end

		if attacker.SpawnedTime + 3 > CurTime() then return end

		damage = damage * 3
	end

	damage = damage * (dmginfo:GetInflictor().FlyingControllable and 0.3 or 1) 
	
	if self:GetNestBuilt() and attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		local points = (damage * 2.35) / self:GetNestMaxHealth() * 5

		PointQueue[attacker] = PointQueue[attacker] + points

		local pos = self:GetPos()
		pos.z = pos.z + 32

		LastDamageDealtPos[attacker] = pos
		LastDamageDealtTime[attacker] = CurTime()
	end

	self:SetNestHealth(self:GetNestHealth() - damage)
	self:SetNestLastDamaged(CurTime())

	if self:GetNestHealth() <= 0 then
		if self:GetNestBuilt() and attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
			--attacker:AddPoints(5)
			attacker.NestsDestroyed = attacker.NestsDestroyed + 1
		end

		gamemode.Call("NestDestroyed", self, attacker)

		net.Start("zs_nestnotifier")
			net.WriteString(self:GetClass())
			net.WriteString(dmginfo:GetInflictor():GetClass())
			net.WriteEntity(attacker)
		net.Broadcast()
		
		local attacker = dmginfo:GetAttacker()
		local fcattacker = IsValid(attacker) and attacker:Team() == TEAM_UNDEAD and attacker:GetZombieClassTable().Name == "Flesh Creeper" 

		net.Start("zs_nestdestroyed")
			net.WriteString(fcattacker and attacker:Name() or "")
			net.WriteBool(fcattacker)
			net.WriteInt(self:GetNestMutationLevel(), 4)
		net.Send(team.GetPlayers(TEAM_UNDEAD))

		self:Destroy()
	end
end

function ENT:Destroy()
	self.Destroyed = true

	local pos = self:WorldSpaceCenter()

	--[[
	local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(pos)
	util.Effect("gib_player", effectdata, true, true)
	]]

	util.Blood(pos, 100, self:GetUp(), 256)

	self:Fire("kill", "", 0.01)
end

function ENT:OnRemove()
	if self.Destroyed and self:GetNestBuilt() then

		local pos = self:WorldSpaceCenter()
		for i=1, 8 do
			local ent = ents.CreateLimited("prop_playergib")
			if ent:IsValid() then
				ent:SetPos(pos + VectorRand() * 12)
				ent:SetAngles(VectorRand():Angle())
				ent:SetGibType(math.random(3, #GAMEMODE.HumanGibs))
				ent:Spawn()
			end
		end
	end
	table.RemoveByValue( GAMEMODE.AllNestsTbl, self)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
