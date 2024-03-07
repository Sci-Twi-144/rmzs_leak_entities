include("shared.lua")

SWEP.ViewModelFOV = 70

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.VElements = {
	["stick1+++"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "stick1", pos = Vector(0, -0.327, -11.448), angle = Angle(0, 0, 180), size = Vector(0.632, 0.632, 1.25), color = Color(105, 95, 85, 255), surpresslightning = false, material = "models/cs_italy/pwtrim2", skin = 0, bodygroup = {} },
	["stick1+"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "stick1", pos = Vector(0, 2.653, 19.566), angle = Angle(0, 0, 180), size = Vector(0.632, 0.632, 1.25), color = Color(105, 95, 85, 255), surpresslightning = false, material = "models/cs_italy/pwtrim2", skin = 0, bodygroup = {} },
	["BLADE"] = { type = "Model", model = "models/gibs/manhack_gib05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "stick1", pos = Vector(0.056, 13.444, 34.348), angle = Angle(-166.478, 90, 90), size = Vector(1.981, 0.884, 1.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["BLADE+++"] = { type = "Model", model = "models/gibs/manhack_gib05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "stick1", pos = Vector(0.056, 12.956, 31.569), angle = Angle(-174.937, 90, 90), size = Vector(1.981, 0.884, 1.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["BLADE++"] = { type = "Model", model = "models/gibs/manhack_gib05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "stick1", pos = Vector(0.056, 13.444, 32.708), angle = Angle(-171.433, 90, 90), size = Vector(1.981, 0.884, 1.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["stick1"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "tag_weapon", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.632, 0.632, 1.25), color = Color(105, 95, 85, 255), surpresslightning = false, material = "models/cs_italy/pwtrim2", skin = 0, bodygroup = {} },
	["stick1++"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "stick1", pos = Vector(0.056, 1.58, 34.312), angle = Angle(180, 0, 0), size = Vector(0.827, 0.652, 1.215), color = Color(105, 95, 85, 255), surpresslightning = false, material = "models/cs_italy/pwtrim2", skin = 0, bodygroup = {} },
	["BACK"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_03.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "stick1", pos = Vector(0.141, 0.136, 33.291), angle = Angle(7.782, -90, 99.166), size = Vector(0.061, 0.264, 0.065), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["BLADE+"] = { type = "Model", model = "models/gibs/manhack_gib05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "stick1", pos = Vector(0.056, 13.444, 33.519), angle = Angle(-166.478, 90, 90), size = Vector(1.981, 0.884, 1.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["blade++++"] = { type = "Model", model = "models/gibs/manhack_gib05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pole", pos = Vector(0.056, 12.956, 31.569), angle = Angle(-174.937, 90, 90), size = Vector(1.981, 0.884, 1.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["pole+"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pole", pos = Vector(0, 2.812, 19.566), angle = Angle(0, 0, 180), size = Vector(0.632, 0.632, 1.25), color = Color(105, 95, 85, 255), surpresslightning = false, material = "models/cs_italy/pwtrim2", skin = 0, bodygroup = {} },
	["blade++"] = { type = "Model", model = "models/gibs/manhack_gib05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pole", pos = Vector(0.056, 13.444, 33.519), angle = Angle(-166.478, 90, 90), size = Vector(1.981, 0.884, 1.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["blade+"] = { type = "Model", model = "models/gibs/manhack_gib05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pole", pos = Vector(0.056, 13.444, 34.348), angle = Angle(-166.478, 90, 90), size = Vector(1.981, 0.884, 1.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["blade+++"] = { type = "Model", model = "models/gibs/manhack_gib05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pole", pos = Vector(0.056, 12.956, 32.708), angle = Angle(-171.433, 90, 90), size = Vector(1.981, 0.884, 1.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["pole++"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pole", pos = Vector(0.056, 1.58, 34.312), angle = Angle(180, 0, 0), size = Vector(0.827, 0.652, 1.215), color = Color(105, 95, 85, 255), surpresslightning = false, material = "models/cs_italy/pwtrim2", skin = 0, bodygroup = {} },
	["back"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_03.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pole", pos = Vector(0.141, 0.136, 33.291), angle = Angle(7.782, -90, 99.166), size = Vector(0.061, 0.264, 0.065), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_CANAL/metalwall005b", skin = 0, bodygroup = {} },
	["pole"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.213, 1.246, 2.063), angle = Angle(177.371, 63.734, -7.24), size = Vector(0.632, 0.632, 1.25), color = Color(105, 95, 85, 255), surpresslightning = false, material = "models/cs_italy/pwtrim2", skin = 0, bodygroup = {} },
	["pole+++"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pole", pos = Vector(0, -0.327, -11.448), angle = Angle(0, 0, 180), size = Vector(0.632, 0.632, 1.25), color = Color(105, 95, 85, 255), surpresslightning = false, material = "models/cs_italy/pwtrim2", skin = 0, bodygroup = {} }
}

local ghostlerp = 0
local add_lerp = Vector(0, 0, 0)
local add_angle = Angle(0, 0, 0)

local metal, field = Material("models/weapons/rmzs/scythe/scythe_metal"), Material("models/weapons/rmzs/scythe/scythe_field")
function SWEP:PostDrawViewModel(vm)
	self.BaseClass.PostDrawViewModel(self, vm)

	metal:SetFloat("$emissiveblendenabled", 0)
	field:SetFloat("$emissiveblendenabled", 0)
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

	--[[if self.VMAng and self.VMPos then
		ang:RotateAroundAxis(ang:Right(), wep.VMAng.x) 
		ang:RotateAroundAxis(ang:Up(), wep.VMAng.y)
		ang:RotateAroundAxis(ang:Forward(), wep.VMAng.z)

		pos:Add(ang:Right() * (wep.VMPos.x))
		pos:Add(ang:Forward() * (wep.VMPos.y))
		pos:Add(ang:Up() * (wep.VMPos.z))
	end]]

	return pos, ang
end