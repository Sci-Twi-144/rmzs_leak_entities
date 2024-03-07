include("shared.lua")

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.VElements = {
	["base+++"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 2, -21.601), angle = Angle(90, 90, 0), size = Vector(0.95, 1.144, 0.56), color = Color(55, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/dome", skin = 0, bodygroup = {} },
	["wires"] = { type = "Model", model = "models/props_debris/rebar_smallnorm01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-1, 1, -8.832), angle = Angle(1.169, -180, -5.871), size = Vector(0.14, 0.497, 0.56), color = Color(165, 208, 208, 255), surpresslightning = false, material = "models/weapons/v_crowbar/crowbar_cyl", skin = 0, bodygroup = {} },
	["base++"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 2.2), angle = Angle(0, 0, 0), size = Vector(0.885, 0.885, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} },
	["slammer+"] = { type = "Model", model = "models/Items/BoxMRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(7.791, 0, -21.299), angle = Angle(0, 90, 90), size = Vector(0.8, 0.649, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["piece"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(0, 0, -12.988), angle = Angle(0, 90, 0), size = Vector(0.36, 0.36, 0.432), color = Color(135, 137, 135, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["skull"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base+++", pos = Vector(0, 0, 1.7), angle = Angle(55, 0, 0), size = Vector(0.82, 0.82, 0.82), color = Color(166, 166, 166, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, -19), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 0.189), color = Color(45, 45, 45, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "tag_weapon", rel = "", pos = Vector(0, 0, 13), angle = Angle(0, 0, 180), size = Vector(1.144, 1.144, 0.237), color = Color(54, 49, 39, 255), surpresslightning = false, material = "phoenix_storms/wood_Dome", skin = 0, bodygroup = {} },
	["base++++"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, -1.9, -21.601), angle = Angle(90, 90, 180), size = Vector(0.95, 1.144, 0.56), color = Color(55, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/dome", skin = 0, bodygroup = {} },
	["slammer"] = { type = "Model", model = "models/Items/BoxMRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-7.6, 0, -21.299), angle = Angle(0, -90, 90), size = Vector(0.8, 0.649, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["skull+"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base+++", pos = Vector(0, 0, -5.715), angle = Angle(-55, 0, 180), size = Vector(0.82, 0.82, 0.82), color = Color(166, 166, 166, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.DVElements = SWEP.VElements

SWEP.WElements = {
	["base+++"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 2, -21.601), angle = Angle(90, 90, 0), size = Vector(0.95, 1.144, 0.56), color = Color(55, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/dome", skin = 0, bodygroup = {} },
	["wires"] = { type = "Model", model = "models/props_debris/rebar_smallnorm01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1, 1, -8.832), angle = Angle(1.169, -180, -5.871), size = Vector(0.14, 0.497, 0.56), color = Color(165, 208, 208, 255), surpresslightning = false, material = "models/weapons/v_crowbar/crowbar_cyl", skin = 0, bodygroup = {} },
	["base++"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 2.2), angle = Angle(0, 0, 0), size = Vector(0.885, 0.885, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} },
	["base++++"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, -1.9, -21.601), angle = Angle(90, 90, 180), size = Vector(0.95, 1.144, 0.56), color = Color(55, 55, 55, 255), surpresslightning = false, material = "phoenix_storms/dome", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, -19), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 0.189), color = Color(45, 45, 45, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++++"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 24.416), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 0.2), color = Color(45, 45, 45, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["piece"] = { type = "Model", model = "models/props_junk/CinderBlock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, -12.988), angle = Angle(0, 90, 0), size = Vector(0.36, 0.36, 0.432), color = Color(135, 137, 135, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["skull"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base+++", pos = Vector(0, 0, 1.7), angle = Angle(55, 0, 0), size = Vector(0.82, 0.82, 0.82), color = Color(166, 166, 166, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++++++"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 24.416), angle = Angle(0, 0, 0), size = Vector(0.885, 0.885, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/mrref2", skin = 0, bodygroup = {} },
	["slammer+"] = { type = "Model", model = "models/Items/BoxMRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(7.791, 0, -21.299), angle = Angle(0, 90, 90), size = Vector(0.8, 0.649, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["base"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -14), angle = Angle(0, 0, 0), size = Vector(1.144, 1.144, 0.237), color = Color(54, 49, 39, 255), surpresslightning = false, material = "phoenix_storms/wood_Dome", skin = 0, bodygroup = {} },
	["slammer"] = { type = "Model", model = "models/Items/BoxMRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-7.6, 0, -21.299), angle = Angle(0, -90, 90), size = Vector(0.8, 0.649, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["cap"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 47.272), angle = Angle(0, 0, 0), size = Vector(1.21, 1.21, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {} },
	["skull+"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base+++", pos = Vector(0, 0, -5.715), angle = Angle(-55, 0, 180), size = Vector(0.82, 0.82, 0.82), color = Color(166, 166, 166, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.DWElements = SWEP.WElements

local ghostlerp = 0
local add_lerp = Vector(0, 0, 0)
local add_angle = Angle(0, 0, 0)

local texture = Material( "models/rmzs/weapons/fusion_breaker/fusion_breaker_head.vmt" )

function SWEP:Holster()
	self.BaseClass.Holster(self)
	texture:SetFloat("$emissiveblendenabled", 1)
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
	texture:SetFloat("$emissiveblendenabled", 0)
	return true
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	texture:SetFloat("$emissiveblendenabled", 0)
	self.ChargeSound = CreateSound(self, "nox/scatterfrost.ogg")
end

function SWEP:GetViewModelPosition(pos, ang)
	local owner = self:GetOwner()

	if self:IsSwinging() or self:IsWinding() then
		local rot = self.SwingRotation
		local offset = self.SwingOffset

		ang = Angle(ang.pitch, ang.yaw, ang.roll) -- Copy

		local power = 0
		if self:IsSwinging() then
			local armdelay = owner:GetMeleeSpeedMul()
			local swingtime = self.SwingTime * (owner.MeleeSwingDelayMul or 1) * armdelay
			local swingend = self:GetSwingEnd()
			local delta = swingtime - math.Clamp(swingend - CurTime(), 0, swingtime - (self:IsHeavy() and swingtime/2 or 0))
			power = CosineInterpolation(0, 1, delta / swingtime)
		else
			local windstart = self:GetWindStart()
			local delta = math.Clamp((CurTime() - windstart) * 1, 0, 1)

			power = CosineInterpolation(0, 1, delta)
		end

		local new_lerp = offset.x * power * ang:Right() + offset.y * power * ang:Forward() + offset.z * power * ang:Up()
		local new_ang = Angle(rot.pitch * power, rot.yaw * power, rot.roll * power)

		add_lerp = LerpVector(0.03, add_lerp, new_lerp)
		add_angle = LerpAngle(0.05, add_angle, new_ang)

		pos = pos + add_lerp

		ang:RotateAroundAxis(ang:Right(), add_angle.pitch)
		ang:RotateAroundAxis(ang:Up(), add_angle.yaw)
		ang:RotateAroundAxis(ang:Forward(), add_angle.roll)
	else
		local rot = self.BlockRotation
		local offset = -self.BlockOffset

		ang = Angle(ang.pitch, ang.yaw, ang.roll) -- Copy

		local swingend = self:GetBlockEnd()
		local delta = 0.3 - math.Clamp(swingend - CurTime(), 0, 0.3)
		local power = CosineInterpolation(0, 1, delta / 0.3)
		power = self:IsBlocking() and power or 1 - power

		local new_lerp = offset.x * power * ang:Right() + offset.y * power * ang:Forward() + offset.z * power * ang:Up()
		local new_ang = Angle(rot.pitch * power, rot.yaw * power, rot.roll * power)

		add_lerp = LerpVector(0.13 * FrameTime() * 100, add_lerp, new_lerp)
		add_angle = LerpAngle(0.05 * FrameTime() * 100, add_angle, new_ang)

		pos = pos + add_lerp

		ang:RotateAroundAxis(ang:Right(), add_angle.pitch)
		ang:RotateAroundAxis(ang:Up(), add_angle.yaw)
		ang:RotateAroundAxis(ang:Forward(), add_angle.roll)
	end

	if owner:GetBarricadeGhosting() then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 4)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 5)
	end

	if ghostlerp > 0 then
		pos = pos + 3.5 * ghostlerp * ang:Up()
		ang:RotateAroundAxis(ang:Right(), -30 * ghostlerp)
	end

	return pos, ang
end

function SWEP:PreDrawViewModel(vm)
	self.BaseClass.PreDrawViewModel(self, vm)

	for mdl, tab in pairs(self.VElements) do
		tab.material = self:IsCharging() and "models/shiny" or self.DVElements[mdl].material
		tab.color = self:IsCharging() and Color(130, 25, 0, 255) or self.DVElements[mdl].color
	end
end

function SWEP:DrawWorldModel()
	self.BaseClass.DrawWorldModel(self)

	for mdl, tab in pairs(self.WElements) do
		tab.material = self:IsCharging() and "models/shiny" or self.DWElements[mdl].material
		tab.color = self:IsCharging() and Color(130, 25, 0, 255) or self.DWElements[mdl].color
	end

	local owner = self:GetOwner()
	if owner:IsValid() and not owner.ShadowMan then

		local boneindex = owner:LookupBone("valvebiped.bip01_r_hand")
		if boneindex then
			local pos, ang = owner:GetBonePosition(boneindex)
			if pos then
				if self:IsCharging() then
					local rdelta = math.min(0.5, CurTime() - self:GetCharge())

					local force = rdelta * 140
					local resist = force * 0.5

					pos = pos + ang:Up() * -32

					local curvel = owner:GetVelocity() * 0.5
					local emitter = ParticleEmitter(pos)
					emitter:SetNearClip(24, 48)

					for i=1, math.min(16, math.ceil(FrameTime() * 200)) do
						local particle = emitter:Add("particle/snow", pos)
						particle:SetVelocity(curvel + VectorRand():GetNormalized() * force)
						particle:SetDieTime(0.5)
						particle:SetStartAlpha(rdelta * 125 + 15)
						particle:SetEndAlpha(0)
						particle:SetStartSize(1)
						particle:SetEndSize(rdelta * 10 + 4)
						particle:SetColor(130, 45, 0)
						particle:SetAirResistance(resist)
					end
					emitter:Finish() emitter = nil collectgarbage("step", 64)
				end
			end
		end
	end
end
