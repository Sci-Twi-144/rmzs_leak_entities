AddCSLuaFile()

SWEP.Base = "weapon_zs_shade"

SWEP.PrintName = "Frost Shade"

SWEP.ShadeControl = "env_frostshadecontrol"
SWEP.ShadeProjectile = "projectile_shadeice"

function SWEP:Reload()
	if not self:CanGrab() then return end

	local owner = self:GetOwner()

	local vStart = owner:GetShootPos()
	local vEnd = vStart + owner:GetForward() * 40

	local tr = util.TraceHull({start = vStart, endpos = vEnd, filter = owner, mins = owner:OBBMins() / 2, maxs = owner:OBBMaxs() / 2})
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1.3)

	if SERVER then
		local rock = ents.Create(self.ShadeProjectile)
		if rock:IsValid() then
			local pos = owner:GetPos() - owner:GetForward() * 15
			if not tr.Hit then
				pos = pos + owner:GetForward() * 30
			end

			rock:SetPos(pos)
			rock:SetOwner(owner)
			rock:Spawn()
			local con = ents.Create(self.ShadeControl)
			if con:IsValid() then
				con:Spawn()
				con:SetOwner(owner)
				con:AttachTo(rock)
				rock.Control = con

				util.ScreenShake(owner:GetPos(), 3, 1, 0.75, 400)

				con:EmitSound("physics/concrete/concrete_break3.wav", 85, 60)
				rock:EmitSound(")weapons/physcannon/physcannon_claws_close.wav")

				owner.LastRangedAttack = CurTime()
			end
		end
	end
end
