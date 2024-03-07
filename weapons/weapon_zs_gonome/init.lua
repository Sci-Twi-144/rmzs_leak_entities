--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.PoisonPattern = {
	{-1, 0},
	{-0.66, 0},
	{-0.33, 0},
	{0, 0},
	{0, 1},
	{0, -1},
	{0.33, 0},
	{0.66, 0},
	{1, 0}
}

function SWEP:DoThrow()
	local owner = self:GetOwner()
	local startpos = owner:GetShootPos()
	local aimang = owner:EyeAngles()
	local ang

	for k, spr in pairs(self.PoisonPattern) do
		if k == "BaseClass" then continue end

		ang = Angle(aimang.p, aimang.y, aimang.r)
		ang:RotateAroundAxis(ang:Up(), spr[1] * 12.5)
		ang:RotateAroundAxis(ang:Right(), spr[2] * 5)
		local heading = ang:Forward()

		local ent = ents.Create("projectile_poisonflesh")
		if ent:IsValid() then
			ent:SetPos(startpos + heading * 8)
			ent:SetOwner(owner)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocityInstantaneous(heading * self.PoisonThrowSpeed)
			end
		end
	end
end

function SWEP:PoundAttackProcess()
	local owner = self:GetOwner()
	local pos = owner:GetPos() + Vector(0, 0, 2)

	owner:LagCompensation(true)

	owner:EmitSound("^npc/Zassassin/beast_walk_foot"..math.random(2,3)..".wav", 97, 103)

	util.ScreenShake(pos, 5, 5, 1, 300)

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(Vector(0, 0, 1))
	util.Effect("ThumperDust", effectdata, true, true)

	owner:GodEnable()
	util.BlastDamageEx(self, owner, pos, 112, 7, DMG_CLUB)
	util.BlastDamageEx(self, owner, pos, 22, 14, DMG_CLUB)
	owner:GodDisable()

	owner:LagCompensation(false)
end
