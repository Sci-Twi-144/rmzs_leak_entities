--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.DeployableFills = true
ENT.LastHitSomething = 0
ENT.TurretDeployableAmmo = "thumper"
ENT.LastHitPeriod = 0.5
ENT.Hitbox = "prop_hitbox_gunturret"
ENT.LastFire = 0
ENT.WarmedUp = false

local function RefreshTurretOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_gunturret*")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:ClearObjectOwner()
			ent:ClearTarget()
		end
	end
end
hook.Add("PlayerDisconnected", "GunTurret.PlayerDisconnected", RefreshTurretOwners)
hook.Add("OnPlayerChangedTeam", "GunTurret.OnPlayerChangedTeam", RefreshTurretOwners)

function ENT:CreateHook()
	local ent = self
	local ENTC = tostring(ent)

	hook.Add("SetupPlayerVisibility", ENTC, function(pl)
		if not IsValid(ent) then return end
		
		if pl ~= ent:GetObjectOwner() then return end

		AddOriginToPVS(ent:GetPos())
		AddOriginToPVS(ent:GetPos() + pl:GetAimVector() * 1024)
	end)
end

function ENT:Initialize()
	self:GetVariables()
	if self:GetTurretType() == 6 then
		self:SetModel("models/rmzs/turrets/heavypulse_turret.mdl")
	else
		self:SetModel("models/Combine_turrets/Floor_turret.mdl")
	end
	self:SetModelScale(self.ModelScale or 1, 0)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(50)
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetAmmo(self.DefaultAmmo)
	self:SetMaxObjectHealth(self.MaxHealth)
	self:SetObjectHealth(self:GetMaxObjectHealth())
	self:SetScanSpeed(1)
	self:SetScanMaxAngle(1)

	local ent = ents.Create(self.Hitbox)
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:SetOwner(self)
		ent:SetParent(self)
		ent:Spawn()

		self:DeleteOnRemove(ent)
		self.Hitbox = ent
		self:SetTurretHitbox(ent)
	end

	self:SetupPlayerSkills()

	self.OriginalFireDelay = self.FireDelay

	self:CreateHook()
end

function ENT:RemoveHook()
	hook.Remove("SetupPlayerVisibility", tostring(self))
end

function ENT:OnRemove()
	self:RemoveHook()
end

function ENT:SetupPlayerSkills()
	local owner = self:GetObjectOwner()
	local scanspeed = 1
	local scanangle = 1

	if owner:IsValid() then
		scanspeed = scanspeed * (owner.TurretScanSpeedMul or 1)
		scanangle = scanangle * (owner.TurretScanAngleMul or 1)
	end

	self:SetScanSpeed(scanspeed)
	local bool = (self:GetTurretType() == 6) or (self:GetTurretType() == 7)
	self:SetScanMaxAngle(scanangle / (bool and 4 or 1))

	self:SetupDeployableSkillHealth("TurretHealthMul")
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(3, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local pos = self:LocalToWorld(self:OBBCenter())

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata, true, true)

		if self:GetObjectOwner():IsValidLivingHuman() then
			self:GetObjectOwner():SendDeployableLostMessage(self)
		end

		local amount = math.ceil(self:GetAmmo() * 0.5)
		while amount > 0 do
			local todrop = math.min(amount, 50)
			amount = amount - todrop
			local ent = ents.Create("prop_ammo")
			if ent:IsValid() then
				local heading = VectorRand():GetNormalized()
				ent:SetAmmoType(self.AmmoType or "smg1")
				ent:SetAmmo(todrop)
				ent:SetPos(pos + heading * 8)
				ent:SetAngles(VectorRand():Angle())
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:ApplyForceOffset(heading * math.Rand(8000, 32000), pos)
				end
			end
		end
	end
end

local TEMPTURRET
local function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() then
		if TEMPTURRET:GetTarget() == ent and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then
			TEMPTURRET.LastHitSomething = CurTime()
		end

		dmginfo:SetInflictor(TEMPTURRET)
	end
	if TEMPTURRET:GetTurretType() == 5 then
		local ent = tr.Entity
		if ent:IsValidLivingZombie() then
			local multi = (attacker.PulseRoundMulti or 1)
			local damage = dmginfo:GetDamage() * (0.1 * (TEMPTURRET.LegDamageMul or 1)) * multi
			ent:AddLegDamageExt(damage, attacker, TEMPTURRET, SLOWTYPE_PULSE)
		end
		if IsFirstTimePredicted() then
			util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
		end
	end

	if TEMPTURRET:GetTurretType() == 6 then
		local ent = tr.Entity
		if ent:IsValidLivingZombie() then
			dmginfo:SetDamage(dmginfo:GetDamage() + math.min(math.sqrt(ent:Health()), 150))
			local multi = (attacker.PulseRoundMulti or 1)
			local damage = dmginfo:GetDamage() * (0.1 * (TEMPTURRET.LegDamageMul or 1)) * multi
			ent:AddLegDamageExt(damage, attacker, TEMPTURRET, SLOWTYPE_PULSE)
		end
		if IsFirstTimePredicted() then
			util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
		end
	end
