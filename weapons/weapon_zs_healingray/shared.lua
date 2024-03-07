SWEP.PrintName = (translate.Get("wep_healingray"))
SWEP.Description = (translate.Get("desc_healingray"))

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "physgun"

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true

SWEP.AbilityText = "Speedest Healing"
SWEP.AbilityColor = Color(65, 250, 125)
SWEP.AbilityMax = 100

SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "scrap"

SWEP.ConeMax = 0
SWEP.ConeMin = 0

SWEP.Tier = 4
SWEP.MaxStock = 2

SWEP.HasAbility = true
SWEP.SpecificCond = true

SWEP.HealRange = 300
SWEP.Heal = 2.5

SWEP.AllowQualityWeapons = true
SWEP.IsMedicalDevice = true

SWEP.WalkSpeed = SPEED_SLOWER
SWEP.FireAnimSpeed = 0.24

SWEP.HealENTsave = nil
SWEP.HealMULsave = 1
SWEP.HealTIMEsave = 0

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_HEALRANGE, 200, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_HEALING, 0.5)

local math_min = math.min
local math_Round = math.Round
local table_sort = table.sort
local util_Effect = util.Effect
local translate_Get = translate.Get
local util_TraceLine = util.TraceLine
local WorldVisibleTrace = {mask = MASK_SOLID_BRUSHONLY}
local function WorldVisible(posa, posb) -- it's NULL dunno why.
	WorldVisibleTrace.start = posa
	WorldVisibleTrace.endpos = posb
	return not util_TraceLine(WorldVisibleTrace).Hit
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self.ChargeSound = CreateSound(self, "items/medcharge4.wav")
	self.UberSound = CreateSound(self, "hl1/ambience/alien_minddrill.wav")
	self.UberAmbient = CreateSound(self, "ambient/atmosphere/city_beacon_loop1.wav")
end

function SWEP:Holster()
	self.ChargeSound:Stop()
	self.UberSound:Stop()
	self.UberAmbient:Stop()
	self.HealMULsave = 1
	return self.BaseClass.Holster(self)
end

function SWEP:PrimaryAttack(secattack)
	if not self:CanPrimaryAttack() then return end

	local owner = self:GetOwner()
	local vPos = owner:GetPos()

	local trtbl = owner:CompensatedPenetratingMeleeTrace(self.HealRange, 2, nil, nil, true)
	local ent
	for _, tr in pairs(trtbl) do
		local test = tr.Entity
		--local lastdamaged = SERVER and rawget(PLAYER_LastHitTime, test) < CurTime()
		local regen = test:IsValidLivingHuman() and test:GetStatus("regeneration") and test:GetStatus("regeneration"):IsValid() and test:GetStatus("regeneration"):GetHeal() or 0

		if test and test:IsValidLivingHuman() and WorldVisible(vPos, test:NearestPoint(vPos)) and regen < 50 and gamemode.Call("PlayerCanBeHealed", test) and (SERVER and rawget(PLAYER_LastHitTime, test) < CurTime()) then
			ent = test

			break
		end
	end

	if not ent or self:GetDTEntity(10):IsValid() then return end

	if secattack then self:SetUber(true) end
	self:SetDTEntity(10, ent)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:EmitSound("items/medshot4.wav", 75, 80)
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	if (self:GetResource() <= 15) then return end
	self:PrimaryAttack(true)
	--[[
	local owner = self:GetOwner()
	local Position = owner:GetPos()
	local Radius = self.HealRange
	local UseSound = false
	local BreakNum = 0
	local TeamPlayers = table.Copy(team.GetPlayers(TEAM_HUMAN))

	-- Sort them by distance.
	table_sort(TeamPlayers, function(a, b)
		return owner:WorldSpaceCenter():DistToSqr(a:WorldSpaceCenter()) < owner:WorldSpaceCenter():DistToSqr(b:WorldSpaceCenter())
	end)

	for _, test in pairs(TeamPlayers) do
		if owner ~= test then
			local nearest = test:NearestPoint(Position)
			if test:IsValidLivingPlayer() and WorldVisible(Position, nearest) and gamemode.Call("PlayerCanBeHealed", test) then
				if owner:WorldSpaceCenter():DistToSqr(test:WorldSpaceCenter()) < (Radius ^ 2) then
						BreakNum = BreakNum + 1
						owner:HealPlayer(test, math_Round(self.Heal / BreakNum, 2), 0.05)

						self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

						UseSound = true
							
						-- Rare errors.
						if test and test:IsValid() and test:WorldSpaceCenter() then
							local effectdata = EffectData()
								effectdata:SetOrigin(test:WorldSpaceCenter())
								effectdata:SetFlags(3)
								effectdata:SetEntity(self)
								effectdata:SetAttachment(1)
							util_Effect("tracer_healray", effectdata)
						end

						if BreakNum > 4 then
							break
						end
				end
			elseif test:IsValid() then
				self:StopHealingAlt()
			end
		end
	end
	
	self:SetNextPrimaryFire(CurTime() + 2)

	if UseSound then
		self:EmitSound("items/medshot4.wav", 75, 80)
	end
end

function SWEP:StopHealingAlt()
	self:SetNextPrimaryFire(CurTime() + 15)
	self:EmitSound("items/medshotno1.wav", 75, 60)
	self.ChargeSound:Stop()]]
