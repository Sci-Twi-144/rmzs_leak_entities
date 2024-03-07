--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_biorifle"
SWEP.Primary.ProjVelocity = 900

function SWEP:PhysModify(physobj)
end
