ENT.Type = "anim"

ENT.CanPackUp = true
ENT.PackUpTime = 3

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.IgnoreBullets = true
ENT.IgnoreMelee = true
ENT.IgnoreTraces = true
ENT.FizzleStatusAOE = true
ENT.EntityDeployable = false
ENT.IsForceFieldShield = true
ENT.ScanFilter = true -- for drones

AccessorFuncDT(ENT, "Emitter", "Entity", 0)
AccessorFuncDT(ENT, "LastDamaged", "Float", 0)