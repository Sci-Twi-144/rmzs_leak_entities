--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Reload()
	--self.BaseClass.SecondaryAttack(self)
end

local function DoFleshThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		--pl:ResetSpeed()
		pl.LastRangedAttack = CurTime()

		local startpos = pl:GetPos()
		startpos.z = pl:GetShootPos().z
		local heading = pl:GetAimVector()

		local ent = ents.Create("projectile_bonemesh")
		if ent:IsValid() then
			ent:SetPos(startpos + heading * 8)
			ent:SetAngles(AngleRand())
			ent:SetOwner(pl)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocityInstantaneous(heading * 600)
				phys:AddAngleVelocity(VectorRand() * 45)
			end
		end

		pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.random(70, 80))

		--pl:RawCapLegDamage(CurTime() + 2)
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

	self:SetSwingAnimTime(CurTime() + 1)
	self:GetOwner():DoAnimationEvent(ACT_RANGE_ATTACK2) -- why?
	self:GetOwner():EmitSound("NPC_PoisonZombie.Throw")
	--self:GetOwner():SetSpeed(1)
	self:SetNextSecondaryFire(CurTime() + 1.1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	timer.Simple(0.6, function() DoSwing(owner, self) end)
	timer.Simple(0.75, function() DoFleshThrow(owner, self) end)
end


--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.NextMessage = 0

function SWEP:SendMessage(msg, friendly)
	if CurTime() >= self.NextMessage then
		self.NextMessage = CurTime() + 2
		self:GetOwner():CenterNotify(friendly and COLOR_GREEN or COLOR_RED, translate.ClientGet(self:GetOwner(), msg))
	end
end

function SWEP:BuildingThink()
	local owner = self:GetOwner()
	local allzombies = table.Copy(team.GetPlayers(TEAM_UNDEAD))
	local pos = owner:WorldSpaceCenter()
	local ang = owner:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	local forward = ang:Forward()
	local right = ang:Right()
	local endpos = pos + forward * 32

	local tr = util.TraceLine({start = pos, endpos = endpos, filter = allzombies, mask = MASK_PLAYERSOLID})
	local trent = tr.Entity

	if trent and trent:IsValid() and trent.ZombieConstruction then
		self:BuildNest(trent)

		return
	end

	if owner.NestBanned then return end

	if owner.NextNestSpawn and CurTime() < owner.NextNestSpawn then
		if CurTime() >= self.NextMessage then
			self.NextMessage = CurTime() + 2
			owner:CenterNotify(COLOR_RED, translate.ClientFormat(owner, "wait_x_seconds_before_making_a_new_nest", math.ceil(owner.NextNestSpawn - CurTime())))
		end

		return
	end

	local uid = owner:UniqueID()
	local count = 0
	local personal_count = 0
	for _, ent in pairs(ents.FindByClass("prop_creepernest")) do
		if ent.OwnerUID == uid then
			personal_count = personal_count + 1
		end
		count = count + 1
	end

	if count >= 12 then
		if CurTime() >= self.NextMessage then
			self.NextMessage = CurTime() + 2
			owner:CenterNotify(COLOR_RED, translate.ClientGet(owner, "there_are_too_many_nests"))
		end

		return
	end

	if personal_count >= 3 then
		if CurTime() >= self.NextMessage then
			self.NextMessage = CurTime() + 2
			owner:CenterNotify(COLOR_RED, translate.ClientGet(owner, "you_have_made_too_many_nests"))
		end

		return
	end

	tr = util.TraceLine({start = endpos, endpos = endpos + Vector(0, 0, -48), filter = allzombies, mask = MASK_PLAYERSOLID})
	local hitnormal = tr.HitNormal
	local z = hitnormal.z
	if not tr.HitWorld or tr.HitSky or z < 0.75 then
		self:SendMessage("not_enough_room_for_a_nest")
		return
	end
	

	local hitpos = tr.HitPos

	for x = -20, 20, 20 do
		for y = -20, 20, 20 do
			local start = endpos + x * right + y * forward
			tr = util.TraceLine({start = start, endpos = start + Vector(0, 0, -48), filter = allzombies, mask = MASK_PLAYERSOLID})
			if not tr.HitWorld or tr.HitSky or math.abs(tr.HitNormal.z - z) >= 0.2 then
				self:SendMessage("not_enough_room_for_a_nest")
				return
			end
		end
	end

	local spawnpositions = {
		Vector(17, 17, 0),
		Vector(-17, -17, 0),
		Vector(17, 17, 64),
		Vector(-17, -17, 64)
	}
	for _, spos in pairs(spawnpositions) do
		if bit.band(util.PointContents(hitpos + spos), CONTENTS_SOLID) == CONTENTS_SOLID then
			self:SendMessage("not_enough_room_for_a_nest")
			return
		end
	end

	--[[

	for _, ent in pairs(team.GetValidSpawnPoint(TEAM_UNDEAD)) do
		if ent.Disabled then continue end

		if util.SkewedDistance(ent:GetPos(), hitpos, 1.5) < GAMEMODE.CreeperNestDistBuildZSpawn then
			self:SendMessage("too_close_to_a_spawn")
			return
		end
	end

	--]]
	

	-- See if there's a nest nearby.
	for _, ent in pairs(ents.FindByClass("prop_creepernest")) do
		if util.SkewedDistance(ent:GetPos(), hitpos, 1.35) <= GAMEMODE.CreeperNestDistBuildNest then
			self:SendMessage("too_close_to_another_nest")
			return
		end
	end

	for _, sigil in pairs(ents.FindByClass("prop_obj_sigil")) do
		if sigil:GetSigilCorrupted() then continue end

		if util.SkewedDistance(sigil:GetPos(), hitpos, 1.35 * (GAMEMODE.CreeperNestVerticalSkewMultiplier or 1)) <= (GAMEMODE.CreeperNestDistBuildNest * (GAMEMODE.CreeperNestDistBuildMultiplier or 1)) then
			self:SendMessage("too_close_to_uncorrupt")
			return
		end
	end

	for _, human in pairs(team.GetPlayers(TEAM_HUMAN)) do
		if util.SkewedDistance(human:GetPos(), hitpos, 1.35 * (GAMEMODE.CreeperNestVerticalSkewMultiplier or 1)) <= (GAMEMODE.CreeperNestDistBuild * (GAMEMODE.CreeperNestDistBuildMultiplier or 1)) then
			self:SendMessage("too_close_to_a_human")
			return
		end
	end

	-- I didn't make this check where trigger_hurt entities are. Rather I made it check the time since the last time you were hit with a trigger_hurt.
	-- I'm not sure if it's possible to check if a trigger_hurt is enabled or disabled through the Lua bindings.
	if owner.LastHitWithTriggerHurt and CurTime() < owner.LastHitWithTriggerHurt + 2 then
		return
	end

	local ent = ents.Create("prop_creepernest")
	if ent:IsValid() then
		nestang = hitnormal:Angle()
		nestang:RotateAroundAxis(nestang:Right(), 270)

		ent:SetPos(hitpos)
		ent:SetAngles(nestang)
		ent:Spawn()

		ent.OwnerUID = uid

		ent:SetNestHealth(1)
		ent:SetNestBuilt(false)

		self:SendMessage("nest_created")

		ent:SetNestOwner(owner)

		owner.NextNestSpawn = CurTime() + 10
	end
end

function SWEP:BuildNest(ent)
	ent:BuildUp()

	ent.LastBuild = CurTime()
	ent.LastBuilder = self:GetOwner()

	if not ent:GetNestBuilt() and ent:GetNestHealth() == ent:GetNestMaxHealth() then
		ent:SetNestBuilt(true)
		ent:EmitSound("physics/flesh/flesh_bloody_break.wav")

		local name = self:GetOwner():Name()
		for _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
			pl:CenterNotify(COLOR_GREEN, translate.ClientFormat(pl, "nest_built_by_x", name))
		end

		net.Start("zs_nestbuilt")
		net.Broadcast()
	end
end
