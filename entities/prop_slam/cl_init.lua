include("shared.lua")

local Material = Material
local Color = Color
local CurTime = CurTime
local render = render
local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local COLOR_GREEN = COLOR_GREEN
local COLOR_DARKGREEN = COLOR_DARKGREEN
local COLOR_WHITE = COLOR_WHITE
local COLOR_RED = COLOR_RED

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.CreateTime = CurTime()
	local attach = self:GetAttachment(self:LookupAttachment("beam_attach"))
	self.LaserPos = attach.Pos
	self.LaserAng = attach.Ang
	self.LaserDir = -attach.Ang:Right() * 192
	
	hook.Add("PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.TripMineLaser_"..self:EntIndex(), function()
		if IsValid(self) then
			self:DrawTranslucent()
		end
	end)
end

local M_Player = FindMetaTable("Player")
local P_Team = M_Player.Team
local matGlow = Material("sprites/glow04_noz")
local matLaser = Material("trails/laser")
local colBlue = Color(100, 100, 255)
local COLOR_WHITE = color_white
function ENT:DrawTranslucent()
	local lightpos = self.LaserPos
	local beamcolor = COLOR_GREEN
	local showbeam = true
	local owner = self:GetOwner()
	local armed = self.CreateTime + self.ArmTime < CurTime()

	if self:GetExplodeTime() == 0 then
		if IsValid(owner) then
			render_SetMaterial(matGlow)
			render_DrawSprite(lightpos, 8, 8, COLOR_RED)
			render_DrawSprite(lightpos, 2, 2, COLOR_DARKRED)
		else
			render_SetMaterial(matGlow)
			render_DrawSprite(lightpos, 8, 8, colBlue)
			render_DrawSprite(lightpos, 2, 2, COLOR_WHITE)
			
			showbeam = false
		end
	else
		local size = (CurTime() * 4.5 % 1) * 24
		render_SetMaterial(matGlow)
		render_DrawSprite(lightpos, size, size, COLOR_RED)
		render_DrawSprite(lightpos, size / 4, size / 4, COLOR_DARKRED)
	end

	if armed and not self.Activated then
		self:EmitSound("weapons/c4/c4_beep1.wav")
		self.Activated = true
	end

	self.NoDraw = P_Team(MySelf)==TEAM_HUMAN and not MySelf:KeyDown(IN_SPEED)
	if self.NoDraw then return end
	
	if showbeam and armed then
		local tr = util.QuickTrace(lightpos, self.LaserDir, self:GetCachedScanFilter())

		render.SetMaterial(matLaser)
		render.DrawBeam(lightpos, tr.HitPos, 0.33, 0, 1, COLOR_WHITE)
		render.DrawBeam(lightpos, tr.HitPos, 1.3, 0, 1, COLOR_RED)
	end
end

function ENT:OnRemove()
	hook.Remove("PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.TripMineLaser_"..self:EntIndex())
end