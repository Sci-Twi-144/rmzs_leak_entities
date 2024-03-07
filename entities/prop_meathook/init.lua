--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.NextDamage = 0
ENT.TicksLeft = 10

function ENT:Initialize()
	self:SetModel("models/props_junk/meathook001a.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEFlags(EFL_SETTING_UP_BONES)
end
--[[
function ENT:CheckDrop()
	if self:GetParent():GetZombieClassTable().Boss or self:GetParent():GetZombieClassTable().MiniBoss then
		return "prop_weapon"
	else
		return "prop_fakeweapon"
	end
end
]]
function ENT:Drop()
	local ent = ents.Create("prop_fakeweapon")
	if ent:IsValid() then
		ent:SetWeaponType(self.BaseWeapon)
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:Spawn()

		--[[local owner = self:GetOwner()
		if owner:IsValidHuman() then
			ent.NoPickupsTime = CurTime() + 15
			ent.NoPickupsOwner = owner
		end]]

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddAngleVelocity(VectorRand() * 200)
			phys:SetVelocityInstantaneous(Vector(0, 0, 200))
		end
	end

	self:Remove()
end

function ENT:Think()
	local parent = self:GetParent()
	if parent:IsValid() and parent:IsPlayer() then
		local owner = self:GetOwner()

		if parent:Alive() and parent:Team() == TEAM_UNDEAD and self.TicksLeft >= 1 and not SpawnProtection[parent] then
			if CurTime() >= self.NextDamage then
				local taketicks = parent:PlayerIsBoss() and 2 or 1
				self.NextDamage = CurTime() + 0.35
				self.TicksLeft = self.TicksLeft - taketicks

				if self.Weaken then
					parent:ApplyZombieDebuff("zombiestrdebuff", 0.45, {Applier = owner}, true, 35)
					--[[
					local status = parent:GiveStatus("zombiestrdebuff")
					status.DieTime = CurTime() + 0.45
					status.Applier = owner
					]]
				end
				
				if self.Bounty then
					local attackertbl = FindMetaTable("Entity").GetTable(owner)
					local prog = math.Clamp(1 - (attackertbl.BountyMultiplier or 0), 0.05, 2)
					owner:AddAccuBounty(self.BleedPerTick * prog)
					owner:BountyRecieve(owner)
				end

				util.Blood((parent:NearestPoint(self:GetPos()) + parent:WorldSpaceCenter()) / 2, math.random(4, 9), Vector(0, 0, 1), 100)
				parent:TakeSpecialDamage(self.BleedPerTick, DMG_SLASH, owner, self)
			end
		else
			self:Drop()
			owner:Give(self.BaseWeapon)
			owner:SelectWeapon(self.BaseWeapon)
		end
	else
		self:Remove()
	end
end