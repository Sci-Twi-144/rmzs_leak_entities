AddCSLuaFile()

ENT.Type = "anim"

if not CLIENT then return end

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.ColorModulation = Color(1, 0.5, 1)
ENT.Seed = 0


ENT.DrawBeam = true
ENT.PrintName = ""
ENT.IsFont = nil
ENT.WepIcon = nil
local tbl = {}
function ENT:Initialize()
	self.Seed = math.Rand(0, 10)
	
	timer.Simple(0.06, function()
		local mat = self.IsAmmo and killicon.Get(GAMEMODE.AmmoIcons[self.WepClass]) or killicon.Get(self.WepClass)
		local material = istable(mat) and mat[1] or "gui/close_32"
		local matweapon = Material(material)
  
		if self.IsAmmo then
			self.AmmoColorModulation = isstring(killicon.Get(GAMEMODE.AmmoIcons[self.WepClass])[2]) and string.ToColor(killicon.Get(GAMEMODE.AmmoIcons[self.WepClass])[2]):ToVector() or (killicon.Get(GAMEMODE.AmmoIcons[self.WepClass])[2]):ToVector()
		end
		
		tbl = {}
		
		table.insert(tbl, killicon.GetSize(self.WepClass or "weapon_zs_caftingpack"))
		self.SizeW = tonumber(table.GetFirstValue(tbl)) or 96
		self.SizeH = tonumber(table.GetFirstKey(tbl)) or 48
		self.SizeH = ((self.SizeH and (self.SizeH <= 47)) and not self.IsQuadro) and self.SizeH * 2 or self.SizeH

		self.WepIcon = matweapon
		if istable(mat) then
			self.WepFont = mat[1]
			self.WepFontL = mat[2]
			
			self.IsFont = matweapon:IsError()
		end
	end)
end

function ENT:DrawPreciseModel(ble, cmod)
	if self.PropWeapon and not self.ShowBaseModel then
		render.SetBlend(0)
	end
	self:DrawModel()
	if self.PropWeapon and not self.ShowBaseModel then
		render.SetBlend(1)
	end
	if self.RenderModels and not self.NoDrawSubModels then
		self:RenderModels(ble, cmod)
	end
end

local col_ammo = Color(0.25, 1, 0.25)

