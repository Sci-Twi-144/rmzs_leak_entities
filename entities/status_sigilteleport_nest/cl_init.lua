include("shared.lua")

ENT.Sound1 = Sound("ambient/atmosphere/hole_hit2.wav")
ENT.Sound2 = Sound("ambient/ambience/waterlap_loop.wav")
ENT.ParticleMaterial = "sprites/glow04_noz"
ENT.SigilSightMaterial = "effects/tp_eyefx/tpeye2"
function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()

	self.TeleportingSound = CreateSound(self, self.Sound1)
	self.TeleportingSound2 = CreateSound(self, self.Sound2)
	
	if owner:IsValid() and owner == MySelf then
		self.TeleportingSound:PlayEx(2, 100)
		self.TeleportingSound2:PlayEx(1, 35)
	end

	if self:GetStartTime() == 0 then
		self:SetStartTime(CurTime())
	end

	owner.NestTeleport = self

	local ent = self
	local ENTC = tostring(ent)

	hook.Add("RenderScreenspaceEffects",ENTC,function()
		if not IsValid(ent) then return end

		if ent:GetOwner() == MySelf and ent:GetSigilSight() then

			DrawMaterialOverlay( self.SigilSightMaterial, 0.3 )

		end
	end)

	hook.Add("ShouldDrawLocalPlayer", ENTC, function(pl)
		if not IsValid(ent) then return end

		if ent:GetOwner() == pl and ent:GetSigilSight() then
			return true
		end
	end)

	hook.Add("CalcView", ENTC, function(pl, origin, angles, fov, znear, zfar)
		if not IsValid(ent) then return end
		
		if ent:GetOwner() ~= pl or not ent:GetSigilSight() then return end

		local sigil = self:GetTargetSigil()
		if not sigil or not sigil:IsValid() then return end

		return {origin = sigil:WorldSpaceCenter()+Vector(0,0,64), angles = angles}
	end)

end

function ENT:OnRemove()
	self.TeleportingSound:Stop()
	self.TeleportingSound2:Stop()
	self:GetOwner():EmitSound("ambient/atmosphere/city_skypass1.wav", 100, 150)
	local ENTC = tostring(self)
	hook.Remove("RenderScreenspaceEffects",ENTC)
	hook.Remove("ShouldDrawLocalPlayer", ENTC)
	hook.Remove("CalcView", ENTC)
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner ~= LocalPlayer() then return end

	local sigil = self:GetTargetSigil()
	if not sigil or not sigil:IsValid() then return end

	local ownerpos = owner:GetPos()
	local sigilpos = sigil:GetPos()
	local dir = sigilpos - ownerpos
	dir:Normalize()

	local aa, bb = owner:WorldSpaceAABB()
	local startpos = Vector(math.Rand(aa.x, bb.x), math.Rand(aa.y, bb.y), math.Rand(aa.z, bb.z))

	if ShouldDrawGlobalParticles(startpos) then
		local emitter = ParticleEmitter(startpos)
		emitter:SetNearClip(24, 32)

		if not ShouldDrawGlobalParticles(startpos) then return end

		local particle = emitter:Add(self.ParticleMaterial, startpos)
		particle:SetDieTime(math.Rand(1.5, 4))
		particle:SetVelocity(dir * math.min(1400, ownerpos:Distance(sigilpos)))
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(1, 2))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-2, 2))
		self:SetParticleColor(particle)


		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	
	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:SetParticleColor(particle)
	particle:SetColor(255, 0, 0)
end

function ENT:Draw()
end
