--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
 
ENT.DefaultEff = 1
ENT.Target = nil
ENT.StayAndExp = nil
ENT.WaitTime = nil
ENT.Radius = 256

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderFX(kRenderFxDistort)
	self.DeathTime = CurTime() + 3.8

	self:SetModel("models/props/cs_italy/orange.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetModelScale(8, 4)

	self:SetColor(Color(38, 138, 59))

	self:PhysicsInitSphere(10)
	self:SetSolid(SOLID_VPHYSICS)

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
		phys:SetVelocityInstantaneous(direction * (36 * speedmul))
	end

	if self.DeathTime <= CurTime() then
		self:Remove()
		self.StayAndExp = true
	end

	if self.StayAndExp then
		local radius = self.Radius
		local owner = self:GetOwner()
		local pos = self:GetPos()
		local damageperc = 0.15

		util.BlastDamageStatus(self, owner, pos, radius, 0, 0.95, DMG_SLASH, "anchor", 6, 34, false)
	end

	self:NextThink(CurTime())
end