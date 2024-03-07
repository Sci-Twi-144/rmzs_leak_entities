--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_junk/TrashDumpster02b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetCustomCollisionCheck(true)
	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_FORCEFIELD, ZS_COLLISIONFLAGS_FORCEFIELD)
	--self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_CROW, bit.bor(ZS_COLLISIONGROUP_ALL, ZS_COLLISIONGROUP_PROJECTILE_ZOMBIE))

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmginfo)
	local inflictor = dmginfo:GetInflictor():IsValid() and dmginfo:GetInflictor() or dmginfo:GetAttacker()
	if dmginfo:GetDamage() <= 0 or not inflictor:IsProjectile() then return end

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		local emitter = self:GetEmitter()
		if emitter and emitter:IsValid() and emitter.GetAmmo and emitter:GetAmmo() > 0 then
			self:SetLastDamaged(CurTime())
			self:EmitSound("ambient/energy/weld2.wav", 65, 255, 0.6)

			local ammousage = (dmginfo:GetDamage() / 8) + (emitter.CarryOver or 0)
			local floor = math.floor(ammousage)
			local owner = emitter:GetObjectOwner()

			emitter.CarryOver = ammousage - floor
			emitter:SetAmmo(math.max(emitter:GetAmmo() - floor, 0))

			if emitter:GetAmmo() == 0 then
				owner:SendDeployableOutOfAmmoMessage(emitter)
			end

			GAMEMODE:DamageFloater(attacker, self, dmginfo:GetDamagePosition(), ammousage, false)

			if owner:IsValidLivingHuman() then
				owner:AddPoints(dmginfo:GetDamage() * 0.05)

				if emitter:GetAmmo() == 0 then
					owner:SendDeployableOutOfAmmoMessage(emitter)
				end
			end

			self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_FORCEFIELD, ZS_COLLISIONFLAGS_FORCEFIELD)
		else
			self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_SPECTATOR, ZS_COLLISIONFLAGS_SPECTATOR)
		end
	end
end
