include("shared.lua")

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

function SWEP:DrawAds()
	self:DrawGenericAbilityBar(self:GetResource(), self.AbilityMax, col, "Special Meter:", false)
	local screenscale = BetterScreenScale()

	surface.SetFont("ZSHUDFont")
	local text_help1 = (translate.Get("idesc_frotchet_help1"))
	local text_help2 = (translate.Get("idesc_frotchet_help2"))
	local text_help3 = (translate.Get("idesc_frotchet_help3"))

	if GetConVar("zs_newbiemode"):GetInt() == 1 then
		draw.SimpleTextBlurry(text_help1, "ZSHUDFontSmall", ScrW() - 260 * screenscale, ScrH() - 100 * screenscale, COLOR_LIMEGREEN , TEXT_ALIGN_CENTER)
		if self:GetFireMode() == 0 then
			draw.SimpleTextBlurry(text_help2, "ZSHUDFontSmall", ScrW() - 260 * screenscale, ScrH() - 130 * screenscale, COLOR_LIMEGREEN , TEXT_ALIGN_CENTER)
		elseif self:GetFireMode() == 1 then
			draw.SimpleTextBlurry(text_help3, "ZSHUDFontSmall", ScrW() - 260 * screenscale, ScrH() - 130 * screenscale, COLOR_LIMEGREEN , TEXT_ALIGN_CENTER)
		end
	end
end

function SWEP:DefineFireMode2D()
	if self:GetFireMode() == 0 then
		return "Frost Armor"
	elseif self:GetFireMode() == 1 then
		return "Ice Barrage"
	end
end

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/frotchet/frotchet.mdl", bone = "tag_weapon", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

