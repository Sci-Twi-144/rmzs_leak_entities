--[[SECURE]]--
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local function RefreshClaymoreOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_claymore")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "Claymore.PlayerDisconnected", RefreshClaymoreOwners)
hook.Add("OnPlayerChangedTeam", "Claymore.OnPlayerChangedTeam", RefreshClaymoreOwners)

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Initialize()
	self.Entity:SetModel("models/hoff/weapons/seal6_claymore/w_claymore.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetCustomGroupAndFlags(ZS_COLLISIONGROUP_HUMAN, ZS_COLLISIONGROUP_ALL)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:Think()
	if self.Exploded then
		self:Remove()
		return
	end

	local pos = self:GetPos()

	local tracedata1 = {}
	tracedata1.start = pos
	tracedata1.endpos = self:GetPos() + self:GetRight() * -50 + self:GetForward() * 40 + Vector(0,0,12)
	tracedata1.filter = self:GetCachedScanFilter()
	local trace1 = util.TraceLine(tracedata1)

	local tracedata2 = {}
	tracedata2.start = pos
	tracedata2.endpos = self:GetPos() + self:GetRight() * -50 + self:GetForward() * -40 + Vector(0,0,12)
	tracedata2.filter = self:GetCachedScanFilter()
	local trace2 = util.TraceLine(tracedata2)
	
	if trace2.HitNonWorld or trace1.HitNonWorld then
		target2 = trace2.Entity 
		target1 = trace1.Entity 
		local owner = self:GetOwner()
		if (target2:IsPlayer() and target2:IsValid() and not target2.NoCollideAll) or (target1:IsPlayer() and target1:IsValid() and not target1.NoCollideAll) then
			if (target1 ~= owner) or (target2 ~= owner) then
				self:Explode()
			end
		end
	end

	self:NextThink(CurTime() + 0.35)
	return true
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if IsValid(owner) and owner:IsPlayer() then
		local pos = self:GetPos()

		util.BlastDamagePlayer(self, owner, pos + self:GetUp() * 6, 128, 290, DMG_ALWAYSGIB, 0.85)

		self:EmitSound( "ambient/explosions/explode_4.wav" )

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetColor(4)
		util.Effect("Explosion", effectdata)
	end
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_claymore")
	pl:GiveAmmo(1, "claymore")

	pl:PushPackedItem(self:GetClass())

	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	if dmginfo:GetDamage() <= 0 then return end

	if not self.Exploded and dmginfo:GetDamage() >= 9 then
		local attacker = dmginfo:GetAttacker()
		if attacker:Team() == TEAM_ZOMBIE then
			self:Explode()
		end
	end
end