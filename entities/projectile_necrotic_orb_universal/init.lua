--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
 
ENT.DefaultEff = 1
ENT.Target = nil
ENT.StayAndExp = nil
ENT.WaitTime = nil
ENT.Radius = 128
ENT.Status = nil
ENT.TimeStatus = 8
ENT.Random = true
ENT.Wordindex = nil
ENT.Damage = 0
ENT.OffsetDieTime = 0

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderFX(kRenderFxDistort)
	self.DeathTime = CurTime() + 3.8 + self.OffsetDieTime
	--models/props/cs_italy/orange.mdl
	--models/gibs/hgibs.mdl
	self:SetModel("models/gibs/hgibs.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetModelScale(4, 0.8)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	local debuffs = {
		[1] = "sickness",
		[2] = "enfeeble",
		[3] = "slow",
		[4] = "anchor",
		[5] = "frightened",
		[6] = "dimvision",
		[7] = "frost",
		[8] = nil
	}
	local debuffsIND = {
		[1] = 12,
		[2] = 6,
		[3] = 8,
		[4] = 34,
		[5] = 39,
		[6] = 7,
		[7] = 10,
		[8] = nil
	}
	local debuffsColor = {
		[1] = Color(255, 132, 0, 255),
		[2] = Color(255, 40, 40, 255),
		[3] = Color(210, 180, 140, 255),
		[4] = Color(255, 150, 255, 255),
		[5] = Color(185, 28, 185),
		[6] = Color(190, 190, 190, 255),
		[7] = Color(153, 217, 234, 255),
		[8] = Color(125, 15, 15, 255)
	}

	local random = math.random(1, 8)
	if self.Random then
		self.Status = debuffs[random]
		self:SetColor(debuffsColor[random])
		self.Wordindex = debuffsIND[random]
	end

	self:PhysicsInitSphere(10)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetupGenericProjectile(false)

	self.Target = self.Killer
	if not IsValid(self.Target) then
		local radius = self.Radius
		local owner = self:GetOwner()
		local pos = self:GetPos()

		for _, ent in pairs(util.BlastAlloc(self, owner, pos, radius)) do
			if ent:IsValidLivingHuman() then
				self.Target = ent
				break
			end
		end
	end

	self:EmitSound("items/suitchargeok1.wav", 55, 28, 1)

	self.TimeCreated = CurTime()
	timer.Simple(0, function()  self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_CROW, ZS_COLLISIONFLAGS_ZOMBIESPECIAL) end) -- hm why i should set it next frame??
end

function ENT:Think()
	local target = self.Target
	if IsValid(target) and target:IsValidLivingHuman() then

		local targetpos = target:LocalToWorld(target:OBBCenter() + Vector(0, 0, 1))
		local direction = (targetpos - self:GetPos()):GetNormal()

		self:SetAngles(direction:Angle())

		local airtime = CurTime() - self.TimeCreated
		local speedmul = self.StayAndExp and 0 or math.Clamp(1 + airtime, 1, 9)
		--print(speedmul)
		local phys = self:GetPhysicsObject()
		phys:SetVelocityInstantaneous(direction * (25 * speedmul))
	end

	if self.DeathTime <= CurTime() then
		self:Remove()
		self.StayAndExp = true
	end

	if self.StayAndExp then
		local radius = self.Radius
		local owner = self:GetOwner()
		local pos = self:GetPos()


		if self.Status == nil then
			self:EmitSound("ambient/explosions/explode_4.wav", 65, 500, 1)
		elseif self.Status == "frightened" then
			self:EmitSound("npc/scanner/scanner_electric2.wav", 65, 100, 1)
		else
			self:EmitSound("ambient/machines/thumper_hit.wav", 65, 150, 1)
		end

		local damage = self.Damage
		if self.Status == nil and self.Random then
			damage = 0.25
		end

		damage = 0.1
		util.BlastDamageStatus(self, game.GetWorld(), pos, radius, damage, 0.95, DMG_SLASH, self.Status, self.TimeStatus, self.Wordindex, false)

		for _, ent in pairs(util.BlastAlloc(self, owner, pos, radius)) do
			if ent:IsValidLivingHuman() then
				if self.Status == "frost" then ent:EmitSound("physics/glass/glass_largesheet_break"..math.random(1, 3)..".wav", 65, math.random(160, 180)) end
			end
		end
	end
	self:NextThink(CurTime())
end
