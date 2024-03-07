ENT.Type = "anim"

ENT.IsProjectileZS = true

ENT.IgnoreBullets = true
ENT.IgnoreMelee = true
ENT.IgnoreTraces = true

AccessorFuncDT(ENT, "HitTime", "Float", 0)
AccessorFuncDT(ENT, "TimeCreated", "Float", 1)

util.PrecacheModel("models/combine_helicopter/helicopter_bomb01.mdl")
