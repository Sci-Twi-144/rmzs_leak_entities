--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.Model = "models/rmzs/weapons/rpg_blueshift/w_rpg_projectile_blueshift.mdl"

ENT.PostKillTime = 1
ENT.HitOneTime = true
ENT.MaxHitCounts = 1
ENT.BoostTime = 0.03

function ENT:InitProjectile()
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)

	self.LastDisturb = self:BeingControlled() and CurTime() or 0
	self.Boosted = not self:BeingControlled()

	self:SetModelScale(0.45)

	self:StartMotionController()

	self.DeadTime = CurTime() + self.LifeSpan
	self:SetupGenericProjectile(false)

	--self:GetPhysicsObject():SetAngleDragCoefficient(0)
	--self:GetPhysicsObject():SetDragCoefficient(20000)

	self:CreateHook()
end

function ENT:CreateHook()
	local ent = self
	local ENTC = tostring(ent)

	hook.Add("SetupPlayerVisibility", ENTC, function(pl)
		if not IsValid(ent) then return end
		
		if pl ~= ent:GetOwner() or not ent:BeingControlled() then return end
	
		AddOriginToPVS(ent:GetPos())
	end)
end

function ENT:RemoveHook()
	hook.Remove("SetupPlayerVisibility", tostring(self))
end

function ENT:OnRemove()
	self:RemoveHook()
end

--[[function ENT:Think()
	if self.PhysicsData then
		self:Explode()
	end

	if self:WaterLevel()>0 then
		self:Explode()
	end

	if self.DeadTime <= CurTime() then
		self:Explode()
	end

	local boosted = self:GetDTBool(1)

	if (self.LastDisturb+self.BoostTime)<CurTime() then
		if not boosted then self:SetDTBool(1,true) end
	else
		if boosted then self:SetDTBool(1,false) end
	end

end]]

function ENT:PhysicsSimulate(phys, frametime)
	phys:Wake()
	local owner = self:GetOwner()
	local physobj = self:GetPhysicsObject()
	if not owner:IsValid() or not physobj:IsValid() then return SIM_NOTHING end

	if self:BeingControlled() then

		--local angdiff = Angle()
		local vel = phys:GetVelocity()
		local movedir = Vector(0, 0, 0)
		local eyeangles = owner:SyncAngles()
		local aimangles = owner:EyeAngles()
		--[[if owner:KeyDown(IN_FORWARD) then
			angdiff.p = -120
		--	self.LastDisturb = CurTime()
		end
		
		if owner:KeyDown(IN_BACK) then
			angdiff.p = 120
		--	self.LastDisturb = CurTime()
		end
		if owner:KeyDown(IN_MOVERIGHT) then
			angdiff.y = -120
		--	self.LastDisturb = CurTime()
		end
		if owner:KeyDown(IN_MOVELEFT) then
			angdiff.y = 120
			--self.LastDisturb = CurTime()
		end]]
		--[[local angdiff = math.AngleDifference(eyeangles.yaw, phys:GetAngles().yaw)
		local pitchdiff = math.AngleDifference(eyeangles.pitch, phys:GetAngles().pitch)
		local rolldiff = math.AngleDifference(eyeangles.roll, phys:GetAngles().roll)
		if math.abs(angdiff) > 4 or math.abs(pitchdiff) > 4 or math.abs(rolldiff) > 4 then
			yawadd = math.Clamp(angdiff, -64, 64) * frametime * 100 - phys:GetAngleVelocity().z * 0.95
			rolladd = math.Clamp(rolldiff, -64, 64) * frametime * 100 - phys:GetAngleVelocity().x * 0.95
			pitchadd = math.Clamp(pitchdiff, -64, 64) * frametime * 100 - phys:GetAngleVelocity().x * 0.95
			phys:AddAngleVelocity(Vector(0, rolladd, yawadd))
		end]]
		
		phys:SetAngles(aimangles)

		if owner:KeyDown(IN_USE) then
			timer.Simple(0,function() self:Explode() end)
			return
		end

		--self:SetAngles(self:GetAngles() + angdiff * frametime)
		physobj:SetVelocityInstantaneous(self:GetAngles():Forward() * ((self.LastDisturb + self.BoostTime) > CurTime() and 75 or 650) * (owner.ProjectileSpeedMul or 1))
	else
		physobj:SetVelocityInstantaneous(self:GetAngles():Forward() * ((self.LastDisturb + self.BoostTime) > CurTime() and 100 or 650) * (owner.ProjectileSpeedMul or 1))
	end
	

	phys:EnableGravity(false)
	phys:SetAngleDragCoefficient(20000)

	self:SetPhysicsAttacker(owner)

	return SIM_NOTHING
end

function ENT:ProcessHitEntity(ent)
	self:Explode()
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true
	

	local pos = self:GetPos()
	local owner = self:GetOwner()

	if owner:IsValidHuman() then
		local source = self:ProjectileDamageSource()
		source.LastTarget = self.Target and self.Target or nil
		local bonusmul = source:GetBonusTime() >= CurTime() and source:GetBonus() or 0
		
		if self.Target then
			local dist = self.Target:NearestPoint(pos):DistToSqr(pos) ^ 0.5
			--for _, enc in pairs(util.BlastAlloc(source, owner, pos, (self.ProjRadius + bonusmul * 5) * (owner.ExpDamageRadiusMul or 1))) do
				if dist <= ((self.ProjRadius + bonusmul * 5) * (owner.ExpDamageRadiusMul or 1)) and self.Target:IsValidLivingPlayer() and gamemode.Call("PlayerShouldTakeDamage", self.Target, owner) then
					local isboss = (self.Target:GetBossTier() > 0)
					if isboss then
						source:HandleBonus(self.Target:GetBossTier())
					else
						self.Target:TakeSpecialDamage(self.Target:Health(), DMG_DIRECT, owner, source, nil)
					end
				end
			--end
		end
		
		util.BlastDamagePlayer(source, owner, pos, self.ProjRadius + bonusmul * 5, self.ProjDamage + (bonusmul * self.ProjDamage * 0.7)/5, DMG_ALWAYSGIB, self.ProjTaper + bonusmul * 0.03)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(self:GetUp() * -1)
	util.Effect("decal_scorch", effectdata)
	util.Effect("Explosion", effectdata)
	util.Effect("explosion_rocket", effectdata)

	for i=1, 3 do
		self:EmitSound("npc/env_headcrabcanister/explosion.wav", 75 + i * 5, 100)
	end

	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end

	self.Done = true
	phys:EnableMotion(false)
	self.PhysicsData = data

	self:NextThink(CurTime())
end