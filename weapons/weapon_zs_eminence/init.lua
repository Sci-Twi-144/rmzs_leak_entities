--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_emi"
SWEP.Primary.ProjVelocity = 100

function SWEP:PhysModify(physobj)
end
