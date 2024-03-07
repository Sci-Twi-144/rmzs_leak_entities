--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
AddCSLuaFile("cl_animations.lua")

ENT.CleanupPriority = 1
ENT.GravManipulated = false
ENT.GravManipulator = nil
ENT.GrabTime = 0

function ENT:Initialize()
	self.ObjHealth = 200
	self.Forced = self.Forced or false
	self.NeverRemove = self.NeverRemove or false
	self.Restrained = self.Restrained or false

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) -- need to think twice before adding collsision in items like this

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("material")
		phys:EnableMotion(not self.Restrained)
		phys:SetMass(45)
		phys:Wake()
	end

	self:ItemCreated()
end

function ENT:Think()
	if self.GravManipulated and self.GravManipulator and self.GravManipulator:IsValidLivingHuman() then
		if self.GrabTime >= CurTime() then
			local ovpos = self.GravManipulator:GetPos()
			if (self:GetPos() - ovpos):LengthSqr() <= 5600 then
				self:Use(self.GravManipulator, self.GravManipulator)
			end
		else
			self.GravManipulated = false
			self.GravManipulator = nil
		end
	end
end

function ENT:Use(activator, caller)
	if self.IgnoreUse then return end
	if self.IsTrueOwner ~= activator and activator:IsSkillActive(SKILL_D_NOODLEARMS) then
		activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "loot_for_plebs"))
	elseif gamemode.Call("PlayerCanCheckout", activator) then
		activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "maybe_i_should_use_worth_first"))
	else
		self:GiveToActivator(activator, caller)
	end
end

function ENT:GiveToActivator(activator, caller)
	if  not activator:IsPlayer()
		or not activator:Alive()
		or activator:Team() ~= TEAM_HUMAN
		or self.Removing
		or (activator:KeyDown(GAMEMODE.UtilityKey) and not self.Forced)
		or self.NoPickupsTime and CurTime() < self.NoPickupsTime and self.NoPickupsOwner ~= activator then

		return
	end

	local itype = self:GetInventoryItemType()
	local removeme = true
	if not itype then
		return
	end
	
	local itypecat = GAMEMODE:GetInventoryItemType(itype)
	if activator:CanPickUpItemTier(itype) and activator:CanPickUpItemTier(itype, true) then
		local activatortrinketname = activator:CanPickUpItemTier(itype, true)
		activator:TakeInventoryItem(activatortrinketname)
		self:SetInventoryItemType(activatortrinketname)
		removeme = false
	elseif itypecat == INVCAT_TRINKETS and activator:HasInventoryItemTier(itype) then
		activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "you_already_have_this_trinket"))
		return
	end

	--[[
	if itypecat == INVCAT_TRINKETS and activator:HasInventoryItemTier(itype) then
		activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "you_already_have_this_trinket"))
		return
	end]]

	activator:AddInventoryItem(itype)
	
	local mins, maxs = self:GetCollisionBounds()
	net.Start("zs_manipanimchange")
		net.WriteString("take_shit_from_floor")
		net.WriteString(self:GetModel())
		net.WriteVector(mins)
		net.WriteVector(self:OBBCenter())
	net.Send(activator)
	
	net.Start("zs_invitem")
		net.WriteString(itype)
	net.Send(activator)

	if (removeme and not self.NeverRemove) then self:RemoveNextFrame() end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "invitemtype" then
		self:SetInventoryItemType(value)
	elseif key == "neverremove" then
		self.NeverRemove = tonumber(value) == 1
	end
end

function ENT:AcceptInput(name, activator, caller, arg)
	name = string.lower(name)
	if name == "givetoactivator" then
		self.Forced = true
		self:GiveToActivator(activator,caller)
		return true
	elseif name == "setinvitemtype" then
		self:SetInventoryItemType(arg)
		return true
	end
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	if self.NeverRemove then return end
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if attacker:IsValid() and attacker:IsPlayer() then return end

	self.ObjHealth = self.ObjHealth - dmginfo:GetDamage()
	if self.ObjHealth <= 0 then
		self:RemoveNextFrame()
	end
end
