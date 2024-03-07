include("shared.lua")

function ENT:Initialize()
	self:GetOwner().Burn = self
end

local function GetRandomBonePos(pl)
	if pl ~= MySelf or pl:ShouldDrawLocalPlayer() then
		local bone = pl:GetBoneMatrix(math.random(0,25))
		if bone then
			return bone:GetTranslation()
		end
	end

	return pl:GetShootPos()
end

function ENT:Draw()
	local ent = self:GetOwner()
	if not ent:IsValid() then return end
	
	local pos
	if ent == MySelf and not ent:ShouldDrawLocalPlayer() then
		local aa, bb = ent:WorldSpaceAABB()
		pos = Vector(math.Rand(aa.x, bb.x), math.Rand(aa.y, bb.y), math.Rand(aa.z, bb.z))
	else
		pos = GetRandomBonePos(ent)
	end

	if ShouldDrawGlobalParticles(self:GetPos()) then
		local emitter = ParticleEmitter(self:GetPos())
		emitter:SetNearClip(16, 24)
		
		--for i = 1, 2 do
			particle = emitter:Add("sprites/light_glow02_add", pos + VectorRand() * 12)
			particle:SetDieTime(math.Rand(1.1, 1.2))
			particle:SetStartAlpha(230)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2)
			particle:SetEndSize(0)
			particle:SetGravity(Vector(0, 0, 75))
			particle:SetAirResistance(300)
			particle:SetStartLength(1)
			particle:SetEndLength(35)
			particle:SetColor(255, 128, 64)
		--end
		
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
end