end

function ENT:FireTurret(src, dir)
	if self:GetNextFire() <= CurTime() then
		local curammo = self:GetAmmo()
		local owner = self:GetObjectOwner()
		local twinvolley = self:GetManualControl() and owner:IsSkillActive(SKILL_TWINVOLLEY)
		if curammo > (twinvolley and 1 or 0) then
			self:SetNextFire(CurTime() + self.FireDelay * (twinvolley and 1.5 or 1))
			self:SetAmmo(curammo - (twinvolley and 2 or 1) * ((self:GetTurretType() == 6) and 3 or 1))

			self:SetHeatLevel(self:GetHeatLevel() + self.HeatBuild * (owner.TurretHeatBuildMul or 1))
			self.LastFire = CurTime() + 8

			if self:GetAmmo() == 0 then
				owner:SendDeployableOutOfAmmoMessage(self)
			end

			self:PlayShootSound()

			TEMPTURRET = self
			if self:GetTurretType() == 1 or self:GetTurretType() == 2 or self:GetTurretType() == 3 or self:GetTurretType() == 5 or self:GetTurretType() == 6 or self:GetTurretType() == 7 then
				self:FireBulletsLua(src, dir, self.Spread, self.NumShots * (twinvolley and 2 or 1), self.Pierces or 1, self.Taper or 1, self.Damage, self:GetObjectOwner(), nil, nil, BulletCallback, nil, nil, nil, nil, self)
				self:SetLastShotTime(self:GetLastShotTime() + 1)
			elseif self:GetTurretType() == 4 then
				local angle = dir:Angle()
				for i = 1, self.NumShots * (twinvolley and 2 or 1) do
					local ent = ents.Create("projectile_rocket")
					if ent:IsValid() then
						ent:SetPos(src)
						ent:SetAngles(angle)
						ent:SetOwner(owner)
						ent.ProjDamage = self.Damage * (owner.ProjectileDamageMul or 1)
						ent.ProjSource = self
						ent.ProjTaper = 0.85

						ent.Team = owner:Team()
						ent:Spawn()

						local phys = ent:GetPhysicsObject()
						if phys:IsValid() then
							phys:Wake()

							angle:RotateAroundAxis(angle:Forward(), math.Rand(0, 360))
							angle:RotateAroundAxis(angle:Up(), math.Rand(-self.Spread, self.Spread))
							phys:SetVelocityInstantaneous(angle:Forward() * 900 * (owner.ProjectileSpeedMul or 1))
						end
					end
				end
			end
		else
			self:SetNextFire(CurTime() + 2)
			self:EmitSound("npc/turret_floor/die.wav")
		end
	end
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
		return
	end

	self:CalculatePoseAngles()

	self:HeatThink()
	if (self:GetHeatState() ~= 2) then 
		self:TurretProcessing()
	else
		local target = self:GetTarget()
		if target:IsValid() then self:ClearTarget() end
		if self:IsFiring() then self:SetFiring(false) end
	end

	if self.LastFire <= CurTime() then
		self:SetHeatLevel(self:GetHeatLevel() -  FrameTime() * 0.11)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:TurretProcessing()
	local owner = self:GetObjectOwner()
	if owner:IsValid() and self:GetAmmo() > 0 and self:GetMaterial() == "" then
		if self:GetManualControl() then
			if owner:KeyDown(IN_ATTACK) then
				if not self:IsFiring() then self:SetFiring(true) end
				self:FireTurret(self:ShootPos(), self:GetGunAngles():Forward())
			elseif self:IsFiring() then
				self:SetFiring(false)
			end

			local target = self:GetTarget()
			if target:IsValid() then self:ClearTarget() end
		else
			if self:IsFiring() then self:SetFiring(false) end
			local target = self:GetTarget()
			if target:IsValid() then
				if self:IsValidTarget(target) and CurTime() < self.LastHitSomething + self.LastHitPeriod then
					self:FireTurret(self:ShootPos(), (self:GetTargetPos(target) - self:ShootPos()):GetNormalized())
				else
					self:ClearTarget()
					self:EmitSound("npc/turret_floor/deploy.wav")
				end
			else
				target = self:SearchForTarget()
				if target then
					self:SetTarget(target)
					self:SetTargetReceived(CurTime())
					self:EmitSound("npc/turret_floor/active.wav")
				end
			end
		end
	elseif self:IsFiring() then
		self:SetFiring(false)
	end
end

function ENT:HeatThink()
	if self:GetHeatLevel() <= 0.0 then self:SetHeatState(1) end

	if self.WarmedUp and self.NextBoost <= CurTime() then
		self.FireDelay = self.OriginalFireDelay
		self.WarmedUp = false
	end
end

