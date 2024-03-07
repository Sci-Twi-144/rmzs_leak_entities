include("shared.lua")

ENT.NextEmit = 0
ENT.VScreen = Vector(0, -2, 45)
ENT.ScanPitch = 100
ENT.ScanSound = "npc/turret_wall/turret_loop1.wav"

function ENT:Initialize()
	self.BeamColor = Color(0, 255, 0, 255)

	self.ScanningSound = CreateSound(self, self.ScanSound)
	self.ShootingSound = CreateSound(self, "npc/combine_gunship/gunship_weapon_fire_loop6.wav")
	if self:GetTurretType() == 2 then
		local ent = ClientsideModel("models/weapons/w_shotgun.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:Spawn()
			self.GunAttachment = ent
		end
	elseif self:GetTurretType() == 3 then
		local ent = ClientsideModel("models/weapons/w_rif_aug.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(70, 70, 70))

			matrix = Matrix()
			matrix:Scale(Vector(1.1, 0.9, 0.9))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunAttachment = ent
		end

		ent = ClientsideModel("models/weapons/w_rif_aug.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(70, 70, 70))

			matrix = Matrix()
			matrix:Scale(Vector(1.1, 0.9, 0.9))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunAttachment2 = ent
		end

		ent = ClientsideModel("models/props_trainstation/trainstation_ornament002.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(100, 100, 100))

			matrix = Matrix()
			matrix:Scale(Vector(0.65, 0.65, 1.5))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunBase = ent
		end

		ent = ClientsideModel("models/props_wasteland/buoy01.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(100, 100, 100))

			matrix = Matrix()
			matrix:Scale(Vector(0.25, 0.15, 0.7))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunBase2 = ent
		end
	elseif self:GetTurretType() == 4 then
		local ent, matrix = ClientsideModel("models/weapons/w_rocket_launcher.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(150, 150, 150))

			matrix = Matrix()
			matrix:Scale(Vector(0.9, 2, 2))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunAttachment = ent
		end

		ent = ClientsideModel("models/props_trainstation/trainstation_ornament002.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(100, 100, 100))

			matrix = Matrix()
			matrix:Scale(Vector(0.65, 0.65, 1.5))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunBase = ent
		end

		ent = ClientsideModel("models/props_wasteland/buoy01.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(100, 100, 100))
				
			matrix = Matrix()
			matrix:Scale(Vector(0.25, 0.15, 0.7))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunBase2 = ent
		end
	elseif self:GetTurretType() == 5 then
		local ent = ClientsideModel("models/weapons/w_IRifle.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:Spawn()
			self.GunAttachment = ent
		end
	elseif self:GetTurretType() == 7 then
		local ent, matrix = ClientsideModel("models/weapons/rmzs/gshg/w_gshg.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(150, 150, 150))

			matrix = Matrix()
			matrix:Scale(Vector(0.6, 1, 1))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunAttachment = ent
		end

		ent = ClientsideModel("models/props_trainstation/trainstation_ornament002.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(100, 100, 100))

			matrix = Matrix()
			matrix:Scale(Vector(0.65, 0.65, 1.5))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunBase = ent
		end

		ent = ClientsideModel("models/props_wasteland/buoy01.mdl")
		if ent:IsValid() then
			ent:SetParent(self)
			ent:SetOwner(self)
			ent:SetLocalPos(vector_origin)
			ent:SetLocalAngles(angle_zero)
			ent:SetMaterial("phoenix_storms/torpedo")
			ent:SetColor(Color(100, 100, 100))
				
			matrix = Matrix()
			matrix:Scale(Vector(0.25, 0.15, 0.7))
			ent:EnableMatrix("RenderMultiply", matrix)

			ent:Spawn()
			self.GunBase2 = ent
		end
	end

	self:GetVariables()
	
	local size = self:GetTurretSearchDistance() + 32
	local nsize = -size
	self:SetRenderBounds(Vector(nsize, nsize, nsize * 0.25), Vector(size, size, size * 0.25))

	self:CreateHook()
end

function ENT:CreateHook()
	local ENTC = tostring(self)
	local ent = self

	hook.Add("CreateMove", ENTC, function(cmd)
		if not IsValid(ent) then return end

		if ent:GetObjectOwner() ~= MySelf then return end
	
		if not ent:GetManualControl() then return end
	
		local buttons = cmd:GetButtons()
	
		cmd:ClearMovement()
	
		if bit.band(buttons, IN_JUMP) ~= 0 then
			buttons = buttons - IN_JUMP
			buttons = buttons + IN_BULLRUSH
		end
	
		if bit.band(buttons, IN_DUCK) ~= 0 then
			buttons = buttons - IN_DUCK
			buttons = buttons + IN_GRENADE1
		end
	
		cmd:SetButtons(buttons)
	end)
	
	hook.Add("ShouldDrawLocalPlayer", ENTC, function(pl)
		if not IsValid(ent) then return end

		if ent:GetObjectOwner() ~= MySelf then return end
	
		if ent:GetManualControl() then
			return true
		end
	end)
	
	local trace_cam = {mask = MASK_VISIBLE, mins = Vector(-4, -4, -4), maxs = Vector(4, 4, 4)}
	hook.Add("CalcView", ENTC, function(pl, origin, angles, fov, znear, zfar)
		if not IsValid(ent) then return end
		
		if ent:GetObjectOwner() ~= pl or not ent:GetManualControl() then return end
	
		local filter = player.GetAll()
		filter[#filter + 1] = ent
		trace_cam.start = ent:ShootPos()
		trace_cam.endpos = trace_cam.start
		trace_cam.filter = filter
		local tr = util.TraceHull(trace_cam)
	
		return {origin = tr.HitPos + tr.HitNormal * 3, angles = angles}
	end)
end

function ENT:RemoveHook()
	local ENTC = tostring(self)
	hook.Remove("CreateMove", ENTC)
	hook.Remove("ShouldDrawLocalPlayer", ENTC)
	hook.Remove("CalcView", ENTC)
end

function ENT:Think()
	if self:GetObjectOwner():IsValid() and self:GetAmmo() > 0 and self:GetMaterial() == "" and not (self:GetHeatState() == 2)  then
		self.ScanningSound:PlayEx(0.55, self.ScanPitch + math.sin(CurTime()))
		if self.PlayLoopingShootSound and (self:IsFiring() or self:GetTarget():IsValid()) then
			self.ShootingSound:PlayEx(1, 100 + math.cos(CurTime()))
		else
			self.ShootingSound:Stop()
		end
	else
		self.ScanningSound:Stop()
		self.ShootingSound:Stop()
	end
end

function ENT:OnRemove()
	if self:GetTurretType() == 2 or self:GetTurretType() == 5 then
		if self.GunAttachment and self.GunAttachment:IsValid() then
			self.GunAttachment:Remove()
		end
	
	elseif self:GetTurretType() == 3 or self:GetTurretType() == 4 or self:GetTurretType() == 7 then
		if self.GunAttachment and self.GunAttachment:IsValid() then
			self.GunAttachment:Remove()
		end

		if self.GunAttachment2 and self.GunAttachment2:IsValid() then
			self.GunAttachment2:Remove()
		end
			
		if self.GunBase and self.GunBase:IsValid() then
			self.GunBase:Remove()
		end

		if self.GunBase2 and self.GunBase2:IsValid() then
			self.GunBase2:Remove()
		end
	end
	
	self.ScanningSound:Stop()
	self.ShootingSound:Stop()
	self:RemoveHook()
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(3, health)
end

local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local smokegravity = Vector(0, 0, 200)
local aScreen = Angle(0, 270, 60)
function ENT:Draw()
	self:CalculatePoseAngles()
	self:SetPoseParameter("aim_yaw", self.PoseYaw)
	self:SetPoseParameter("aim_pitch", self.PosePitch)

	local owner = self:GetObjectOwner()

	if owner == MySelf and self:GetManualControl() then return end

	local alpha = self:TransAlphaToMe()

	render.SetBlend(alpha)
	self:DrawModel()
	render.SetBlend(1)

	local healthpercent = self:GetObjectHealth() / self:GetMaxObjectHealth()

	if (healthpercent <= 0.5) or (self:GetHeatState() == 2) and CurTime() >= self.NextEmit then
		self.NextEmit = CurTime() + 0.05

		local pos = self:DefaultPos()
		local sat = healthpercent * 360

		if ShouldDrawGlobalParticles(pos) then
			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)

			local particle = emitter:Add("particles/smokey", pos)
			particle:SetStartAlpha(180)
			particle:SetEndAlpha(0)
			particle:SetStartSize(0)
			particle:SetEndSize(math.Rand(8, 32))
			particle:SetColor(sat, sat, sat)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(8, 64))
			particle:SetGravity(smokegravity)
			particle:SetDieTime(math.Rand(0.8, 1.6))
			particle:SetAirResistance(150)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-4, 4))
			particle:SetBounce(0.2)

			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
	end

	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN or ShouldVisibleDraw(self:GetPos()) then return end

	local ammo = self:GetAmmo()
	local flash = math.sin(CurTime() * 15) > 0
	local wid, hei = 128, 92
	local x = wid / 2
	local selfname = self:GetClass()
	local turtype = self:GetTurretType()
	local colorfprhud

	if selfname == "prop_gunturret" then
		if turtype == 5 then
			colorfprhud = Color(150, 150, 150, 160)
		elseif turtype == 2 then
			colorfprhud = Color(99, 255, 94, 160)
		else
			colorfprhud = Color(200, 200, 200, 160)
		end
	elseif selfname == "prop_gunturret_q1" then
		if turtype == 5 then
			colorfprhud = Color(172, 219, 105, 160)
		elseif turtype == 2 then
			colorfprhud = Color(22, 201, 46, 160)
		else
			colorfprhud = Color(235, 235, 115, 160)
		end
	elseif selfname == "prop_gunturret_q2" then
		if turtype == 5 then
			colorfprhud = Color(35, 110, 145, 160)
		elseif turtype == 2 then
			colorfprhud = Color(27, 129, 24, 160)
		else
			colorfprhud = Color(50, 90, 175, 160)
		end
	elseif selfname == "prop_gunturret_q3" then
		if turtype == 5 then
			colorfprhud = Color(252, 100, 100, 160)
		elseif turtype == 2 then
			colorfprhud = Color(11, 75, 26, 160)
		else
			colorfprhud = Color(160, 95, 235, 160)
		end
	end

	cam_Start3D2D(self:LocalToWorld(self.VScreen), self:LocalToWorldAngles(aScreen), 0.075)
		surface_SetDrawColor(0, 0, 0, 160)
		surface_DrawRect(0, 0, wid, hei)

		surface_SetDrawColor(colorfprhud)
		surface_DrawRect(0, 0, 8, 16)
		surface_DrawRect(wid - 8, 0, 8, 16)
		surface_DrawRect(8, 0, wid - 16, 8)

		surface_DrawRect(0, hei - 16, 8, 16)
		surface_DrawRect(wid - 8, hei - 16, 8, 16)
		surface_DrawRect(8, hei - 8, wid - 16, 8)

		if owner:IsValid() and owner:IsPlayer() then
			draw_SimpleText(owner:ClippedName(), "DefaultFont", x, 10, owner == MySelf and COLOR_LBLUE or COLOR_WHITE, TEXT_ALIGN_CENTER)
		end
		draw_SimpleText(translate.Format("integrity_x", math.ceil(healthpercent * 100)), "DefaultFontBold", x, 25, COLOR_WHITE, TEXT_ALIGN_CENTER)

		if flash and self:GetManualControl() then
			draw_SimpleText(translate.Get("manual_control"), "DefaultFont", x, 40, COLOR_YELLOW, TEXT_ALIGN_CENTER)
		end

		if ammo > 0 then
			draw_SimpleText("["..ammo.." / "..(self.MaxAmmo or 333).."]", "DefaultFontBold", x, 55, COLOR_WHITE, TEXT_ALIGN_CENTER)
		elseif flash then
			draw_SimpleText(translate.Get("empty"), "DefaultFontBold", x, 55, COLOR_RED, TEXT_ALIGN_CENTER)
		end

		draw_SimpleText("CH. "..self:GetChannel().." / "..GAMEMODE.MaxChannels["turret"], "DefaultFontSmall", x, 70, COLOR_WHITE, TEXT_ALIGN_CENTER)

		surface_SetDrawColor(0, 0, 0, 160)
		surface_DrawRect(0, hei, wid, 14)
		surface_SetDrawColor(1 * self:GetHeatLevel() * 255, 255 / self:GetHeatLevel() / 8, 0, 255)
		surface_DrawRect(0, hei, wid * self:GetHeatLevel(), 14)
		draw_SimpleText("HEAT LEVEL", "DefaultFontSmall", x, 93, COLOR_WHITE, TEXT_ALIGN_CENTER)

	cam_End3D2D()
end

function ENT:GetAttVariables()
	local nodrawattachs = self:TransAlphaToMe() < 0.4
	if self:GetTurretType() == 2 then
		local atch = self.GunAttachment
		if atch and atch:IsValid() then
			local ang = self:GetGunAngles()
			ang:RotateAroundAxis(ang:Up(), 180)

			atch:SetPos(self:ShootPos() + ang:Forward() * -8)
			atch:SetAngles(ang)

			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end
	elseif self:GetTurretType() == 3 then
		local atch = self.GunAttachment
		if atch and atch:IsValid() then
			local ang = self:GetGunAngles()
			local gunpos = self:ShootPos() + ang:Forward() * 4 + ang:Right() * 4
			ang:RotateAroundAxis(ang:Forward(), 45)

			atch:SetPos(gunpos)
			atch:SetAngles(ang)

			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end

		atch = self.GunAttachment2
		if atch and atch:IsValid() then
			local ang = self:GetGunAngles()
			local gunpos = self:ShootPos() + ang:Forward() * 4 + ang:Right() * 4
			ang:RotateAroundAxis(ang:Forward(), -45)

			atch:SetPos(gunpos)
			atch:SetAngles(ang)

			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end

		atch = self.GunBase
		if atch and atch:IsValid() then
			local ang = self:GetAngles()
			ang:RotateAroundAxis(ang:Up(), 180)

			atch:SetPos(self:GetPos())
			atch:SetAngles(ang)

			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end

		atch = self.GunBase2
		if atch and atch:IsValid() then
			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end
	elseif self:GetTurretType() == 4 then
		local atch = self.GunAttachment
		if atch and atch:IsValid() then
			local ang = self:GetGunAngles()
			ang:RotateAroundAxis(ang:Up(), 180)

			atch:SetPos(self:ShootPos() + ang:Forward() * -8 + ang:Right() * 1 + ang:Up() * -5)
			atch:SetAngles(ang)

			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end

		atch = self.GunBase
		if atch and atch:IsValid() then
			local ang = self:GetAngles()
			ang:RotateAroundAxis(ang:Up(), 180)

			atch:SetPos(self:GetPos())
			atch:SetAngles(ang)

			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end

		atch = self.GunBase2
		if atch and atch:IsValid() then
			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end
	elseif self:GetTurretType() == 5 then
		local atch = self.GunAttachment
		if atch and atch:IsValid() then
			local ang = self:GetGunAngles()
			--ang:RotateAroundAxis(ang:Up(), 180)
			ang:RotateAroundAxis(ang:Forward(), 180)
			ang:RotateAroundAxis(ang:Right(), 180)

			atch:SetPos(self:ShootPos() + ang:Up() * -3 + ang:Forward() * -6 + ang:Right() * 2)
			
			atch:SetAngles(ang)

			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end
	elseif self:GetTurretType() == 7 then
		local atch = self.GunAttachment
		if atch and atch:IsValid() then
			local ang = self:GetGunAngles()
			ang:RotateAroundAxis(ang:Forward(), 180)

			
			atch:ManipulateBoneAngles(atch:LookupBone("block"), Angle(0, 0 + self:GetLastShotTime() * 36, 0))

			atch:SetPos(self:ShootPos() + ang:Up() * -3 + ang:Forward() * 7)
			
			atch:SetAngles(ang)

			atch:SetNoDraw(nodrawattachs or self:GetObjectOwner() == MySelf and self:GetManualControl())
		end
	end
end

local M_Player = FindMetaTable("Player")
local P_Team = M_Player.Team

local matBeam = Material("trails/laser")
local matGlow = Material("sprites/glow04_noz")
function ENT:DrawTranslucent()
	self:GetAttVariables()
	if self:GetMaterial() ~= "" then return end


	local owner = self:GetObjectOwner()
	local manualcontrol = self:GetManualControl()

	if P_Team(MySelf) == TEAM_HUMAN then
		if (owner~=MySelf or not manualcontrol ) and not GAMEMODE.AlwaysShowTurretBeam and not MySelf:KeyDown(IN_SPEED) then
			return
		end
	end

	local lightpos = self:LightPos()

	local ang = self:GetGunAngles()
	local alpha = self:TransAlphaToMe()

	local colBeam = self.BeamColor

	local hasowner = owner:IsValid()
	local hasammo = self:GetAmmo() > 0
	local overheated =  (self:GetHeatState() == 2)
	--local hasammo = (self:GetHeatState() == 2) and false or (self:GetAmmo() > 0)

	local tr = util.TraceLine({start = lightpos, endpos = lightpos + ang:Forward() * (manualcontrol and 4096 or self:GetTurretSearchDistance() * (hasowner and owner.TurretRangeMul or 1)), mask = MASK_SHOT, filter = self:GetCachedScanFilter()})

	if not hasowner then
		local rate = FrameTime() * 512
		colBeam.r = math.Approach(colBeam.r, 0, rate)
		colBeam.g = math.Approach(colBeam.g, 0, rate)
		colBeam.b = math.Approach(colBeam.b, 255, rate)
	elseif not hasammo or not manualcontrol and self:GetTarget():IsValid() then
		local rate = FrameTime() * 512
		colBeam.r = math.Approach(colBeam.r, 255, rate)
		colBeam.g = math.Approach(colBeam.g, 0, rate)
		colBeam.b = math.Approach(colBeam.b, 0, rate)
	elseif manualcontrol then
		local rate = FrameTime() * 512
		colBeam.r = math.Approach(colBeam.r, 255, rate)
		colBeam.g = math.Approach(colBeam.g, 255, rate)
		colBeam.b = math.Approach(colBeam.b, 0, rate)
	elseif overheated then
		local rate = FrameTime() * 512
		colBeam.r = math.Approach(colBeam.r, 255, rate)
		colBeam.g = math.Approach(colBeam.g, 255, rate)
		colBeam.b = math.Approach(colBeam.b, 0, rate)
	else
		local rate = FrameTime() * 200
		colBeam.r = math.Approach(colBeam.r, 0, rate)
		colBeam.g = math.Approach(colBeam.g, 255, rate)
		colBeam.b = math.Approach(colBeam.b, 0, rate)
	end

	if hasowner and hasammo and not overheated then
		render.SetMaterial(matBeam)
		if alpha > 0.5 then
			render.DrawBeam(lightpos, tr.HitPos, 1 * self.ModelScale, 0, 1, COLOR_WHITE)
		end
		render.DrawBeam(lightpos, tr.HitPos, 4 * self.ModelScale, 0, 1, colBeam)
		render.SetMaterial(matGlow)
		if alpha > 0.5 then
			render.DrawSprite(lightpos, 4 * self.ModelScale, 4 * self.ModelScale, COLOR_WHITE)
		end
		render.DrawSprite(lightpos, 16 * self.ModelScale, 16 * self.ModelScale, colBeam)
		render.DrawSprite(tr.HitPos, 2, 2, COLOR_WHITE)
		render.DrawSprite(tr.HitPos, 8, 8, colBeam)
	else
		render.SetMaterial(matGlow)
		render.DrawSprite(lightpos, 4 * self.ModelScale, 4 * self.ModelScale, COLOR_WHITE)
		render.DrawSprite(lightpos, 16 * self.ModelScale, 16 * self.ModelScale, colBeam)
	end
end

function ENT:SetTarget(ent)
	if ent:IsValid() then
		self:SetTargetReceived(CurTime())
	else
		self:SetTargetLost(CurTime())
	end

	self:SetDTEntity(0, ent)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(1, ent)
end