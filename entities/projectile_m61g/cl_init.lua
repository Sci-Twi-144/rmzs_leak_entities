include("shared.lua")

ENT.NextTickSound = 0
ENT.LastTickSound = 0

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeTime
end

function ENT:Think()
	local curtime = CurTime()

	if curtime >= self.NextTickSound then
		local delta = self.DieTime - curtime

		self.NextTickSound = curtime + math.max(0.15, delta * 0.25)
		self.LastTickSound = curtime
		self:EmitSound("npc/roller/mine/rmine_blip1.wav", 75, math.Clamp((1 - delta / self.LifeTime) * 220, 150, 220))
	end
end

function ENT:DrawTranslucent()
	self:DrawModel()
end
