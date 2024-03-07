include("shared.lua")

ENT.NextEmit = 0

ENT.Color = { --:diesfromcringe:
	{155, 0, 255},
	{255, 50, 50},
	{220, 0, 0},
	{180, 200, 0}
}

function ENT:Draw()
	if not IsValid(self) then return end
     
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
	if owner:GetZombieClassTable().IgnoreTargetAssist then return end
		
	if SpawnProtection[owner] then return end
	local pos = owner:WorldSpaceCenter()
		
	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.25
    local type = self:GetType()
    local cr = self.Color[type][1]
    local cg = self.Color[type][2]
    local cb = self.Color[type][3]
 
	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(16, 24)
		
		local dir = (VectorRand() * 20 + Vector(0, 0, 40)):GetNormal()
		
		for i = 1, 10 do
			local particle = emitter:Add("sprites/glow04_noz", pos)
			particle:SetVelocity(dir * 120)
			particle:SetDieTime(math.Rand(1.1, 1.4))
			particle:SetStartAlpha(150)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(1, 2))
			particle:SetEndSize(4)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-5, 5))
			particle:SetGravity(Vector(0, 0, 25))
			particle:SetCollide(true)
			particle:SetBounce(0.45)
			particle:SetAirResistance(300)
			particle:SetColor(cr, cg, cb)
        end
		
        emitter:Finish() emitter = nil collectgarbage("step", 64)
    end
end
