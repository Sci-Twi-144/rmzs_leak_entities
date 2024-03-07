include("shared.lua")

local matGlow = Material("sprites/light_glow02_add")

ENT.SmokeTimer = 0
ENT.CurrentGlow = 1

local ang=Angle(0,0,4)

function ENT:Draw()
	local owner = self:GetOwner()
	if owner == MySelf then
		if self.Target then
			cam.IgnoreZ(true)
				local posed = self.Target:GetShootPos()
				local sprite = Material("zombiesurvival/headshot_stacks.png")
				local size = 50
				render.SetMaterial(sprite)
				render.DrawSprite(posed, size, size, Color(255,150,100,150))
			cam.IgnoreZ(false)
		end
	end
	if owner == MySelf and self:BeingControlled() then return end
	if GAMEMODE.NoDrawHumanProjectilesInFPS_H and not (owner == MySelf) and not owner:ShouldDrawLocalPlayer() and not (MySelf:Team() == TEAM_UNDEAD) then return end
	self:DrawModel()
	local pos = self:GetPos()
	local boosted = self:GetDTBool(1)

	self.CurrentGlow = Lerp( FrameTime()*3 ,self.CurrentGlow,boosted and 100 or 0)

	self.matrix:Rotate(ang*(boosted and 2 or 1))
	self:EnableMatrix( "RenderMultiply", self.matrix )

	render.SetMaterial(matGlow)
	render.DrawSprite(pos, self.CurrentGlow, self.CurrentGlow, Color(255,210,170))
end

function ENT:Initialize()

	self.AmbientSound = CreateSound(self, "Missile.Ignite")
	self.AmbientSound:PlayEx(0.25, 65)
	self:CreateHook()

	self.matrix = Matrix()
end

function ENT:CreateHook()
	local ent = self
	local ENTC = tostring(ent)

	hook.Add("CreateMove", ENTC, function(cmd)
		if not IsValid(ent) then return end

		if ent:GetOwner() ~= MySelf or not self:BeingControlled() then return end
	
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

		if ent:GetOwner() ~= MySelf or not self:BeingControlled() then return end
	
		return true
	end)
	
	local trace_cam = {mask = MASK_VISIBLE, mins = Vector(-4, -4, -4), maxs = Vector(4, 4, 4)}
	hook.Add("CalcView", ENTC, function(pl, origin, angles, fov, znear, zfar)
		if not IsValid(ent) then return end
		
		if ent:GetOwner() ~= pl or not self:BeingControlled() then return end -- or not ent:BeingControlled()
	
		return {origin = ent:GetPos() ,angles=ent:GetAngles()}
	end)
end

function ENT:RemoveHook()
	local ENTC = tostring(self)
	hook.Remove("CreateMove", ENTC)
	hook.Remove("ShouldDrawLocalPlayer", ENTC)
	hook.Remove("CalcView", ENTC)
end


--[[function ENT:Think()
	local pos = self:GetPos()

	local boosted = self:GetDTBool(1)

	--self.AmbientSound:ChangePitch(boosted and 255 or 100)
	self.AmbientSound:ChangeVolume(boosted and 1 or 0.25,0.25)

	if not boosted then return end

	if ShouldDrawGlobalParticles(pos) then
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(24, 32)

		if self.SmokeTimer < CurTime() then
			self.SmokeTimer = CurTime() + (0.05)

			local particle = emitter:Add("effects/fire_cloud1", pos)
			particle:SetVelocity(self:GetVelocity() * -0.4 + VectorRand() * 60)
			particle:SetDieTime(0.5)
			particle:SetStartAlpha(100)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(12, 19))
			particle:SetEndSize(5)
			particle:SetRoll(math.Rand(-0.8, 0.8))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetColor(240, 180, 120)

			particle = emitter:Add("particles/smokey", pos + VectorRand() * 10)
			particle:SetDieTime(math.Rand(0.4, 0.6))
			particle:SetStartAlpha(math.Rand(110, 130))
			particle:SetEndAlpha(0)
			particle:SetStartSize(2)
			particle:SetEndSize(math.Rand(20, 34))
			particle:SetRoll(math.Rand(0, 359))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetColor(240, 190, 120)
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)

	end
end]]

function ENT:OnRemove()
	self.AmbientSound:Stop()
	self:RemoveHook()

	local pos = self:GetPos()

end