local matWireframe = Material("models/wireframe")
local matWhite = Material("models/debug/debugwhite")
local matLight = Material( "vgui/gradient_up.vmt" )
local defaulticon = Material( "zombiesurvival/killicons/weapon_zs_craftables" )
function ENT:DrawTranslucent()
	local centerpos = self:LocalToWorld(self:OBBCenter())
	local distance = MySelf:GetPos():Distance(centerpos)
	local alpha = math.Clamp( 1024 - ( distance * 8 ) / 2, 0, 200 )
	local alpha2 = math.Clamp( 1024 - ( distance ), 0, 200 )

	local qcol1 = Color(255, 255, 255)
	if self.QualityTier then
		local customcols1 = self.BranchData and self.BranchData.Colors and self.BranchData.Colors[self.QualityTier]
		local qcolt1 = customcols1 and customcols1 or GAMEMODE.WeaponQualityColors[self.QualityTier][self.Branch and 2 or 1]
		qcol1 = qcolt1
	end

	local light_color = self.QualityTier and  Color((qcol1.r / 255) * 255, (qcol1.g / 255) * 255, (qcol1.b / 255) * 255) or Color(255, 255, 255)--Color(self.ColorModulation.r * 255, self.ColorModulation.g * 255, self.ColorModulation.b * 255)
	local light_start = self:LocalToWorld(self:OBBCenter()) -- + Vector( 0, 4, 0 )
	local light_end = centerpos + Vector( 0, 0, 32 )

	if (GAMEMODE.GetLootType == 0) or (GAMEMODE.GetLootType == 1) then

	
		if not WorldVisible(MySelf:GetPos(), self:GetPos()) and not MySelf:IsSkillActive(SKILL_SCAVENGER) then return end
		--if distance >= 1024 then return end
		if distance <= 1024 then
			if MySelf:IsSkillActive(SKILL_SCAVENGER) then
				cam.IgnoreZ(true)
			end

			local angl = MySelf:LocalToWorldAngles(Angle( 0, -90, 90 ))
			local posl = self:GetPos() + Vector( 0, 4, 0 )--self:LocalToWorld(self:OBBCenter() + Vector(0, 4, -6))

			cam.Start3D2D(posl, angl, 0.15)
                --killicon.Draw( 0, 0, self.IsAmmo and GAMEMODE.AmmoIcons[self.WepClass] or self.WepClass, 255 ) -- png returns missing texture
                if not (self.IsFont or self.IsAmmo) then
                    surface.SetMaterial(self.WepIcon or defaulticon)
                    surface.SetDrawColor(light_color)
                    surface.DrawTexturedRect(-47, -15, self.SizeH or 256, self.SizeW or 64)
                else
                    killicon.Draw( 0, 0, self.IsAmmo and GAMEMODE.AmmoIcons[self.WepClass] or self.WepClass, 255 )
                end
			cam.End3D2D()

			cam.IgnoreZ(false)

		end
	end
	local amcol = self.AmmoColorModulation or Color(255, 255, 255)
	local light_color = self.IsAmmo and Color(amcol.r * 255, amcol.g * 255, amcol.b * 255) or light_color
	if ((GAMEMODE.GetLootType == 0) or (GAMEMODE.GetLootType == 2)) and not ((GAMEMODE.GetLootType == 3) or (GAMEMODE.GetLootType == 1)) then
		if distance <= 256 then
			local textcolor = Color( light_color.r + 35, light_color.g + 35, light_color.b + 35, alpha )
			local text_pos = light_end:ToScreen()
			render.SetMaterial( matLight )
			--print(light_color.r)
			render.DrawBeam( light_start, light_end, 0.5, 0, 1, Color( light_color.r, light_color.g, light_color.b, alpha2 ) )
			cam.Start2D( light_end, Angle( 0, 0, 0 ), 0.25 )
				draw.WordBox( 6, text_pos.x, text_pos.y, self.PrintName, "DermaDefaultBold", Color( 35, 35, 35, alpha ), textcolor )
			cam.End2D()
		end
	end

	if (GAMEMODE.GetLootType == 2) or (GAMEMODE.GetLootType == 3) and not ((GAMEMODE.GetLootType == 0)) then

		if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN then
			self:DrawPreciseModel()
			return
		end
	
		local mul = self.QualityTier and (self.QualityTier + 1) or 1
		local time = (CurTime() * 1.5*mul + self.Seed) % 2/mul
	
		self:DrawPreciseModel()
	
		if time > 1 then return end

		local eyepos = EyePos()
		local pos = self:GetPos()
		local dist = eyepos:DistToSqr(pos)

		if dist > 1048576 then return end--or (self.PropWeapon and not self.ShowBaseModel) then return end -- 1024^2

		--self.NoDrawSubModels = true

		local oldscale = self:GetModelScale()
		local normal = self:GetUp()
		local rnormal = normal * -1
		local mins = self:OBBMins()
		local mdist = self:OBBMaxs().z - mins.z
		mins.x = 0
		mins.y = 0
		local minpos = self:LocalToWorld(mins)

		self:SetModelScale(oldscale * 1.01, 0)

		if render.SupportsVertexShaders_2_0() then
			render.EnableClipping(true)
			render.PushCustomClipPlane(normal, normal:Dot(minpos + mdist * time * normal))
			render.PushCustomClipPlane(rnormal, rnormal:Dot(minpos + mdist * time * (1 + 0.25 * mul) * normal))
		end

		if self.IsAmmo then
			self.ColorModulation = self.AmmoColorModulation or col_ammo
		end

		local div = self.IsAmmo and 255 or 1
		local qcol = {self.ColorModulation.r, self.ColorModulation.g, self.ColorModulation.b}
		if self.QualityTier then
			local customcols = self.BranchData and self.BranchData.Colors and self.BranchData.Colors[self.QualityTier]

			if customcols then
				qcol = {customcols.r/255, customcols.g/255, customcols.b/255}
			else
				local qcolt = GAMEMODE.WeaponQualityColors[self.QualityTier][self.Branch and 2 or 1]
				qcol = {qcolt.r/255, qcolt.g/255, qcolt.b/255}
			end
		end

		render.SetColorModulation(unpack(qcol))
		render.SuppressEngineLighting(true)

		render.SetBlend(0.1 + 0.05 * mul)
		render.ModelMaterialOverride(matWhite)
		if MySelf:IsSkillActive(SKILL_SCAVENGER) then
			cam.IgnoreZ(true)
		end
		self:DrawPreciseModel(0.1 + 0.05 * mul, qcol)

		render.SetBlend(0.05 + 0.1 * mul)
		render.ModelMaterialOverride(matWireframe)
		self:DrawPreciseModel(0.05 + 0.1 * mul, qcol)

		cam.IgnoreZ(false)

		render.ModelMaterialOverride(0)
		render.SuppressEngineLighting(false)
		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)

		if render.SupportsVertexShaders_2_0() then
			render.PopCustomClipPlane()
			render.PopCustomClipPlane()
			render.EnableClipping(false)
		end
		self:SetModelScale(oldscale, 0)
	end
end

function ENT:Draw()
	self:DrawTranslucent()
end
