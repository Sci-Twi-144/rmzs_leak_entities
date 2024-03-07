AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_power_scythe"))
SWEP.Description = (translate.Get("desc_power_scythe"))
SWEP.AbilityMax = 10

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.LastUpd = {}
	SWEP.TrailPositions = {}
	SWEP.VertsTable = {}
	SWEP.NextRandom = 0
	SWEP.PointsToDraw = {}
	SWEP.InstantBone = {}
	SWEP.PointMatrices = {}
	
	function SWEP:DrawAds()
		self:DrawGenericAbilityBar(self:GetResource() , self.AbilityMax, col, "Power Infusement", false)
	end
	
	local beam1mat = Material("trails/electric", "smooth")
	local matBeam = Material("trails/electric")
	local glowmat = Material("sprites/glow04_noz")
	
	function SWEP:DrawLightning(startpos, endpos, iteration, sizable, randomdivides)
		local pi = math.pi
		local dir = endpos - startpos
		local dirnorm = dir:GetNormalized()
		local life = 0.5
		
		local function Dir()
			local ang = dir:Angle()
			local forward = ang:Forward()
			ang:RotateAroundAxis(forward, math.random(360))
			return ang:Up()
		end
		
		if not self.PointMatrices[iteration] or self.PointMatrices[iteration][2] < CurTime() then
			local points = randomdivides and math.random(15,20) or 10
			self.PointMatrices[iteration] = {}
			self.PointMatrices[iteration][1] = {}
			for i = 1, points do
				table.insert(self.PointMatrices[iteration][1], i, Dir())
			end
			self.PointMatrices[iteration][2] = CurTime() + life
		end
		if self.PointMatrices[iteration] then
			render.SetMaterial(beam1mat)
			local ldelta = math.Clamp((self.PointMatrices[iteration][2] - CurTime())/life, 0, 1)
			local count = #self.PointMatrices[iteration][1]
			local tbl = self.PointMatrices[iteration][1]
			local between = dir:LengthSqr()^0.5 / (count - 1)
			render.StartBeam(count)
				for i=1, count do
					local sinmod = math.sin(i/count * pi)
					local heading = Vector(0,0,0) --VectorRand()
					heading:Normalize()
					local up = Vector(0,0,1) * 3
					render.AddBeam(startpos + dirnorm * between * (i - 1) + tbl[i] * 0.1 * (2 - ldelta) + heading * 0.2 * sinmod + up * sinmod * (1-ldelta), 2 * sinmod, 1, Color(190, 190, 255, 255 * ldelta))
				end
			render.EndBeam()
		end
	end
	
	function SWEP:DrawVertices(vm)
	
		local boneid = vm:LookupBone("ValveBiped.Bip01_Spine4")
		local matrix = vm:GetBoneMatrix(boneid)
		
		if not matrix then return end
				
		if #self.VertsTable < 1 then
			local shitone, shittwo = util.GetModelMeshes(self.ViewModel)
			for a, b in pairs(shitone) do
				for i = 1, #b["verticies"] do
					table.insert(self.VertsTable, 1, {b["verticies"][i].pos, b["verticies"][i].weights[1].bone})
				end
			end
			for c, d in pairs(shittwo) do
				table.insert(self.InstantBone, c, d.matrix)
			end
		end	
		
		local tablesize = #self.VertsTable
		if self.NextRandom <= CurTime() then
			self.NextRandom = CurTime() + 0.5
			self.PointsToDraw = {}
			for s = 1, 10 do
				local desired = math.random(tablesize)
				local vec = self.VertsTable[desired][1]
				table.insert(self.PointsToDraw, 1, {vec, self.VertsTable[desired][2]})
			end
		end
		
		local mypos = vm:GetPos()
		local clr = Color(110, 255, 195,255)
		local boneMatrices = {}
		for i = 0, vm:GetBoneCount() - 1 do
			boneMatrices[i] = vm:GetBoneMatrix(i)
		end
		
		for a = 1, #self.PointsToDraw/2 do
			--if (z % 2) == 0 then return end
			if a == #self.PointsToDraw then return end
			local z = (a == 1) and 1 or (a * 2 -1)
			local coord, bone = self.PointsToDraw[z][1], self.PointsToDraw[z][2]
			local boneMatrix = boneMatrices[bone]
			local newmatrix = boneMatrix * self.InstantBone[bone]
			local coord1, bone1 = self.PointsToDraw[z+1][1], self.PointsToDraw[z+1][2]
			local boneMatrix1 = boneMatrices[bone1]
			local newmatrix1 = boneMatrix1 * self.InstantBone[bone1]

			self:DrawLightning(newmatrix * coord, newmatrix1 * coord1, 10, false, true)		
		end
	end
	
	function SWEP:DrawConditions(vm)
		local fulltime = self.Primary.Delay * self:GetOwner():GetMeleeSpeedMul()
		
		GAMEMODE:DrawCircleEx(x, y, 17, self:IsHeavy() and COLOR_YELLOW or COLOR_DARKRED, self:GetNextPrimaryFire() , fulltime)

		local screenscale = BetterScreenScale()
		local wid, hei = 180 * screenscale, 64 * screenscale
		local w, h = ScrW(), ScrH()
		local x, y = w - wid - screenscale * 128, h - hei - screenscale * 72
		local ammo = math.min(math.max(0, self:GetOwner():GetAmmoCount(self.Primary.Ammo)), 999)

		local size = 42
		local ki = killicon.Get(GAMEMODE.AmmoIcons[self.Primary.Ammo])
		
		local kim = Material(tostring(ki[1]))
		surface.SetMaterial(kim)
		surface.SetDrawColor(ki[2])
		surface.DrawTexturedRect(x + wid * 0.3, y + hei * 0.75, size, size)

		draw.SimpleTextBlurry(ammo, "ZSHUDFont", x + wid * 0.8, y + hei * 1.1, ammo > 3 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self:GetNextAbilityUse() >= CurTime() then
			local times = math.sin((self:GetNextAbilityUse() - CurTime())* math.pi)
			local colored = Color(255 * times, 40, 30, 255)
			draw.SimpleTextBlurry("OVERHEATED", "ZSHUDFont", x - wid * 0.35, y + hei * 0.7, colored, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end	
	end
	
	function SWEP:DrawParticles(vm)
		local boneMatrices = {}
		
		for i = 0, vm:GetBoneCount() - 1 do
			boneMatrices[i] = vm:GetBoneMatrix(i)
		end
					
		local rnd = #self.VertsTable
		local desired = math.random(rnd)
		
		local coord, bone = self.VertsTable[desired][1], self.VertsTable[desired][2]
		local boneMatrix = boneMatrices[bone]
		local newmatrix = boneMatrix * self.InstantBone[bone]
		
		local pos = newmatrix * coord
		local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(24, 32)

			for i=1, math.random(2, 5) do
				local heading = VectorRand()
				heading:Normalize()

				local particle = emitter:Add("sprites/orangeflare1_gmod", pos + heading * 3)
				particle:SetVelocity(50 * heading * math.random())
				particle:SetDieTime(math.Rand(0.5, 1))
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(255)
				particle:SetStartSize(math.Rand(2, 3))
				particle:SetEndSize(0)
				particle:SetStartLength(1)
				particle:SetEndLength(10)
				particle:SetColor(50, 50, 255)
				particle:SetGravity(Vector(0,0,200))
				particle:SetAirResistance(250)
			end
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	
	local refractmat = Material("trails/tube")
	function SWEP:DrawTrail(vm)
		local function GetPosition(cor)
			local bone = vm:LookupBone("tag_weapon")
			local bpos, bang = vm:GetBonePosition(bone)
			local vectorshiet = bang:Up()
			local truepos =  cor == "base" and bpos or vectorshiet
			return truepos
		end
		
		local checktable = #self.TrailPositions < 1 or self.TrailPositions[1][2]:DistToSqr(GetPosition("base")) > 5^2
	
		if self:GetNextPrimaryFire() >= CurTime() then
			table.insert(self.TrailPositions, 1, {GetPosition("base"), GetPosition("vector"), CurTime()})
		end
		local points = 15
		if self.TrailPositions[points] then
			table.remove(self.TrailPositions, points)
		end
			if #self.TrailPositions > 1 then
				for k,v in pairs(self.TrailPositions) do 
					if k > 1 then
						points = #self.TrailPositions
						render.SetMaterial(refractmat)
						local color = Color(150,150,255, 255)

						local ad = 30 * k/points
						local ak = 30 * (k-1)/points

						local times = (CurTime() - v[3]) * 40

						local low, high = 10 + times, 42 + times
						local nem, nom = high, high
						local corner1, corner2, corner3, corner4 = v[1]+v[2]*(low + ad), v[1]+v[2]*(nom), self.TrailPositions[k-1][1] + self.TrailPositions[k-1][2]*(nem), self.TrailPositions[k-1][1]+self.TrailPositions[k-1][2]*(low + ak)
						render.DrawQuad(corner1, corner2, corner3, corner4, color)
						
						if self:GetTumbler() then
							render.SetColorMaterial()
							local opacity = 1 - k/points
							local colore = Color(110, 255, 195, 255 * opacity)
							colore.g = k/points * 255
							low = 10 + times
							high = 42 + times
							
							local mem, mom = high, high 
							local corne1, corne2, corne3, corne4 = v[1]+v[2]*(low + ad), self.TrailPositions[k-1][1]+self.TrailPositions[k-1][2]*(low + ak), self.TrailPositions[k-1][1] + self.TrailPositions[k-1][2]*(mem), v[1]+v[2]*(mom)
							render.DrawQuad(corne1, corne2, corne3, corne4, colore)
						end
			
					end
				end
			end
		--end
	end
	
	SWEP.VMAng = Angle(0, 0, 0)
	SWEP.VMPos = Vector(0, 0, 0)
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/rmzs/scythe/c_grotesque.mdl"
SWEP.WorldModel = "models/weapons/rmzs/scythe/w_grotesque.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.SPMultiplier = 4

SWEP.MeleeDamage = 175
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 80
SWEP.MeleeSize = 3.5
SWEP.MeleeKnockBack = 170

SWEP.Primary.Delay = 1.5
SWEP.Primary.Ammo = "pulse"

SWEP.SwingTime = 0.3
SWEP.SwingRotation = Angle(0, -15, -15)
SWEP.SwingHoldType = "melee2"

SWEP.SwingTimeSP = 2.6

SWEP.BlockRotation = Angle(0, 0, 15)
SWEP.BlockOffset = Vector(-5, 0, -2)

SWEP.CanBlocking = true
SWEP.BlockReduction = 22
SWEP.BlockStability = 0.25
SWEP.StaminaConsumption = 18

SWEP.HitAnim = false
SWEP.MissAnim = false
SWEP.AltBashAnim = ACT_VM_HITCENTER
SWEP.NoHitSoundFlesh = true

SWEP.MaxStock = 2
SWEP.Tier = 6

SWEP.HasAbility = true
SWEP.ResourceMul = 0.75
SWEP.SpecificCond = true

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.AllowQualityWeapons = true

local E_meta = FindMetaTable("Entity")
local E_GetTable = E_meta.GetTable
local metal, field = Material("models/weapons/rmzs/scythe/scythe_metal"), Material("models/weapons/rmzs/scythe/scythe_field")

if CLIENT then
	function SWEP:PostDrawViewModel(vm)
		self.BaseClass.PostDrawViewModel(self, vm)
		local vmmat = vm:GetMaterials()
		if self:GetOwner():KeyPressed(IN_SPEED) then
			for bone = 0, vm:GetBoneCount() do
				print(vm:GetBoneName(bone))
			end
		end
		
		if self:GetNextPrimaryFire() >= CurTime() then
			self:DrawTrail(vm)
		end
		
		if self:GetTumbler() then
			self:DrawVertices(vm)
			self:DrawParticles(vm)
			metal:SetFloat("$emissiveblendenabled", 1)
			field:SetFloat("$emissiveblendenabled", 1)
		else
			metal:SetFloat("$emissiveblendenabled", 0)
			field:SetFloat("$emissiveblendenabled", 0)
		end
	end
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	self.ChargeSound = CreateSound(self, "ambient/machines/electric_machine.wav")
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
	local deploysound = self:GetTumbler() and "weapons/rmzs/scythe/scythe_deploy_energy.mp3" or "weapons/rmzs/scythe/scythe_deploy_1.wav"
	self:EmitSound(deploysound, 75, math.random(100, 120), 0.7, CHAN_WEAPON + 20)
	if self:GetTumbler() then
		self.ChargeSound:PlayEx(1, 100)
	end
	return true
end

function SWEP:Holster()
	if self:GetTumbler() then
		self.ChargeSound:Stop()
	end
	self.BaseClass.Holster(self)
	return true
end

function SWEP:GetTracesNumPlayers(traces)
	local numplayers = 0

	local ent
	for _, trace in pairs(traces) do
		ent = trace.Entity
		if ent and ent:IsValidPlayer() then
			numplayers = numplayers + 1
		end
	end

	return numplayers
end

function SWEP:GetDamage(numplayers, basedamage)
	basedamage = basedamage or self.MeleeDamage
	local ispowered = self:GetTumbler()
	local lowcap = ispowered and 0.6 or 0.4

	if numplayers then
		return basedamage * math.Clamp(1.25 - numplayers * 0.25, lowcap, 1)
	end

	return basedamage
end

function SWEP:StartSwinging()
	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)
	local stbl = E_GetTable(self)
	local heavy = self:IsHeavy()
	local animtbl = {
	ACT_VM_PRIMARYATTACK,
	ACT_VM_PRIMARYATTACK_2
	}

	if self:GetTumbler() then
		self:SendWeaponAnim(heavy and ACT_VM_HITLEFT or ACT_VM_PRIMARYATTACK)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	else
		self:SendWeaponAnim(heavy and ACT_VM_HITLEFT or ACT_VM_PRIMARYATTACK_2)
		stbl.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	self:GetOwner():GetViewModel():SetPlaybackRate(1.05)
	self:PlayStartSwingSound()

	local time = heavy and stbl.SwingTime * 1.5 or stbl.SwingTime
	local armdelay = owner:GetMeleeSpeedMul()
	--local clamped = math.min(math.max(0, (otbl.MeleeSwingDelayMul or 1) * armdelay), 1.5) -- we dont want over 2x attack penalty, right?
	local condition = not self:GetTumbler() and clamped or 1
	self:SetSwingEnd(CurTime() + time)

	--[[if not self:GetTumbler() then
		self:GetOwner():GetViewModel():SetPlaybackRate(1 - ((clamped) - 1))
	end]]
end

function SWEP:MeleeSwing()
	local owner = self:GetOwner()

	if SERVER then
		owner:TakeStamina(self.StaminaConsumption, 2.5)
	end

	owner:DoAttackEvent()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local hit = false
	local tr = owner:CompensatedPenetratingMeleeTrace(self.MeleeRange * (owner.MeleeRangeMul or 1), self.MeleeSize)
	local ent

	local damagemultiplier = (owner:Team() == TEAM_HUMAN and (owner.MeleeDamageMultiplier or 1)) or 1
	damagemultiplier = owner:GetStatus("laststand") and 1.33 or 1

	if self:IsHeavy() then
		damagemultiplier = damagemultiplier * 1.45
		if owner:GetInfo("zs_noheavyviewpunch") == "0" and IsFirstTimePredicted() then
			local r = math.Rand(0.8, 1) * 3
			owner:ViewPunch(Angle(-1 * r, 0, r * (math.random(2) == 1 and -1 or 1)))
		end

		self:OnHeavy()
    end
	local overheat = self:GetNextAbilityUse() > CurTime() and 0.7 or 1
    damagemultiplier = self:BeforeSwing(damagemultiplier)
    local damage = self:GetDamage(self:GetTracesNumPlayers(tr), 1)
	damagemultiplier = damagemultiplier * damage * overheat
	if not self:IsHeavy() then
		for _, trace in ipairs(tr) do
			if not trace.Hit then continue end

			ent = trace.Entity

			hit = true

			local hitflesh = trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH

			if hitflesh then
				util.Decal(self.BloodDecal, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)

				if SERVER then
					self:ServerHitFleshEffects(ent, trace, damagemultiplier)
				end

			end

			if ent and ent:IsValid() then
				if SERVER then
					self:ServerMeleeHitEntity(trace, ent, damagemultiplier)
				end

				self:MeleeHitEntity(trace, ent, damagemultiplier, damage)

				if SERVER then
					self:ServerMeleePostHitEntity(trace, ent, damagemultiplier)
				end

				if owner.GlassWeaponShouldBreak then break end
			end
		end
	else
		local pos = owner:GetShootPos()
		local start, dir = owner:GetShootPos(), owner:GetAimVector():GetNormalized()
		local dist = (self.MeleeRange + (owner.MeleeRangeAds or 0)) * (owner.MeleeRangeMul or 1)
		local dumbs = ents.FindInCone( start, dir, dist, math.cos(math.rad(45)))
		local dmgtpr = 1
		local dmgaffect = self:GetTumbler() and 0.06 or (self:GetNextAbilityUse() > CurTime()) and 0.1 or 0.08
		local distancetoobs = self:CheckObstacles(owner, pos, dist)
		for num, entic in pairs(dumbs) do
			if entic:IsValidLivingZombie() and WorldVisible(pos, entic:NearestPoint(pos)) and pos:DistToSqr(entic:GetShootPos()) <= distancetoobs then
				local bossmul = (entic:GetBossTier() >= 2) and 0.03 or (entic:GetBossTier() >= 1) and 0.7 or 0.25 
				local addictional = self:GetTumbler() and (entic:GetMaxHealthEx() * bossmul or 0) or 0
				entic:TakeSpecialDamage((self.MeleeDamage + addictional) * damagemultiplier * dmgtpr, DMG_SLASH, self:GetOwner(), self, nil)
				self:PlayHitFleshSound()
				dmgtpr = math.max(dmgtpr - dmgaffect, 0.05)
			end
		end
	end

	if hit then
		self:PlayHitSound()
	else
		self:PlaySwingSound()

		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end
end

function SWEP:CanReload()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end
	return self:GetNextPrimaryFire() <= CurTime() and not self:IsSwinging() and not self:IsWinding()
end

function SWEP:Reload()
	if not self:CanReload() then return end
	self:ProcessSpecialAttack()
end

function SWEP:CheckObstacles(owner, shootpos, distance)
	local obstacles = {
		["prop_physics"] = true,
		["worldspawn"] = true
	}
	local tracec = {mask = MASK_SHOT}

	tracec.start = shootpos
	tracec.endpos = shootpos + owner:GetAimVector() * distance
	tracec.filter = function (ent) return obstacles[ent:GetClass()] end
	local tr = util.TraceLine(tracec)
	if tr.Entity and tr.Entity:IsValid() then
		return tr.HitPos:DistToSqr(shootpos) 
	else
		return distance^2
	end
end

function SWEP:ProcessSpecialAttack()
	local owner = self:GetOwner()
	if owner:GetAmmoCount(self.Primary.Ammo) >= 100 and not self:GetTumbler() and self:GetNextAbilityUse() <= CurTime() then
		self:TakePrimaryAmmo(100)
		self:SetTumbler(true)
		self:SetResource(10)
		self:SetBuffDur(10)
		self.ChargeSound:PlayEx(1, 100)
	end
end

function SWEP:MeleeHitEntity(tr, hitent, damagemultiplier)
	local stbl = E_GetTable(self)

	if not IsFirstTimePredicted() then return end

	if stbl.MeleeFlagged then stbl.IsMelee = true end

	local owner = self:GetOwner()
	local otbl = E_GetTable(owner)

	if SERVER and hitent:IsPlayer() and not stbl.NoGlassWeapons and owner:IsSkillActive(SKILL_GLASSWEAPONS) then
		damagemultiplier = damagemultiplier * 3.5
		otbl.GlassWeaponShouldBreak = not otbl.GlassWeaponShouldBreak
	end
	local bossmul = hitent:IsValidLivingZombie() and ((hitent:GetBossTier() >= 2) and 0.05 or (hitent:GetBossTier() >= 1) and 0.10 or 0.25) or 0 
	local addictional = hitent:IsValidLivingZombie() and (self:GetTumbler() and (hitent:GetMaxHealthEx() * bossmul) or 0) or 0

	local damage = (stbl.MeleeDamage + (otbl.MeleeDamageAds or 0) + addictional) * damagemultiplier

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetAttacker(owner)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(stbl.DamageType)
	if hitent:IsPhysicsProp() and not owner:IsValidLivingZombie() then
		dmginfo:SetDamage(0)
	else
		local headshot = (SERVER and (tr.HitGroup == HITGROUP_HEAD) and not stbl.ZombieOnly) and 1.6 or 1
		dmginfo:SetDamage(damage * headshot)
	end
	dmginfo:SetDamageForce(math.min(stbl.MeleeDamage, 50) * 50 * owner:GetAimVector())

	local vel
	if hitent:IsPlayer() then
		self:PlayerHitUtil(owner, damage, hitent, dmginfo)

		if SERVER then
			hitent:SetLastHitGroup(tr.HitGroup)
			if tr.HitGroup == HITGROUP_HEAD then
				hitent:SetWasHitInHead()
			--	dmginfo:SetDamage(damage * 1.6) -- that was stupid, but anyway its still not best solution
			end

			if hitent:WouldDieFrom(damage, tr.HitPos) then
				dmginfo:SetDamageForce(math.min(stbl.MeleeDamage, 50) * 400 * owner:GetAimVector())
			end
		end

		vel = hitent:GetVelocity()
	else
		if otbl.MeleePowerAttackMul and otbl.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end
	end

	self:PostHitUtil(owner, hitent, dmginfo, tr, vel)
end

function SWEP:Think()
	self.BaseClass.Think(self)
	
	if self:GetTumbler() then
		self:SetResource(self:GetBuffDur() - CurTime())
		if self:GetResource() <= 0 then
			self:SetResource(0)
			self:SetTumbler(false)
			self.ChargeSound:Stop()
			self:SetNextAbilityUse(10)
		end
	end
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/rmzs/scythe/scythe_miss"..math.random(2)..".mp3", 75, math.random(100, 125))
end

function SWEP:PlayHitSound()
	--self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(86, 90))
	self:EmitSound("weapons/rmzs/scythe/scythe_impact_world"..math.random(2)..".mp3", 75, math.random(100, 120), 0.7, CHAN_WEAPON + 20)
end

function SWEP:PlayHitFleshSound()
	--self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90))
	self:EmitSound("weapons/rmzs/scythe/scythe_hit_flesh"..math.random(3)..".mp3", 75, math.random(100, 120), 0.7, CHAN_WEAPON + 20)
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and hitent:IsHeadcrab() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
	end
end

function SWEP:SetBuffDur(timer)
	self:SetDTFloat(21, CurTime() + timer)
end

function SWEP:GetBuffDur()
	return self:GetDTFloat(21)
end

function SWEP:SetNextAbilityUse(s)
	self:SetDTFloat(22, CurTime() + s)
end

function SWEP:GetNextAbilityUse()
	return self:GetDTFloat(22)
end