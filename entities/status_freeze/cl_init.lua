include("shared.lua")

function ENT:GetPower()
	return math.Clamp(self:GetStartTime() + self:GetDuration() - CurTime(), 0, 1)
end

local imat = Material("models/shadertest/shader2")
local imet = "trails/electric"

function ENT:OnInitialize()
end

local matBlack = CreateMaterial("shadowlurkersheet", "UnlitGeneric", {["$basetexture"] = "trails/electric", ["$model"] = 1})
function ENT:Draw()
	if not self:GetModel() then return end
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not owner:ShouldDrawLocalPlayer() then return end
	--render.MaterialOverride(imat)
	render.ModelMaterialOverride(imat)
	if owner.ShadowMan then
		render.SetBlend(0)
	else
		render.SetBlend(0.5)
	end

	self:DrawModel()
	LastDrawFrame[owner] = FrameNumber()

	if owner.ShadowMan then
		render.SetBlend(1)
	end
	render.ModelMaterialOverride(nil)
	--render.MaterialOverride(0)
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	
	local ENTC = tostring(self)
		hook.Remove("PrePlayerDraw", ENTC)
		hook.Remove("PostPlayerDraw", ENTC)
		hook.Remove("RenderScreenspaceEffects", ENTC)
		hook.Remove("PostDrawHUD", ENTC)
		hook.Remove("PreDrawViewModel", ENTC)
		
	self:ChangeRate(1, owner)
	--self.BaseClass.OnRemove(self)
	if self.CModel then
		self.CModel:Remove()
	end
	
	if owner:IsValid() then
		local vm = owner:GetViewModel()
		if vm and vm:IsValid() then
			vm:SetPlaybackRate(1)
		end
	end

	self.BaseClass.OnRemove(self)
end