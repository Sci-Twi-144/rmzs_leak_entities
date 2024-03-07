include("shared.lua")

ENT.NextEmit = 0

function ENT:Initialize()
	self.BaseClass.Initialize(self)
end

function ENT:Draw()
	if not IsValid(self) then return end
		
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
	if owner:GetZombieClassTable().IgnoreTargetAssist then return end
	
	if SpawnProtection[owner] then return end
	
	if CurTime() < self.NextEmit then return end
	self.NextEmit = CurTime() + 0.25
	
	local pos = owner:WorldSpaceCenter()
	pos.z = pos.z + 24
	
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)
	
	for i = 1, 6 do
		particle = emitter:Add("sprites/light_glow02_add", pos + VectorRand() * 12)
		particle:SetDieTime(math.Rand(1.1, 1.2))
		particle:SetStartAlpha(230)
		particle:SetEndAlpha(0)
		particle:SetStartSize(2)
		particle:SetEndSize(0)
		particle:SetGravity(Vector(0, 0, -155))
		particle:SetAirResistance(300)
		particle:SetStartLength(1)
		particle:SetEndLength(35)
		particle:SetColor(30, 255, 30)
	end

	emitter:Finish() emitter = nil collectgarbage("step", 64)
end