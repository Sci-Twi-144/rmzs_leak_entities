AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local pairs = pairs
local hook = hook
local ents = ents
local NULL = NULL
local ents_FindByClass = ents.FindByClass
local SOLID_VPHYSICS = SOLID_VPHYSICS
local bit = bit
local bit_bor = bit.bor
local ents_Create = ents.Create
local EffectData = EffectData
local util = util
local util_Effect = util.Effect
local TEAM_HUMAN = TEAM_HUMAN
local table = table
local table_insert = table.insert

ENT.PropQueue = {}
ENT.ActivatorTBL = {}

function ENT:NotifyOwnerStatus(pl)
	if self:GetObjectOwner() == pl then
		self:SetObjectOwner(nil)
	end
end

function ENT:Initialize()
	self:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
	self:PhysicsInitStatic(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetMaxObjectHealth(100)
	self:SetObjectHealth(self:GetMaxObjectHealth())
	
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_DEPLOYABLE_TURRET, ZS_COLLISIONGROUP_ALL)
	
	self:SetBuildingTimer(0)
	self.AmbientSound = CreateSound(self, ")weapons/physcannon/superphys_hold_loop.wav")

	self:SetGlobalPrinter(self)
	self:SetArsenalBool(false)
	self:SetTime(30)

end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "maxobjecthealth" then
		value = tonumber(value)
		if not value then return end

		self:SetMaxObjectHealth(value)
	elseif key == "objecthealth" then
		value = tonumber(value)
		if not value then return end

		self:SetObjectHealth(value)
	end
end

function ENT:AcceptInput(name, activator, caller, args)
	if name == "setobjecthealth" then
		self:KeyValue("objecthealth", args)
		return true
	elseif name == "setmaxobjecthealth" then
		self:KeyValue("maxobjecthealth", args)
		return true
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)

	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local effectdata = EffectData()
			effectdata:SetOrigin(self:LocalToWorld(self:OBBCenter()))
		util_Effect("Explosion", effectdata, true, true)
	end
end

function ENT:Use(activator, caller)
	local ishuman = activator:Team() == TEAM_HUMAN and activator:Alive()
	if not IsValid(self:GetObjectOwner()) and ishuman then
		self:SetObjectOwner(activator)
	end

	if not activator:IsBot() then
		if activator:Team() == TEAM_HUMAN and activator:Alive() and self:CheckIfNear(activator) and not (table.Count(self.PropQueue) >= 2) then
			activator:SendLua("GAMEMODE:OpenPrinterMenu()")
			activator:SendLua("surface.PlaySound(\"buttons/button24.wav\")")
			self.ActivatorTBL[#self.ActivatorTBL + 1] = activator
		elseif ishuman then
			activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "you_cant_purchase_now"))
		end
	end
end

function ENT:StartSpawning()
	self:NextThink(CurTime() + self.Delay)
	self.m_bSpawning = true
end

function ENT:AddPropQueue(player, entity_name, itemname, model, iSkin, strBody, time)
	if not self.m_bSpawning then
		self:StartSpawning()
	end

	table.insert(self.PropQueue, {
		ply = player,
		name = itemname,
		ent = entity_name,
		mdl = model,
		skin = iSkin,
		body = strBody,
		time = time * (player.PPPrintingMulti or 1)
	})

	if table.Count(self.PropQueue) >= 2 then
		self:SetArsenalBool(true)
		for _, ply in pairs(self.ActivatorTBL) do
			ply:SendLua("GAMEMODE.PropPrinterInt:Close()")
		end
		self.ActivatorTBL = {}
	end
end

function ENT:BuildProp(pl, name, entname, model, pos, ang, skin, groups)
	local ent = ents.Create( entname )
	if not IsValid(ent) then return end
	self:SetBuilder(pl)
	self:SetBuilding(true)
	self:SetPropName(name)
	self:SetBuildingTimer(CurTime() + self:GetTime())
	self:SetProp(ent)
	
	ent:SetModel(model)
	ent:SetSkin(skin)
	ent:SetAngles(ang)
	ent:SetBodyGroups(groups)
	ent:Spawn()
	ent:Activate()
	ent:SetMoveType(MOVETYPE_NONE)
	ent:SetNotSolid(true)
	
	local mx, mn = self:OBBMaxs(), self:OBBMins()
	local omx, omn = ent:OBBMaxs(), ent:OBBMins()
	
	pos.z = pos.z + (mx.z * 0.3) - omn.z
	ent:SetPos(pos)
end