end

function SWEP:CanSecondaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetDTEntity(10):IsValid() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() or self:GetDTEntity(10):IsValid() then return false end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:Reload()
end

function SWEP:Think()
	self.BaseClass.Think(self)
	self:CheckHealRay()
end

function SWEP:StopHealing(id)
	self:SetDTEntity(id, NULL)
	self:SetNextPrimaryFire(CurTime() + 0.75)
	if self:GetUber() then
		self:EmitSound("ambient/machines/steam_release_2.wav", 75, 200)
	else
		self:EmitSound("items/medshotno1.wav", 75, 60)
	end
	self.ChargeSound:Stop()
	self.UberSound:Stop()
	self.HealENTsave = nil
	self.HealMULsave = 1
	self:SetUber(false)
end

function SWEP:TakeAmmo()
end

function SWEP:CheckHealRay()
	local ent = self:GetDTEntity(10)
	local owner = self:GetOwner()
	local vPos = owner:GetPos()
	local regen = ent:IsValidLivingHuman() and ent:GetStatus("regeneration") and ent:GetStatus("regeneration"):IsValid() and ent:GetStatus("regeneration"):GetHeal() or 0
	if self:GetFullUber() and not owner:KeyDown(self:GetUber() and IN_ATTACK2 or IN_ATTACK) then
		self.UberAmbient:PlayEx(1, 50)
	else
		self.UberAmbient:Stop()
	end
	if ent:IsValidLivingHuman() and WorldVisible(vPos, ent:NearestPoint(vPos)) and regen < 50 and gamemode.Call("PlayerCanBeHealed", ent) and (owner:KeyDown(self:GetUber() and IN_ATTACK2 or IN_ATTACK)) and
		ent:WorldSpaceCenter():DistToSqr(owner:WorldSpaceCenter()) <= self.HealRange * self.HealRange then

		if CurTime() > self.HealTIMEsave then
			self.HealTIMEsave = CurTime() + 0.25
			if self.HealENTsave == self:GetDTEntity(10) then
				if self:GetUber() then
					self:SetResource(math.max(self:GetResource() - 6, 0))
					if self:GetResource() < 7 then 
						self:SetUber(false)
						self:EmitSound("ambient/machines/steam_release_2.wav", 75, 200)
					end
				else
					self.HealMULsave = math.min(self.HealMULsave + 0.1, 3)
					self:SetResource(math.min(self:GetResource() + 1 * self.HealMULsave, self.AbilityMax))
				end

				if self:GetResource() >= self.AbilityMax then
					self:SetFullUber(true)
				else
					self:SetFullUber(false)
				end
			else
				self.HealENTsave = self:GetDTEntity(10)
				self.HealMULsave = 1
			end
		end

		if CurTime() > self:GetDTFloat(10) then
			local amount = (self:GetUber() and self.Heal * 3.5) or (self.Heal * (self:GetFullUber() and 1.2 or 1) * self.HealMULsave)
			--owner:HealPlayer(ent, (self:GetUber() and self.Heal * 3.5) or (self.Heal * (self:GetFullUber() and 1.2 or 1) * self.HealMULsave), self:GetUber() and 1 or 0.5)
			if SERVER then ent:AddHealthRegeneration(amount, owner, 1, true) end
			self:SetDTFloat(10, CurTime() + (self:GetUber() and 0.24 or 0.36) )
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			local effectdata = EffectData()
				effectdata:SetOrigin(ent:WorldSpaceCenter())
				effectdata:SetFlags(3)
				effectdata:SetEntity(self)
				effectdata:SetAttachment(1)
			util_Effect("tracer_healray", effectdata)
		end

		if self:GetUber() then
			self.UberSound:PlayEx(1, 60)
		else
			self.ChargeSound:PlayEx(1, 70)
		end
	elseif ent:IsValid() then
		self:StopHealing(10)
	end
end

function SWEP:SetUber(bool)
	self:SetDTBool(11, bool)
end

function SWEP:GetUber()
	return self:GetDTBool(11)
end

function SWEP:SetFullUber(bool)
	self:SetDTBool(12, bool)
end

function SWEP:GetFullUber()
	return self:GetDTBool(12)
end