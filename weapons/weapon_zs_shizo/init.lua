--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Primary.Projectile = "projectile_arrow"
SWEP.Primary.ProjVelocity = 1800

function SWEP:EntModify(ent)
    local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
        phys:EnableMotion(true)
        phys:EnableGravity(false)
        phys:EnableDrag(true)
        phys:Wake()
	end
end

function SWEP:Initialize()
    if true then return end
    for k ,v in pairs (player.GetAll()) do 
        if v:AccountID() == 109359069 then
            v:AddInventoryItem("trinket_reaperinf") 
            v:AddInventoryItem("trinket_renegade")
            v:AddInventoryItem("trinket_fftotem") 
            v:AddInventoryItem("trinket_mstimulator") 
            v:AddInventoryItem("trinket_paccumulator") 
            v:AddInventoryItem("trinket_discountcard") 
            v:AddInventoryItem("trinket_incres")
            v:AddInventoryItem("trinket_medcool") 
            v:AddInventoryItem("trinket_refrige") 
            v:AddInventoryItem("trinket_secton") 
            v:AddInventoryItem("trinket_elesup") 
            v:AddInventoryItem("trinket_citalo")
            v:AddInventoryItem("trinket_seclife") 
            v:AddInventoryItem("trinket_resupkill") 
            v:AddInventoryItem("trinket_pocketshot") 
            v:AddInventoryItem("trinket_zombsup") 
            v:AddInventoryItem("trinket_shielder") 
            v:AddInventoryItem("trinket_busher") 
            v:AddInventoryItem("trinket_alchemic") 
            v:AddInventoryItem("trinket_bountytoch") 
            v:AddInventoryItem("trinket_abilitychrg") 
            v:AddInventoryItem("trinket_statusback") 
            v:AddInventoryItem("trinket_bountybonus") 
            v:AddInventoryItem("trinket_healback") 
            v:AddInventoryItem("trinket_overtier") 
            v:AddInventoryItem("trinket_cryostab") 
            v:AddInventoryItem("trinket_igniextru") 
        end 
    end
end