function ENT:CheckIfNear(ent)
	local pos = ent:EyePos()

	local nearest = self:NearestPoint(pos)
	if pos:Distance(nearest) <= 80 and (WorldVisible(pos, nearest) or ent:TraceLine(80).Entity == self) then
		return true
	end

	return false
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (IsValid(attacker) and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
	end
end

function ENT:AltUse(activator, tr)
	--print(table.Count(self.PropQueue))
	if self.m_bSpawning or table.Count(self.PropQueue) > 0 then 
		activator:CenterNotify(COLOR_RED, "Невозможно упаковать, принтер в данный момент работает.")
		return 
	end
	
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_printer")
	pl:GiveAmmo(1, "printers")

	self:Remove()
end

function ENT:OnRemove()
	self:SetGlobalPrinter(nil)
	self:SetArsenalBool(true)
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end
	
	return self:GetBuilding() and self:FinishBuilding() or self:SpawnThink()
end

function ENT:FinishBuilding()
	local prop = self:GetProp()

	if IsValid(prop) then
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetMoveType(MOVETYPE_VPHYSICS)
		prop:SetNotSolid(false)
		prop:SetNoDraw(false)
		
		GAMEMODE:SetupPropHealth(prop, prop:GetClass(), "prop_physics_multiplayer")

		--prop._OldCG_Prop = prop:GetCollisionGroup()
		--prop:SetCollisionGroup(COLLISION_GROUP_WORLD)

		local phys = prop:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
		
		local mx, mn = prop:OBBMaxs(), prop:OBBMins()
		local top = prop:LocalToWorld(mx)
		if not util.IsInWorld(prop:LocalToWorld(mx)) then
			prop:DropToFloor()
		end
		
		local phys = prop:GetPhysicsObject()
		if IsValid(phys) and phys:GetMass() >= CARRY_MAXIMUM_MASS then
			phys:SetMass(CARRY_DRAG_MASS + 1)
		end
		
		local tr = util.TraceHull( {
			start = prop:LocalToWorld(Vector(0, 0, mx.z)),
			endpos = prop:LocalToWorld(Vector(0, 0, mx.z)) + prop:LocalToWorld(Vector(0, 0, mn.z)),
			mins = mn,
			maxs = mx,
			filter = self
		} )
		if tr.Hit and tr.HitWorld then
			prop:DropToFloor()
		end

		--[[
		local mn, mx = prop:WorldSpaceAABB()
		for _, ent in pairs(ents.FindInBox(mn, mx)) do
			if ent ~= prop and ent:GetClass() ~= "prop_propprinter" then
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					ent._OldCG_Prop = ent:GetCollisionGroup()
					ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					
					local rand = math.random(100 * 20, 100 * 40)
					phys:ApplyForceCenter(Vector(rand, rand, 0))
				
					timer.Simple(1, function()
						if not IsValid(ent) then return end
						
						ent:SetCollisionGroup(ent._OldCG_Prop)
						ent._OldCG_Prop = nil
					end)
				end
				
				local pl_owner = self:GetObjectOwner()
				if IsValid(pl_owner) then
					ent:SetPhysicsAttacker(pl_owner)
				end
			end
		end]]
	
		self.AmbientSound:Stop()
		self:EmitSound("ambient/energy/zap"..math.random(1, 9)..".wav")
		
		self:SetBuilding(false)
		self:SetPropName("")

		self:SetArsenalBool(false)
		self:SetTime(30)

		timer.Simple(1, function() -- idc
			prop:GhostAllPlayersInMe(5)
		end)

		--[[]
		prop._SpecFlag = true

		timer.Simple(0, function() -- idc
			if self:IsValid() then
				for _, ent in pairs(ents.FindInSphere(self:GetPos(), 52)) do
					if ent and ent:IsValid() and prop._SpecFlag then
						for i = 1, 2 do
							timer.Simple(0.5 * i, function() 
								if prop:IsValid() and prop._SpecFlag and prop._OldCG_Prop then 
									prop:SetCollisionGroup(prop._OldCG_Prop) 
									prop._OldCG_Prop = nil 
									prop._SpecFlag = nil
								end 
							end)
						end
					end
				end
			end
		end)]]
	end
	
	self:NextThink(CurTime() + self.Delay)
			
	return true
end

function ENT:SpawnThink()

	if table.Count(self.PropQueue) <= 0 then
		self.m_bSpawning = false
		self:NextThink(CurTime() + self.Delay)
		return true
	end

	if not self.m_bSpawning then return false end

	local prop = self.PropQueue[1]
	self:SetTime(prop.time or 30)
	if not prop then return false end
	
	self.AmbientSound:Play()
	self:BuildProp(prop.ply, prop.name, prop.ent, prop.mdl, self:GetPos(), self:GetAngles(), prop.skin, prop.body)
	self:NextThink(CurTime() + self:GetTime())
	
	table.remove(self.PropQueue, 1)
	
	return true
end

function ENT:SetBuilder(ply)
	self:SetDTEntity(3, ply)
end