AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local hook = hook
local ents = ents
local pairs = pairs
local NULL = NULL
local ents_FindByClass = ents.FindByClass
local util_Effect = util.Effect
local EffectData = EffectData
local CurTime = CurTime

local SOLID_VPHYSICS = SOLID_VPHYSICS
local SIMPLE_USE = SIMPLE_USE
local COLLISION_GROUP_WORLD = COLLISION_GROUP_WORLD

ENT.LaserPos = Vector(0, 0, 0)
ENT.LaserAng = Angle(0, 0, 0)
ENT.LaserLength = 1.0
ENT.TraceTable = {}

local function RefreshSlamOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_slam")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
			ent:EmitSound( "items/battery_pickup.wav", 75, 72 )
		end
	end
end
hook.Add("PlayerDisconnected", "Slam.PlayerDisconnected", RefreshSlamOwners)
hook.Add("OnPlayerChangedTeam", "Slam.OnPlayerChangedTeam", RefreshSlamOwners)

function ENT:Initialize()
	self.CreateTime = CurTime()
	self:SetModel("models/weapons/w_slam.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)
	
	self:SetBodygroup(0, 1)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	local attach = self:GetAttachment(self:LookupAttachment("beam_attach"))
	self.LaserPos = attach.Pos
	self.LaserAng = attach.Ang
	self.LaserDir = -attach.Ang:Right() * 192
	
	local tr = util.QuickTrace(attach.Pos, self.LaserDir, self:GetCachedScanFilter())
	self.LaserLength = tr.Fraction
end

function ENT:Use(activator, caller)
	if self.Exploded or self:GetExplodeTime() ~= 0 or not activator:IsPlayer() or activator:Team() == TEAM_UNDEAD or self:GetMaterial() ~= "" then return end

	local owner = self:GetOwner()
	if owner == activator or not IsValid(owner) then
		self:SetOwner(activator)
		self:EmitSound( "items/battery_pickup.wav", 75, 132 )
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if IsValid(owner) and owner:IsPlayer() and owner:Team() == TEAM_HUMAN then
		local pos = self:GetPos()

		--util.BlastDamageEx(self, owner, pos, 256, 192, DMG_BLAST)
		util.BlastDamagePlayer(self, owner, pos, 256, 192, DMG_ALWAYSGIB, 0.65)

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetAngles(self.LaserAng)
		util_Effect("Explosion", effectdata) --fx_explosion
	end
end

function ENT:Think()
	if self.Exploded then
		self:Remove()
		return
	end
	
	if not IsValid(self:GetOwner()) then return end
	
	if not self.Exploded and self:GetExplodeTime() == 0 then
		local tr = util.QuickTrace(self.LaserPos, self.LaserDir, self:GetCachedScanFilter())
		local ent = tr.Entity
		if self:GetExplodeTime() == 0 and ent:IsValidLivingZombie() then
			self:SetExplodeTime(CurTime() + self.ExplosionDelay)
		end
	end

	if self:GetExplodeTime() ~= 0 then
		if CurTime() >= self:GetExplodeTime() then
			self:Explode()
		elseif self.NextBlip <= CurTime() then
			self.NextBlip = CurTime() + self.ExplosionDelay * 0.25
			self:EmitSound("weapons/c4/c4_beep1.wav")
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_slam")
	pl:GiveAmmo(1, "smg1_grenade")

	pl:PushPackedItem(self:GetClass())

	self:Remove()
end

function ENT:SetExplodeTime(time)
	if self.CreateTime + self.ArmTime > CurTime() then return end

	self:SetDTFloat(0, time)
end
