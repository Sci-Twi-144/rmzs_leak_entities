include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 72))

	self.AmbientSound = CreateSound(self, "npc/combine_gunship/dropship_engine_distant_loop1.wav")
	self.AmbientSound:Play()

	self.PixVis = util.GetPixelVisibleHandle()

	self:CreateHook()
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.25, math.Clamp(125 + self:GetVelocity():Length() * 0.5, 150, 250))
end

function ENT:CreateHook()
	local ent = self
	local ENTC = tostring(ent)

	hook.Add("CreateMove", ENTC, function(cmd)
		if not IsValid(ent) then return end

		if ent:GetObjectOwner() ~= MySelf then return end

		if not ent:BeingControlled() then return end

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

		if ent:BeingControlled() then
			return true
		else
			-- just putted it here because i want it to be disabled immediately
			if GAMEMODE.m_NightVision then GAMEMODE.m_NightVision = false end
		end
	end)

	hook.Add("CalcView", ENTC, function(pl, origin, angles, fov, znear, zfar)
		if not IsValid(ent) then return end
		
		if ent:GetObjectOwner() ~= pl or not ent:BeingControlled() then return end

		return {origin = ent:GetCameraPosition(angles)}
	end)

	hook.Add("PlayerBindPress", ENTC, function(pl, bind)
		if not IsValid(ent) then return end

		if ent:GetObjectOwner() ~= pl or not ent:BeingControlled() then return end

		if bind == "impulse 100" then
			GAMEMODE.m_NightVision = not GAMEMODE.m_NightVision
		end
	end)
end

function ENT:RemoveHook()
	local ENTC = tostring(self)
	hook.Remove("CreateMove", ENTC)
	hook.Remove("ShouldDrawLocalPlayer", ENTC)
	hook.Remove("CalcView", ENTC)
	hook.Remove("PlayerBindPress", ENTC)

	-- disable a nightvision manually
	GAMEMODE.m_NightVision = false
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
	self:RemoveHook()
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local colWhite = Color(255, 255, 255)
local colLight = Color(255, 255, 255)
local matLight = Material("sprites/light_ignorez")
local normalvec = Vector(0, 0, 26)
local spreadvec = Vector(40, 40, 0)

function ENT:DrawTranslucent()
	local owner = self:GetObjectOwner()
	if not owner:IsValid() then return end

	local lp = MySelf
	local camera = owner == lp and self:BeingControlled()

	if not camera then
		local alpha = self:TransAlphaToMe()
		render.SetBlend(alpha)
		self:DrawModel()
		render.SetBlend(1)
	end

	local epos = self:GetRedLightPos()
	local LightNrm = self:GetForward()
	local ViewNormal = epos - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = math.min(1, ViewNormal:Dot( LightNrm * -1 ) + 0.25)

	local ang = LightNrm

	if lp:IsValid() and lp:Team() == TEAM_HUMAN and owner:IsValid() and owner:IsPlayer() and not ShouldVisibleDraw(self:GetPos()) then
		local adjvec = epos + spreadvec * ang
		adjvec.z = adjvec.z + 15
		ang = lp:EyeAngles()
		ang.pitch = 0
		ang:RotateAroundAxis(ang:Up(), 270)
		ang:RotateAroundAxis(ang:Forward(), 90)
		cam.Start3D2D(camera and adjvec or self:LocalToWorld(normalvec), ang, 0.03)
			cam.IgnoreZ(camera)
			local name = ""
			if owner:IsValid() and owner:IsPlayer() then
				name = owner:ClippedName()
			end
			self:Draw3DHealthBar(math.Clamp(self:GetObjectHealth() / self:GetMaxObjectHealth(), 0, 1), name, 150, 0.85, -150)

			cam.IgnoreZ(false)
		cam.End3D2D()
	end

	if ViewDot > 0 then
		local LightPos = epos + LightNrm * 5

		render.SetMaterial(matLight)
		local Visibile	= util.PixelVisible( LightPos, 16, self.PixVis )

		if not Visibile then return end

		local Size = math.Clamp(Distance * Visibile * ViewDot, 25, 250)

		Distance = math.Clamp(Distance, 32, 800)
		local Alpha = math.Clamp((1000 - Distance) * Visibile * ViewDot, 0, 120)
		colLight.a = Alpha
		colWhite.a = Alpha

		render.DrawSprite(LightPos, Size, Size, colLight, Visibile * ViewDot)
		render.DrawSprite(LightPos, Size*0.4, Size*0.4, colWhite, Visibile * ViewDot)
	end
end
