AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Radius = 400

if CLIENT then return end

ENT.Classes = table.ToAssoc(
	{"prop_ammo", "prop_invitem", "prop_weapon"}
)
ENT.Force = 60
ENT.ForceDelay = 0.25

function ENT:Think()
	local owner = self:GetOwner()

	if owner:Team() == TEAM_UNDEAD then
		self:Remove()
		return
	end

	local activeweapon = owner:GetActiveWeapon()
	if not activeweapon:IsValid() or not activeweapon.IsMagnet then return end

	local pos = self:GetPos()
	for _, ent in pairs(ents.FindInSphere(pos, self.Radius)) do
		if ent and ent:IsValid() and not ent.PlacedInMap and not owner:IsSkillActive(SKILL_D_NOODLEARMS) then -- fuck you magnet main. Whoever took the free weapons/ammo from the map.
			local class = ent:GetClass()
			local ownsitem = not ent.NoPickupsOwner or ent.NoPickupsOwner == owner
			local droppedrecent = not ent.DroppedTime or ent.DroppedTime + 4 < CurTime()

			if self.Classes[class] and WorldVisible(pos, ent:NearestPoint(pos)) and droppedrecent and ownsitem then
				local phys = ent:GetPhysicsObject()

				if IsValid(phys) then
					local dir = (pos - ent:NearestPoint(pos)):GetNormalized()
					local mass = phys:GetMass()

					phys:ApplyForceCenter(mass * self.Force * dir)
					ent:SetPhysicsAttacker(owner, 4)

					if (ent:GetPos() - pos):LengthSqr() <= 5600 and ent.GiveToActivator then
						ent:GiveToActivator(owner)
					end
				end
			end
		end
	end

	self:NextThink(CurTime() + self.ForceDelay)
	return true
end
