--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.HealthLock = 0
ENT.DeployableFills = true
ENT.SigilInvincible = false 

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderFX(kRenderFxDistort)

	self:SetModel("models/props_wasteland/medbridge_post01.mdl")
	self:PhysicsInitBox(Vector(-16.285, -16.285, -0.29) * self.ModelScale, Vector(16.285, 16.285, 104.29) * self.ModelScale)
	self:SetUseType(SIMPLE_USE)

	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONGROUP_ALL)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetSigilHealthBase(self.MaxHealth)
	self:SetSigilHealthRegen(self.HealthRegen)
	self:SetSigilLastDamaged(0)

	local ent = ents.Create("prop_prop_blocker")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		--ent.EntityDeployable = true
		ent:Spawn()
		ent:SetOwner(self)
		ent:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_CROW, ZS_COLLISIONFLAGS_ZOMBIESPECIAL)
		--ent:SetParent(self) -- Prevents collisions
		self:DeleteOnRemove(ent)
	end

	self:FireInfoSigilOutput("OnSigilSpawn")
end

function ENT:Use(pl)
	if self:GetInfoSigilKV("DisableTeleports") then
		GAMEMODE:ConCommandErrorMessage(pl, "You cannot teleport from this sigil.")
		return
	end

	if pl.NextSigilTPTry and pl.NextSigilTPTry >= CurTime() then return end

	if pl:Team() == TEAM_HUMAN and pl:Alive() and not self:GetSigilCorrupted() then
		local tpexist = pl:GetStatus("sigilteleport")
		if tpexist and tpexist:IsValid() then return end

		if GAMEMODE:NumUncorruptedSigils() >= 2 then
			local status = pl:GiveStatus("sigilteleport")
			if status:IsValid() then
				local stime = (NoGhosting[pl] and not GAMEMODE:GetWaveActive()) and 0.5 or 1.5
				local result = NoGhosting[pl] and stime or 1

				status:SetFromSigil(self)
				status:SetEndTime(CurTime() + (2 * (pl.SigilTeleportTimeMul or 1)) * result)

				pl.NextSigilTPTry = CurTime() + 1
			end
		end
	end
end

function ENT:Think()
	local desired = self:GetInfoSigilKV("DesiredCorruptionState")
	if desired ~= nil then 
		self:SetInfoSigilKV("DesiredCorruptionState",nil)

		if desired then
			gamemode.Call("PreOnSigilCorrupted", self, nil)
			self:SetSigilCorrupted(true)
			self:SetSigilHealthBase(self.MaxHealth)
			self:SetSigilLastDamaged(0)
			self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_ZOMBIE, ZS_COLLISIONGROUP_ALL)
			gamemode.Call("OnSigilCorrupted", self, nil)
			self:FireInfoSigilOutput("OnCorrupt")
		else
			gamemode.Call("PreOnSigilUncorrupted", self, nil)
			self:SetSigilCorrupted(false)
			self:SetSigilHealthBase(self.MaxHealth)
			self:SetSigilLastDamaged(0)
			self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONGROUP_ALL)
			gamemode.Call("OnSigilUncorrupted", self, nil)
			self:FireInfoSigilOutput("OnUnCorrupt")
		end

	end
	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:OnTakeDamage(dmginfo)
	if self:GetSigilHealth() <= 0 or dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() and dmginfo:GetDamage() > 2 and CurTime() >= self.HealthLock then
		if self:CanBeDamagedByTeam(attacker:Team()) then
			if attacker:Team() == TEAM_HUMAN then
				local inflictor = dmginfo:GetInflictor()
				if inflictor and inflictor == attacker:GetActiveWeapon() and inflictor.IsMelee then
					dmginfo:SetDamage(dmginfo:GetDamage() * 1.6)
				else
					dmginfo:SetDamage(0)
					return
				end
			end

			dmginfo:SetDamage(dmginfo:GetDamage() * (attacker:Team() == TEAM_HUMAN and GetGlobalFloat("humansigildamagemul",1) or GetGlobalFloat("zombiesigildamagemul",1)))

			local oldhealth = self:GetSigilHealth()
			self:SetSigilLastDamaged(CurTime())
			self:SetSigilHealthBase(oldhealth - dmginfo:GetDamage())

			if self:GetSigilHealth() <= 0 then
				if self:GetSigilCorrupted() then
					gamemode.Call("PreOnSigilUncorrupted", self, dmginfo)
					self:SetSigilCorrupted(false)
					self:SetSigilHealthBase(self.MaxHealth)
					self:SetSigilLastDamaged(0)
					self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONGROUP_ALL)
					gamemode.Call("OnSigilUncorrupted", self, dmginfo)
					self:FireInfoSigilOutput("OnUnCorrupt")
				else
					gamemode.Call("PreOnSigilCorrupted", self, dmginfo)
					self:SetSigilCorrupted(true)
					self:SetSigilHealthBase(self.MaxHealth)
					self:SetSigilLastDamaged(0)
					self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_ZOMBIE, ZS_COLLISIONGROUP_ALL)
					gamemode.Call("OnSigilCorrupted", self, dmginfo)
					self:FireInfoSigilOutput("OnCorrupt")
				end
			end
		elseif attacker:Team() == TEAM_UNDEAD then
			self.HealthLock = CurTime() + 1
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:GetInfoSigilKV(key)
	if self.InfoSigil and self.InfoSigil:IsValid() then
		return self.InfoSigil and self.InfoSigil[key]
	end
 	return nil
end

function ENT:SetInfoSigilKV(key,value)
	if self.InfoSigil and self.InfoSigil:IsValid() then
		self.InfoSigil[key]=value
	end
end

function ENT:FireInfoSigilOutput(key, arg1, arg2, arg3)
	if self.InfoSigil and self.InfoSigil:IsValid() then
		self.InfoSigil:Input(key, arg1, arg2, arg3)
	end
end