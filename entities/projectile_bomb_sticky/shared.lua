ENT.Type = "anim"

ENT.IsProjectileZS = true
ENT.IgnoreBullets = true
ENT.ChargeTime = 3

AccessorFuncDT(ENT, "HitTime", "Float", 0)
AccessorFuncDT(ENT, "TimeCreated", "Float", 1)

function ENT:GetCharge()
	if self:GetTimeCreated() == 0 then return 0 end

	return math.Clamp(0.5 + (CurTime() - self:GetTimeCreated()) / self.ChargeTime / 2, 0, 1)
end

util.PrecacheModel("models/combine_helicopter/helicopter_bomb01.mdl")
