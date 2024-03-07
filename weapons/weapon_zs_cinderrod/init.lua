--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		local pos = tr.HitPos
		for ent, dmg in pairs(util.BlastDamageExAlloc(attacker:GetActiveWeapon(), attacker, pos, 82, dmginfo:GetDamage() * 0.75, DMG_ALWAYSGIB)) do
			if math.random(4) == 1 and ent:IsValidLivingPlayer() and (ent:Team() == TEAM_UNDEAD or ent == attacker) then
				ent:AddBurnDamage(dmg / 2.8, attacker or dmginfo:GetInflictor(), attacker.BurnTickRate or 1)
			end
		end

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata, true, true)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self:GetFireDelay())

	self:EmitFireSound()
	self:TakeAmmo()
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local owner = self:GetOwner()
	if owner:IsValid() then
		local pos = owner:GetPos()

		util.BlastDamagePlayer(self, owner, pos, 50, 55, DMG_ALWAYSGIB)

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata, true, true)
	end
end
