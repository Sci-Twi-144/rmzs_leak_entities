include("shared.lua")

local M_Player = FindMetaTable("Player")
local P_Team = M_Player.Team
local matBeam = Material("effects/laser1")
local matGlow = Material("sprites/glow04_noz")
local colBeam = Color(40, 70, 255)
local COLOR_WHITE = color_white
local trace = {mask = MASK_SHOT}
function ENT:DrawTranslucent()
	if not self:IsActive() then return end

	local pos = self:GetStartPos()
	if CurTime() >= self.NextTrace then
		self.NoDraw = P_Team(MySelf)==TEAM_HUMAN and not MySelf:KeyDown(IN_SPEED)
		self:SetColor(ColorAlpha(COLOR_WHITE,self.NoDraw and 25 or 255))
		self.NextTrace = CurTime() + 0.15

		local forward = self:GetUp()
		trace.start = pos
		trace.endpos = pos + forward * self.Range
		trace.filter = function(ent)
			if (ent:IsPlayer() and ent:Team() == TEAM_HUMAN) or ent.IsProjectile or ent.IsForceFieldShield or ent == self then
				return false
			end

			return true
		end

		self.LastPos = util.TraceLine(trace).HitPos
	end

	if self.NoDraw then return end

	local hitpos = self.LastPos
	render.SetMaterial(matBeam)
	render.DrawBeam(pos, hitpos, 0.33, 0, 1, COLOR_WHITE)
	render.DrawBeam(pos, hitpos, 1.3, 0, 1, colBeam)
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 2, 2, COLOR_WHITE)
	render.DrawSprite(pos, 8, 8, colBeam)
	render.DrawSprite(hitpos, 1, 1, COLOR_WHITE)
	render.DrawSprite(hitpos, 4, 4, colBeam)
end

function ENT:Draw()
	self:DrawModel()

	if not MySelf == self:GetOwner() then return end
	local pos = self:GetPos()
	local ang = self:GetAngles()

	cam.Start3D2D(pos, ang, 0.075)
		self:Draw3DHealthBar(math.Clamp(self:GetSelfTime() / 100, 0, 1), nil, 150, 0.3)
	cam.End3D2D()
end
