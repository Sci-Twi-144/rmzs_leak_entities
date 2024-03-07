--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:GetPositionByTrace(owner, pos, distance, direction)

	local tracec = {mask = MASK_SOLID_BRUSHONLY}

	tracec.start = pos
	tracec.endpos = pos + direction * distance
	local tr = util.TraceLine(tracec)
	if tr.Hit then
		return tr.HitPos, tr.HitNormal, tr.Normal
	else
		return false, false
	end
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	local secondary = self:IsCharging()

	if secondary then
		self.OriginalMeleeDamage = self.MeleeDamage
		self.OriginalMeleeKnockBack = self.MeleeKnockBack
		self.OriginalArmDamageMul = self.ArmDamageMul
		self.MeleeDamage = self.MeleeDamage * self.MeleeDamageSecondaryMul
		self.MeleeKnockBack = self.MeleeKnockBack * self.MeleeKnockBackSecondaryMul
		self.ArmDamageMul = self.ArmDamageMul * 2
	end

	local owner = self:GetOwner()
	
	if hitent:IsValid() and hitent:IsPlayer() and secondary then
		if owner:KeyDown(IN_SPEED) and self:GetResource() >= 500 then
			self.TargetEntity = hitent
		end
	end

	if tr.HitWorld and tr.HitNormal.z > 0.8 and hitent == Entity(0) and secondary then
	
		if owner:KeyDown(IN_SPEED) and self:GetResource() >= 500 then
			local hedpos = owner:GetShootPos()
			local direct = owner:GetForward():GetNormalized()
			local distance = math.floor(self:GetResource()/500) * 50
			local firstcheck, firsthitnorm, firstnorm = self:GetPositionByTrace(owner, hedpos, distance, direct)
			if not firstcheck then
				for i = 1, distance/50 do
					local posp, hitnormp, normp = self:GetPositionByTrace(owner, hedpos + i*50 * direct, 500, Vector(0,0,-1))
					if posp and hitnormp.z > 0.8 then
						self.Spikes[i] = {posp, CurTime() + i*0.2}
					end
				end
			else
				local iter = 0
				while distance > 0 and iter < 5 do
					local diff = firstcheck and firstcheck:DistToSqr(hedpos) ^ 0.5 or distance
					local count = math.floor(diff/50)
					for i = 1, count do
						local posp, hitnormp, normp = self:GetPositionByTrace(owner, hedpos + i*50 * direct, 300, Vector(0,0,-1))
						if posp and hitnormp.z > 0.8 then
							table.insert(self.Spikes, #self.Spikes + 1, {posp, CurTime() + #self.Spikes * 0.2})
						end
					end
					distance = distance - diff
					if distance > 0 then
						direct = (2 * firsthitnorm * firsthitnorm:Dot(firstnorm * -1) + firstnorm)
						hedpos = firstcheck
						firstcheck, firsthitnorm, firstnorm = self:GetPositionByTrace(owner, firstcheck, distance, direct)
					end
					iter = iter + 1
				end
			end
		
			--[[local vPos, pikecount, counter = owner:GetPos(), math.floor(self:GetResource() / 500), 0
			for _, ent in pairs(team.GetPlayers(TEAM_ZOMBIE)) do
				if ent and ent:IsValidLivingPlayer() and WorldVisible(vPos, ent:NearestPoint(vPos)) then
					if ent:GetPos():DistToSqr(vPos) < ((self.MeleeDamage * 1.5) ^ 2) then
						timer.Simple(counter * 0.2, function()
							local ice = ents.Create("env_protrusionspike")
							if ice:IsValid() then
								ice.Special = true
								ice:SetPos(ent:GetPos())
								ice:SetOwner(owner)
								ice.Damage = self.MeleeDamage * 0.6
								ice.Team = owner:Team()
								ice.Tier = self.Tier
								ice:Spawn()
							end
						end)
						pikecount = pikecount - 1
						counter = counter + 1
						self:SetResource(self:GetResource() - 500)
						if pikecount == 0 then break end
					end
				end
			end]]
			
		else
		
			local ice = ents.Create("env_protrusionspike")
			if ice:IsValid() then
				ice:SetPos(tr.HitPos)
				ice:SetOwner(owner)
				ice.Damage = self.MeleeDamage * 0.7
				ice.Team = owner:Team()
				ice:Spawn()
				ice.Tier = self.Tier
			end
		end
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if self:IsCharging() then
		self.MeleeDamage = self.OriginalMeleeDamage
		self.MeleeKnockBack = self.OriginalMeleeKnockBack
		self.ArmDamageMul = self.OriginalArmDamageMul
	end
end
