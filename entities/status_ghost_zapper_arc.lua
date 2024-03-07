AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status_ghost_zapper"

ENT.GhostEntity = "prop_zapper_arc"
ENT.GhostWeapon = "weapon_zs_zapper_arc"

local colValid = Color(50, 255, 50, 50)
local colInvalid = Color(255, 50, 50, 50)
function ENT:DrawTranslucent()

	if self:GetOwner()~=MySelf then return end
	local owner = self:GetOwner()
	local wep = owner:GetActiveWeapon()
	local validp = self:GetValidPlacement()
	local pos = self:LocalToWorld(Vector(0, 0, 37))
	
	cam.Start3D(EyePos(), EyeAngles())
		render.SuppressEngineLighting(true)
		if validp then
			render.SetBlend(0.75)
			render.SetColorModulation(0, 1, 0)
		else
			render.SetBlend(0.5)
			render.SetColorModulation(1, 0, 0)
		end

		if self.GhostArrow then
			local angs = self:GetAngles()
			angs:RotateAroundAxis(self:GetRight(), self.GhostArrowUp and 270 or 0)

			cam.Start3D2D(self:WorldSpaceCenter(), angs, 0.2)
				surface.SetDrawColor(validp and colValid or colInvalid)
				surface.DrawRect( 0, -1, 128, 2 )
			cam.End3D2D()
		end

		self:DrawModel()

		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
		render.SuppressEngineLighting(false)
		
		if wep:IsValid() then
			render.DrawWireframeSphere( pos, (wep.MaxDistance or 90) * (owner.FieldRangeMul or 1), 16, 16, validp and colValid or colInvalid, true)
		end
		
	cam.End3D()
end