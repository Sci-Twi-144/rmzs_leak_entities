--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

--ENT.DeployableFills = true
ENT.Close = true
ENT.Close2 = false

-- models/rmzs/xen_gear/xen_supplypod01_p2.mdl -- крышка 
--"models/rmzs/xen_gear/xen_supplypod01a_p1.mdl" -- под ящики с патронами
-- models/rmzs/xen_gear/xen_supplypod01b_p1.mdl -- половина ящики и 1 место под оружие
-- models/rmzs/xen_gear/xen_supplypod01c_p1.mdl -- чисто оружие

-- models/weapons/w_weaponbox.mdl -- ящик маленький

function ENT:Initialize()
	self:SetModel("models/rmzs/xen_gear/xen_supplypod01a_p1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)

	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	--self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_DEPLOYABLE_TURRET, ZS_COLLISIONGROUP_ALL)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(true)
		phys:Wake()
	end

	self:ResetSequence("idle_closed")

	local ent = ents.Create("prop_xenresupbox_cup")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles() + Angle(0, 90, 0))
		ent:Spawn()
		ent:SetParent(self)
		self:DeleteOnRemove(ent)
	end

	local centerpos = self:LocalToWorld(self:OBBCenter())
	local angle = self:GetAngles()

	for i = 1, 2 do
		vector = Vector(6, 6 + 12 * (i - 1), 1)
		vector:Rotate(angle)
		pos = centerpos + vector
		local ent = ents.Create("prop_xenwepbox")
		if ent:IsValid() then
			ent:SetPos(pos)
			ent:SetAngles(angle + Angle(0, 90, 0))
			ent:Spawn()
			ent:SetParent(self)
			self:DeleteOnRemove(ent)
		end
	end

	for i = 1, 2 do
		vector = Vector(-6, 6 + 12 * (i - 1), 1)
		vector:Rotate(angle)
		pos = centerpos + vector
		local ent = ents.Create("prop_xenwepbox")
		if ent:IsValid() then
			ent:SetPos(pos)
			ent:SetAngles(angle + Angle(0, 90, 0))
			ent:Spawn()
			ent:SetParent(self)
			self:DeleteOnRemove(ent)
		end
	end

	for i = 1, 2 do
		vector = Vector(6, -6 - 12 * (i - 1), 1)
		vector:Rotate(angle)
		pos = centerpos + vector
		local ent = ents.Create("prop_xenwepbox")
		if ent:IsValid() then
			ent:SetPos(pos)
			ent:SetAngles(angle + Angle(0, 90, 0))
			ent:Spawn()
			ent:SetParent(self)
			self:DeleteOnRemove(ent)
		end
	end

	for i = 1, 2 do
		vector = Vector(-6, -6 - 12 * (i - 1), 1)
		vector:Rotate(angle)
		pos = centerpos + vector
		local ent = ents.Create("prop_xenwepbox")
		if ent:IsValid() then
			ent:SetPos(pos)
			ent:SetAngles(angle + Angle(0, 90, 0))
			ent:Spawn()
			ent:SetParent(self)
			self:DeleteOnRemove(ent)
		end
	end

	self:SetMaxObjectHealth(250)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "maxcratehealth" then
		value = tonumber(value)
		if not value then return end

		self:SetMaxObjectHealth(value)
	elseif key == "cratehealth" then
		value = tonumber(value)
		if not value then return end

		self:SetObjectHealth(value)
	end
end

function ENT:AcceptInput(name, activator, caller, args)
	if name == "setcratehealth" then
		self:KeyValue("cratehealth", args)
		return true
	elseif name == "setmaxcratehealth" then
		self:KeyValue("maxcratehealth", args)
		return true
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetModel(self:GetModel())
			ent:SetMaterial(self:GetMaterial())
			ent:SetAngles(self:GetAngles())
			ent:SetPos(self:GetPos())
			ent:SetSkin(self:GetSkin() or 0)
			ent:SetColor(self:GetColor())
			ent:Spawn()
			ent:Fire("break", "", 0)
			ent:Fire("kill", "", 0.1)
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetDamage() <= 0 then return end

	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
	end
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end

	if self.Close2 then
		self:EmitSound("ambient/machines/steam_release_1.wav")
		self.Close2 = false
		for _, ent in pairs(ents.FindInSphere(self:GetPos(), 15)) do
			if ent and ent:GetClass() == "prop_xenresupbox_cup" then
				ent:SetParent()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:EnableMotion(true)
					phys:Wake()
					ent:SetPos(self:GetPos())

					local vector = self:GetUp()
					vector.y = vector.y + 0.2
					timer.Simple(0, function()
						phys:SetVelocityInstantaneous(vector * 400)
						phys:AddAngleVelocity(VectorRand() * 150)
						ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
					end)
				end
			end
		end
	end
end

function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_HUMAN or not activator:Alive() then return end

	if self.Close then
		timer.Simple(1, function() self.Close2 = true end)
		self:ResetSequence("idle_open")
		self:EmitSound("items/ammocrate_open.wav")
		self:OpenSelf()
	end
end

function ENT:OnRemove()
	self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav")
end