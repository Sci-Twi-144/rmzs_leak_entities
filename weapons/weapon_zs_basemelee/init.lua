--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable

function SWEP:ServerMeleeHitEntity(tr, hitent, damagemultiplier)
	if not hitent or not hitent:IsValid() then return end

	if GAMEMODE.ZombieEscape then
		hitent:ThrowFromPositionSetZ(tr.StartPos, 325, nil, true)
	end

	local phys = hitent:GetPhysicsObject()
	if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
		hitent:SetPhysicsAttacker(self:GetOwner())
	end
end

function SWEP:ServerMeleePostHitEntity(tr, hitent, damagemultiplier)
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if otbl.GlassWeaponShouldBreak and hitent:IsPlayer() and not stbl.NoGlassWeapons and owner:IsSkillActive(SKILL_GLASSWEAPONS) and otbl.GlassWeaponShouldBreak then
		local effectdata = EffectData()
		effectdata:SetOrigin(owner:EyePos())
		effectdata:SetEntity(owner)
		util.Effect("weapon_shattered", effectdata, true, true)

		owner:StripWeapon(self:GetClass())
	end
end

function SWEP:ServerHitFleshEffects(hitent, tr, damagemultiplier)
	local owner = self:GetOwner()
	local damage = self.MeleeDamage * (damagemultiplier or 1)

	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == owner:Team() then return end

	util.Blood(tr.HitPos, math.Rand(damage * 0.25, damage * 0.6), (tr.HitPos - owner:GetShootPos()):GetNormalized(), math.min(400, math.Rand(damage * 6, damage * 12)), true)
end

SWEP.NumShards = 3

function SWEP:UtilShockWave()
	--[[
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)

	if not ((owner:GetMeleeAttachement() == "trinket_sanity_attachement") and ((stbl.Tier or 1) < 6)) then return end

	local damagemultiplier = (owner:Team() == TEAM_HUMAN and (otbl.MeleeDamageMultiplier or 1)) or 1
	local dmgmul = self:BeforeSwing(damagemultiplier)
	local numshots = stbl.NumShards
	local damage = ((stbl.MeleeDamage * dmgmul) / numshots) * (0.65 + (otbl.SanityAttachAds or 0))

	for i = 0, numshots -1 do
		local ent = ents.Create("projectile_shockwave")
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetAngles(owner:EyeAngles())
			ent:SetOwner(owner)
			ent.ProjDamage = damage * (owner.ProjectileDamageMul or 1)
			ent.ProjSource = self
			ent.ShotMarker = i
			ent.Team = owner:Team()	
			--ent:SetDTInt(5, (numshots - 1) -i)

			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()

				local angle = owner:GetAimVector():Angle()
				angle:RotateAroundAxis(angle:Up(), (1 - i) * 3)
				
				ent.PreVel = angle:Forward() * 900 * (otbl.ProjectileSpeedMul or 1)
				phys:SetVelocityInstantaneous(ent.PreVel)
			end
		end
	end
	owner:TakeStamina(stbl.StaminaConsumption * 1.6, 5)
	]]
end

function SWEP:OnZombieDed(zombie)
	local attacker = self:GetOwner()
	
	if attacker:IsValid() then
		
		if attacker.TrinketBusher and zombie.StaminaForKill and zombie.StaminaForKill > CurTime() then
			local orbcount = math.floor(zombie:GetMaxHealth() * 0.01)
			for i = 0, orbcount do
				local ent = ents.Create("prop_armororb")
				if ent:IsValid() then
					ent.PickupType = 2
					ent:SetPos(zombie:GetShootPos())
					ent:SetOwner(attacker)
					ent:Spawn()
				end
			end
		end
		
		if attacker.TrinketResupplyKill then
			rawset(PLAYER_NextResupplyUse, attacker, rawget(PLAYER_NextResupplyUse, attacker) - math.ceil(zombie:GetMaxHealth() * 0.02))
			net.Start("zs_nextresupplyuse")
			net.WriteFloat(rawget(PLAYER_NextResupplyUse, attacker))
			net.Send(attacker)
		end
	end
end