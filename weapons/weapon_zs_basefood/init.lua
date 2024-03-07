--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local function FoodTimer(time, mul, owner)
	local mul = 1 + (owner:IsSkillActive(SKILL_GLUTTON) and 1 or 0) + (owner:IsSkillActive(SKILL_SPREADING) and -0.5 or 0)
	return (time or 10) * mul * (timemul or 1)
end

SWEP.StatusTBL = {
	["weapon_zs_f_banana"] = { -- fasthand
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("fasthand", FoodTimer(10, timemul, owner), {Applier = ent, Stacks = 1, Max = 3}, true, false)
		end
	},
	["weapon_zs_f_beer"] = { -- fftotem
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("fftotem", FoodTimer(8, timemul1, owner), {Applier = ent, Stacks = 1, Max = 3}, true, false)
		end
	},
	["weapon_zs_f_cannedmeat"] = { -- breaper
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("reaperb", FoodTimer(10, timemul, owner), {Applier = ent, Stacks = 1, Max = 3}, true, false)
		end
	},
	["weapon_zs_f_dogfood"] = { -- auf
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("auf", FoodTimer(8, timemul, owner), {Applier = ent, Stacks = 1, Max = 3}, true, false)
		end
	},
	["weapon_zs_f_milk"] = { -- pacaccu
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("focused", FoodTimer(15, timemul, owner), {Applier = ent, Stacks = 1, Max = 3})
		end
	},
	["weapon_zs_f_orange"] = { -- Renegade
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("renegade", FoodTimer(12, timemul, owner), {Applier = ent})
		end
	},
	["weapon_zs_f_takeout"] = { -- regeneration
		function(ent, owner, timemul)
			ent:AddHealthRegeneration(FoodTimer(20, timemul, owner), owner)
		end
	},
	["weapon_zs_f_water"] = { -- defense
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("medrifledefboost", FoodTimer(15, timemul, owner), {Applier = owner, Damage = 0.2 * (owner.BuffEffectiveness or 1)})
		end
	},
	["weapon_zs_f_soda"] = { -- speed
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("healdartboost", FoodTimer(15, timemul, owner), {Applier = ent})
		end
	},
	["weapon_zs_f_watermelon"] = { -- streth
		function(ent, owner, timemul)
			ent:ApplyHumanBuff("strengthdartboost", FoodTimer(15, timemul, owner), {Applier = owner, Damage = 0.15 * (owner.BuffEffectivenessMD or 1)})
		end
	}
}

function SWEP:Eat()
	local owner = self:GetOwner()

	self:BuffMe()

	if owner:IsSkillActive(SKILL_SUGARRUSH) then
		--local val = self.FoodHealth * (owner.FoodRecoveryMul or 1) * (owner.FoodEffectivenessMul or 1)
		local boost = owner:GiveStatus("adrenalineamp", 14)
		if boost and boost:IsValid() then
			boost:SetSpeed(35)
		end
	end

	owner:SetStamina(owner.MaxStamina or GAMEMODE.BaseStamina)

	if owner:IsSkillActive(SKILL_SPREADING) then
		local vPos = owner:GetPos()
		for _, ent in pairs(team.GetPlayers(TEAM_HUMAN)) do
			if ent and ent:IsValidLivingPlayer() then
				if ent:GetPos():DistToSqr(vPos) < (104 ^ 2) then
					if owner:IsSkillActive(SKILL_FOODSTATUS) and ent:IsValidLivingHuman() then
						if ent ~= owner then
							self.StatusTBL[self:GetClass()][1](ent, owner, 0.33)
							net.Start("zs_buffby")
								net.WriteEntity(owner)
								net.WriteString(self.PrintName)
							net.Send(ent)
						end
					elseif ent:IsSkillActive(SKILL_GLUTTON) and ent:IsValidLivingHuman() then
						if ent ~= owner then
							local armor = (self.FoodHealth * (owner.FoodRecoveryMul or 1)) * (owner.FoodEffectivenessMul or 1)
							local gaining = math.min(ent:GetBloodArmor() + (math.min(30, armor) * ent.BloodarmorGainMul), ent.MaxBloodArmor + ((40 * (owner.FoodEffectivenessMul or 1)) * (ent.MaxBloodArmorMul or 1)))
							ent:SetBloodArmor(gaining)
							
							if owner.TrinketRefrigeCooldown then
								rawset(PLAYER_NextRefrigeratorUse, owner, rawget(PLAYER_NextRefrigeratorUse, owner) - gaining * owner.HpToFood)
								net.Start("zs_nextrefrigeratoruse")
								net.WriteFloat(rawget(PLAYER_NextRefrigeratorUse, owner))
								net.Send(owner)
							end

							if ent:GetBloodArmor() < (ent.MaxBloodArmor + ((40 * (owner.FoodEffectivenessMul or 1)) * (ent.MaxBloodArmorMul or 1))) then
								local points = armor / 8
								if not (GAMEMODE:GetWave() == 0) then
									--print(points, "pts")
									owner:AddPoints(points)
								end
							end
							net.Start("zs_buffby")
								net.WriteEntity(owner)
								net.WriteString(self.PrintName)
							net.Send(ent)
						end
					else
						if ent ~= owner then
							owner:HealPlayer(ent, self.FoodHealth * (owner.FoodRecoveryMul or 1) * (owner.FoodEffectivenessMul or 1), 0.5, true)
						end
					end
				end
			end
		end
	end

	if owner:IsSkillActive(SKILL_FOODSTATUS) then
		self.StatusTBL[self:GetClass()][1](owner, owner, 1)
		--owner:EmitSound("player/suit_sprint.wav", 50, 85)
	elseif owner:IsSkillActive(SKILL_GLUTTON) then
		local healing = self.FoodHealth * ((owner.FoodRecoveryMul or 1) * (owner.SelfFoodEffectivenessMul or 1))

		owner:SetBloodArmor(math.min(owner:GetBloodArmor() + (math.min(30, healing) * (owner.BloodarmorGainMul or 1)), owner.MaxBloodArmor + (40 * (owner.MaxBloodArmorMul or 1))))
	else
		local healing = self.FoodHealth * ((owner:GetTotalAdditiveModifier("FoodRecoveryMul", "HealingReceived") * (owner.SelfFoodEffectivenessMul or 1)) - (owner:GetPhantomHealth() > 0.5 and 0.5 or 0))

		owner:SetHealth(math.min(owner:Health() + healing, owner:GetMaxHealth()))
		owner:SetPhantomHealth(math.max(0, math.floor(owner:GetPhantomHealth() - healing)))
	end

	self:TakePrimaryAmmo(1)
	if self:GetPrimaryAmmoCount() <= 0 then
		owner:StripWeapon(self:GetClass())
	end
end
