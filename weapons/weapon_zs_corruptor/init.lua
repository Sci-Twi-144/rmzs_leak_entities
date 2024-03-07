--[[SECURE]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

local function DoFleshThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:ResetSpeed()

		local startpos = pl:GetPos()
		startpos.z = pl:GetShootPos().z
		local aimang = pl:EyeAngles()

		for i=1, 10 do
			local ang = Angle(aimang.p, aimang.y, aimang.r)
			ang:RotateAroundAxis(ang:Up(), math.Rand(-25, 25))
			ang:RotateAroundAxis(ang:Right(), math.Rand(-5, 5))
			local heading = ang:Forward()

			local ent = ents.Create("projectile_poisonflesh_c")
			if ent:IsValid() then
				ent:SetPos(startpos + heading * 8)
				ent:SetOwner(pl)
				ent.SpecialDamage = 8
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous(heading * math.Rand(340, 550) + pl:GetVelocity())
				end
			end
		end

		--pl:TakeSpecialDamage(50, DMG_CLUB, pl, self)
		
		pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.random(70, 80))

		pl:RawCapLegDamage(CurTime() + 2)
	end
end

local function DoSwing(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.random(70, 83))
		if wep.SwapAnims then wep:SendWeaponAnim(ACT_VM_HITCENTER) else wep:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		wep.IdleAnimation = CurTime() + wep:SequenceDuration()
		wep.SwapAnims = not wep.SwapAnims
	end
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() then return end

	local owner = self:GetOwner()
	owner:DoAnimationEvent(ACT_RANGE_ATTACK2)
	owner:EmitSound("NPC_PoisonZombie.Throw")
	--owner:SetSpeed(35)
	local div = (owner.PoisonBuffZombie and owner.PoisonBuffZombie.DieTime >= CurTime() and 0.5) or 1
	
	self:SetNextSecondaryFire(CurTime() + 4 * div)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	timer.Simple(0.6, function() DoSwing(owner, self) end)
	timer.Simple(1, function() DoFleshThrow(owner, self) end)
end
