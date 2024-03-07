--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_arrow_cha"
SWEP.Primary.ProjVelocity = 1400

function SWEP:EntModify(ent)
    ent.IsMarked = true
end