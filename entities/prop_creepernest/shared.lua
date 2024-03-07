ENT.Type = "anim"

ENT.MaxHealth = 350

ENT.ModelScale = Vector(1, 1, 0.5)

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.Blocked = false

ENT.IsCreeperNest = true

AccessorFuncDT(ENT, "NestHealth", "Float", 0)
AccessorFuncDT(ENT, "NestBuilt", "Bool", 0)
AccessorFuncDT(ENT, "NestLastDamaged", "Float", 1)
AccessorFuncDT(ENT, "NestOwner", "Entity", 0)

function ENT:SetNestBuilt(b)
	self:SetDTBool(0, b)
	self:CollisionRulesChanged()
	if SERVER and b then
		GAMEMODE.AllNestsTbl[#GAMEMODE.AllNestsTbl + 1] = self
	end
end

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() --and (not self:GetNestBuilt() or ent:Team() == TEAM_UNDEAD)
end

function ENT:GetNestMaxHealth()
	return self.MaxHealth
end

function ENT:SetNestMutationLevel(level)
	self:SetDTInt(10, level)
end

function ENT:GetNestMutationLevel()
	return self:GetDTInt(10)
end
