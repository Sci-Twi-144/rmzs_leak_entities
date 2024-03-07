AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local SOLID_VPHYSICS = SOLID_VPHYSICS
local COLLISION_GROUP_DEBRIS = COLLISION_GROUP_DEBRIS
local IsValid = IsValid
local Vector = Vector
local TEAM_SPECTATOR = TEAM_SPECTATOR

ENT.Models = {
	"models/katharsmodels/present/type-2/normal/present.mdl",
	"models/katharsmodels/present/type-2/normal/present2.mdl",
	"models/katharsmodels/present/type-2/normal/present3.mdl"
}

ENT.LifeTime = 30

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel(self.Models[math.random(1, 3)])
	self:SetModelScale(2, 0)
	self:SetPos(self:GetPos() + self:GetUp() * 18)
	self:PhysicsInitBox(Vector(-16,-16,0), Vector(16,16,16))
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	self:Activate()
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	
	timer.Simple(1, function() if IsValid(self) then self:SetTrigger(true) end end)
	
	self:DropToFloor()

	self:Fire("kill", "", self.LifeTime)
end

function ENT:Touch(ent)
	if not self.bPickedUp then
		if not ent:IsValidLivingHuman() or ent:IsBot() then return end -- oh lol

		self.bPickedUp = true
		if ent:Team() == TEAM_HUMAN then
		--[[	if not ent:HasWeapon("weapon_zs_giftcase") then
				ent:GiveEmptyWeapon("weapon_zs_giftcase")
			end
			ent:GiveAmmo(1, "gift")
		else]]
			GiveNonBullshitReward(ent)
		end
		
		ent:EmitSound("pickups/bonus_crate.wav", 180)
		self:Remove()
	end
end
