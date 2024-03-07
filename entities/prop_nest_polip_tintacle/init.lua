--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.SeekTimer = 0
ENT.Target = nil
ENT.LastAttack = 0

function ENT:Initialize()
	self:SetModel("models/hunter/misc/sphere1x1.mdl")
	self:SetModelScale(0.5)
	self:PhysicsInitSphere(1)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_ZOMBIE, ZS_COLLISIONFLAGS_ZOMBIE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end
	self:SeekRetards()
	self:AttackRetards()
end

function ENT:SeekRetards()
	if (self.SeekTimer < CurTime()) then
		self.SeekTimer = CurTime() + 1
		local owner = self:GetOwner() or World()
		local pos = self:GetPos()

		if IsValid(self.Target) and ((pos:Distance(self.Target:GetPos()) > 350) or not WorldVisible(pos, self.Target:GetPos())) then 
			self.Target = nil 
			self:SetCanAttack(false)
		end

		if not IsValid(self.Target) then
			for _, ent in pairs(util.BlastAlloc(self, owner, pos, 350)) do
				if ent:IsValidLivingHuman() then
					if WorldVisible(pos, ent:GetPos()) then
						self.Target = ent
						break
					end
				end
			end
		end

		if IsValid(self.Target) and pos:Distance(self.Target:GetPos()) < 350 then
			self:SetCanAttack(true)
		else
			self:SetCanAttack(false)
		end
	end
	
	if IsValid(self.Target) then
		local target = self.Target
		targetpos = target:LocalToWorld(target:OBBCenter() + Vector(0, 0, 32))
		direction = (targetpos - self:GetPos()):GetNormal()
		self:SetAngles(direction:Angle())
	end
end

function ENT:AttackRetards()
	if IsValid(self.Target) and self.LastAttack < CurTime() and self:GetCanAttack() then
		self.LastAttack = CurTime() + 1.5

		self:GetRandomOwner()

		self:EmitSound("npc/barnacle/barnacle_die2.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting1.wav")
		self:EmitSound("npc/barnacle/barnacle_digesting2.wav")
		for i = 1, math.random(25, 30) do
			local ent = ents.Create("projectile_poisonpuke")
			if ent:IsValid() then
				ent:SetPos(self:GetPos())
				ent:SetOwner(self:GetOwner())
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					local ang = self:GetAngles()
					ang:RotateAroundAxis(ang:Forward(), math.Rand(-6, 6))
					ang:RotateAroundAxis(ang:Up(), math.Rand(-22, 22))
					phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(625, 750))
				end
			end
		end
	end
end

function ENT:GetRandomOwner()
	local bots = player.GetBots()
	local random = math.random(#bots)
	self:SetOwner(bots[random])
end

