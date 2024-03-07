include("shared.lua")

ENT.ChargeTime = 3

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))

	self:GetOwner().MedRay = self

	self.AmbientSound = CreateSound(self, "weapons/physcannon/energy_sing_loop4.wav")

	self.Rotation = math.Rand(0, 360)
	
	self.TimeCreated = CurTime()

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(20, 32)
end

function ENT:Think()
	local airtime = CurTime() - self.TimeCreated
	local charge = math.Clamp(0 + airtime, 0, 1)
	self.AmbientSound:PlayEx(0.5 + charge * 0.3, 60 + charge * 100)

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
	-- self:GetOwner().MedRay = nil
end

local matGlow = Material("effects/rollerglow")
local matLaser = Material("trails/laser")
function ENT:DrawTranslucent()
	local col = Color(50, 150, 255, 255)
	local owner = self:GetOwner()

	local airtime = CurTime() - self.TimeCreated
	local charge = math.Clamp(0 + airtime, 0, 1.5)
	local eyeangles = owner:EyeAngles()
	eyeangles:RotateAroundAxis(eyeangles:Forward(), CurTime() * 360)
	
	local tr = owner:TraceHull(32768, MASK_SHOT, 255)
	
	local entishealable = ent and ent:IsPlayer() and ent:Alive() and ent:Team() == owner:Team()
	local hitpos = entishealable and ent:LocalToWorld(ent:OBBCenter()) or tr.HitPos
	
	local startpos = Vector(-10, -5, 3.5)
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

	local spritesize = math.abs(math.sin(CurTime() * 6)) * 6 + charge * 12
	render.SetMaterial(matGlow)
	render.DrawSprite(startpos, spritesize, spritesize, col)

	local r, g, b = col.r, col.g, col.b
	local emitter = self.Emitter
	local curvel = owner:GetVelocity()
	for i=1, 4 do
		eyeangles:RotateAroundAxis(eyeangles:Forward(), 90)
		local dir = eyeangles:Up()

		local particle = emitter:Add("sprites/glow04_noz", startpos + dir)
		particle:SetVelocity((charge + 1) * 48 * dir)
		particle:SetDieTime(0.25)
		particle:SetStartSize(1 + charge * 4)
		particle:SetEndSize(0)
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(255)
		particle:SetAirResistance(8)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-8, 8))
		particle:SetColor(r, g, b)
	end
end
