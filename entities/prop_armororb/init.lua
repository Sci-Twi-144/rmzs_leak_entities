--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeTime
	self.DeployTime = CurTime() + 0.5
	
	self:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
	--self:PhysicsInitSphere(2)
	self:PhysicsInitBox(Vector(-2, -2, -2),Vector(2, 2, 2))
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(0.15, 0)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_SPECTATOR, ZS_COLLISIONFLAGS_SPECTATOR)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetTrigger(true)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:SetMaterial("zombieflesh")
		phys:EnableMotion(true)
		phys:SetMass(15)
		phys:Wake()
		phys:ApplyForceCenter(VectorRand():GetNormalized() * math.Rand(3000, 3200))
		phys:AddAngleVelocity(VectorRand() * 360)
	end
	
	local color
	if self.PickupType == 1 then
		color = self.ColorBlood
	elseif self.PickupType == 2 then
		color = self.ColorStamina
	elseif self.PickupType == 3 then
		color = self.ColorMedsup
	end
	self:SetType(self.PickupType)
	self.Trail = util.SpriteTrail( self, 0, color, true, 8, 1, 1.5, 0.05, "sprites/bluelaser1" )
end

function ENT:Think()

	local owner = self:GetOwner()
	local pos = owner:GetShootPos()
	local phys = self:GetPhysicsObject()
	if (self:GetPos() - pos):LengthSqr() <= 40000 and WorldVisible(pos, self:NearestPoint(pos)) and self.DeployTime <= CurTime() then
		if IsValid(phys) then
			local dir = (pos - self:NearestPoint(pos)):GetNormalized()
			local mass = phys:GetMass()

			phys:ApplyForceCenter(mass * self.Force * dir)
			self:SetPhysicsAttacker(owner, 4)
		end
	end
	self:NextThink(CurTime() + self.ForceDelay)
	
	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:StartTouch(ent)
	local owner = self:GetOwner()
	if not ent:IsValidLivingHuman() or ent:IsBot() or ent ~= owner then return end

	if ent:IsValidLivingHuman() then
		if self.PickupType == 1 then
			local iron = ent.IronBlood
			ent:SetBloodArmor(math.Clamp(ent:GetBloodArmor() + (iron and 2 or 5), 0, ent.MaxBloodArmor * 2))
			
		elseif self.PickupType == 2 then
		
			local otbl = E_GetTable(ent)
			local maxstamina = otbl.MaxStamina or GAMEMODE.BaseStamina
			ent:SetStamina(math.min(maxstamina, ent:GetStamina() + maxstamina * 0.1))
			
		elseif self.PickupType == 3 then
		
			ent:GiveAmmo(5, "Battery")
			net.Start("zs_ammopickup")
				net.WriteUInt(5, 16)
				net.WriteString("battery")
			net.Send(ent)
			
		end
	end
	
	ent:EmitSound("items/battery_pickup.wav", 55, 150, 0.45)
	self:Remove()
end
