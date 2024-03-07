AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.ArmorPlates = {
{Vector(-4.3114700317383, -1.2291259765625, -3.5869750976563), Angle(12.564273834229, 51.231327056885, 100.39836883545), Vector(1, 1, 1), 0.2, "models/props_debris/concrete_column001a_chunk01.mdl"},
{Vector(-2.1471099853516, 8.3069458007813, -0.02313232421875), Angle(-1.1846745014191, 154.72515869141, -90.142105102539), Vector(0.69999998807907, 1.2000000476837, 1), 0.6, "models/props_debris/concrete_chunk08a.mdl"},
{Vector(2.7057876586914, -6.7146606445313, 7.944091796875), Angle(8.505916595459, 43.613033294678, 75.294692993164), Vector(1, 1, 1), 0.35, "models/props_debris/concrete_column001a_chunk04.mdl"},
{Vector(5.8741912841797, -8.97705078125, 5.9844589233398), Angle(-1.5811536312103, 127.87686920166, -174.06256103516), Vector(1, 1, 1), 0.35, "models/props_debris/concrete_spawnchunk001e.mdl"},
{Vector(6.8630905151367, -12.6728515625, -0.92913818359375), Angle(20.477382659912, 36.138854980469, -91.943405151367), Vector(1.2000000476837, 1.2000000476837, 1), 0.35, "models/props_debris/concrete_column001a_chunk02.mdl"},
{Vector(2.9521331787109, 0.77349853515625, -5.0297584533691), Angle(7.3285250663757, 51.551551818848, 174.88356018066), Vector(1, 1, 1.2000000476837), 0.275, "models/props_debris/concrete_chunk06c.mdl"}
}

util.PrecacheModel("models/props_debris/concrete_column001a_chunk01.mdl")
util.PrecacheModel("models/props_debris/concrete_chunk08a.mdl")
util.PrecacheModel("models/props_debris/concrete_column001a_chunk04.mdl")
util.PrecacheModel("models/props_debris/concrete_spawnchunk001e.mdl")
util.PrecacheModel("models/props_debris/concrete_column001a_chunk02.mdl")
util.PrecacheModel("models/props_debris/concrete_chunk06c.mdl")

ENT.Ephemeral = true
ENT.Model = Model("models/gibs/HGIBS.mdl")

AccessorFuncDT(ENT, "Duration", "Float", 0)
AccessorFuncDT(ENT, "StartTime", "Float", 4)
AccessorFuncDT(ENT, "Magnitude", "Int", 1)

function ENT:PlayerSet()
	self:SetStartTime(CurTime())
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	--[[print("init")

	if SERVER then
		local enty = self
		self:CreateSVHook(enty)
	end	]]
end

function ENT:UpdateMagnitude(ply, mag, dur)
	local curmag = self:GetMagnitude()
	self:SetMagnitude(math.min(curmag + mag, 350))
	if IsValid(ply) and SERVER then
		self.Appliers[ply] = (self.Appliers[ply] or 0) + (self:GetMagnitude() - curmag)
		if self.Appliers[ply] <= 0 then self.Appliers[ply] = nil end
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)
end