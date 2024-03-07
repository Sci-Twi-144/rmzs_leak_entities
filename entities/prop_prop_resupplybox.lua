AddCSLuaFile()

ENT.Type = "anim"

ENT.IgnoreMelee = true
ENT.IgnoreBullets = true
ENT.IgnoreTraces = true

ENT.ForceDamageFloaters = true

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetNoDraw(true)

	if SERVER then
		self:SetModel("models/Items/ammocrate_ar2.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	end
end
