--[[SECURE]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local hook = hook
local ents = ents
local ents_FindByClass = ents.FindByClass
local SOLID_VPHYSICS = SOLID_VPHYSICS
local SIMPLE_USE = SIMPLE_USE
local bit = bit
local bit_bor = bit.bor
local ents_Create = ents.Create
local table = table
local table_insert = table.insert
local math = math
local math_min = math.min
local math_max = math.max
local math_round = math.Round

ENT.OnlyOnceTarget = false

local function RefreshTeslaOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_tesla")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "Tesla.PlayerDisconnected", RefreshTeslaOwners)
hook.Add("OnPlayerChangedTeam", "Tesla.OnPlayerChangedTeam", RefreshTeslaOwners)

function ENT:Initialize()
	self:SetModel("models/rmzs_customs/tesla_coil.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONGROUP_ALL)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	self:SetAmmo(self.DefaultAmmo)
	self:SetMaxObjectHealth(200)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		if self:GetObjectOwner():IsValidLivingHuman() then
			self:GetObjectOwner():SendDeployableLostMessage(self)
		end

		local pos = self:LocalToWorld(self:OBBCenter())
		local amount = math.ceil(self:GetAmmo() * 0.5)
		while amount > 0 do
			local todrop = math.min(amount, 50)
			amount = amount - todrop
			local ent = ents.Create("prop_ammo")
			if ent:IsValid() then
				local heading = VectorRand():GetNormalized()
				ent:SetAmmoType(self.AmmoType)
				ent:SetAmmo(todrop)
				ent:SetPos(pos + heading * 8)
				ent:SetAngles(VectorRand():Angle())
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:ApplyForceOffset(heading * math.Rand(8000, 32000), pos)
				end
			end
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (IsValid(attacker) and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon(self.SWEP)
	pl:GiveAmmo(1, self.DeployableAmmo)

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())
	pl:GiveAmmo(self:GetAmmo(), self.AmmoType)
	
	self:Remove()
end

ENT.DeployableFills = true
function ENT:Use(activator, caller)
	local ishuman = activator:Team() == TEAM_HUMAN and activator:Alive()
	
	if not self.NoTakeOwnership and not self:GetObjectOwner():IsValid() and ishuman then
		self:SetObjectOwner(activator)
		self:GetObjectOwner():SendDeployableClaimedMessage(self)
	end
	
	if IsValid(self:GetObjectOwner()) and ishuman then
		if activator:GetInfo("zs_nousetodeposit") == "0" or self:GetObjectOwner() == activator then
			if self:GetObjectOwner():IsSkillActive(SKILL_D_NOODLEARMS) and (self:GetObjectOwner() ~= activator) then
				GAMEMODE:ConCommandErrorMessage(activator, translate.ClientGet(activator, "loot_for_plebs_3"))
			else
				local curammo = self:GetAmmo()
				local togive = math.min(math.min(15, activator:GetAmmoCount(self.AmmoType)), self.MaxAmmo - curammo)
				if togive > 0 then
					self:SetAmmo(curammo + togive)
					activator:RemoveAmmo(togive, self.AmmoType)
					activator:RestartGesture(ACT_GMOD_GESTURE_ITEM_GIVE)
					self:EmitSound("npc/turret_floor/click1.wav")
				end
			end
		end
	else
		self:SetObjectOwner(activator)
	end
end

ENT.NextVisThink = 0
function ENT:Think()
	if self.Destroyed then
		self:Remove()	
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
		util.Effect("Explosion", effectdata, true, true)
	elseif self.NextVisThink<=CurTime() then
		if not IsValid(self:GetObjectOwner()) then return end
		
		local vPos = self:GetPos()
		self.NextVisThink = CurTime() + (self:GetNextZap() * (self:GetObjectOwner().FieldDelayMul or 1))
		if self:GetAmmo() > 0 then
			for _, hitent in pairs(player.GetAll()) do
				local p = hitent:GetPos()
				if p:DistToSqr(self:GetPos()) < 22500 then --150^2
					if IsValid(hitent) and WorldVisible(vPos, hitent:NearestPoint(vPos)) then
						if hitent:IsPlayer() and hitent:Alive() and hitent:Team() == TEAM_UNDEAD--[[and hitent:IsHeadcrab()]] then
							local owner = self:GetObjectOwner()
							if hitent:IsHeadcrab() then
								local damage = self.Damage * (0.1 * 2.353)
								hitent:AddLegDamageExt(damage, owner, self, SLOWTYPE_PULSE)
								hitent:TakeSpecialDamage(self.Damage or 50, DMG_DISSOLVE, owner, self)
								self:ShouldTakeAmmo(1)
							end
							 if not self.OnlyOnceTarget then
								self:DoElectricityEffect()
								self:DoElectricityEffectSmall()
 
								local damage = self.Damage * (0.1 * 2.353)
								hitent:AddLegDamageExt(damage, owner, self, SLOWTYPE_PULSE)

								hitent:TakeSpecialDamage(self.Damage or 50, DMG_DISSOLVE, owner, self)
								self:ShouldTakeAmmo(3)
								self.OnlyOnceTarget = true
								timer.Simple(1, function() 
									self.OnlyOnceTarget = false
								end)
							end

							if self:GetAmmo() == 0 then
								self:GetObjectOwner():SendDeployableOutOfAmmoMessage(self)
							end
							
							local effectdata = EffectData()
								effectdata:SetOrigin(self:GetPos() + self:GetUp() * 26)
								effectdata:SetStart(hitent:WorldSpaceCenter() or p)
							util.Effect("tracer_tesla", effectdata, true, true)
						end
					end--
				end
			end
		end
	end
end

function ENT:ShouldTakeAmmo(num)
	self:SetAmmo(self:GetAmmo() - num)
end

function ENT:DoElectricityEffect()
	local teslacoil = ents.Create("point_tesla")
	if !teslacoil or !IsValid(teslacoil) then return false end
	teslacoil:SetPos(self:GetPos() + self:GetUp() * 26)
	teslacoil:SetKeyValue( "m_SoundName", "DoSpark" )
	teslacoil:SetKeyValue("texture", "trails/laser.vmt")
	teslacoil:SetKeyValue("m_Color", "255, 128, 0")
	teslacoil:SetKeyValue("m_flRadius", (64))
	teslacoil:SetKeyValue("interval_min", (0.012 * 0.75))
	teslacoil:SetKeyValue("interval_max", (0.112 * 1.25))
	teslacoil:SetKeyValue("beamcount_min", (math_round(6 * 0.75)))
	teslacoil:SetKeyValue("beamcount_max", (math_round(12 * 1.25)))
	teslacoil:SetKeyValue("thick_min", (2 * 0.75))
	teslacoil:SetKeyValue("thick_max", (4 * 1.25))
	teslacoil:SetKeyValue("lifetime_min", (0.3 * 0.75))
	teslacoil:SetKeyValue("lifetime_max", (0.3 * 1.25))
	--teslacoil:SetParent(self)
	--teslacoil:SetParentAttachment("sphere")
	teslacoil:Spawn()
	teslacoil:Fire("DoSpark", "", 0)
	teslacoil:Fire("DoSpark", "", 0.1)
	teslacoil:Fire("DoSpark", "", 0.2)
	teslacoil:Fire("DoSpark", "", 0.3)
	teslacoil:Fire("kill", "", 0.3)
	--self:DoElectricityEffectSmall()
end

function ENT:DoElectricityEffectSmall()
	local teslacoil = ents.Create("point_tesla")
	if !teslacoil or !IsValid(teslacoil) then return false end
	teslacoil:SetPos(self:GetPos() + self:GetUp() * 26)
	teslacoil:SetKeyValue( "m_SoundName", "DoSpark" )
	teslacoil:SetKeyValue("texture", "effects/tau_beam.vmt")
	teslacoil:SetKeyValue("m_Color", "255, 64, 0")
	teslacoil:SetKeyValue("m_flRadius", (32))
	teslacoil:SetKeyValue("interval_min", (0.016 * 0.75))
	teslacoil:SetKeyValue("interval_max", (0.022 * 1.25))
	teslacoil:SetKeyValue("beamcount_min", (math_round(6 * 0.75)))
	teslacoil:SetKeyValue("beamcount_max", (math_round(6 * 1.25)))
	teslacoil:SetKeyValue("thick_min", (1 * 0.75))
	teslacoil:SetKeyValue("thick_max", (1 * 1.25))
	teslacoil:SetKeyValue("lifetime_min", (0.3 * 0.75))
	teslacoil:SetKeyValue("lifetime_max", (0.3 * 1.25))
	--teslacoil:SetParent(self)
	--teslacoil:SetParentAttachment("sphere")
	teslacoil:Spawn()
	teslacoil:Fire("DoSpark", "", 0)
	teslacoil:Fire("DoSpark", "", 0.1)
	teslacoil:Fire("DoSpark", "", 0.2)
	teslacoil:Fire("DoSpark", "", 0.3)
	teslacoil:Fire("kill", "", 0.3)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end