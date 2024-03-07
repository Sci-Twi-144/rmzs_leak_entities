ENT.Type = "anim"
ENT.IsProjectileZS = true

ENT.IgnoreBullets = true
ENT.IgnoreMelee = true
ENT.IgnoreTraces = true
ENT.Target = nil
ENT.LifeSpan = 5

util.PrecacheModel("models/rmzs/weapons/rpg_blueshift/w_rpg_projectile_blueshift.mdl")

function ENT:BeingControlled()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local wep = owner:GetActiveWeapon()
		return wep:IsValid() and wep.IsThruster and wep:GetDTBool(8)
	end
	
	return false
end

function ENT:Think()
	if self:BeingControlled() and not self.Target then
		self:FindTarget()
	elseif self.Target and not self:BeingControlled() then
		self.Target = nil
	end
	
	if self.Target and not self.Target:IsValidLivingZombie() then
		self.Target = nil
	end
	if CLIENT then
		local pos = self:GetPos()

		local boosted = self:GetDTBool(1)

		--self.AmbientSound:ChangePitch(boosted and 255 or 100)
		self.AmbientSound:ChangeVolume(boosted and 1 or 0.25,0.25)

		if not boosted then return end

		if ShouldDrawGlobalParticles(pos) then
			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)

			if self.SmokeTimer < CurTime() then
				self.SmokeTimer = CurTime() + (0.05)

				local particle = emitter:Add("effects/fire_cloud1", pos)
				particle:SetVelocity(self:GetVelocity() * -0.4 + VectorRand() * 60)
				particle:SetDieTime(0.5)
				particle:SetStartAlpha(100)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(12, 19))
				particle:SetEndSize(5)
				particle:SetRoll(math.Rand(-0.8, 0.8))
				particle:SetRollDelta(math.Rand(-3, 3))
				particle:SetColor(240, 180, 120)

				particle = emitter:Add("particles/smokey", pos + VectorRand() * 10)
				particle:SetDieTime(math.Rand(0.4, 0.6))
				particle:SetStartAlpha(math.Rand(110, 130))
				particle:SetEndAlpha(0)
				particle:SetStartSize(2)
				particle:SetEndSize(math.Rand(20, 34))
				particle:SetRoll(math.Rand(0, 359))
				particle:SetRollDelta(math.Rand(-3, 3))
				particle:SetColor(240, 190, 120)
			end

			emitter:Finish() emitter = nil collectgarbage("step", 64)

		end
	end

	if SERVER then
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
	end

end

function ENT:FindTarget()
	local lastdistance = 0
	local owner = self:GetOwner()
	local owpos = owner:GetPos()
	for _, ent in pairs(team.GetPlayers(TEAM_ZOMBIE)) do
		if ent:IsValidLivingZombie() and not SpawnProtection[ent] and owpos:DistToSqr(ent:GetPos()) > lastdistance then
			self.Target = ent
			lastdistance = owpos:DistToSqr(ent:GetPos())
		end
	end
end