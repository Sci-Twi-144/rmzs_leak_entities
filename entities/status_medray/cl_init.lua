include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))

	self:GetOwner().MedRay = self

	self:EmitSound("weapons/physcannon/energy_bounce2.wav")

	self.AmbientSound = CreateSound(self, "weapons/physcannon/superphys_hold_loop.wav")

	self.Rotation = math.Rand(0, 360)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(20, 32)
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.75, 200)

	local owner = self:GetOwner()
	if owner:IsValid() then
		local hitpos = owner:TraceHull(32768, MASK_SHOT, 255).HitPos
		self:SetRenderBoundsWS(owner:GetShootPos(), hitpos, Vector(64, 64, 64))
		self.Emitter:SetPos(hitpos)
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
	--self.Emitter:Finish()
	self:GetOwner().MedRay = nil
end

local matBeam = Material("effects/laser1")
local matMainBeam = Material("effects/laser_citadel1")
local matGlow = Material("sprites/glow04_noz")
function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local tr = owner:TraceHull(32768, MASK_SHOT, 255)
	local ent = tr.Entity
	local entishealable = ent and ent:IsPlayer() and ent:Alive() and ent:Team() == owner:Team()
	if not entishealable then
		tr = owner:TraceLine(32768, MASK_SHOT)
	end
	local hitpos = entishealable and ent:LocalToWorld(ent:OBBCenter()) or tr.HitPos

	local startpos
	local wep = owner:GetActiveWeapon()
	if wep:IsValid() then
		local attach
		if owner == MySelf and not NOX_VIEW then
			attach = owner:GetViewModel():GetAttachment(1)
		else
			attach = wep:GetAttachment(1)
		end
		if attach then
			startpos = attach.Pos
		end
	end

	startpos = startpos or owner:GetShootPos()
	local eyeangles = entishealable and (hitpos - startpos):Angle() or owner:EyeAngles()

	local col = team.GetColor(owner:Team())

	self.Rotation = self.Rotation - FrameTime() * 180
	if self.Rotation < 0 then self.Rotation = self.Rotation + 360 end

	eyeangles:RotateAroundAxis(eyeangles:Forward(), self.Rotation)

	local mul = 4
	if owner == MySelf and not NOX_VIEW then mul = 9 end

	local up = eyeangles:Up() * mul
	local right = eyeangles:Right() * mul

	render.SetMaterial(matBeam)
	render.DrawBeam(startpos + up, hitpos, 16, 1, 0, Color(30, 255, 30, 255))
	render.DrawBeam(startpos - up, hitpos, 16, 1, 0, Color(30, 255, 30, 255))
	render.DrawBeam(startpos + right, hitpos, 16, 1, 0, Color(30, 255, 30, 255))
	render.DrawBeam(startpos - right, hitpos, 16, 1, 0, Color(30, 255, 30, 255))
	render.SetMaterial(matMainBeam)
	render.DrawBeam(startpos, hitpos, 40, 1, 0, Color(255, 10, 10, 255))
	render.SetMaterial(matGlow)
	render.DrawSprite(hitpos, math.sin(CurTime() * 10) * 32 + 48, math.cos(CurTime() * 10) * 32 + 48, Color(255, 10, 10, 255))

	self.Emitter:SetPos(hitpos)
	local particle = self.Emitter:Add("sprites/glow04_noz", hitpos)
	particle:SetVelocity(tr.Normal * -128 + VectorRand():GetNormalized() * 32)
	particle:SetDieTime(0.5)
	particle:SetStartSize(20)
	particle:SetEndSize(0)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetAirResistance(32)
	particle:SetColor(30, 255, 30)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-10, 10))
end
