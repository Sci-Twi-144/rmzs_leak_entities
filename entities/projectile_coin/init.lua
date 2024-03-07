--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Base = "projectile_basezs"
ENT.HitOneTime = true
ENT.Model = "models/combine_helicopter/helicopter_bomb01.mdl"
ENT.Split = false

function ENT:InitProjectile()
	self.Bounces = 0
	self:PhysicsInitSphere(2)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(1, 0)
	self:SetTrigger(true)
	self.Black = 0
	self.StartTime = CurTime()
	self.BlackEnt = nil

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:EnableGravity(not self.Special)
	end


	self:Fire("kill", "", self.Special and 5 or 10)
	self.Trail = util.SpriteTrail( self, 0, Color(255, 255, 0, 255), true, 8, 0, 0.5, 0.05, "sprites/bluelaser1" )
end

--[[function ENT:InitProjectilePhys(phys)
	phys:EnableGravity(not self.Special)
	phys:EnableDrag(false)
end]]

function ENT:CoinRicochet(dmg, inflictor, taper, hull, pierce, ent)

	local owner = self:GetOwner()
	local targetpos, pos, coinent, iterations = nil, self:GetPos(), nil, self.Split and 1 or 0
	self.Black = self.Black + 1
	local dmg = dmg * 1.25
	
	timer.Simple(0.08, function()
	pos = self:IsValid() and self:GetPos() or pos
		for i = 0, iterations do
		targetpos = nil
		coinent = nil
			for _, coins in pairs(ents.FindByClass("projectile_coin")) do
				if coins and coins:IsValid() and (coins.Black < self.Black) and WorldVisible(pos, coins:GetPos()) and coins ~= self and coins:GetOwner() == owner and (self.BlackEnt == nil or (self.BlackEnt ~= coins)) then
					coinent = coins
					if self.Split then
						coinent.Split = true
					end
				end 
			end

			if owner:IsValidHuman() then
				local source, rand = self:ProjectileDamageSource(), 360
				
				if coinent == nil then
					for _, ent in pairs(team.GetPlayers(TEAM_ZOMBIE)) do
						local vpos = ent:GetPos()
						if vpos:DistToSqr(self:GetPos()) < 1048576 then --1024^2
							if IsValid(ent) and WorldVisible(pos, ent:NearestPoint(pos)) then
								if ent:IsValidLivingZombie() and not SpawnProtection[ent] then
									if targetpos == nil and (self.BlackEnt == nil or (self.BlackEnt ~= ent)) then
										targetpos = ent
									elseif targetpos ~= nil and pos:DistToSqr(ent:GetShootPos()) < pos:DistToSqr(targetpos:GetShootPos()) and (self.BlackEnt == nil or (self.BlackEnt ~= ent)) then
										targetpos = ent
									end
								end
							end
						end
					end
				end	
				self.BlackEnt = coinent and coinent or targetpos and targetpos or nil
				local vectordir = coinent and ((coinent:GetPos() - self:GetPos()):GetNormalized()) or targetpos and self:FindHead(targetpos) or Vector(math.random(rand), math.random(rand), math.random(rand))
				self:FireBulletsLua(self:WorldSpaceCenter(), vectordir, 0, 1, pierce, taper, dmg, owner, nil, "tracer_piercer", inflictor.BulletCallback, hull, nil, 1024, nil, inflictor)
			end
			
			if (self.Split and i == iterations) or not self.Special then
				self:Remove()
			end			
		end
		
		--[[if not self.Special then
			self:Remove()
		end]]
	end)
end

function ENT:ProcessHitEntity(ent)
	--[[if not self.Special then
		self:Remove()
	end]]
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:IsValidLivingHuman() then
		local inflictor = dmginfo:GetInflictor()
		local extrataper, extrahull, extrapierce = (inflictor.DamageTaper or 1), (inflictor.Primary.HullSize or nil), (inflictor.Pierces or 1)
		local manyshots = inflictor.Primary and (inflictor.Primary.NumShots < 4) or false -- надо фикс
		if inflictor:IsValid() and attacker == self:GetOwner() then
			if manyshots and not self.Special and not self.Split and (0.25 + math.abs(math.cos((CurTime() - self.StartTime) * 2 * math.pi))) >= 1 then
				self.Split = true
			end
			self:CoinRicochet(dmginfo:GetDamage(), inflictor, extrataper, extrahull, extrapierce)
		end
	end
end

function ENT:OnRemove()
	if self.Special then
		self.ProjSource:SetTumbler(false)
	end
end

function ENT:FindHead(target)
	local classmdl, bloated, poison, skeletaltorso = (target and target:GetZombieClassTable().Model or nil), Model("models/player/fatty/fatty.mdl"), Model("models/Zombie/Poison.mdl"), Model("models/zombie/classic_torso.mdl")
	local bonenum = target and ((classmdl == poison and 14) or (classmdl == bloated and 12) or (classmdl == skeletaltorso and 7)) or 0
	
	return (target:GetBonePositionMatrixed(target:GetHitBoxBone(bonenum, 0)) - self:WorldSpaceCenter()):GetNormalized()
end