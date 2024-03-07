--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_needle"
SWEP.Primary.ProjVelocity = 2500

function SWEP:EntModify(ent)
    ent.IsMarked = false -- На всякий случай
end
