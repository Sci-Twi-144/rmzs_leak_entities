AddCSLuaFile()

SWEP.PrintName = (translate.Get("wep_cleaver_x37"))
SWEP.Description = (translate.Get("desc_cleaver_x37"))

if CLIENT then
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -1), angle = Angle(90, 0, 0), size = Vector(0.8, 1, 1), color = Color(255, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -3.182), angle = Angle(90, 0, 0), size = Vector(0.8, 1, 1), color = Color(255, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_SLASH

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true
SWEP.NoDroppedWorldModel = true
--[[SWEP.BoxPhysicsMax = Vector(8, 1, 4)
SWEP.BoxPhysicsMin = Vector(-8, -1, -4)]]

SWEP.MeleeDamage = 66
SWEP.MeleeRange = 66
SWEP.MeleeSize = 0.875
SWEP.Primary.Delay = 0.4

SWEP.BlockRotation = Angle(0, 15, -50)
SWEP.BlockOffset = Vector(3, 9, 4)

SWEP.CanBlocking = true
SWEP.BlockStability = 0.15
SWEP.BlockReduction = 30
SWEP.StaminaConsumption = 3

SWEP.WalkSpeed = SPEED_FAST

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitDecal = "Manhackcut"
SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.Tier = 5

SWEP.AllowQualityWeapons = true
SWEP.Culinary = true
SWEP.PArsenalModel = "models/props_lab/cleaver.mdl"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.06)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 4)

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav", 72, math.Rand(85, 95))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav", 72, math.Rand(75, 85))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav")
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

-- function SWEP:OnZombieKilled(zombie, total, dmginfo)
	-- local killer = self:GetOwner()
	-- local minushp = -zombie:Health()
	-- local randomnumber = math.random(1, 3)
	-- if SERVER and killer:IsValidLivingHuman() and randomnumber == 1 then
		-- local pos = zombie:GetPos()
			-- if dmginfo:GetInflictor() == killer:GetActiveWeapon() then
				-- timer.Simple(0.06, function()
					-- if killer:IsValidLivingHuman() then
						-- BlastDamage2NoSelf(self, owner, tr.HitPos, 92, self.MeleeDamage)
					-- end
				-- end)
			-- end
		-- end
-- end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)

	local owner = self:GetOwner()
	local pos = tr.HitPos

	if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD then
		owner:SetHealth(owner:Health() + 3)
	
		if owner:Health() > owner:GetMaxHealth() * 2 then
			owner:SetHealth(owner:GetMaxHealth() * 2)
		end
	
		local randomnumber = math.random(1, 5)
		
		if SERVER and randomnumber == 1 then
			for _, hitent in pairs(util.BlastAlloc(self, owner, pos, 72)) do
				if hitent:IsValidLivingZombie() then
					hitent:AddLegDamageExt(self.MeleeDamage * 0.075, self:GetOwner(), self, SLOWTYPE_ACID) -- dmginfo:GetDamage() * 0.135
					hitent:TakeDamage(self.MeleeDamage * 0.2, self:GetOwner(), self) -- dmginfo:GetDamage() * 0.135
				end
			end
		end
		if SERVER and randomnumber == 2 then
			for _, hitent in pairs(util.BlastAlloc(self, owner, pos, 72)) do
				if hitent:IsValidLivingZombie() then
					hitent:AddBurnDamage(self.MeleeDamage * 2, owner, owner.BurnTickRate or 1)
				end
			end
		end
		if SERVER and randomnumber == 3 then
			for _, hitent in pairs(util.BlastAlloc(self, owner, pos, 72)) do
				if hitent:IsValidLivingZombie() then
					hitent:AddLegDamageExt(self.MeleeDamage * 2, self:GetOwner(), self, SLOWTYPE_COLD)
				end
			end
		end
		if SERVER and randomnumber == 4 then
			for _, hitent in pairs(util.BlastAlloc(self, owner, pos, 72)) do
				if hitent:IsValidLivingZombie() then
					hitent:AddLegDamageExt(self.MeleeDamage * 0.8, self:GetOwner(), self, SLOWTYPE_PULSE)
				end
			end
		end
		if SERVER and randomnumber == 5 then
			BlastDamage2NoSelf(self, owner, tr.HitPos, 92, self.MeleeDamage * 2)
		end
	end
end

function BlastDamage2NoSelf(inflictor, attacker, epicenter, radius, damage)
    for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
        if ent and ent:IsValid() and ent != attacker then
            local nearest = ent:NearestPoint(epicenter)
            if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
                ent:TakeSpecialDamage(((radius - nearest:Distance(epicenter)) / radius) * damage, DMG_BLAST, attacker, inflictor, nearest)
            end
        end
    end
end
