ENT.Type = "anim"
ENT.IsProjectileZS = true

ENT.NoNails = true
ENT.LifeTime = 5
ENT.Force = 220
ENT.ForceDelay = 0.5
ENT.PickupType = 1
ENT.ColorBlood = Color(255, 0, 0, 255)
ENT.ColorStamina = Color(166, 255, 231, 255)
ENT.ColorMedsup = Color(0, 155, 0, 255)
util.PrecacheSound("items/battery_pickup.wav")

function ENT:SetType(tip)
	self:SetDTInt(2, tip)
end

function ENT:GetType()
	return self:GetDTInt(2)
end