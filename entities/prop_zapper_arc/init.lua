--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local math_round = math.Round

ENT.LastFire = 0

ENT.DeployableFills = true

function ENT:Initialize()
	self:SetModel("models/rmzs/zapper.mdl")
	self:SetModelScale(1, 0)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)
	self:SetBodygroup(1,1)

	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONGROUP_ALL)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetMaxObjectHealth(150)
	self:SetObjectHealth(self:GetMaxObjectHealth())

	self.NextZapCheck = CurTime()
end

function ENT:HitTarget(ent, damage, owner)
	local legdamage = self.Damage * (0.1 * 1.8185) -- too lazy to fix it right now
	ent:AddLegDamageExt(legdamage * 0.33, owner, self, SLOWTYPE_PULSE)
	timer.Simple(0, function()
		ent:AddLegDamage(legdamage * 0.67)
	end)

	if self.PointsMultiplier then
		POINTSMULTIPLIER = self.PointsMultiplier
	end
	ent:TakeSpecialDamage(damage, DMG_SHOCK, owner, self)
	if self.PointsMultiplier then
		POINTSMULTIPLIER = nil
	end

	self:EmitSound("ambient/office/zap1.wav", 70, 160, 0.6, CHAN_AUTO)
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	end

	if CurTime() < self:GetNextZap() or CurTime() < self.NextZapCheck then return end

	local curammo = self:GetAmmo()
	local owner = self:GetObjectOwner()
	if curammo >= 3 and owner:IsValid() then
		self.NextZapCheck = CurTime() + 0.4

		local pos = self:LocalToWorld(Vector(0, 0, 37))
		local target = self:FindZapperTarget(pos, owner)

		local shocked = {}
		if (self:GetHeatState() ~= 2) then 
			if target then
				self.LastFire = CurTime() + 6
				self:SetHeatLevel(self:GetHeatLevel() + self.HeatBuild * (owner.TurretHeatBuildMul or 1))
				self:SetAmmo(curammo - 3)

				if self:GetAmmo() == 0 then
					owner:SendDeployableOutOfAmmoMessage(self)
				end

				self:SetNextZap(CurTime() + 4.5 * (owner.FieldDelayMul or 1))
				self:HitTarget(target, (self.Damage or 55), owner)

				local effectdata = EffectData()
					effectdata:SetOrigin(target:WorldSpaceCenter())
					effectdata:SetStart(pos)
					effectdata:SetEntity(self)
				util.Effect("tracer_zapper_new", effectdata)
				
				local eData = EffectData()
					eData:SetEntity( self )
					eData:SetMagnitude(5)
					eData:SetScale(10)
				util.Effect( "TeslaHitboxes", eData, true, true )

				shocked[target] = true
				for i = 1, 3 do
					local tpos = target:WorldSpaceCenter()

					for k, ent in pairs(util.BlastAlloc(self, owner, tpos, self.Range * (owner.FieldRangeMul or 1))) do
						if not shocked[ent] and ent:IsValidLivingZombie() and not ent:GetZombieClassTable().NeverAlive then
							if WorldVisible(tpos, ent:NearestPoint(tpos)) then
								shocked[ent] = true
								target = ent

								timer.Simple(i * 0.15, function()
									if not ent:IsValid() or not ent:IsValidLivingZombie() or not WorldVisible(tpos, ent:NearestPoint(tpos)) then return end

									self:HitTarget(ent, (self.Damage or 55) / (i + 0.5), owner)

									local worldspace = ent:WorldSpaceCenter()
									effectdata = EffectData()
										effectdata:SetOrigin(worldspace)
										effectdata:SetStart(tpos)
										effectdata:SetEntity(target)
									util.Effect("tracer_zapper_new", effectdata)
								end)

								break
							end
						end
					end
				end
			end
		end
	end

	if self.LastFire <= CurTime() then
		self:SetHeatLevel(self:GetHeatLevel() -  FrameTime() * 2)
	end

	self:HeatThink()
	self:NextThink(CurTime())
	return true
end

function ENT:HeatThink()
	if self:GetHeatLevel() <= 0.0 then self:SetHeatState(1) end
end

function ENT:HitByWrench(wep, owner, tr)
	if not wep.IsWrench then return end
	if self:GetObjectOwner() == owner then
		self:SetHeatLevel(self:GetHeatLevel() - 0.04)
	end
end

function ENT:SetHeatState(state)
	self:SetDTInt(6, state)
end

function ENT:SetHeatLevel(heat)
	if heat > 1.0 then
		self:SetHeatState(2)
		self:DoElectricityEffect()
	end
	return self:SetDTFloat(6, heat)	
end

function ENT:DoElectricityEffect()
	local pos = self:LocalToWorld(Vector(0, 0, 25))
	local teslacoil = ents.Create("point_tesla")
	if teslacoil or teslacoil:IsValid() then
		teslacoil:SetPos(pos)
		teslacoil:SetKeyValue( "m_SoundName", "DoSpark" )
		teslacoil:SetKeyValue("texture", "trails/laser.vmt")
		teslacoil:SetKeyValue("m_Color", "50, 50, 255")
		teslacoil:SetKeyValue("m_flRadius", (32))
		teslacoil:SetKeyValue("interval_min", (0.012 * 0.75))
		teslacoil:SetKeyValue("interval_max", (0.112 * 1.25))
		teslacoil:SetKeyValue("beamcount_min", (math_round(6 * 0.75)))
		teslacoil:SetKeyValue("beamcount_max", (math_round(12 * 1.25)))
		teslacoil:SetKeyValue("thick_min", (2 * 0.75))
		teslacoil:SetKeyValue("thick_max", (4 * 1.25))
		teslacoil:SetKeyValue("lifetime_min", (0.3 * 0.75))
		teslacoil:SetKeyValue("lifetime_max", (0.3 * 1.25))
		teslacoil:Spawn()
		teslacoil:Fire("DoSpark", "", 0.1)
		teslacoil:Fire("kill", "", 0.5)
	end
end