function ENT:HitByWrench(wep, owner, tr)
	if not wep.IsWrench then return end
	if self:GetObjectOwner() == owner then
		if not self.WarmedUp and owner:IsSkillActive(SKILL_ENGINEER) then
			self.WarmedUp = true 
			self.NextBoost = CurTime() + 0.33
			self.FireDelay = self.FireDelay * 0.69
		end

		if self.LastFire >= CurTime() then
			self.LastFire = self.LastFire - 3
		end

		self:SetHeatLevel(self:GetHeatLevel() - 0.05)
	end
end

function ENT:SetupPlayerVisibility(pl)
	if pl ~= self:GetObjectOwner() then return end

	AddOriginToPVS(self:GetPos())
	AddOriginToPVS(self:GetPos() + pl:GetAimVector() * 1024)
end

function ENT:Use(activator, caller)
	if self.Removing or not activator:IsPlayer() or self:GetMaterial() ~= "" then return end

	if activator:Team() == TEAM_HUMAN then
		if self:GetObjectOwner():IsValid() then
			if activator:GetInfo("zs_nousetodeposit") == "0" or self:GetObjectOwner() == activator then
				if self:GetObjectOwner():IsSkillActive(SKILL_D_NOODLEARMS) and (self:GetObjectOwner() ~= activator) then
					GAMEMODE:ConCommandErrorMessage(activator, translate.ClientGet(activator, "loot_for_plebs_3"))
				else
					local curammo = self:GetAmmo()
					local togive = math.min(15, activator:GetAmmoCount(self.AmmoType or "smg1"), (self.MaxAmmo or 1000) - curammo)
					if togive > 0 then
						self:SetAmmo(curammo + togive)
						activator:RemoveAmmo(togive, self.AmmoType or "smg1")
						activator:RestartGesture(ACT_GMOD_GESTURE_ITEM_GIVE)
						self:EmitSound("npc/turret_floor/click1.wav")
						--gamemode.Call("PlayerRepairedObject", activator, self, togive * 1.5, self)
					end
				end
			end
		else
			self:SetObjectOwner(activator)
			self:GetObjectOwner():SendDeployableClaimedMessage(self)
			if not activator:HasWeapon("weapon_zs_gunturretcontrol") then
				activator:Give("weapon_zs_gunturretcontrol")
			end
		end
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon(self.SWEP)
	pl:GiveAmmo(1, self.TurretDeployableAmmo)

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth(), self:GetHeatLevel())
	pl:GiveAmmo(self:GetAmmo(), self.AmmoType or "smg1")

	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	if dmginfo:GetDamage() <= 0 then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end

local tabSearch = {mask = MASK_SHOT}
function ENT:SearchForTarget()
	local shootpos = self:ShootPos()
	local owner = self:GetObjectOwner()

	tabSearch.start = shootpos
	tabSearch.endpos = shootpos + self:GetGunAngles():Forward() * self:GetTurretSearchDistance() * (owner.TurretRangeMul or 1)
	tabSearch.filter = self:GetCachedScanFilter()
	local tr = util.TraceLine(tabSearch)
	local ent = tr.Entity
	if ent and ent:IsValid() and self:IsValidTarget(ent) then
		return ent
	end
end

function ENT:SetAmmo(ammo)
	self:SetDTInt(0, ammo)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTInt(1, health)
end

function ENT:SetHeatState(state)
	self:SetDTInt(6, state)
end

function ENT:SetChannel(channel)
	self:SetDTInt(2, channel)
end

function ENT:SetFiring(onoff)
	self:SetDTBool(0, onoff)
end

function ENT:SetHeatLevel(heat)
	if heat > 1.0 then
		self:SetHeatState(2)
	end
	return self:SetDTFloat(6, heat)	
end
--[[
function ENT:SetHeatLevel(heat)
	self:SetDTFloat(6, heat)
end
]]
function ENT:SetScanMaxAngle(angle)
	self:SetDTFloat(5, angle)
end

function ENT:SetScanSpeed(speed)
	self:SetDTFloat(4, speed)
end

function ENT:SetNextFire(tim)
	self:SetDTFloat(2, tim)
end

function ENT:ClearObjectOwner()
	self:SetObjectOwner(NULL)
end

function ENT:ClearTarget()
	self:SetTarget(NULL)
end

function ENT:SetTargetReceived(tim)
	self:SetDTFloat(0, tim)
end

function ENT:SetTargetLost(tim)
	self:SetDTFloat(1, tim)
end

function ENT:SetTarget(ent)
	if ent:IsValid() then
		self:SetTargetReceived(CurTime())
		self.LastHitSomething = CurTime()
	else
		self:SetTargetLost(CurTime())
	end

	self:SetDTEntity(0, ent)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
	if self.HitBox then
		self.HitBox:SetObjectOwner(ent)
	end

	self:SetupPlayerSkills()
end

function ENT:SetTurretHitbox(ent)
	self:SetDTEntity(2, ent)
end
