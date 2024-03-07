include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:OnInitialize()
	local ent = self
	local ENTC = tostring(ent)

	hook.Add("Move", ENTC, function(pl, move)
		if not IsValid(ent) then return end

		if pl ~= ent:GetOwner() then return end
	
		move:SetMaxSpeed(0)
		move:SetMaxClientSpeed(0)
	end)
	
	hook.Add("CreateMove", ENTC, function(cmd)
		if not IsValid(ent) then return end

		if LocalPlayer() ~= ent:GetOwner() then return end
	
		local ang = cmd:GetViewAngles()
		ang.yaw = ent.CommandYaw or ang.yaw
		cmd:SetViewAngles(ang)
	
		if bit.band(cmd:GetButtons(), IN_JUMP) ~= 0 then
			cmd:SetButtons(cmd:GetButtons() - IN_JUMP)
		end
	end)
	
	hook.Add("ShouldDrawLocalPlayer", ENTC, function(pl)
		if not IsValid(ent) then return end
		
		if pl ~= ent:GetOwner() then return end
	
		return true
	end)

	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()
	if owner:IsValid() then
		FeignDeath[owner] = self
		owner.NoCollideAll = true

		self.CommandYaw = owner:GetAngles().yaw

		owner:CallWeaponFunction("KnockedDown", self, false)
		owner:CallZombieFunction("KnockedDown", self, false)
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then
		FeignDeath[owner] = nil
		owner.NoCollideAll = owner:Team() == TEAM_UNDEAD and owner:GetZombieClassTable().NoCollideAll
	end

	hook.Remove("Move", tostring(self))
	hook.Remove("CreateMove", tostring(self))
	hook.Remove("ShouldDrawLocalPlayer", tostring(self))
end

function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	
	local pos = owner:GetPos() + EyeAngles():Right() * 32
	local col = table.Copy(COLOR_GRAY)
	if self:GetState() == 1 then
		col.a = math.max(self:GetStateEndTime() - CurTime(), 0) * 80
	else
		col.a = (1 - math.max(self:GetStateEndTime() - CurTime(), 0)) * 80
	end
	local ang = owner:GetAngles()
	ang.pitch = 0
	ang.roll = 0

	if owner ~= MySelf then return end
	cam.IgnoreZ(true)
	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleTextBlur(translate.Get("press_sprint_to_get_up"), "ZS3D2DFont2Small", 0, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	cam.IgnoreZ(false)
end
