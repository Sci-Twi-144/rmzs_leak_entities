--[[SECURE]]--

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
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

ENT.MedstDeployableAmmo = "medst"
ENT.DeployableFills = true

local function RefreshMedStationOwners(pl)
	for _, ent in ipairs(ents.FindByClass("prop_medstantion*")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "MedStation.PlayerDisconnected", RefreshMedStationOwners)
hook.Add("OnPlayerChangedTeam", "MedStation.OnPlayerChangedTeam", RefreshMedStationOwners)

function ENT:Initialize()
	self:SetModel("models/zombiesurvival/reciever_cart.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	--self:SetAngles(Angle(0,0,-90))
	self:SetCustomCollisionCheck(true)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_DEPLOYABLE_TURRET, ZS_COLLISIONGROUP_ALL)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	self:SetAmmo(self.DefaultAmmo)
	self:SetMaxObjectHealth(400)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end
--[[
function ENT:SetIdleCollisionGroup()
	self:SetCustomCollisionGroup(ZS_COLLISIONGROUP_DEPLOYABLE)
end
]]
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

	if dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon(self.SWEP)
	pl:GiveAmmo(1, self.MedstDeployableAmmo)

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
		activator:SendLua("GAMEMODE:OpenMedStationMenu()")
		activator:SendLua("surface.PlaySound(\"buttons/button1.wav\")")
		activator.Pmedstation_target = self
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
	elseif self.NextVisThink <= CurTime() then
		if not IsValid(self:GetObjectOwner()) then return end

		local curammo = self:GetAmmo()
		local chance
		local owner = self:GetObjectOwner()
		local vpered
		if owner.TrinketMedicCooldown then
			if (owner.MedCoolChance * 100) >= (self:GetRandom() or 100) then
				chance = 0.01
			else
				chance = 1
			end
		end
		
		self.NextVisThink = CurTime() + self.Cooldown * (chance or 1)
		--print(chance, 'second')
		if curammo > 0 then

			local vPos = self:GetPos()
			local target, lowesthp = nil, 9999
			for _, hitent in ipairs(player.GetAll()) do
				local p = hitent:GetPos()
				if hitent:IsValidLivingHuman() and gamemode.Call("PlayerCanBeHealed", hitent) then
					if p:DistToSqr(vPos) < 16384 and WorldVisible(vPos, hitent:NearestPoint(vPos)) then --128^2
						local hp = hitent:Health()
						if hp < hitent:GetMaxHealth() and lowesthp > hp then
							target, lowesthp = hitent, hp
						end
					end
				end
			end

			--local owner = self:GetObjectOwner()

			if target then
				local health, maxhealth = lowesthp, target:GetMaxHealth()
				local multiplier = owner.MedicHealMul or 1
				local timemultiplier = (owner.MedicCooldownMul or 1) * (chance or 1)
				local healed = owner:HealPlayer(target, math.min(curammo, self.Healing or 5))
				local totake = math.ceil(healed / multiplier)
				self:SetRandom(math.random(100))
				if healed > 0 then
					self:ShouldTakeAmmo(math.floor(totake)) -- okay pussies	 		
					self:EmitSound("items/medshot4.wav")

					local effectdata = EffectData()
						effectdata:SetOrigin((target:NearestPoint(vPos) + target:WorldSpaceCenter()) / 2)
						effectdata:SetEntity(target)
					util.Effect("hit_healdart", effectdata)

					if self:GetAmmo() == 0 then
						owner:SendDeployableOutOfAmmoMessage(self)
					end
				end
			end
		end
	end
end

function ENT:ShouldTakeAmmo(num)
	self:SetAmmo(self:GetAmmo() - num)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
end

function ENT:SetAmmo(ammo)
	self:SetDTInt(0, ammo)
end

function ENT:SetRandom(rnd)
	self:SetDTInt(10, rnd)
end

function ENT:GetRandom()
	 return self:GetDTInt(10)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end