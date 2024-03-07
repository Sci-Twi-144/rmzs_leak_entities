ENT.Type = "anim"

ENT.CanPackUp = true
ENT.PackUpTime = 3

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true
ENT.IgnoreBullets = true
ENT.IgnoreMeleeTeam = TEAM_HUMAN
ENT.IgnoreTraces = true
ENT.FizzleStatusAOE = true
ENT.EntityDeployable = false
ENT.IsForceFieldShield = true
ENT.ScanFilter = true -- for drones

ENT.IsBarricadeObject = true

AccessorFuncDT(ENT, "Emitter", "Entity", 1)
AccessorFuncDT(ENT, "LastDamaged", "Float", 1)