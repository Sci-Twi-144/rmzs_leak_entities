include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self.DieTime = CurTime() + 0.06
	
	--[[local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(attacker:GetShootPos())
	util.Effect("hit_ice", effectdata)]]
end
