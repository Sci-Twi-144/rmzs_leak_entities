include("shared.lua")

--[[function ENT:Initialize()
	self:DrawShadow(false)
	local owner = self:GetOwner()
	
	local boneid = owner:LookupBone("ValveBiped.Bip01_Spine4")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)
	
	for _, mods in ipairs(self.ArmorPlates) do
		local modl = ClientsideModel(mods[5], RENDERGROUP_OPAQUE)
		if modl:IsValid() then
			modl:SetMaterial("models/shadertest/shader2")
			modl:SetModelScale(mods[4])
			local mat = Matrix()
			mat:Scale(mods[3])
			modl:EnableMatrix("RenderMultiply", mat)
			modl:SetPos(bonepos + mods[1])
			modl:SetAngles(boneang + mods[2])
		end
	end

end

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
	
	local boneid = owner:LookupBone("ValveBiped.Bip01_Spine4")
	if not boneid or boneid <= 0 then return end

	local bonepos, boneang = owner:GetBonePositionMatrixed(boneid)
	
	for _, mods in ipairs(self.ArmorPlates) do
		self:SetModel(mods[5])
		self:SetMaterial("models/shadertest/shader2")
		self:SetModelScale(mods[4])
		local mat = Matrix()
		mat:Scale(mods[3])
		self:EnableMatrix("RenderMultiply", mat)
		self:SetPos(bonepos * mods[1])
		self:SetAngles(boneang * mods[2])
	end


	if owner.ShadowMan then
		render.SetBlend(0.2)
	end

	self:DrawModel()

	if owner.ShadowMan then
		render.SetBlend(1)
	end
end]]

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
local matGlow = Material("zombiesurvival/defense.png")

function ENT:RenderInfo(pos, ang, multi)
	ang:RotateAroundAxis( ang:Up(), -90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )
	
	cam.Start3D2D(pos, ang, 0.075)
		draw.SimpleText(self:GetMagnitude(), "ZS3D2DFont2", 0, 0, Color(180, 180, 255, 255 * multi), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
end

function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end
	
	local function ShadowNegga()
		local multi
		if owner.ShadowMan then
			multi = 0.01
		else
			multi = 1
		end
		return multi
	end
	
	render.SetBlend(0)
	
	self:SetRenderOrigin(owner:GetPos() + Vector(0, 0, owner:OBBMaxs().z + math.abs(math.sin(CurTime() * 2)) * 4))
	--self:SetRenderAngles(Angle(0, CurTime() * 270, 0))
	
	render.SetMaterial(matGlow)
	render.DrawSprite(owner:GetPos() + Vector(0, 0, owner:OBBMaxs().z + math.abs(math.sin(CurTime() * 2)) * 8), 10, 10, Color(20, 150, 255, 100 * ShadowNegga()))
	self:RenderInfo(owner:GetPos() + Vector(0, 0, owner:OBBMaxs().z + math.abs(math.sin(CurTime() * 2)) * 8), EyeAngles(), ShadowNegga())
end