--[[
SWEP.VElements = {
	["base++++"] = { type = "Model", model = "models/gibs/glass_shard02.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-30.751, -0.101, -5.35), angle = Angle(-169.978, 0, 90), size = Vector(1.149, 0.651, 0.5), color = Color(45, 145, 255, 255), surpresslightning = false, material = "models/shadertest/shader2", skin = 0, bodygroup = {} },
	["base+++++"] = { type = "Model", model = "models/gibs/glass_shard05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-22.646, -0.11, -5.762), angle = Angle(14.866, 0, 90), size = Vector(0.952, 0.847, 0.4), color = Color(45, 145, 255, 255), surpresslightning = false, material = "models/shadertest/shader2", skin = 0, bodygroup = {} },
	["base++++++"] = { type = "Model", model = "models/gibs/glass_shard06.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-26.855, -0.12, -0.797), angle = Angle(132.593, 0, 90), size = Vector(0.813, 1.879, 0.449), color = Color(45, 145, 255, 255), surpresslightning = false, material = "models/shadertest/shader2", skin = 0, bodygroup = {} },
	["base++"] = { type = "Model", model = "models/props_wasteland/rockcliff01g.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(35.922, 0.632, 1.478), angle = Angle(1.037, 86.152, 93.763), size = Vector(0.03, 0.037, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_foliage/driftwood_01a", skin = 0, bodygroup = {} },
	["base"] = { type = "Model", model = "models/props_foliage/driftwood_01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.473, 1.353, -12.9), angle = Angle(93.541, 15.888, -27.748), size = Vector(0.14, 0.059, 0.059), color = Color(236, 234, 233, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+++++++"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-26.306, -0.119, 0.578), angle = Angle(62.902, 0, 0), size = Vector(0.014, 0.041, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_foliage/driftwood_01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(22.452, 0.104, -0.147), angle = Angle(0.186, -1.838, 2.183), size = Vector(0.07, 0.075, 0.071), color = Color(89, 69, 57, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
	["base+++"] = { type = "Model", model = "models/props_wasteland/rockgranite04b.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-27.06, -0.257, 0.49), angle = Angle(55.191, 1.259, 180), size = Vector(0.016, 0.014, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_foliage/driftwood_01a", skin = 0, bodygroup = {} }
}
]]
SWEP.DVElements = SWEP.VElements

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/frotchet/frotchet.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.5999999046326, 1.5, 0), angle = Angle(180, 75, 3), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
--[[
SWEP.WElements = {
	["base+++++"] = { type = "Model", model = "models/gibs/glass_shard05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-20.38, -0.099, -5.185), angle = Angle(14.866, 0, 90), size = Vector(0.856, 0.762, 0.36), color = Color(45, 145, 255, 255), surpresslightning = false, material = "models/shadertest/shader2", skin = 0, bodygroup = {} },
	["base+++"] = { type = "Model", model = "models/props_wasteland/rockgranite04b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-24.354, -0.232, 0.441), angle = Angle(55.191, 1.259, 180), size = Vector(0.014, 0.013, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_foliage/driftwood_01a", skin = 0, bodygroup = {} },
	["base++++++"] = { type = "Model", model = "models/gibs/glass_shard06.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-24.17, -0.109, -0.717), angle = Angle(132.593, 0, 90), size = Vector(0.731, 1.692, 0.405), color = Color(45, 145, 255, 255), surpresslightning = false, material = "models/shadertest/shader2", skin = 0, bodygroup = {} },
	["base"] = { type = "Model", model = "models/props_foliage/driftwood_01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.296, 1.764, -12.671), angle = Angle(85.412, 40.909, -21.896), size = Vector(0.126, 0.054, 0.054), color = Color(236, 234, 233, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base++"] = { type = "Model", model = "models/props_wasteland/rockcliff01g.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(32.328, 0.568, 1.33), angle = Angle(1.037, 86.152, 93.763), size = Vector(0.027, 0.032, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_foliage/driftwood_01a", skin = 0, bodygroup = {} },
	["base+++++++"] = { type = "Model", model = "models/props_pipes/concrete_pipe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-23.674, -0.106, 0.521), angle = Angle(62.902, 0, 0), size = Vector(0.012, 0.037, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/guttermetal01a", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_foliage/driftwood_01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(20.207, 0.093, -0.132), angle = Angle(0.186, -1.838, 2.183), size = Vector(0.063, 0.067, 0.064), color = Color(89, 69, 57, 255), surpresslightning = false, material = "models/props_c17/chairchrome01", skin = 0, bodygroup = {} },
	["base++++"] = { type = "Model", model = "models/gibs/glass_shard02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-27.675, -0.091, -4.816), angle = Angle(-169.978, 0, 90), size = Vector(1.034, 0.584, 0.449), color = Color(45, 145, 255, 255), surpresslightning = false, material = "models/shadertest/shader2", skin = 0, bodygroup = {} }
}
]]
SWEP.DWElements = SWEP.WElements
--[[
local ghostlerp = 0
local add_lerp = Vector(0, 0, 0)
local add_angle = Angle(0, 0, 0)

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
]]
function SWEP:PreDrawViewModel(vm)
	self.BaseClass.PreDrawViewModel(self, vm)

	for mdl, tab in pairs(self.VElements) do
		tab.material = self:IsCharging() and "models/shiny" or self.DVElements[mdl].material
		tab.color = self:IsCharging() and Color(255, 255, 255, 255) or self.DVElements[mdl].color
	end
end

function SWEP:DrawWorldModel()
	self.BaseClass.DrawWorldModel(self)

	for mdl, tab in pairs(self.WElements) do
		tab.material = self:IsCharging() and "models/shiny" or self.DWElements[mdl].material
		tab.color = self:IsCharging() and Color(255, 255, 255, 255) or self.DWElements[mdl].color
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
						particle:SetAirResistance(resist)
					end
					emitter:Finish() emitter = nil collectgarbage("step", 64)
				end
			end
		end
	end
end

--[[
function SWEP:DrawHUD()
	local screenscale = BetterScreenScale()

	surface.SetFont("ZSHUDFont")
	local text_nails = (translate.Get("idesc_hammer_nail_special"))
	local text_prop = (translate.Get("idesc_hammer_prop_special"))

	if GetConVar("zs_newbiemode"):GetInt() == 1 then
		draw.SimpleTextBlurry(text_prop, "ZSHUDFontSmall", ScrW() - 64 * screenscale, ScrH() - 40 , COLOR_LIMEGREEN , TEXT_ALIGN_CENTER)
		draw.SimpleTextBlurry(text_nails, "ZSHUDFontSmall", ScrW() - 64 * screenscale, ScrH() - 40, COLOR_LIMEGREEN , TEXT_ALIGN_CENTER)
	end
end ]]